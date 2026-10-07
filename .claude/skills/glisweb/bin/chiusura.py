#!/usr/bin/env python3
"""chiusura.py — raccoglie in modo deterministico lo stato di un deploy glisweb prima di
rispondere a "posso chiudere qui?".

Solo lettura: non committa, non pusha, non sistema niente. Stampa i fatti, divisi in
  ✗ bloccante   — finché c'è, "clear sicuro" non si può dire
  ⚠ da guardare — può essere voluto, va giudicato e detto
  ✓ a posto
e in fondo ricorda le verifiche che restano al giudizio di Claude.

Sta in dev/.claude/skills/glisweb/bin/ e arriva coi file del framework; la regola d'uso è in
../riferimenti/contesto.md, "Il punto fermo lo dichiara Claude".

Uso:  chiusura.py [cartella-del-deploy]     ( senza argomento risale dalla cwd )
      chiusura.py --no-fetch                ( salta il git fetch, più veloce )
Exit: 0 tutto a posto, 1 solo avvisi, 2 almeno un bloccante.
"""
import os, re, sys, subprocess, glob, time, collections, datetime

OGGI = datetime.date.today().isoformat()
T_OGGI = time.mktime(datetime.date.today().timetuple())
righe = []          # (livello, sezione, testo)
DETTAGLIO = 8       # righe di dettaglio massime per voce


def sh(cmd, cwd=None, timeout=30):
    try:
        r = subprocess.run(cmd, cwd=cwd, shell=isinstance(cmd, str), stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, timeout=timeout, universal_newlines=True)
        return r.returncode, r.stdout.strip(), r.stderr.strip()
    except subprocess.TimeoutExpired:
        return 124, '', 'timeout'


def dì(liv, sez, testo, dettagli=()):
    dettagli = list(dettagli)
    extra = ['    ' + d for d in dettagli[:DETTAGLIO]]
    if len(dettagli) > DETTAGLIO:
        extra.append('    … e altri %d' % (len(dettagli) - DETTAGLIO))
    righe.append((liv, sez, '\n'.join([testo] + extra)))


def trova_root(partenza):
    d = os.path.abspath(partenza)
    while d != '/':
        if os.path.isdir(os.path.join(d, 'dev')) and (os.path.isfile(os.path.join(d, 'CLAUDE.md'))
                                                      or os.path.isfile(os.path.join(d, 'TODO.md'))):
            return d
        d = os.path.dirname(d)
    return None


def è_repo(p):
    return os.path.isdir(p) and sh(['git', '-C', p, 'rev-parse', '--show-toplevel'])[1] == os.path.realpath(p)


# ---------------------------------------------------------------- git
def controlla_git(repo, etichetta, fetch):
    sez = 'git ' + etichetta
    if fetch:
        rc, _, err = sh(['git', '-C', repo, 'fetch', '-q'], timeout=20)
        if rc:
            dì('⚠', sez, 'fetch fallito ( %s ): l\'allineamento è rispetto all\'ultimo fetch' % (err.splitlines() or ['?'])[-1][:80])
    _, sporchi, _ = sh(['git', '-C', repo, 'status', '--short'])
    sporchi = [s for s in sporchi.splitlines() if s]
    _, testa, _ = sh(['git', '-C', repo, 'status', '-sb'])
    testa = testa.splitlines()[0] if testa else ''
    _, oggi, _ = sh(['git', '-C', repo, 'log', '--since=%s 00:00' % OGGI, '--format=%h'])
    n_oggi = len(oggi.split()) if oggi else 0
    ramo = re.sub(r'^## ', '', testa).split('...')[0]
    if sporchi:
        dì('✗', sez, '%d file non committati' % len(sporchi), sporchi)
    rc, up, _ = sh(['git', '-C', repo, 'rev-parse', '--abbrev-ref', '@{u}'])
    if rc:
        dì('✗', sez, 'il ramo %s non ha upstream: niente garantisce che sia propagato' % ramo)
    else:
        _, avanti, _ = sh(['git', '-C', repo, 'log', '@{u}..HEAD', '--format=%h %ad %an: %s', '--date=format:%d/%m %H:%M'])
        _, indietro, _ = sh(['git', '-C', repo, 'rev-list', '--count', 'HEAD..@{u}'])
        avanti = [a for a in avanti.splitlines() if a]
        if avanti:
            dì('✗', sez, '%d commit da pushare su %s ( il push lo decide l\'utente )' % (len(avanti), up), avanti)
        if indietro not in ('', '0'):
            dì('⚠', sez, 'indietro di %s commit rispetto a %s' % (indietro, up))
    if not sporchi and not rc and not avanti and indietro in ('', '0'):
        dì('✓', sez, '%s pulito e allineato a %s, %d commit oggi' % (ramo, up, n_oggi))
    return n_oggi


# ---------------------------------------------------------------- PROD
def excludes_da_deploy(root):
    """Gli --exclude dell'ultimo rsync scritto nel DEPLOY.md, se c'è."""
    p = os.path.join(root, 'DEPLOY.md')
    if not os.path.isfile(p):
        return None
    ultimo = None
    for l in open(p, errors='replace'):
        if l.startswith('rsync ') and '/dev/' in l and '/stable' in l:
            ultimo = l
    return re.findall(r'--exclude[ =](\S+)', ultimo) if ultimo else None


def controlla_prod(root):
    dev, stable = os.path.join(root, 'dev'), os.path.join(root, 'stable')
    if not os.path.isdir(stable):
        dì('⚠', 'PROD', 'nessuna stable/ locale: se PROD è remota, l\'allineamento va verificato a mano')
        return 0
    esc = excludes_da_deploy(root)
    fonte = 'DEPLOY.md'
    if esc is None:
        esc, fonte = ['var', 'tmp', '.git', 'src/shadow.json', 'etc/deploy'], 'default'
    cmd = ['rsync', '-rnic', '--delete'] + ['--exclude=' + e for e in esc] + [dev + '/', stable]
    rc, out, err = sh(cmd, timeout=120)
    if rc:
        dì('⚠', 'PROD', 'rsync di prova fallito: %s' % err[:120])
        return 0
    diff = [l for l in out.splitlines() if l and not l.startswith('.d')]
    # i file del framework ( _src _mod _usr _etc e .claude/ ) si contano a parte da quelli di progetto
    std = [l for l in diff if re.search(r' (_(src|mod|usr|etc)|\.claude)/', l)]
    prog = [l for l in diff if l not in std]
    if prog:
        dì('✗', 'PROD', '%d file di progetto diversi fra dev/ e stable/ ( excludes da %s ): c\'è da caricare, o è voluto?' % (len(prog), fonte),
           [re.sub(r'^\S+ ', '', l) + ('  [solo in stable]' if l.startswith('*deleting') else '') for l in prog])
    if std:
        dì('⚠', 'PROD', '%d file del framework ( _src _mod _usr _etc .claude ) diversi fra dev/ e stable/' % len(std),
           [re.sub(r'^\S+ ', '', l) for l in std])
    if not diff:
        dì('✓', 'PROD', 'dev/ e stable/ identici ( excludes da %s )' % fonte)
    return len(prog)


# ---------------------------------------------------------------- standard toccati a mano
def controlla_standard(root):
    """File _* di dev/ toccati dopo l'ultimo aggiornamento del framework: stanotte diventano
    disallineamenti. L'ultimo aggiornamento è il minuto più recente in cui sono cambiati
    almeno 50 file standard."""
    dev = os.path.join(root, 'dev')
    mt = []
    for d in ('_src', '_mod', '_usr', '_etc'):
        for base, dirs, files in os.walk(os.path.join(dev, d)):
            for f in files:
                p = os.path.join(base, f)
                try:
                    mt.append((os.lstat(p).st_mtime, p))
                except OSError:
                    pass
    if not mt:
        return
    per_minuto = collections.Counter(int(m // 60) for m, _ in mt)
    massivi = [m for m, n in per_minuto.items() if n >= 50]
    if not massivi:
        return
    soglia = (max(massivi) + 1) * 60
    toccati = sorted((m, p) for m, p in mt if m >= soglia and '/_lib/_ext/' not in p)
    quando = time.strftime('%d/%m %H:%M', time.localtime(soglia - 60))
    if toccati:
        dì('⚠', 'standard', '%d file standard modificati dopo l\'ultimo aggiornamento ( %s ): stanotte diventano disallineamenti' % (len(toccati), quando),
           [time.strftime('%d/%m %H:%M ', time.localtime(m)) + os.path.relpath(p, dev) for m, p in toccati])
    else:
        dì('✓', 'standard', 'nessun file standard toccato dopo l\'ultimo aggiornamento ( %s )' % quando)


# ---------------------------------------------------------------- i cinque file
def controlla_file_progetto(root, lavoro_oggi):
    toccati = {}
    for f in ('TODO.md', 'DONE.md', 'CHAT.md', 'READ.md'):
        p = os.path.join(root, f)
        toccati[f] = os.path.isfile(p) and os.path.getmtime(p) >= T_OGGI
    stato = ', '.join('%s %s' % (f, 'oggi' if v else 'no') for f, v in toccati.items())
    if lavoro_oggi and not toccati['DONE.md']:
        dì('⚠', 'file di progetto', 'c\'è lavoro di oggi ( commit o carichi ) ma DONE.md non è stato toccato — ' + stato)
    else:
        dì('✓', 'file di progetto', 'toccati oggi: ' + stato)
    chat = os.path.join(root, 'CHAT.md')
    if os.path.isfile(chat):
        t = open(chat, errors='replace').read()
        m = re.search(r'^## lock\s*\n(.*)', t, re.M)
        if m and 'libero' not in m.group(1):
            dì('✗', 'file di progetto', 'il lock del CHAT.md è preso: ' + m.group(1).strip()[:100])
    todo = os.path.expanduser('~/.claude/bin/todo.py')
    if os.path.isfile(todo) and os.path.isfile(os.path.join(root, 'TODO.md')):
        _, out, _ = sh([sys.executable, todo, '-u'], cwd=root)
        urg = [l for l in out.splitlines() if re.match(r'\s*\d+', l)]
        _, cnt, _ = sh([sys.executable, todo, '-c'], cwd=root)
        tot = cnt.splitlines()[-1].strip() if cnt else '?'
        dì('·', 'file di progetto', 'TODO: %s; urgenti aperte: %d' % (tot, len(urg)), urg)


# ---------------------------------------------------------------- igiene
RE_COPIA = re.compile(r'(\.(bak|orig|old|save|tmp)(\.|$)|~$|\.\d{8,14}$|\.\d{8,14}\.)', re.I)


def controlla_igiene(root):
    rootroot, copie = [], []
    for alb in ('dev', 'stable'):
        a = os.path.join(root, alb)
        for base, dirs, files in os.walk(a):
            rel = os.path.relpath(base, a)
            dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ('var', 'tmp', 'node_modules', 'vendor')]
            standard = re.search(r'(^|/)_', rel) is not None
            for n in dirs + files:
                p = os.path.join(base, n)
                try:
                    st = os.lstat(p)
                except OSError:
                    continue
                if st.st_uid == 0 and st.st_gid == 0 and st.st_mtime >= T_OGGI - 7 * 86400:
                    rootroot.append(os.path.relpath(p, root))
                if n in files and RE_COPIA.search(n) and not standard:
                    copie.append(os.path.relpath(p, root))
    if rootroot:
        dì('✗', 'igiene', '%d file o cartelle root:root toccati negli ultimi 7 giorni ( 500 sui file, 403 sulle cartelle )' % len(rootroot), rootroot)
    if copie:
        dì('⚠', 'igiene', '%d copie di appoggio dentro la document root ( vanno in var/<id>/ )' % len(copie), copie)
    if not rootroot and not copie:
        dì('✓', 'igiene', 'niente root:root recente, niente copie di appoggio nella document root')


# ---------------------------------------------------------------- processi e scratchpad
def controlla_processi(root):
    nome = os.path.basename(root)
    trovati = []
    for pid in os.listdir('/proc'):
        if not pid.isdigit() or int(pid) == os.getpid():
            continue
        try:
            cmd = open('/proc/%s/cmdline' % pid, 'rb').read().replace(b'\0', b' ').decode(errors='replace').strip()
            cwd = os.readlink('/proc/%s/cwd' % pid)
        except OSError:
            continue
        if not cmd or re.search(r'\b(claude|apache2|php-fpm|chiusura\.py)', cmd) or re.match(r'-?(ba)?sh$', cmd):
            continue
        tunnel = re.match(r'ssh\b.*\s-[A-Za-z]*[LRDN]', cmd)
        if cwd.startswith(root) or nome in cmd or tunnel:
            trovati.append('%s %s%s' % (pid, cmd[:140], '  [tunnel ssh]' if tunnel else ''))
    if trovati:
        dì('⚠', 'processi', '%d processi legati al deploy ( o tunnel ssh ) ancora vivi' % len(trovati), trovati)
    else:
        dì('✓', 'processi', 'nessun processo del deploy in background')


RE_CRED = re.compile(r'(^\s*password\s*=\s*\S|PASS=\S|IDENTIFIED BY|BEGIN [A-Z ]*PRIVATE KEY)', re.I | re.M)


def controlla_scratchpad(root):
    proj = '-' + root.strip('/').replace('/', '-').replace('.', '-')
    con_cred, n = [], 0
    for p in glob.glob('/tmp/claude-*/%s/*/scratchpad/**' % proj, recursive=True):
        if not os.path.isfile(p) or os.path.getmtime(p) < T_OGGI:
            continue
        n += 1
        try:
            if os.path.getsize(p) < 200000 and RE_CRED.search(open(p, errors='replace').read()):
                con_cred.append(p)
        except OSError:
            pass
    if con_cred:
        dì('⚠', 'scratchpad', '%d file di oggi con credenziali in chiaro: servono ancora?' % len(con_cred), con_cred)
    elif n:
        dì('·', 'scratchpad', '%d file di oggi nelle scratchpad, nessuno con credenziali' % n)


# ---------------------------------------------------------------- cose che partono da sole
def controlla_cron(root):
    nome = os.path.basename(root)
    datati = []
    for f in glob.glob('/etc/cron.d/*'):
        try:
            for l in open(f, errors='replace'):
                c = l.split()
                if len(c) > 5 and not l.startswith('#') and nome in l and c[2] != '*' and c[3] != '*':
                    datati.append('%s: %s' % (os.path.basename(f), ' '.join(c[:5])))
        except OSError:
            pass
    if datati:
        dì('·', 'cron', '%d cron a data fissa sul deploy: vanno controllati dopo che girano' % len(datati), datati)


def controlla_sito(root):
    dom = os.path.basename(root)
    rc, code, _ = sh(['curl', '-s', '-o', '/dev/null', '-m', '10', '-w', '%{http_code}', 'https://%s/' % dom], timeout=15)
    if code.startswith(('2', '3')):
        dì('✓', 'sito', 'https://%s/ risponde %s' % (dom, code))
    else:
        dì('⚠', 'sito', 'https://%s/ risponde %s' % (dom, code or 'niente'))


# ---------------------------------------------------------------- glisweb / glisdev
COPPIA = ['/var/www/glisweb.istricesrl.it', '/var/www/glisdev.istricesrl.com']


def controlla_hardlink():
    s = os.path.join(COPPIA[1], 'sync-check.sh')
    if not os.path.isfile(s):
        return
    rc, out, err = sh(['bash', s], cwd=COPPIA[1], timeout=120)
    coda = [l for l in (out + '\n' + err).splitlines() if l.strip()][-6:]
    dì('✓' if rc == 0 else '✗', 'hard link', 'sync-check.sh exit %d' % rc, coda)


# ---------------------------------------------------------------- main
def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    fetch = '--no-fetch' not in sys.argv
    root = trova_root(args[0] if args else os.getcwd())
    if not root:
        print('non trovo la root di un deploy ( una cartella con dev/ e CLAUDE.md o TODO.md )')
        return 2
    print('chiusura %s — %s' % (root, time.strftime('%d/%m/%Y %H:%M')))
    repo = [root] if è_repo(root) else []
    repo += [os.path.join(root, d) for d in ('dev', 'stable') if è_repo(os.path.join(root, d))]
    coppia = root in COPPIA
    if coppia:
        repo += [os.path.join(c, 'dev') for c in COPPIA if c != root]
    if not è_repo(os.path.join(root, 'dev')):
        dì('⚠', 'git', 'dev/ non è un repository git')
    commit_oggi = 0
    for r in repo:
        commit_oggi += controlla_git(r, os.path.relpath(r, '/var/www'), fetch)
    if coppia:
        controlla_hardlink()
    carichi = controlla_prod(root) if not coppia else 0
    if not coppia:
        controlla_standard(root)
    controlla_file_progetto(root, commit_oggi or carichi)
    controlla_igiene(root)
    controlla_processi(root)
    controlla_scratchpad(root)
    controlla_cron(root)
    controlla_sito(root)

    for liv, sez, t in righe:
        print('%s %-16s %s' % (liv, sez, t))
    n = collections.Counter(l for l, _, _ in righe)
    print('\nesito: %d bloccanti, %d da guardare' % (n['✗'], n['⚠']))
    print('resta al giudizio di Claude: ogni cosa aperta è nel TODO.md coi tre flag? il lavoro a metà ha un file che tiene il filo?\n'
          'decisioni e domande nate in conversazione sono nei file ( TODO, CHAT )? qualcosa da caricare in PROD che non è un file ( righe di DB )?\n'
          'task in background avviati da questa sessione ( questo script non li vede tutti )?')
    return 2 if n['✗'] else (1 if n['⚠'] else 0)


if __name__ == '__main__':
    sys.exit(main())

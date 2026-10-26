#!/usr/bin/env python3
"""cartella-progetto.py — cosa sta nella cartella di un progetto glisweb ( /var/www/<progetto>/ ),
e cosa non ci dovrebbe stare.

Nato il 26/10/2026: nella cartella di bernispa c'erano dump .sql, un READ.md.bak.<data> e un
backup.db..sql.gz lasciati dalle sessioni, e lo stesso su altri sei progetti. La regola era
scritta solo per la document root; questa e' l'unica fonte dell'elenco dei canonici, e la
usano chiusura.py, l'hook niente-rusco del server e tutto-ok.py del capitano.

Nella cartella del progetto stanno solo i file e le cartelle qui sotto; tutto il resto va in
var/AAAAMMGG-scopo/. Un progetto che ha bisogno di altro lo elenca, un nome per riga, in
.claude/cartella-progetto.consentiti ( e scrive perche' nel CLAUDE.md ).

In var/ si guardano solo le voci nate dalla DECORRENZA in poi: il formato vale per le nuove,
le vecchie non si rinominano perche' TODO e DONE ci rimandano.

Uso:  cartella-progetto.py [cartella ...]           ( senza argomenti: tutti i progetti di /var/www )
      cartella-progetto.py --consentito CARTELLA NOME  ( exit 0 se NOME puo' stare li', per l'hook )
      cartella-progetto.py --canonici                ( stampa l'elenco )
Exit: 0 tutto a posto, 1 almeno un'anomalia.
"""
import os, re, sys, glob, datetime

FILE_CANONICI = {
    'CLAUDE.md', 'READ.md', 'TODO.md', 'DONE.md', 'CHAT.md', 'DEPLOY.md',   # i file di progetto
    'burndown.md', 'CHAT.md.flock',                                         # generati
    'update.branch.conf', 'update.check.conf', 'update.repository.conf',    # aggiornamento del framework
    'devuser.conf', 'ftpuser.conf',                                         # gabbie chroot
    'phpmalwarefinder.log',                                                 # scansione malware notturna
}
CARTELLE_CANONICHE = {'dev', 'stable', 'test', 'var', 'backups', 'disallineamenti', '.claude'}
CONSENTITI = '.claude/cartella-progetto.consentiti'

DECORRENZA = datetime.datetime(2026, 10, 26).timestamp()
RE_VAR = re.compile(r'^(\d{8}-[a-z0-9][a-z0-9.-]*|[a-z][a-z0-9-]*)$')   # 20261026-scopo, o un tema senza data


def è_progetto(p):
    return os.path.isdir(p) and any(os.path.exists(os.path.join(p, n)) for n in ('dev', 'stable', 'CLAUDE.md', 'TODO.md'))


def consentiti(root):
    extra = set()
    try:
        for l in open(os.path.join(root, CONSENTITI), errors='replace'):
            l = l.split('#')[0].strip()
            if l:
                extra.add(l)
    except OSError:
        pass
    return extra


def consentito(root, nome):
    return nome in FILE_CANONICI or nome in CARTELLE_CANONICHE or nome in consentiti(root)


def anomalie(root):
    fuori, var = [], []
    extra = consentiti(root)
    for n in sorted(os.listdir(root)):
        p = os.path.join(root, n)
        if n in extra:
            continue
        if os.path.isdir(p) and not os.path.islink(p):
            if n not in CARTELLE_CANONICHE:
                fuori.append(n + '/')
        elif n not in FILE_CANONICI:
            fuori.append(n)
    v = os.path.join(root, 'var')
    if os.path.isdir(v):
        for n in sorted(os.listdir(v)):
            p = os.path.join(v, n)
            try:
                nuovo = os.lstat(p).st_mtime >= DECORRENZA
            except OSError:
                continue
            if not nuovo or n == '.gitignore':
                continue
            if not os.path.isdir(p):
                var.append('var/%s  ( file sciolto: va in una cartella var/AAAAMMGG-scopo/ )' % n)
            elif not RE_VAR.match(n):
                var.append('var/%s/  ( il nome va scritto AAAAMMGG-scopo, minuscolo, coi trattini )' % n)
    return fuori, var


def main():
    a = sys.argv[1:]
    if a[:1] == ['--canonici']:
        print('\n'.join(sorted(FILE_CANONICI) + sorted(c + '/' for c in CARTELLE_CANONICHE)))
        return 0
    if a[:1] == ['--consentito']:
        return 0 if len(a) == 3 and consentito(a[1].rstrip('/'), a[2]) else 1
    radici = a or sorted(p.rstrip('/') for p in glob.glob('/var/www/*/') if è_progetto(p))
    tot = 0
    for r in radici:
        r = os.path.abspath(r)
        fuori, var = anomalie(r)
        if fuori or var:
            tot += len(fuori) + len(var)
            print('%s: %d fuori posto' % (r, len(fuori) + len(var)))
            for n in fuori:
                print('    %s' % n)
            for n in var:
                print('    %s' % n)
    if len(radici) > 1 or not a:
        print('%d progetti, %d voci fuori posto' % (len(radici), tot))
    return 1 if tot else 0


if __name__ == '__main__':
    sys.exit(main())

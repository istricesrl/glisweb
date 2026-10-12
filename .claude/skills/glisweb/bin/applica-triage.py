#!/usr/bin/env python3
"""applica-triage.py — applica al TODO.md di un deploy glisweb i verdetti di una pulizia delle todo.

Un triage produce un TSV di verdetti riferiti ai NUMERI DI RIGA del TODO.md del momento in cui
lo si è fatto. Applicarli a mano è il punto dove la pulizia si rompe: ogni chiusura toglie righe
e sposta tutte quelle sotto, e un'altra sessione ( o il cron delle urgenze ) può aver scritto nel
frattempo. Questo script fa il giro in modo deterministico:

  1. legge i verdetti e controlla, PRIMA di scrivere qualunque cosa, che ogni riga contenga
     ancora il testo atteso; se anche una sola non torna non scrive niente ( tutto o niente );
  2. applica in ordine di riga DECRESCENTE, così una voce tolta non sposta quelle ancora da fare,
     e ricontrolla il testo di ogni riga subito prima di toccarla.

Il TSV ha quattro colonne separate da TAB ( le righe vuote e quelle che iniziano con # si saltano ):

  riga   azione   atteso   nota

  azione  chiudi   [v] fatta: trasloca nel DONE.md con `voce-progetto.py todo-chiudi`
          scarta   [x] scartata ( superata, doppione ): `voce-progetto.py todo-scarta`
          attesa   `[ ]` -> `[=]`, e la nota ( `-- **Nome, dal GG/MM** — cosa si è chiesto` )
                   in coda alle note della voce
          nota     solo la nota in coda alle note della voce, marcatore invariato
                   ( p.es. `-- domanda in CHAT.md › Da chiederle (12/10)` )
  atteso  un pezzo del testo della voce, abbastanza lungo da riconoscerla ( 30-40 caratteri
          presi dopo i flag vanno bene ); il confronto ignora gli asterischi del grassetto
  nota    per chiudi/scarta è il "com'è andata / perché"; per attesa/nota è la riga da aggiungere

Uso:  applica-triage.py <verdetti.tsv> [--deploy CARTELLA] [--applica]
      senza --applica fa solo il controllo e stampa cosa farebbe ( prova a secco )

Le chiusure passano da ~/.claude/bin/voce-progetto.py, che trasloca la voce con le sue note nel
capitolo di oggi del DONE.md e ricorda chi va avvisato: lo script non rifà quel lavoro. Le
scritture dirette ( attesa, nota ) prendono lo stesso flock esclusivo sul TODO.md.

La procedura completa della pulizia sta in ../riferimenti/pulizia-todo.md.
"""
import argparse, fcntl, os, re, subprocess, sys

VOCE = re.compile(r'^- \[(.)\] ')
VOCE_PROGETTO = os.path.expanduser('~/.claude/bin/voce-progetto.py')
AZIONI = ('chiudi', 'scarta', 'attesa', 'nota')


def normalizza(s):
    return re.sub(r'\s+', ' ', s.replace('*', '')).strip().lower()


def trova_deploy(partenza):
    d = os.path.abspath(partenza)
    while d != '/':
        if os.path.isfile(os.path.join(d, 'TODO.md')) and os.path.isdir(os.path.join(d, 'dev')):
            return d
        d = os.path.dirname(d)
    sys.exit('ERRORE: nessun deploy ( TODO.md accanto a dev/ ) risalendo da %s' % partenza)


def leggi_verdetti(percorso):
    verdetti, errori = [], []
    with open(percorso, encoding='utf-8') as fh:
        for n, r in enumerate(fh, 1):
            r = r.rstrip('\n')
            if not r.strip() or r.startswith('#'):
                continue
            c = r.split('\t')
            if len(c) != 4 or not c[0].strip().isdigit() or c[1].strip() not in AZIONI:
                errori.append('riga %d del TSV malformata: %s' % (n, r[:100]))
                continue
            if not c[2].strip() or not c[3].strip():
                errori.append('riga %d del TSV: atteso e nota sono obbligatori' % n)
                continue
            verdetti.append((int(c[0]), c[1].strip(), c[2].strip(), c[3].strip()))
    righe = [v[0] for v in verdetti]
    doppie = sorted(set(x for x in righe if righe.count(x) > 1))
    if doppie:
        errori.append('righe con più di un verdetto: %s' % ' '.join(map(str, doppie)))
    return verdetti, errori


def controlla(righe, riga, azione, atteso):
    """Ritorna None se la riga è la voce attesa, altrimenti il motivo."""
    if riga < 1 or riga > len(righe):
        return 'la riga %d non esiste ( il file ne ha %d )' % (riga, len(righe))
    r = righe[riga - 1]
    m = VOCE.match(r)
    if not m:
        return 'la riga %d non è una voce: %s' % (riga, r[:80])
    if normalizza(atteso) not in normalizza(r):
        return 'la riga %d non contiene «%s»: %s' % (riga, atteso[:40], r[:80])
    if azione == 'attesa' and m.group(1) != ' ':
        return 'la riga %d è già [%s], non [ ]' % (riga, m.group(1))
    return None


def fine_voce(righe, i):
    """Indice ( 0-based ) dell'ultima riga di note della voce che sta in righe[i]."""
    j = i
    while j + 1 < len(righe) and (righe[j + 1].startswith('--') or righe[j + 1].startswith(' ')):
        j += 1
    return j


def scrivi_diretto(todo, riga, azione, atteso, nota):
    with open(todo, 'r+', encoding='utf-8') as fh:
        fcntl.flock(fh, fcntl.LOCK_EX)
        righe = fh.read().split('\n')
        motivo = controlla(righe, riga, azione, atteso)
        if motivo:
            return motivo
        i = riga - 1
        if azione == 'attesa':
            righe[i] = righe[i].replace('- [ ] ', '- [=] ', 1)
        righe.insert(fine_voce(righe, i) + 1, nota if nota.startswith('--') else '-- ' + nota)
        fh.seek(0)
        fh.write('\n'.join(righe))
        fh.truncate()
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('tsv')
    ap.add_argument('--deploy', help='cartella del deploy ( default: risale dalla cwd )')
    ap.add_argument('--applica', action='store_true', help='scrive davvero; senza, prova a secco')
    a = ap.parse_args()

    deploy = trova_deploy(a.deploy or os.getcwd())
    todo = os.path.join(deploy, 'TODO.md')
    verdetti, errori = leggi_verdetti(a.tsv)

    with open(todo, encoding='utf-8') as fh:
        righe = fh.read().split('\n')
    for riga, azione, atteso, nota in verdetti:
        motivo = controlla(righe, riga, azione, atteso)
        if motivo:
            errori.append(motivo)

    conta = {x: sum(1 for v in verdetti if v[1] == x) for x in AZIONI}
    print('%s: %d verdetti ( %s )' % (todo, len(verdetti), ', '.join('%s %d' % kv for kv in conta.items() if kv[1])))
    if errori:
        print('NON SCRIVO NIENTE, %d problemi:' % len(errori))
        for e in errori:
            print('  ✗ ' + e)
        sys.exit(2)
    if (conta['chiudi'] or conta['scarta']) and not os.access(VOCE_PROGETTO, os.X_OK):
        sys.exit('ERRORE: per chiudere serve %s' % VOCE_PROGETTO)
    if not a.applica:
        print('✓ tutte le righe tornano. Prova a secco: rilanciare con --applica per scrivere.')
        return

    progetto = os.path.basename(deploy)
    fatti, falliti = 0, []
    for riga, azione, atteso, nota in sorted(verdetti, key=lambda v: -v[0]):
        if azione in ('chiudi', 'scarta'):
            with open(todo, encoding='utf-8') as fh:
                motivo = controlla(fh.read().split('\n'), riga, azione, atteso)
            if not motivo:
                p = subprocess.run([VOCE_PROGETTO, progetto, 'todo-' + azione, str(riga), '-n', nota],
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
                if p.returncode:
                    motivo = 'voce-progetto.py ha risposto %d: %s' % (p.returncode, p.stdout.strip()[:200])
        else:
            motivo = scrivi_diretto(todo, riga, azione, atteso, nota)
        if motivo:
            falliti.append(motivo)
        else:
            fatti += 1

    print('✓ applicati %d verdetti su %d' % (fatti, len(verdetti)))
    for f in falliti:
        print('  ✗ ' + f)
    sys.exit(1 if falliti else 0)


if __name__ == '__main__':
    main()

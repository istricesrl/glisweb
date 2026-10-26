#!/usr/bin/env python3
"""md-leggibile.py — controlla che i file .md di un progetto si leggano con mcedit e con less,
cioe' come testo, senza anteprima.

Nato il 26/10/2026: Fabio cercava un'informazione nel READ.md di bernispa e l'ha trovata
difficile da leggere: righe fino a 1000 caratteri, tabelle a 8 colonne con le celle non
allineate. Le regole sono nella skill, riferimenti/cinque-file.md, "Come si scrive un .md
di progetto"; qui si misurano.

Cosa guarda:
  - righe oltre LARGHEZZA caratteri, fuori dai blocchi di codice ( ``` e righe rientrate di
    4 spazi, dove un URL o un comando lungo puo' stare );
  - tabelle con piu' di COLONNE colonne;
  - tabelle con le colonne non allineate ( --allinea le sistema da solo );
  - tabelle che anche allineate superano LARGHEZZA: vanno riscritte a mano, come elenco.

Il DONE.md non si guarda per default: e' un archivio che si appende, i capitoli vecchi
restano come sono. Lo si passa per nome se serve.

Uso:  md-leggibile.py [cartella-del-progetto | file.md ...]   ( senza argomenti: la cwd )
      md-leggibile.py --allinea ...                          ( riscrive le tabelle allineate )
Exit: 0 tutto a posto, 1 qualcosa da sistemare.
"""
import os, re, sys, unicodedata

LARGHEZZA = 100
COLONNE = 5
FILE_DEFAULT = ('CLAUDE.md', 'READ.md', 'TODO.md', 'CHAT.md', 'DEPLOY.md')
RE_SEP = re.compile(r'^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)*\|?\s*$')


def larghezza(s):
    n = 0
    for c in s:
        if unicodedata.combining(c):
            continue
        n += 2 if unicodedata.east_asian_width(c) in ('W', 'F') else 1
    return n


def celle(riga):
    s = riga.strip()
    if s.startswith('|'):
        s = s[1:]
    if s.endswith('|') and not s.endswith('\\|'):
        s = s[:-1]
    # NOTA il | dentro i backtick o scappato con \ non separa le celle
    out, cur, codice, i = [], '', False, 0
    while i < len(s):
        c = s[i]
        if c == '\\' and i + 1 < len(s):
            cur += s[i:i + 2]
            i += 2
            continue
        if c == '`':
            codice = not codice
        if c == '|' and not codice:
            out.append(cur.strip())
            cur = ''
        else:
            cur += c
        i += 1
    out.append(cur.strip())
    return out


def allinea(blocco):
    rientro = re.match(r'^\s*', blocco[0]).group(0)
    righe = [celle(r) for r in blocco]
    n = max(len(r) for r in righe)
    righe = [r + [''] * (n - len(r)) for r in righe]
    sep = [i for i, r in enumerate(blocco) if RE_SEP.match(r)]
    w = [3] * n
    for i, r in enumerate(righe):
        if i in sep:
            continue
        for j, c in enumerate(r):
            w[j] = max(w[j], larghezza(c))
    out = []
    for i, r in enumerate(righe):
        if i in sep:
            out.append(rientro + '|' + '|'.join('-' * (w[j] + 2) for j in range(n)) + '|')
        else:
            out.append(rientro + '| ' + ' | '.join(c + ' ' * (w[j] - larghezza(c)) for j, c in enumerate(r)) + ' |')
    return out


def esamina(percorso, sistema):
    testo = open(percorso, errors='replace').read()
    righe = testo.split('\n')
    lunghe, larghe, colonne, storte = [], [], [], []
    nuove, i, fence = [], 0, False
    while i < len(righe):
        r = righe[i]
        if r.lstrip().startswith('```'):
            fence = not fence
            nuove.append(r)
            i += 1
            continue
        if not fence and r.lstrip().startswith('|'):
            j = i
            while j < len(righe) and righe[j].lstrip().startswith('|'):
                j += 1
            blocco = righe[i:j]
            fatto = allinea(blocco)
            ncol = len(celle(blocco[0]))
            if ncol > COLONNE:
                colonne.append('%d ( %d colonne )' % (i + 1, ncol))
            if max(larghezza(x) for x in fatto) > LARGHEZZA:
                larghe.append('%d ( %d caratteri anche allineata )' % (i + 1, max(larghezza(x) for x in fatto)))
            if fatto != blocco:
                storte.append(str(i + 1))
            nuove.extend(fatto if sistema else blocco)
            i = j
            continue
        codice = fence or (r.startswith('    ') and not re.match(r'^\s*([-*+]|\d+\.)\s', r))
        if not codice and larghezza(r) > LARGHEZZA:
            lunghe.append('%d ( %d )' % (i + 1, larghezza(r)))
        nuove.append(r)
        i += 1
    if sistema and storte:
        # NOTA scrittura sullo stesso inode: niente file temporaneo e rename
        with open(percorso, 'r+') as f:
            f.seek(0)
            f.write('\n'.join(nuove))
            f.truncate()
    return lunghe, larghe, colonne, storte


def main():
    sistema = '--allinea' in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith('--')] or [os.getcwd()]
    file = []
    for a in args:
        if os.path.isdir(a):
            file += [os.path.join(a, f) for f in FILE_DEFAULT if os.path.isfile(os.path.join(a, f))]
        else:
            file.append(a)
    problemi = 0
    for f in file:
        if os.path.getsize(f) > 2 * 1024 * 1024:
            print('%s: %d MB, non e\' un file da leggere: va riportato a diario' % (f, os.path.getsize(f) // 1024 // 1024))
            problemi += 1
            continue
        lunghe, larghe, colonne, storte = esamina(f, sistema)
        voci = []
        if lunghe:
            voci.append('%d righe oltre %d caratteri: %s%s' % (len(lunghe), LARGHEZZA, ', '.join(lunghe[:6]), ' …' if len(lunghe) > 6 else ''))
        if colonne:
            voci.append('tabelle con piu\' di %d colonne alle righe %s' % (COLONNE, ', '.join(colonne)))
        if larghe:
            voci.append('tabelle da riscrivere come elenco alle righe %s' % ', '.join(larghe))
        if storte:
            voci.append('tabelle %s alle righe %s' % ('allineate' if sistema else 'non allineate ( --allinea )', ', '.join(storte)))
        if voci:
            problemi += len([v for v in voci if not v.startswith('tabelle allineate')])
            print('%s:' % f)
            for v in voci:
                print('    ' + v)
    if not problemi:
        print('leggibili: %s' % ', '.join(os.path.basename(f) for f in file))
    return 1 if problemi else 0


if __name__ == '__main__':
    sys.exit(main())

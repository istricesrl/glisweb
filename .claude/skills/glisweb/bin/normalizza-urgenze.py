#!/usr/bin/env python3
"""normalizza-urgenze.py — toglie l'urgenza alle voci ferme da troppo tempo.

Regola decisa da Fabio l'08/10/2026, scritta in riferimenti/cinque-file.md ( "L'urgenza scade" ):
una voce `- [ ]` col primo flag a `!` che non si muove da piu' di 14 giorni non era urgente, e
perde il `!`. Non si chiude e non si sposta: cambia solo il flag, e in coda alla riga si aggiunge
`( declassata GG/MM/AAAA: ferma da N gg )`, cosi' chi la rimette urgente sa da dove viene.

Il movimento e' la data piu' recente citata nella voce o nelle sue note, compreso il campo
`( aperta GG/MM/AAAA )`. Restano fuori:
  - le voci `[=]` e `[?]`, che non sono nel carico e aspettano qualcun altro;
  - le voci che citano una data futura, cioe' hanno una scadenza davanti;
  - le voci senza nessuna data: non si sa da quando sono ferme, e una data non si inventa.

Le scritture prendono il flock esclusivo sul TODO.md, come voce-progetto.py, rileggono il file
sotto lock e cambiano solo le righe delle voci declassate.

uso:
    normalizza-urgenze.py                     # anteprima su tutti i /var/www/*/TODO.md
    normalizza-urgenze.py -v                  # anteprima con l'elenco delle voci
    normalizza-urgenze.py --applica           # scrive
    normalizza-urgenze.py -p polmasi -v       # solo i progetti col testo nel nome
    normalizza-urgenze.py -g 14 -b /var/www   # soglia in giorni e cartella dei deploy
"""
import argparse
import datetime
import fcntl
import glob
import os
import re
import sys

OGGI = datetime.date.today()
FUTURO_SENZA_ANNO = 60  # un gg/mm senza anno oltre questi giorni avanti e' dell'anno scorso

RE_VOCE = re.compile(r'^- \[ \]\s*\(!([-!?])([-!?])\)')
RE_ALTRA = re.compile(r'^(- \[|#)')
RE_ANNO_ISO = re.compile(r'\b(20\d\d)-(\d\d)-(\d\d)\b')
RE_ANNO = re.compile(r'\b(\d{1,2})/(\d{1,2})/(20\d\d|\d\d)\b')
RE_SENZA_ANNO = re.compile(r'(?<![\d/])(\d{1,2})/(\d{1,2})(?![\d/])')


def date_citate(testo):
    """( passate, future ) citate nel testo."""
    passate, future = [], []

    def metti(a, m, g):
        try:
            d = datetime.date(a, m, g)
        except ValueError:
            return
        if d.year < 2018:
            return
        (future if d > OGGI else passate).append(d)

    for m in RE_ANNO_ISO.finditer(testo):
        metti(int(m[1]), int(m[2]), int(m[3]))
    for m in RE_ANNO.finditer(testo):
        a = int(m[3])
        metti(a + 2000 if a < 100 else a, int(m[2]), int(m[1]))
    for m in RE_SENZA_ANNO.finditer(testo):
        g, me = int(m[1]), int(m[2])
        try:
            d = datetime.date(OGGI.year, me, g)
        except ValueError:
            continue
        if (d - OGGI).days > FUTURO_SENZA_ANNO:
            d = d.replace(year=OGGI.year - 1)
        metti(d.year, d.month, d.day)
    return passate, future


def esamina(righe, soglia):
    """Classifica le voci urgenti aperte. Ritorna dict con le liste
    'declassare' [( indice, giorni )], 'scadenza', 'senza_data', 'ferme_ok'."""
    esito = {'declassare': [], 'scadenza': [], 'senza_data': [], 'vive': []}
    for i, r in enumerate(righe):
        if not RE_VOCE.match(r):
            continue
        testo = [r]
        for s in righe[i + 1:]:
            if RE_ALTRA.match(s):
                break
            if s.startswith('--') or (s.startswith('  ') and s.strip()):
                testo.append(s)
        passate, future = date_citate('\n'.join(testo))
        if future:
            esito['scadenza'].append(i)
        elif not passate:
            esito['senza_data'].append(i)
        else:
            giorni = (OGGI - max(passate)).days
            if giorni > soglia:
                esito['declassare'].append((i, giorni))
            else:
                esito['vive'].append(i)
    return esito


def declassa(riga, giorni):
    riga = riga.rstrip()
    nuova = re.sub(r'^(- \[ \]\s*\()!', r'\1-', riga, count=1)
    return '%s ( declassata %s: ferma da %d gg )' % (nuova, OGGI.strftime('%d/%m/%Y'), giorni)


def breve(riga, n=100):
    t = re.sub(r'^- \[ \]\s*', '', riga.strip())
    return t if len(t) <= n else t[:n - 1] + '…'


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('-b', '--base', default='/var/www')
    ap.add_argument('-g', '--giorni', type=int, default=14)
    ap.add_argument('-p', '--progetto', help='solo i deploy col testo nel nome')
    ap.add_argument('-v', '--voci', action='store_true', help='elenca le voci declassate')
    ap.add_argument('--applica', action='store_true', help='scrive; senza e\' anteprima')
    a = ap.parse_args()

    totale = {'declassare': 0, 'scadenza': 0, 'senza_data': 0, 'vive': 0}
    modo = 'APPLICATO' if a.applica else 'ANTEPRIMA'
    print('%s %s — soglia %d gg, urgenti aperte ferme da piu\' di tanto perdono il !'
          % (modo, OGGI.strftime('%d/%m/%Y'), a.giorni))
    print('%-36s %8s %7s %8s %10s' % ('progetto', 'declass.', 'vive', 'scadenza', 'senza data'))
    for p in sorted(glob.glob(os.path.join(a.base, '*', 'TODO.md'))):
        nome = os.path.basename(os.path.dirname(p))
        if a.progetto and a.progetto not in nome:
            continue
        with open(p, 'r+' if a.applica else 'r', encoding='utf-8') as fh:
            if a.applica:
                fcntl.flock(fh, fcntl.LOCK_EX)
            righe = fh.read().split('\n')
            e = esamina(righe, a.giorni)
            vecchie = {i: righe[i] for i, _ in e['declassare']}
            if a.applica and e['declassare']:
                for i, g in e['declassare']:
                    righe[i] = declassa(righe[i], g)
                fh.seek(0)
                fh.write('\n'.join(righe))
                fh.truncate()
        n = {k: len(v) for k, v in e.items()}
        if not any(n.values()):
            continue
        for k in totale:
            totale[k] += n[k]
        print('%-36s %8d %7d %8d %10d' % (nome, n['declassare'], n['vive'], n['scadenza'], n['senza_data']))
        if a.voci:
            for i, g in sorted(e['declassare'], key=lambda x: -x[1]):
                print('    r%-5d %4d gg  %s' % (i + 1, g, breve(vecchie[i])))
    print('%-36s %8d %7d %8d %10d' % ('TOTALE', totale['declassare'], totale['vive'],
                                      totale['scadenza'], totale['senza_data']))
    if not a.applica and totale['declassare']:
        print('anteprima: niente e\' stato scritto, --applica per declassare')


if __name__ == '__main__':
    sys.exit(main())

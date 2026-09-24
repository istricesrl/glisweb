# note e cronologia di release
La release corrente del framework non si scrive qui: sta nel file [`_etc/_current.release`](https://github.com/istricesrl/glisweb/blob/develop/_etc/_current.release), nella forma
`major.minor.bugfix`, e si cambia a mano quando si crea una nuova release branch. Accanto c'è
[`_etc/_current.version`](https://github.com/istricesrl/glisweb/blob/develop/_etc/_current.version), il timestamp che i
git hook di sviluppo riscrivono a ogni commit. Le due numerazioni e le loro regole sono spiegate nel capitolo
[file di `_etc/`](https://github.com/istricesrl/glisweb/blob/develop/_usr/_docs/_read/211.file.etc.md) del manuale
sviluppatore.

La cronologia delle modifiche sta in
[`_etc/_changelog.json`](https://github.com/istricesrl/glisweb/blob/develop/_etc/_changelog.json), che i git hook
aggiornano a ogni commit sul ramo `master` a partire dal messaggio di commit. Un'installazione legge release e
versione nella pagina di status ( `/status` ), che le confronta con l'ultima versione pubblicata, e le espone agli
indirizzi `/current.release` e `/current.version`.

## 0.0.1 del 08/10/2020
Questa è una release di test, pubblicata per dare modo agli sviluppatori esterni di provare il codice. Comprende la maggior parte delle funzionalità di base ma i moduli non sono ancora stati portati e alcune caratteristiche minori sono mancanti.

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

## 2.1.0 del 01/05/2024 — linea unstable ( glisdev )
Prima release della linea unstable, che vive nel repository [glisdev](https://github.com/istricesrl/glisdev) ed è
dichiarata in `_etc/_current.release` fin dal commit iniziale. Contiene solo la generazione nuova: i template
Twig in `_src/_tpl/` ( in parte già su Bootstrap 5 ) e i moduli con prefisso di due lettere ( `_AC000.account`,
`_NO000.notizie`, ... ), che dal 2025 ci sono anche nella linea stable; non contiene più i moduli e il templating
della generazione precedente ( `_src/_templates/`, `_src/_html/`, `_mod/_NNNN.*` ). La parte condivisa del codice
è la stessa della linea stable, file per file. Il tag `2.1.0` punta al commit iniziale del repository.

## 2.0.0 del 11/09/2023 — linea stable ( glisweb )
Release corrente della linea stable, dichiarata con l'introduzione di `_etc/_current.release` e
`_etc/_current.version` ( commit `5cdad4372` ). Raccoglie circa 1.800 commit successivi alla 0.1.1 e mantiene la
compatibilità con i moduli e i template della generazione precedente. Il numero non è più cambiato: fino al
24/09/2026 la linea ha avuto altri 1.110 commit, fra cui, dal 2025, i template e i moduli di nuova generazione. Il
tag `2.0.0` punta al commit della dichiarazione, non al codice corrente della linea.

## 0.1.1 del 04/11/2021
Release intermedia, presente come tag nel repository.

## 0.0.1 del 08/10/2020
Questa è una release di test, pubblicata per dare modo agli sviluppatori esterni di provare il codice. Comprende la maggior parte delle funzionalità di base ma i moduli non sono ancora stati portati e alcune caratteristiche minori sono mancanti.

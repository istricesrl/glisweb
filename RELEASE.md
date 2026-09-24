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

<!-- BOZZA DA RIVEDERE ( 24/09/2026 ): le voci 2.1.0, 2.0.0 e 0.1.1 sono ricostruite dalla storia git dei due
repository, date e contenuti vanno confermati prima di creare i tag 2.0.0 e 2.1.0 -->

## 2.1.0 del 01/05/2024 — linea unstable ( glisdev )
Prima release della linea unstable, che vive nel repository [glisdev](https://github.com/istricesrl/glisdev) ed è
dichiarata in `_etc/_current.release` fin dal commit iniziale. Rispetto alla 2.0 porta i template di nuova
generazione in `_src/_tpl/` ( Twig, in parte già su Bootstrap 5 ), i moduli di nuova generazione con prefisso di due
lettere ( `_AC000.account`, `_NO000.notizie`, ... ) e non contiene più i moduli e il templating della generazione
precedente ( `_src/_templates/`, `_src/_html/`, `_mod/_NNNN.*` ). La parte condivisa del codice è la stessa della
linea stable, file per file.

## 2.0.0 del 11/09/2023 — linea stable ( glisweb )
Release corrente della linea stable, dichiarata con l'introduzione di `_etc/_current.release` e
`_etc/_current.version` ( commit `5cdad4372` ). Raccoglie circa 1.800 commit successivi alla 0.1.1 e mantiene la
compatibilità con i moduli e i template della generazione precedente.

## 0.1.1 del 04/11/2021
Release intermedia, presente come tag nel repository.

## 0.0.1 del 08/10/2020
Questa è una release di test, pubblicata per dare modo agli sviluppatori esterni di provare il codice. Comprende la maggior parte delle funzionalità di base ma i moduli non sono ancora stati portati e alcune caratteristiche minori sono mancanti.

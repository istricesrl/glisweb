# colli

Il modulo colli gestisce i contenitori fisici con cui la merce viene movimentata e spedita: scatole,
bancali, ceste. Ogni collo ha un codice proprio, stampato su un'etichetta, che lo accompagna per
tutta la sua vita.

## a cosa serve un collo
<!-- @pubblico: operatore, amministratore -->

Un collo è l'unità che si scansiona. Tutte le maschere di magazzino ragionano su di esso: quando si
riceve merce la si associa a un collo, quando si prepara una spedizione ci si mette dentro degli
articoli, quando si chiude lo si sigilla e lo si consegna.

Il codice del collo è la sua identità: va letto con il lettore di barcode e non digitato a mano. Un
codice battuto a tastiera è la causa più frequente di merce associata al collo sbagliato.

## stampare le etichette
<!-- @pubblico: operatore, amministratore -->

Le etichette si stampano dal riquadro **stampa etichette**, che chiede due codici:

| campo compilato | che cosa stampa |
|---|---|
| solo **dal codice** | il collo indicato, oppure l'intera serie se si scrive solo il prefisso |
| **dal codice** e **al codice** | tutti i colli compresi fra i due, estremi inclusi |

Se non compare nessuna etichetta, il codice digitato non corrisponde a nessun collo: la stampa lo
dice invece di produrre un foglio bianco.

> **attenzione** — c'è un tetto di 500 etichette per stampa. Oltre quel numero la richiesta viene
> rifiutata e va ristretta: serve a non mandare in coda migliaia di pagine per un codice sbagliato.

## chiudere un collo
<!-- @pubblico: operatore -->

Alla chiusura si conferma il codice del collo che è bloccato in maschera. Il codice digitato **è una
conferma, non una scelta**: se non corrisponde a quello aperto, la chiusura viene rifiutata e il
collo resta aperto, così si può ritentare.

## configurare le etichette
<!-- @pubblico: amministratore -->

Il formato dell'etichetta e il testo di intestazione non si cambiano da maschera: sono configurazione
dell'installazione. L'intestazione può cambiare in base al prefisso del codice, per distinguere a
colpo d'occhio i colli di ricevimento da quelli di spedizione.

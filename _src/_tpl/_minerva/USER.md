# Minerva, la web app da tablet

Minerva è il template delle **web app**: le pagine che si usano in piedi, con un tablet o un
telefono in mano, per fare un lavoro preciso, in magazzino per esempio. Si entra con
utente e password e si trova una barra in alto e, sotto, delle **piastrelle** grandi da toccare.
È lontano dal gestionale per scelta: poche cose per pagina, bersagli grandi, niente tabelle da
scrivania.

> **nota** — nello standard le pagine di Minerva sono quasi vuote: la home dell'app e la pagina
> dell'account mostrano il titolo e le piastrelle, e nient'altro. Le maschere vere — ricezione,
> smistamento, trasferimenti, iscrizioni — le aggiunge il progetto o un modulo, e hanno la loro
> documentazione. Questo capitolo descrive quello che hanno in comune.

## entrare

La pagina di accesso non ha barra né piede: un riquadro chiaro con **username**, **password** e il
pulsante **login**. Se il sito usa reCAPTCHA, prima dell'invio può chiedere di confermare di non
essere un programma.

> **nota** — la pagina di accesso di Minerva non ha il link *password dimenticata*: la password si
> fa reimpostare da chi amministra l'installazione, o dalla pagina di reimpostazione del sito se
> l'installazione ne ha una.

## la barra in alto
<!-- @pubblico: operatore -->

Resta ferma in cima mentre si scorre, e ha due parti:

| parte | cosa contiene |
|---|---|
| **menu** | le aree dell'app: *home* e quelle aggiunte dai moduli |
| **icone** a destra | l'**account** ( l'omino ), il **carrello** quando contiene qualcosa, e l'**uscita** |

Il carrello compare **solo se ci sono articoli dentro**: vederlo è già un'informazione.
L'icona di uscita chiude la sessione e riporta alla pagina di accesso.

Su schermo stretto il menu si raccoglie nel pulsante con le **tre linee**, e le icone restano sempre
visibili accanto a lui: l'uscita non finisce mai nascosta. Se le voci del menu sono tante la barra
**va a capo** e cresce in altezza, invece di tagliare le ultime.

> **nota** — su uno schermo **basso** — un telefono tenuto in orizzontale — la barra smette di stare
> ferma e scorre via col contenuto, per non occupare un terzo dello schermo. Per tornarci si risale
> la pagina.

Passando col mouse su un'icona compare il suo nome: serve quando l'icona da sola non basta a
capire. Su un tablet, dove il mouse non c'è, il nome non compare.

## le piastrelle
<!-- @pubblico: operatore -->

Sotto il titolo della pagina ci sono le **piastrelle**: una per ogni pagina che sta dentro quella in
cui ci si trova. Ognuna ha un'icona, un titolo e una riga che dice a cosa serve. Toccarla fa una di
tre cose:

| comportamento | cosa succede |
|---|---|
| **apre una pagina** | il caso normale: si scende di un livello |
| **apre una finestra** | un riquadro sopra la pagina, per un'operazione veloce che non merita una pagina sua |
| **esegue un'operazione** | l'operazione parte subito, senza cambiare pagina |

Su un telefono le piastrelle stanno una sotto l'altra; su un tablet o uno schermo più largo si
affiancano, di norma tre per riga.

## maschere con tabelle
<!-- @pubblico: operatore -->

Le maschere che mostrano elenchi — gli articoli attesi, quelli ricevuti, i colli — su schermo stretto
possono essere più larghe dello schermo. Quando la maschera è fatta bene **scorre la tabella** di
lato, e il resto della pagina sta fermo; se invece scorre di lato **tutta la pagina**, barra
compresa, è un difetto di quella maschera e va segnalato.

## quello che questo capitolo non dice ancora

- cosa c'è nella pagina **account** di un'installazione reale, che nello standard è vuota;
- come si presentano il **carrello** e la sua conferma, che stanno nei moduli;
- le figure: sarebbero utili lo scatto della pagina di accesso e quello di una home con le
  piastrelle, a larghezza di tablet in verticale ( 768 punti ) e di telefono.

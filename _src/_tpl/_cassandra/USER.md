# Cassandra, il sito a una colonna

> **nota** — Cassandra è un template **in costruzione**. Nessuna pagina standard del framework lo
> usa, la sua documentazione per sviluppatori è ancora vuota e mancano pezzi che un sito completo
> dà per scontati, a cominciare dalla pagina di accesso. Questo capitolo descrive quello che c'è
> oggi; se l'installazione che si ha davanti lo usa, è probabile che sia stato completato per il
> progetto, e qualche dettaglio può non corrispondere.

Cassandra è un template per il **sito pubblico**: una colonna centrale di contenuto, una barra col
menu in alto e un piede in fondo, entrambi su fondo grigio chiaro. È il fratello maggiore di
Aurora — stesso carattere a spaziatura fissa, stessa sobrietà — con in più un menu che su schermo
stretto si raccoglie in un pulsante.

## com'è fatta la pagina

| fascia | cosa contiene |
|---|---|
| **barra in alto** | il menu del sito; **resta ferma** in cima mentre si scorre la pagina |
| **contenuto** | il titolo e l'eventuale sottotitolo, centrati, e sotto il testo della pagina |
| **piede** | la firma del framework e i link a *privacy* e *affiliazioni*, in piccolo |

I link del testo sono **rossi e in grassetto**, e si sottolineano al passaggio del mouse: è il modo
in cui Cassandra dice *questo si può premere*.

## il menu

Su uno schermo largo le voci stanno in riga nella barra in alto. Su uno schermo stretto — un
telefono, un tablet in verticale — al loro posto c'è il pulsante con le **tre linee**: si preme e
il menu si apre sotto la barra, si ripreme e si richiude.

Se una voce ha delle sotto-voci, queste compaiono **elencate sotto di lei**, sempre visibili: non ci
sono tendine che si aprono al passaggio del mouse.

## i blocchi di link
<!-- @pubblico: amministratore -->

Chi scrive i contenuti ha a disposizione due forme di link pensate per le pagine di smistamento,
quelle che servono a mandare il visitatore altrove:

| forma | come si presenta | a cosa serve |
|---|---|---|
| **link di area** | una fascia grigio chiaro a tutta larghezza, con un bordo scuro a sinistra | elencare le sezioni del sito una sotto l'altra |
| **riquadro** | un blocco grigio scuro con testo bianco, che schiarisce al passaggio del mouse | mettere in evidenza pochi collegamenti affiancati |

Si ottengono dando al link la classe `area-link` o `box-link` nell'editor del contenuto.

## cookie e stampa

Il **banner dei cookie**, quando il sito ne ha bisogno, compare in fondo alla pagina come in tutti
i template del sito pubblico. In **stampa** barra, menu e banner spariscono e resta il contenuto.

## quello che Cassandra non fa ancora

- non ha una **pagina di accesso**: una pagina riservata fatta con Cassandra non può mostrare il
  modulo per entrare;
- non mostra il **percorso** ( *home > sezione > pagina* ): il pezzo esiste nel template ma non è
  collegato alla pagina;
- non ha **ricerca**, **carrello** né **area utente**.

## quello che questo capitolo non dice ancora

- le figure: sarebbero utili lo scatto di una pagina a schermo largo e quello a schermo stretto col
  menu aperto, ma serve prima una pagina di esempio che usi il template.

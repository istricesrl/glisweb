# Aurora, la pagina essenziale

Aurora è il template più semplice del framework: testo nero su fondo bianco, carattere a spaziatura
fissa, nessuna immagine di cornice. Chi visita il sito non lo chiama per nome, e spesso nemmeno si
accorge di esserci: lo incontra sulle pagine di servizio che ogni installazione ha già di suo.

| pagina | quando la si vede |
|---|---|
| **privacy e cookie policy** | dal link in fondo a ogni pagina, o dal banner dei cookie |
| **divulgazione delle affiliazioni** | dal link in fondo a ogni pagina, accanto alla privacy |
| **pagina non trovata** | quando l'indirizzo scritto o seguito non corrisponde a nessuna pagina |

Un sito può anche essere fatto interamente con Aurora — piccoli siti, pagine di sola lettura — ma
in un'installazione tipica è questo il suo posto: le pagine che devono esserci e dire una cosa sola.

## com'è fatta la pagina

Dall'alto in basso, sempre le stesse quattro fasce:

| fascia | cosa contiene |
|---|---|
| **percorso** | dove ci si trova, come fila di link separati da `>`; c'è solo sulle pagine che ne hanno uno |
| **menu** | le voci del sito in riga, separate da una barra verticale; se una voce ha delle sotto-voci, queste compaiono sotto la riga |
| **contenuto** | il titolo, l'eventuale sottotitolo e il testo della pagina |
| **piede** | la firma del framework e i link a *privacy* e *affiliazioni* |

Il menu non si apre e non si chiude: è una riga di link, e su schermo stretto va semplicemente a
capo. Man mano che lo schermo si allarga i margini laterali crescono, così il testo non arriva mai
a riempire tutta la larghezza di un monitor grande.

> **nota** — se il sito non ha un menu, o la pagina non ha un percorso, la fascia corrispondente
> non c'è: non è un errore, sulle pagine di servizio è la regola.

## la pagina non trovata

Dice che la pagina cercata non esiste più o è stata spostata, propone il link alla **home page** e
riporta data e ora in cui è stata generata. Quell'orario serve a chi assiste: se si segnala un link
rotto, conviene copiarlo insieme all'indirizzo che non ha funzionato.

## cookie e stampa

Se il sito usa cookie per cui serve un consenso, in fondo alla pagina compare il **banner dei
cookie** con i pulsanti *accetta tutti* e *rifiuta tutti* e il dettaglio cookie per cookie. Il
banner non compare sulla pagina della privacy, che è quella da leggere prima di decidere, ed è lo
stesso in tutti i template del sito pubblico: cambia l'aspetto, non le scelte.

In **stampa** percorso, menu e banner dei cookie spariscono: resta il contenuto col piede, che è
quello che serve quando si stampa un'informativa.

## quello che Aurora non fa

- non ha un **accesso riservato**: una pagina fatta con Aurora che richieda di entrare con utente e
  password mostra una pagina vuota invece del modulo di accesso;
- non ha **ricerca**, **carrello** né **area utente**: sono componenti che portano altri template;
- non ha una versione per **schermo stretto** diversa da quella normale: è la stessa pagina, con
  margini più piccoli.

## quello che questo capitolo non dice ancora

- come si presenta il **menu con le sotto-voci**, che su Aurora escono sotto la riga principale
  come testo semplice e non come tendina;
- le figure: sarebbero utili lo scatto della pagina della privacy col banner dei cookie aperto e
  quello della pagina non trovata.

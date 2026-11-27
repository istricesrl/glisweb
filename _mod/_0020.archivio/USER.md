# archivio

Il modulo raccoglie le **anagrafiche di servizio** del back-end: gli elenchi di supporto che altre schede richiamano nei loro menu a tendina ( luoghi, zone, indirizzi, periodi, listini, immagini, video, audio ). Nel menu sta alla voce **archivio**, divisa in aree: **logistica**, **media**, **amministrazione**, **commerciale**, **contenuti**. Le voci sono visibili a amministratore e staff; le aree contenuti, logistica, amministrazione e commerciale, i reparti, le modalità di spedizione, i gruppi dei listini e i metadati solo all'amministratore.

Per elenchi, ricerche e schede vedi [elenchi e ricerche](012.elenchi.md) e [le schede](014.schede.md).

## logistica

### gli indirizzi

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: indirizzi.view -->

L'elenco ha le colonne #, stato, comune, indirizzo. Ha tre linguette: l'elenco; **indirizzi da normalizzare** ( #, codice, anagrafica, categorie, indirizzo, elaborazione ); **azioni indirizzi**, dove sta il riquadro **unione indirizzi**, che unisce due indirizzi e tutti gli oggetti collegati.

La scheda ( `indirizzi.form` ) ha i dati generali: tipo, indirizzo ( obbligatorio ), civico, CAP, località, comune, descrizione e note. Le linguette: **associazioni**, **mappa** ( latitudine, longitudine e mappa ) e **azioni indirizzo**, con il pulsante "geolocalizza l'indirizzo" che compila le coordinate quando il servizio di geolocalizzazione è configurato.

La scheda di normalizzazione ha anagrafica, ruolo, indirizzo ( obbligatorio ), note e un riquadro **analisi**, di sola lettura, con il risultato dell'analisi dell'indirizzo ( indirizzo, civico, località e così via ).

### luoghi, zone e le loro tipologie

| elenco | colonne | scheda |
|---|---|---|
| luoghi | #, luogo, tipologia, indirizzo | tipologia, genitore ( un altro luogo ), nome, indirizzo ( con inserimento rapido ), URL, descrizione e note |
| tipologie dei luoghi | #, nome | genitore, nome ( obbligatorio ) |
| zone | #, luogo, tipologia | tipologia, genitore, nome ( obbligatorio ), note; linguetta **stati** con gli stati che ne fanno parte |
| tipologie delle zone | #, nome | genitore, nome |

Genitore serve a costruire un albero: un luogo o una zona può stare dentro un altro.

### tipologie di corrispondenza e pesi

Due piccoli elenchi ( #, nome ): le tipologie di corrispondenza ( voce "corrispondenza" ) e i loro pesi ( voce "pesi" ). La scheda ha genitore e nome ( obbligatorio ); la linguetta metadati è solo dell'amministratore.

## media

### immagini

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: immagini.view -->

L'elenco ha #, titolo, path, ruolo. La scheda ha **dati generali** ( etichetta obbligatoria, anno ) e i riquadri per il file dell'immagine ( con orientamento e taglio ), un eventuale file alternativo e l'anteprima. Le linguette:

| linguetta | a cosa serve |
|---|---|
| associazioni | lega l'immagine a pagine, anagrafiche, indirizzi, prodotti, categorie, progetti, notizie, contratti e altro, con ordine ( obbligatorio ) e ruolo |
| anagrafica | le anagrafiche collegate e il loro ruolo |
| SEM/SMM | per lingua, il testo alternativo ( attributo alt ) |
| testo | per lingua, i testi h1, h2, h3 e il cappello |
| metadati | solo amministratore |
| azioni immagine | "scalatura immagine": forza la scalatura di questa immagine |

### video e audio

Stesso schema delle immagini ( elenco #, titolo, path, ruolo ). La scheda ha etichetta ( obbligatoria ), tipologia ( file o incorporato ), il codice di incorporamento e il file caricato. Le linguette **associazioni** ( ordine, ruolo; pagine, prodotti, categorie, anagrafiche ) e **testo** ( lingua, h1, h2, h3, cappello ).

## amministrazione e commerciale

| elenco | colonne | scheda |
|---|---|---|
| periodi | #, tipologia, nome, data inizio, data fine | tipologia, nome, date di inizio e fine, descrizione e note |
| tipologie dei periodi | #, nome | genitore, nome |
| listini | #, nome | dati del listino; linguetta **gruppi** ( solo amministratore ) |
| reparti | #, nome | nome ( obbligatorio ), IVA ( obbligatoria ), settore, note |
| modalità di spedizione | — | riquadro **a cosa si applica** ( tipologia, zona, categoria di prodotti, prodotto, articolo ) e riquadro **costo e tempi** ( pezzi per spedizione, importo netto, valuta, IVA, giorni per la spedizione, giorni per la consegna ) |

> **attenzione** — le anagrafiche di servizio sono richiamate da altre schede: cambiare il nome di una voce la cambia dappertutto.

## quello che questo capitolo non dice ancora

- le schede di template, mail, redirect, valutazioni e ranking delle anagrafiche, dichiarate nell'area contenuti e commerciale;
- il dettaglio della scheda dei listini e l'elenco delle modalità di spedizione;
- la procedura di unione degli indirizzi passo per passo.

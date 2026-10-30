# progetti

Il modulo gestisce i **progetti**: lavori con un cliente, una tipologia, un valore e un ciclo che va dall'apertura alla chiusura. Compaiono in tre aree del menu, ciascuna con la propria voce **progetti**: **produzione** ( in archivio ), **commerciale** e **amministrazione**. Le tre maschere sono gemelle; cambiano le linguette disponibili e i gruppi che le vedono. Per elenchi e schede vedi [elenchi e ricerche](012.elenchi.md) e [le schede](014.schede.md).

| area | chi la vede |
|---|---|
| produzione | amministratore e staff |
| commerciale | amministratore e staff |
| amministrazione | solo amministratore |

## l'elenco dei progetti

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: progetti.view -->

Colonne: #, cliente, tipologia, nome, categorie. Ogni area ha le linguette **elenco**, **archivio** ( i progetti archiviati ) e **azioni**. In produzione e in amministrazione c'è anche la voce **categorie**.

## la scheda di un progetto

<!-- @pagina: progetti.form -->

Il riquadro **dati generali**:

| campo | cosa si scrive |
|---|---|
| codice | il codice del progetto ( obbligatorio ) |
| cliente | l'anagrafica cliente |
| indirizzo | un indirizzo del cliente |
| tipologia | obbligatoria |
| nome | obbligatorio |
| descrizione | note libere |

Nella scheda commerciale c'è anche la data di apertura. Le altre linguette, nell'ordine in cui compaiono:

| linguetta | contenuto |
|---|---|
| accettazione | data apertura, periodicità, valore del progetto ( € ), stima dei costi ( € ), stima delle ore; data di accettazione, periodicità, valore di accettazione, note |
| attività, todo | le attività e le to-do del progetto |
| pianificazioni | in produzione: ripetizioni ogni n. giorni, fino al, giorni di rinnovo |
| web, SEM, testo, immagini, video, audio, file | contenuti pubblici del progetto; web e SEM solo amministratore |
| macro, metadati | solo amministratore |
| chiusura | data di chiusura, valore finale, costi finali, ore finali, note |
| archiviazione | data e note di archiviazione |

> **nota** — le cifre di accettazione e di chiusura sono obbligatorie nei rispettivi riquadri: valorizzarle a zero se non servono.

## le categorie dei progetti

<!-- @pagina: categorie.progetti.view -->

Solo amministratore. L'elenco ha #, categoria. La scheda ha sito, genitore, nome ( obbligatorio ) e i segni "gestione progetti" ( ordinario, straordinario ) e "gestione corsi" ( disciplina, classe, fascia ), più le linguette web, SEM, testo, immagini, video, audio, file, macro, menu e metadati.

## i progetti nelle altre schede

Il modulo aggiunge una linguetta **progetti** alla scheda anagrafica ( con il pulsante **nuova attività** che apre l'agenda ) e alle pagine dell'area contenuti ( a cui si legano i progetti ).

## quello che questo capitolo non dice ancora

- le linguette matricole, mastri, pause, done, planned, sprint e backlog;
- il ciclo completo di un progetto, dall'accettazione alla chiusura;
- l'uso delle categorie nella pubblicazione sul sito.

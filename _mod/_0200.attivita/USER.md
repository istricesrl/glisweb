# attività

Il modulo gestisce le **attività**: i lavori programmati ed eseguiti dagli operatori, con data, orari, ore e collegamento al cliente o al progetto. Sta nell'area **archivio**, in **produzione**, alla voce **attività**. Aggiunge anche una linguetta **attività** a molte altre schede ( anagrafica, documenti, progetti, ticket, todo ). Per elenchi, ricerche e linguette vedi [elenchi e ricerche](012.elenchi.md) e [le schede](014.schede.md).

## l'elenco delle attività

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: attivita.view -->

Ha tre linguette: l'elenco, i **cartellini** e le **azioni**. L'elenco è ordinato per data di esecuzione. Colonne principali: #, tipologia, ID e nome del progetto, codice, cliente, data e orario programmati, assegnata a, data di esecuzione, svolta da, descrizione dell'attività, ID dello step e del documento, ore ( alcune sono nascoste e si mostrano dalla scelta delle colonne ).

Filtri propri: giorno, mese, anno, step, incaricato, esecutore, cliente, tipologia.

La linguetta **azioni** offre le esportazioni delle ore ( per operatore, per progetto, per progetto e tipologia, operatori per progetto, in un mese e anno ) e tre operazioni sull'archivio statico delle attività: ripopolamento, pulizia, svuotamento.

> **attenzione** — svuotamento e pulizia dell'archivio statico cancellano i dati della vista, non le attività; il ripopolamento li ricostruisce ma può richiedere tempo.

## la scheda di un'attività

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: attivita.form -->

Si intitola "gestione attività". Le linguette sono **gestione**, **feedback** ( solo amministratore ) e **file**. I riquadri della gestione:

| riquadro | campi |
|---|---|
| dati generali | tipologia ( obbligatoria ), tipologia INPS, descrizione ( obbligatoria ); i magazzini di scarico e carico, dove previsti |
| programmazione | data, ora inizio, ora fine, ore, incaricato, note di programmazione |
| esecuzione | data, ora inizio, ora fine, ore, esecutore, esito ( step ), note interne, note per il cliente |
| attribuzione | cliente, indirizzo e, dove presenti, immobile, todo, progetto, matricola ( con barcode ), documento |

Per un'attività legata a una to-do o a un progetto la scheda mostra anche lo storico delle attività completate e programmate. Il feedback registra data, operatore, interesse, raccomandazione e note.

## le attività dentro le altre schede

La linguetta **attività** compare sulle schede di anagrafica, documenti, fatture, note di credito e ricevute di amministrazione, macchine, ticket, todo e progetti ( amministrazione, commerciale, produzione ). Mostra il sotto-elenco delle attività di quell'oggetto; nuovo inserimento precompila il collegamento. Nell'anagrafica un riquadro **nuova attività** ha un pulsante per tipologia che apre l'agenda, sopra al sotto-elenco e ai promemoria.

## turni

<!-- @pagina: turni.view -->

Solo amministratore. L'elenco ha #, contratto, turno, data inizio, data fine, pianificazione, con le linguette **elenco**, **schema** e **pianificazione**. La scheda ha contratto, anagrafica, date e turno; la linguetta **pianificazione** imposta la periodicità ( ogni n. settimane, ultima data di inizio, giorni di rinnovo ) e i giorni della settimana.

## categorie e tipologie delle attività

Solo amministratore. Le **categorie** ( #, categoria ) hanno genitore, nome e i ruoli ordinario, straordinario, produzione, ticket. Le **tipologie** ( #, tipologia ) hanno genitore, nome e i ruoli anagrafica, produzione, amministrazione, commerciale, contratto, ticket, più la linguetta metadati.

## quello che questo capitolo non dice ancora

- la scheda e le esportazioni dei cartellini;
- il significato di ogni campo della pianificazione dei turni;
- le schede di todo e ticket, che dichiarano la propria linguetta attività.

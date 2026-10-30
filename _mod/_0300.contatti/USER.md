# contatti

Il modulo raccoglie i **contatti** arrivati dai moduli di richiesta del sito ( "scrivici", "richiedi informazioni" e simili ): ogni invio produce una riga che l'operatore ritrova nel back-end, può collegare a un'anagrafica e a una campagna e annotare. Si trova nell'area **archivio**, sotto **commerciale**, alla voce **contatti**.

Per come si usano gli elenchi, la ricerca e le schede vedi i capitoli [elenchi e ricerche](012.elenchi.md) e [le schede](014.schede.md).

## l'elenco dei contatti

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contatti.view -->

Elenca i contatti ricevuti. Le colonne:

| colonna | contenuto |
|---|---|
| # | numero progressivo del contatto |
| data | giorno in cui il contatto è arrivato |
| form | il modulo del sito da cui è stato inviato |
| contatto | il nome indicato da chi ha scritto |
| ora | l'ora del contatto |
| tipologia | la tipologia assegnata al contatto |
| anagrafica | l'anagrafica collegata, se c'è |
| segnalatore | chi ha segnalato il contatto, se c'è |
| campagna | la campagna a cui il contatto è attribuito |
| testo | il testo del messaggio |

Con il pulsante per aggiungere se ne inserisce uno a mano ( per esempio una richiesta arrivata per telefono ); cliccando una riga si apre la scheda.

## la scheda di un contatto

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contatti.form -->

La scheda si intitola "gestione contatto" ed è una sola schermata. Il riquadro **dati generali** contiene:

| campo | cosa si scrive |
|---|---|
| nome | il nome del contatto ( obbligatorio ) |
| campagna | la campagna a cui attribuirlo, da scegliere fra quelle esistenti |
| tipologia | la tipologia del contatto ( obbligatoria ) |
| segnalatore | l'anagrafica che ha segnalato il contatto |

Il riquadro **dati contatto** contiene:

| campo | cosa si scrive |
|---|---|
| data, ora | quando è avvenuto il contatto; in un contatto nuovo sono precompilati con la data e l'ora correnti |
| cliente | l'anagrafica a cui il contatto si riferisce; dal campo si può aprire la scheda anagrafica |
| nome | il nome della persona che ha scritto, se diverso dal nome del contatto |
| note | annotazioni libere dell'operatore |

> **nota** — i contatti che arrivano dal sito si creano da soli: l'operatore li completa ( cliente, campagna, note ) ma non deve reinserirli.

Le schede e gli elenchi sono visibili agli utenti dei gruppi amministratore e staff.

## quello che questo capitolo non dice ancora

- il testo e il mittente delle mail automatiche che il sito invia a chi compila un modulo, e come si personalizzano ( sono materia dello sviluppatore, vedi il `READ.md` del modulo );
- i valori possibili del campo tipologia e il modo in cui si gestiscono le campagne: appartengono ad altri capitoli.

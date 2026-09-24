# Athena, la cornice e le maschere

> **nota** — bozza del 2026-09-20, primo impianto. Serve a decidere il taglio prima di scrivere gli
> USER.md degli altri template. Le maschere ritratte contengono **dati generati**, non contatti veri:
> sono le anagrafiche `DEMO.` prodotte da `_src/_py/_mysql.populate.py`, e l'elenco è fotografato
> filtrato su di loro. Il filtro sta **dentro l'indirizzo dichiarato con lo scatto**, così nemmeno
> una rigenerazione può inquadrare qualcos'altro.

Athena è il template con cui è fatto il **back-end**: l'applicazione da cui si lavora tutti i giorni.
Chi la usa non lo chiama per nome — per lui è *l'applicazione* — e questo capitolo serve proprio a
lui: racconta com'è fatta una maschera, una volta sola, per tutte.

Perché Athena non disegna una maschera per volta: disegna **sei famiglie di pagina**, e ogni
maschera dell'applicazione appartiene a una delle sei. Imparata la famiglia, si sa usare anche una
pagina che non si è mai vista.

| famiglia | a cosa serve | come la si riconosce |
|---|---|---|
| dashboard | mostra informazioni | riquadri raccolti in gruppi, niente tabella |
| strumenti | contiene operazioni | riquadri che si premono, la risposta arriva lì |
| elenco | elenca oggetti | una tabella, la ricerca in alto, le frecce in fondo |
| scheda | gestisce **un** oggetto | campi da compilare e i dischetti in fondo |
| sotto-elenco | elenca oggetti che dipendono da un altro | una tabella **dentro** una scheda |
| strumenti di scheda | operazioni su **quell'** oggetto | riquadri dentro una linguetta della scheda |

## la cornice
<!-- @pubblico: operatore, amministratore -->

![la cornice dell'applicazione](shot/athena.cornice.png)
<!-- @shot: athena.cornice | /admin.it-IT.html | 1440x900 | #form-navigation | 9000 -->

Resta identica in tutte le pagine: il **menu** a sinistra con le aree a cui si ha accesso, le
**linguette** in alto con i lati da cui guardare la sezione in cui ci si trova, i **pulsanti dei
pannelli** in alto a destra.

Il menu si apre **sulla voce in cui si è**: le sotto-voci dell'area corrente compaiono sotto di lei e
scompaiono quando si va altrove, così l'elenco resta corto anche su un'installazione con dodici aree.

> **nota** — i pannelli in alto a destra — avvisi, sessione, lavori in corso, carrello, segnalibri,
> assistenza, informazioni, uscita — hanno il loro capitolo, *la dashboard e la cornice
> dell'applicazione*: sono della cornice, non di questa o quella maschera.

## gli elenchi
<!-- @pubblico: operatore, amministratore -->

![l'elenco delle anagrafiche](shot/athena.elenco.png)
<!-- @shot: athena.elenco | /anagrafica.it-IT.html?__view__[a47172af8b050311d71a4c6cf62ea1df][__search__]=DEMO | 1200x760 | #form-filtro | 9000 -->

Un elenco ha **una riga di comandi in alto e una barra in fondo**, e sono sempre quelle.

In alto:

| comando | cosa fa |
|---|---|
| ricerca per parola chiave | filtra l'elenco; la lente accanto, o l'invio, conferma |
| le tendine sopra le colonne | **ordinano** per quella colonna, crescente o decrescente |
| il **più** | apre la scheda di un oggetto nuovo |
| gli inserimenti rapidi | aprono un riquadro per aggiungere una riga senza lasciare l'elenco |

In fondo:

| comando | cosa fa |
|---|---|
| *da – a di totale* | a che punto dell'elenco si è |
| le frecce | la pagina precedente e la successiva |
| il foglio di calcolo | **scarica quello che si sta vedendo**, coi filtri e l'ordinamento correnti |
| il **più** | lo stesso di sopra, a portata di mano quando l'elenco è lungo |

Ricerca, ordinamento e pagina **restano** quando si esce dall'elenco e ci si torna: sono ricordati
per quell'elenco, non per la sessione intera, quindi due elenchi diversi non si disturbano.

> **nota** — *nessun dato trovato* non è un errore: vuol dire che con quella ricerca non c'è niente.
> Si svuota il campo e si riprova.

## le schede
<!-- @pubblico: operatore, amministratore -->

![la scheda di un contatto](shot/athena.scheda.png)
<!-- @shot: athena.scheda | /anagrafica/gestione.it-IT.html?anagrafica[id]=650 | 1200x760 | #form-anagrafica | 9000 -->

Una scheda è **un oggetto per volta**, e i suoi dati sono divisi in **linguette**: i dati generali
nella prima, il resto raggruppato per argomento. Cambiare linguetta non fa perdere quello che si è
scritto — si perde solo uscendo dalla scheda senza salvare.

In fondo, al posto delle frecce, ci sono i **dischetti**:

| pulsante | cosa fa |
|---|---|
| dischetto | **salva e resta** nella scheda |
| freccia + dischetto | **salva e torna** da dove si era entrati |
| freccia tonda a sinistra | **torna indietro senza salvare** |
| freccia tonda in giù | salva, quando si sta lavorando dentro un oggetto più grande |
| il giù della nuvola | scarica il documento allegato alla scheda, dove c'è |
| cestino | **cancella** l'oggetto, previa conferma |

> **attenzione** — *salva e torna* riporta **alla pagina da cui si è entrati**, che non è sempre
> l'elenco: entrando in una riga da un documento, si torna a quel documento.

Dentro una scheda ci sono spesso dei **sotto-elenchi**: sono elenchi a tutti gli effetti, con le
stesse regole di sopra, ma legati all'oggetto che si sta guardando. Si aggiunge una riga col più e la
si toglie col cestino; tutto diventa definitivo **al salvataggio della scheda**, non prima.

## le pagine di strumenti
<!-- @pubblico: operatore, amministratore -->

![una pagina di strumenti](shot/athena.strumenti.png)
<!-- @shot: athena.strumenti | /strumenti.it-IT.html | 1440x900 | #form-navigation | 9000 -->

Sono fatte di **riquadri raccolti in gruppi**: un clic esegue l'operazione **senza cambiare pagina**,
e la risposta arriva lì sopra il riquadro. Le operazioni che non si possono disfare chiedono prima
conferma.

La stessa forma torna dentro le schede, nella linguetta *azioni*: lì i riquadri operano su
**quell'oggetto** e non sull'installazione. La pagina *strumenti* dell'applicazione ha un capitolo
suo, che entra nel merito di ogni riquadro.

## quello che questo capitolo non dice ancora

- le **azioni rapide** che compaiono nell'ultima colonna di certi elenchi, una per una: nello scatto
  si vedono quattro icone e il capitolo non dice cosa fanno;
- i **filtri** sopra l'elenco — *stato* e *categoria* nella figura — che sono diversi dalla ricerca
  per parola chiave e cambiano da un elenco all'altro;
- la **riga di icone** in cima a una scheda, che sono le azioni e le stampe di quell'oggetto;
- i **campi** di una scheda visti da vicino: le tendine che cercano mentre si scrive, gli allegati,
  le date, l'editor di testo;
- come si comporta la stessa maschera **su schermo stretto**, dove il menu diventa una tendina;
- la **stampa** di un elenco e di una scheda, che non è l'esportazione in foglio di calcolo.

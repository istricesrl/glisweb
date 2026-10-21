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

In Athena la **ricerca** e il **più** stanno in alto a destra, e gli eventuali **filtri** alla
loro sinistra; le **tendine di ordinamento** sono la riga subito sopra la tabella, al posto delle
intestazioni; le **frecce**, il conteggio *da – a di totale* e l'icona del **foglio di calcolo** sono
in fondo, a sinistra e a destra. Le icone in fondo a ogni riga sono la colonna delle **azioni**.

Cosa fa ciascun comando, e come cerca la ricerca, lo dice il capitolo *elenchi e ricerche*: vale
per tutti gli elenchi, in qualsiasi template.

## le schede
<!-- @pubblico: operatore, amministratore -->

![la scheda di un contatto](shot/athena.scheda.png)
<!-- @shot: athena.scheda | /anagrafica/gestione.it-IT.html?anagrafica[id]=650 | 1200x760 | #form-anagrafica | 9000 -->

In Athena le **linguette** della scheda occupano le prime due righe in alto: a parole quelle con
i dati, a icone quelle con le immagini, i file, l'archivio, le stampe e le azioni. I **pulsanti per
salvare** sono in fondo alla scheda, a destra; il cestino sta in mezzo, e a sinistra la freccia per
tornare indietro senza salvare.

Le linguette che contengono un **sotto-elenco** si riconoscono perché sotto c'è una tabella con la
sua ricerca, come un elenco. Cosa fa ogni pulsante, e come si salvano sotto-elenchi e campi
ripetuti, lo dice il capitolo *le schede*.

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

- i **campi** di una scheda visti da vicino: gli allegati e l'editor di testo;
- come si comporta la stessa maschera **su schermo stretto**, dove il menu diventa una tendina;

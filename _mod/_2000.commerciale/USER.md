# commerciale

Il modulo *commerciale* offre una **dashboard** per seguire l'andamento delle trattative, stampare il rapporto sulla gestione commerciale e fare esportazioni e importazioni in CSV. Non ha schede proprie: i progetti, le attività e i promemoria si aprono nelle schede degli altri moduli. La voce **commerciale** sta nel menu dell'area riservata ed è accessibile allo staff e agli amministratori.

Per muoversi tra le linguette e le tessere vedi i capitoli [010 dashboard](../../_usr/_docs/_user/010.dashboard.md) e [012 elenchi](../../_usr/_docs/_user/012.elenchi.md).

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: commerciale -->

## la dashboard commerciale

La pagina ha quattro linguette: *commerciale*, *gestiti*, *stampe* e *azioni*. Le prime due sono elenchi di progetti, le altre due raccolgono tessere con le operazioni disponibili.

### andamento progetti: linguette *commerciale* e *gestiti*

La linguetta *commerciale* mostra l'**andamento delle trattative attive**; la linguetta *gestiti* mostra lo stesso prospetto per le **trattative gestite**. Le colonne sono le stesse:

| colonna | contenuto |
|---|---|
| # | numero del progetto |
| titolo | nome del progetto |
| account | l'account a cui fa capo la trattativa |
| valore | margine previsto |
| aggiornata | data dell'ultima attività svolta, con nome e note dell'attività |
| prossima azione | data dell'attività programmata, con nome e note; è un collegamento che apre la scheda dell'attività |
| azioni | tre icone, descritte sotto |

Un clic sulla riga apre la scheda del progetto.

Nella colonna **azioni** le icone aprono una finestra rapida per quel progetto, senza lasciare la dashboard:

- l'icona delle attività da fare (spunte) aggiunge un **todo**;
- la matita registra un'**attività**;
- il calendario con il segno più crea un **promemoria**.

> **nota** — le finestre rapide appartengono ai moduli delle attività e dei todo: le icone compaiono solo dove quei moduli sono presenti, e i campi delle finestre sono descritti nei rispettivi capitoli.

### stampe

Nella linguetta *stampe* c'è la tessera **rapporto gestione commerciale**, che stampa in PDF un rapporto sulla gestione di clienti e contatti. Il clic apre una finestra con:

| campo | contenuto |
|---|---|
| categoria | la categoria di anagrafiche da includere; è obbligatoria, se manca compare l'avviso "selezionare una categoria" |
| stato | lo stato da considerare |

Con **stampa** il PDF si apre in una nuova scheda, con **annulla** si chiude la finestra. Per le stampe in generale vedi il capitolo [016 stampe](../../_usr/_docs/_user/016.stampe.md).

### azioni: esportazioni e importazioni

La linguetta *azioni* ha due gruppi di tessere, tutte con una finestra di conferma.

**esportazioni**

- **esportazione per MailChimp**: scarica in formato CSV le e-mail dei contatti anagrafici;
- **esportazione indirizzario**: scarica in formato CSV gli indirizzi dei contatti anagrafici.

**importazioni**

- **importazione anagrafiche**: carica un file CSV di contatti anagrafici;
- **importazione azioni commerciali**: carica un file CSV di azioni commerciali. La finestra permette di scegliere il file e offre un collegamento al **modello CSV** da compilare; con **importa** si avvia il caricamento, al termine la pagina si ricarica.

> **attenzione** — l'importazione scrive direttamente nell'archivio: parti dal modello CSV fornito e controlla il file prima di caricarlo.

## quello che questo capitolo non dice ancora

- il contenuto esatto del PDF del rapporto di gestione commerciale e il significato di ciascuno stato selezionabile;
- il tracciato dettagliato dei CSV di esportazione e le regole di validazione dell'importazione;
- i campi delle finestre rapide di todo, attività e promemoria (sono nei capitoli degli altri moduli);
- i filtri dell'elenco progetti (tipologia, cliente) nella scheda dei progetti commerciali.

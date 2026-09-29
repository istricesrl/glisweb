# amministrazione

L'**amministrazione** è l'area del menu che raccoglie i documenti che contano per i conti: le
fatture, i loro articoli e i loro pagamenti. Come il commerciale e la logistica è divisa fra
**ciclo attivo** ( quello che si emette verso i clienti ) e **ciclo passivo** ( quello che arriva
dai fornitori ), e ha un archivio che raccoglie tutti i documenti insieme. Di suo porta la cornice
e l'elenco dei **reparti**; il resto lo aggiungono gli altri moduli.

Com'è fatta una dashboard, un elenco e una scheda lo dicono i capitoli *la dashboard e la cornice
dell'applicazione*, *la pagina strumenti* e *Athena, la cornice e le maschere*: qui si dice soltanto
che cosa c'è in quest'area.

## la dashboard dell'amministrazione
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione -->

Si apre dalla voce **amministrazione** del menu, e ha tre linguette:

| linguetta | cosa contiene |
|---|---|
| amministrazione | la dashboard: riquadri raccolti in gruppi, con ciò che vale la pena vedere entrando nell'area |
| stampe | i riquadri delle stampe in PDF dell'area |
| azioni | le operazioni dell'area, divise in esportazioni, importazioni ed elaborazioni |

> **nota** — lo standard prepara le tre pagine ma **non ci mette riquadri**: su un'installazione
> che non le ha personalizzate sono vuote, e in fondo c'è solo il pulsante per tornare indietro.

Tutte le pagine dell'area sono aperte solo a chi appartiene allo **staff** o agli
**amministratori**.

## le voci dell'area
<!-- @pubblico: operatore, amministratore -->

Aperta la voce *amministrazione*, il menu mostra sotto di lei le sotto-voci dell'area. Quali siano
dipende dai moduli attivi:

| sotto-voce | da dove viene | cosa si trova |
|---|---|---|
| ciclo attivo | questo modulo | la pagina dei documenti emessi; dentro, la voce **fatture** se c'è il modulo delle fatture |
| ciclo passivo | questo modulo | la pagina dei documenti ricevuti |
| archivio | questo modulo | l'archivio dell'area, qui sotto |

## il ciclo attivo e il ciclo passivo
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.ciclo.attivo -->

Ciascuno dei due è una piccola dashboard con la sua linguetta **azioni**, dove sono previsti i
gruppi esportazioni, importazioni, elaborazioni e viste statiche.

Sotto il **ciclo attivo** il modulo delle fatture aggiunge la voce **fatture**: l'elenco delle
fatture emesse, con i loro articoli, i pagamenti, le archiviate e le azioni. La scheda di una
fattura è materia del capitolo di quel modulo.

> **nota** — nello standard nessun modulo aggiunge ancora voci al **ciclo passivo**: la pagina c'è,
> ma è vuota.

## l'archivio dell'amministrazione
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.archivio -->

L'archivio raccoglie gli elenchi trasversali dell'area. Le linguette dei documenti le aggiunge il
modulo dei documenti, e dove quel modulo non c'è non compaiono:

| linguetta | da dove viene | cosa si trova |
|---|---|---|
| archivio | questo modulo | la dashboard dell'archivio, vuota nello standard |
| documenti | il modulo dei documenti | tutti i documenti, di qualunque tipo |
| articoli | il modulo dei documenti | tutte le righe di tutti i documenti |
| pagamenti | il modulo dei documenti | tutti i pagamenti registrati |
| reparti | questo modulo | l'elenco dei reparti, qui sotto |
| azioni | questo modulo | esportazioni, importazioni, elaborazioni e viste statiche |

Servono a cercare un documento, una riga o un pagamento quando non si sa a che cosa appartiene; il
lavoro di tutti i giorni si fa dalle voci dei due cicli.

### i reparti
<!-- @pubblico: amministratore -->
<!-- @pagina: amministrazione.archivio.reparti.view -->

La linguetta **reparti** elenca i reparti a cui si possono riferire i prezzi, uno per riga col suo
nome, in ordine alfabetico inverso.

#### la scheda di un reparto
<!-- @pubblico: amministratore -->
<!-- @pagina: amministrazione.archivio.reparti.form -->

Il clic su una riga dell'elenco, o il pulsante per aggiungerne uno, apre la scheda del reparto, con
due linguette:

| linguetta | cosa contiene |
|---|---|
| gestione | i dati del reparto |
| azioni | le operazioni sul reparto, divise in esportazioni, importazioni, elaborazioni e viste statiche; nello standard sono vuote |

Nella linguetta **gestione** si compilano:

| campo | cosa indica |
|---|---|
| nome | il nome del reparto, obbligatorio |
| IVA | l'aliquota IVA del reparto, obbligatoria |
| settore | il settore di attività a cui il reparto appartiene, facoltativo |
| note | appunti liberi |

## quello che questo capitolo non dice ancora

- i riquadri che una personalizzazione tipica mette nella dashboard e nelle stampe dell'area;
- quali moduli occuperanno il ciclo passivo, e con quali maschere;
- a che cosa serve un reparto nei calcoli di prezzi e documenti.

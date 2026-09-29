# contenuti

I **contenuti** sono l'area del menu da cui si cura ciò che il sito pubblica: pagine, notizie,
moduli di contatto, immagini e file. Come le altre aree porta una dashboard con le sue azioni e un
archivio, che gli altri moduli riempiono con le loro voci; in più ha una maschera tutta sua, la
**gestione dei template**, che permette di ritoccare l'aspetto del sito senza passare da chi lo
sviluppa.

Com'è fatta una dashboard, un elenco e una scheda lo dicono i capitoli *la dashboard e la cornice
dell'applicazione*, *la pagina strumenti* e *Athena, la cornice e le maschere*: qui si dice soltanto
che cosa c'è in quest'area.

## la dashboard dei contenuti
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti -->

Si apre dalla voce **contenuti** del menu, e ha due linguette: la **dashboard** e le **azioni**,
dove sono previsti i gruppi esportazioni, importazioni ed elaborazioni.

> **nota** — lo standard prepara le due pagine ma **non ci mette riquadri**: su un'installazione che
> non le ha personalizzate sono vuote, e in fondo c'è solo il pulsante per tornare indietro.

Tutte le pagine dell'area sono aperte solo a chi appartiene allo **staff** o agli
**amministratori**.

## le voci dell'area
<!-- @pubblico: operatore, amministratore -->

Aperta la voce *contenuti*, il menu mostra sotto di lei le sotto-voci dell'area, nell'ordine in cui
compaiono. Quali siano dipende dai moduli attivi:

| sotto-voce | da dove viene | cosa si trova |
|---|---|---|
| pagine | il modulo delle pagine | le pagine del sito, con i redirect, le archiviate e le azioni |
| notizie | il modulo delle notizie | le notizie e le loro categorie |
| contatti | il modulo dei contatti | le richieste arrivate dai moduli di contatto del sito |
| template | questo modulo | la gestione dei template, qui sotto |
| archivio | questo modulo | l'archivio dell'area, in fondo al capitolo |

## la gestione dei template
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.template.view -->

Un **template** è la veste grafica del sito: gli schemi delle pagine, i fogli di stile, gli script.
La voce **template** elenca quelli installati, uno per riga, e un clic su una riga apre l'elenco dei
suoi file. Il template del back-end — quello con cui è fatta l'applicazione stessa — non compare:
da qui non si può modificare.

> **attenzione** — è una maschera per chi sa che cosa sta toccando. Un errore in uno schema o in un
> foglio di stile si vede **subito sul sito pubblico**, per tutti i visitatori.

### l'elenco dei file di un template
<!-- @pagina: contenuti.template.form -->

La linguetta **gestione** mostra tutti i file del template, compresi quelli che i moduli attivi gli
aggiungono:

| colonna | contenuto |
|---|---|
| file | il percorso del file dentro il template |
| tipo | l'estensione: schema, foglio di stile, script, dati, testo |
| modulo | il modulo che porta quel file, vuoto se è del template stesso |

Sopra l'elenco, oltre alla ricerca per parola chiave, ci sono due tendine: una filtra per **tipo di
file** ( schemi HTML/Twig, fogli di stile CSS, script Javascript, dati JSON, dati YAML, testo
Markdown ), l'altra per **modulo**.

Il pulsante col **più cerchiato** apre la riga di inserimento rapido: si sceglie il modulo ( oppure
nessuno ) e si scrive il nome del file. Se lo standard ha già un file con quel nome se ne parte da
una copia, altrimenti si crea un file vuoto.

### l'editor
<!-- @pagina: contenuti.template.form.editor -->

Un clic su un file apre la linguetta **editor**, che compare solo quando c'è un file aperto: un
riquadro di testo con i numeri di riga e i colori della sintassi del tipo di file. Si salva coi
dischetti in fondo, come ogni scheda.

Il file originale del template **non viene mai sovrascritto**: la modifica finisce in una copia
personalizzata che da quel momento prende il suo posto. Per lo stesso motivo il **cestino** non
cancella il file del template ma solo la copia personalizzata, e il file torna com'era in origine.

> **attenzione** — la copia personalizzata nasce **già all'apertura** del file, anche se poi non lo
> si modifica: aprire un file per guardarlo equivale a congelarlo, e un aggiornamento successivo di
> quel file nello standard non si vedrà finché la copia non viene tolta col cestino.

> **attenzione** — svuotare del tutto il testo e salvare **non ha effetto**: il file resta com'era.
> Per tornare all'originale si usa il cestino.

## l'archivio dei contenuti
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.archivio -->

È l'ultima voce dell'area, e raccoglie gli elenchi trasversali: le linguette le aggiungono i moduli
attivi, e dove il modulo non c'è la linguetta non c'è.

| linguetta | da dove viene | cosa si trova |
|---|---|---|
| contenuti | il modulo dei contenuti testuali | tutti i testi collegati a pagine, notizie, prodotti e altri oggetti |
| menu | il modulo delle pagine | le voci dei menu del sito |
| immagini | il modulo delle immagini | tutte le immagini caricate |
| video | il modulo dei video | tutti i video collegati |
| audio | il modulo degli audio | tutti gli audio collegati |
| file | il modulo dei file | tutti i file allegati |
| azioni | questo modulo | esportazioni, importazioni, elaborazioni e viste statiche |

Servono a cercare un elemento quando non si sa a che cosa è attaccato; il lavoro di tutti i giorni
si fa dalla scheda dell'oggetto a cui l'elemento appartiene.

## quello che questo capitolo non dice ancora

- le **azioni** della gestione dei template, che nello standard sono vuote;
- come si riconosce, nell'elenco dei file, quali sono già stati personalizzati e quali no;
- dove finisce un file creato con l'inserimento rapido quando il template ha delle sottocartelle.

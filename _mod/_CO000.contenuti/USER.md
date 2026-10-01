# contenuti

Il modulo contenuti è quello che trasforma un oggetto dell'applicazione — una pagina, una notizia,
un prodotto, una categoria — in **qualcosa che si pubblica sul sito**: i testi in ogni lingua, i
titoli, l'indirizzo, i dati per i motori di ricerca e per i social, la voce di menu, il modello
grafico con cui la pagina si presenta.

Non ha una voce di menu sua. Lavora **dentro le schede degli altri moduli**, aggiungendo linguette:
chi apre la scheda di una notizia o di un prodotto trova lì tutto quello che serve per pubblicarlo,
senza andare altrove. L'unica maschera propria è l'**archivio dei contenuti**, descritto in fondo.

> **nota** — molte di queste linguette si presentano come un'**icona** e non come una scritta: il
> nome compare fermandoci sopra il puntatore.

## dove compaiono le linguette
<!-- @pubblico: operatore, amministratore -->

| scheda | linguette aggiunte |
|---|---|
| pagina | SEO/SEM, contenuti, javascript, macro, metadati |
| notizia | web, SEO/SEM, contenuti, metadati |
| categoria di notizie | web, SEO/SEM, contenuti, menu, metadati |
| prodotto | web, SEO/SEM, catalogo, metadati |
| categoria di prodotti | web, SEO/SEM, catalogo, menu |
| marchio | web, SEO/SEM, catalogo |
| articolo | metadati |
| contatto dell'anagrafica | metadati |
| template di una mail | contenuti |

Nelle schede del catalogo la linguetta dei testi si chiama **catalogo** invece di *contenuti*, ma è
la stessa cosa.

## i testi, lingua per lingua
<!-- @pubblico: operatore, amministratore -->

La linguetta **contenuti** ( o *catalogo* ) tiene i testi che il visitatore legge. In cima c'è la
tendina della **lingua**: si sceglie la lingua su cui lavorare, la pagina si ricarica e mostra i
testi di quella lingua. Le altre lingue non spariscono: restano salvate e tornano scegliendole.

| campo | contenuto |
|---|---|
| valore del tag h1 | il titolo principale della pagina |
| valore del tag h2, h3 | sottotitoli |
| cappello | le righe introduttive, prima del testo |
| abstract | il riassunto, usato negli elenchi e nelle anteprime |
| testo | il corpo della pagina |

Il **testo** si scrive in un editor di codice, che mostra il testo così com'è, con i suoi marcatori.
Dopo il primo salvataggio accanto al titolo del riquadro compare il link **vai all'editor visuale**,
che apre lo stesso testo in un editor che lo mostra già impaginato, con la barra dei pulsanti per il
grassetto, i titoli, i link.

> **attenzione** — scegliere un'altra lingua **invia la scheda**, come il dischetto: ci si arriva con
> i testi della lingua corrente già a posto, perché partono insieme al cambio.

## indirizzo, motori di ricerca, social
<!-- @pubblico: operatore, amministratore -->

La linguetta **SEO/SEM** ha anche lei la tendina della lingua, perché ogni lingua ha il suo
indirizzo e i suoi testi per i motori di ricerca.

| riquadro | campi |
|---|---|
| opzioni URL | **path custom**, **URL custom**, **rewrite custom**: servono a dare alla pagina un indirizzo diverso da quello che l'applicazione costruirebbe da sola |
| meta tag | **title** ( il titolo che compare nella scheda del browser e nei risultati di ricerca ), **keywords**, **description** ( le righe sotto il titolo nei risultati ), **robots** ( le istruzioni ai motori di ricerca ) |
| OpenGraph protocol | come la pagina si presenta quando la si condivide su un social: tipo, determinante, titolo, immagine, audio, video, descrizione |

## la pubblicazione sul sito
<!-- @pubblico: operatore, amministratore -->

La linguetta **web** dice **dove e come** l'oggetto va online:

| riquadro | campi |
|---|---|
| dati generali | il **sito** su cui compare, se l'installazione ne ha più d'uno, e delle note |
| flag di elaborazione | se la pagina entra nella **mappa del sito** per i motori di ricerca, e se può essere tenuta **già pronta in memoria** per servirla più in fretta |
| template, schema e tema | l'aspetto grafico: il **template**, lo **schema** di pagina e il **tema** dei colori |

Sotto c'è il sotto-elenco delle **pubblicazioni**: ogni riga è un periodo in cui l'oggetto è
pubblicato, con ordine, tipologia, data e ora di inizio e di fine, note. È così che si prepara una
notizia che deve uscire lunedì mattina, o un prodotto che deve sparire a fine stagione.

> **nota** — le tendine *schema* e *tema* dipendono dal template scelto, e si riempiono **dopo aver
> salvato** la scheda col template impostato.

> **nota** — anche la linguetta *web* dei **marchi** ha il sotto-elenco delle pubblicazioni, come
> prodotti, categorie e notizie.

## voci di menu, metadati, macro
<!-- @pubblico: operatore, amministratore -->

La linguetta **menu** — sulle categorie di notizie e di prodotti — mette l'oggetto nei menu del
sito. È un sotto-elenco, una riga per voce:

| campo | contenuto |
|---|---|
| ordine | la posizione della voce fra le altre |
| menu | in quale menu del sito compare |
| lingua | per quale lingua vale la voce |
| voce | il testo della voce |
| target | se il link si apre nella stessa finestra o in una nuova |
| ancora | un punto preciso della pagina a cui portare |
| sottopagine | se sotto la voce compaiono anche le pagine figlie |

La linguetta **metadati** è un sotto-elenco di coppie **etichetta – valore**, eventualmente per
lingua: dati in più che il sito può usare senza che serva un campo apposta nella scheda. Quali
etichette abbiano un effetto lo decide chi ha costruito il sito.

La linguetta **javascript** delle pagine ha un capitolo suo, *il javascript di una pagina*.

### le macro di una pagina
<!-- @pubblico: amministratore -->

La linguetta **macro** delle pagine è un sotto-elenco di **programmi** da eseguire quando la pagina
viene composta, scelti da una tendina di quelli disponibili sull'installazione. Serve a chi
costruisce il sito: aggiungerne o toglierne una cambia quello che la pagina sa fare, e una scelta
sbagliata può impedirle di comporsi.

## i testi dei template di posta
<!-- @pubblico: amministratore -->

Nella scheda di un template di posta la linguetta **contenuti** tiene, lingua per lingua, quello che
la mail contiene:

| campo | contenuto |
|---|---|
| mittente | chi figura come mittente |
| destinatari, destinatari CC, destinatari BCC | a chi va la mail, in chiaro, in copia e in copia nascosta |
| oggetto | l'oggetto della mail |
| testo | il corpo della mail |

Sui template degli **SMS** la stessa linguetta tiene, lingua per lingua, il **nome** e il
**numero** del mittente, i **destinatari** e il **testo**: un SMS non ha oggetto né copie.

## l'archivio dei contenuti
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.archivio.contenuti.view -->

Nell'area *contenuti*, sotto **archivio**, la linguetta **contenuti** elenca in un colpo solo tutti
i testi dell'installazione, qualunque sia l'oggetto a cui appartengono: una riga per ogni testo in
ogni lingua. Serve a cercare un testo quando non si sa dove sia.

La scheda di un contenuto raccoglie in una sola linguetta, **gestione**, i testi e i dati per i
motori di ricerca e i social descritti qui sopra, più due linguette per il corpo del testo:

| linguetta | cosa ci sta |
|---|---|
| testo | il corpo del testo nell'editor di codice |
| WYSIWYG | il corpo del testo nell'editor visuale, già impaginato |
| azioni | le operazioni sul testo; lo standard prepara i gruppi ma non ci mette riquadri |

> **nota** — di norma i testi si modificano dalla scheda dell'oggetto a cui appartengono, dove si
> vede il contesto. L'archivio è lo strumento per cercarli e per il lavoro di revisione.

## quello che questo capitolo non dice ancora

- quali **metadati** hanno un effetto sul sito standard, e cosa fanno;
- le **tipologie di pubblicazione** e cosa cambia fra l'una e l'altra;
- come si ottiene e si controlla l'**indirizzo** di una pagina, e quando servono i campi *custom*;
- il rapporto fra i **menu** decisi qui e quelli costruiti dalle pagine.

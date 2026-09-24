# documentazione del template Minerva

## Bootstrap: markup BS4 servito su BS5 (attenzione)

Il template carica **Bootstrap 5.3** (`etc/template.yaml`, `css.external` / `js.external`) ma è nato
su **Bootstrap 4** e la migrazione del markup è stata fatta **solo in parte**. Diverse utility BS4
sono state rinominate o rimosse in BS5 e, dove sono rimaste nel markup, sono **no-op silenziosi**:
non danno errore, semplicemente non fanno più nulla. È la causa tipica dei difetti di layout
("l'icona è tagliata", "non è allineato a destra", "il modale non si apre").

Tabella di conversione delle classi/attributi che ricorrono qui:

| BS4 (morto in BS5) | BS5 |
|---|---|
| `ml-*` / `mr-*` | `ms-*` / `me-*` |
| `pl-*` / `pr-*` | `ps-*` / `pe-*` |
| `text-left` / `text-right` | `text-start` / `text-end` |
| `no-gutters` | `g-0` |
| `form-row` | `row` (i gutter si regolano con `g-*`) |
| `.close` (bottone chiusura modale) | `.btn-close` (senza `&times;` dentro) |
| `data-toggle` / `data-target` / `data-dismiss` | `data-bs-toggle` / `data-bs-target` / `data-bs-dismiss` |
| `.media` / `.media-body` / `.media-left` | rimosse: si usa `d-flex` + utility flex |

Note pratiche viste sul progetto:
- `form-row` da solo in BS5 **non è un flex row**: dove il markup ha `class="form-row row"` funziona
  perché c'è `row`; dove ha solo `form-row` la riga non si dispone. Controllare sempre che ci sia `row`.
- il toggler dell'hamburger in `inc/navbar.twig` era già stato portato a `data-bs-toggle`/`data-bs-target`
  (per questo il menu collassa), ma tooltip, `text-right`, `ml-auto`/`mr-auto` erano rimasti BS4.
- i **tooltip** (`data-bs-toggle="tooltip"`) in BS5 vanno **inizializzati via JS**: il solo attributo non
  li accende. Qui non sono inizializzati, quindi si vede solo il `title` nativo del browser.

## Usabilità tablet (2026-09-01)

Il magazzino usa Minerva da tablet. Interventi fatti, tutti nel template (markup + CSS), verificati con
screenshot headless a 480 / 768 / 1024 px:

- **`inc/navbar.twig`**: classi di spaziatura/allineamento portate a BS5 (`ms-`/`me-`/`text-end`) e
  attributi tooltip a `data-bs-*`. Senza, l'header non allineava le icone e l'ultima (logout) finiva a
  filo del bordo.
- **`inc/subnav.twig`**: link dei modali da `data-toggle`/`data-target` a `data-bs-toggle`/`data-bs-target`
  (altrimenti le piastrelle-modale della subnav non aprono nulla).
- **`css/main.css`** (blocco "USABILITÀ TABLET" in coda): i pulsanti-icona dell'header centrati in flex e
  senza padding (il glyph FontAwesome veniva tagliato dentro il quadrato 2em); header da 1.8em a 1.5em;
  `.form-login` reso fluido con tetto 420px (a 20%/280px l'input di login si comprimeva); e la regola
  `main .form-row.row.d-flex > [class*="col-"] { min-width:0; overflow-wrap:anywhere }` per le griglie
  tabellari (es. "stato evasione LP" in packing), dove le intestazioni lunghe in colonne `col-md-1`
  debordavano e si sovrapponevano — un flex item ha `min-width:auto` e non scende sotto il contenuto.

Le regole CSS stanno **in coda** al file di proposito: sovrascrivono per cascata quelle sopra e, a formato
uguale, lasciano invariato l'aspetto dove era già corretto — così gli altri progetti su Minerva non
cambiano dove non serve. Le griglie sono ancora migliorabili accorciando le intestazioni (decisione di
contenuto, lasciata al progetto).

### Stati densi e tabelle (2026-09-01)

Le maschere logistica, quando sono "cariche" (fornitore/DDT/collo/magazzino agganciati), mostrano
elenchi e **tabelle vere** (`<table class="table ...">`), non solo form. Verifica sul tablet:

- gli **stati impilati** con i "cambia X" nella legend (`legend.d-flex.justify-content-between`)
  reggono bene: etichetta a sinistra, pulsante a destra.
- le **griglie a colonne bootstrap** (`.form-row.row.d-flex`, es. "stato evasione LP" in packing)
  sono coperte dalla regola CSS di wrap vista sopra.
- le **tabelle `<table>`** (smistamento "articoli attesi/ricevuti" con 5 colonne, riepilogo
  ricezione, trasferimento, associazione barcode) **non vanno a capo in larghezza**: a 768 px
  stanno, ma **sotto i 768** traboccano e fanno scrollare orizzontalmente **tutta la pagina**
  (header incluso). La cura è il wrapper bootstrap **`.table-responsive`** attorno a ogni tabella,
  così scrolla la tabella nel suo contenitore e non la pagina. Applicato nei template di progetto
  (`src/tpl/minerva/{smistamento,ricezione,trasferimento,associazione-barcode}.twig`).

Regola pratica per Minerva: **ogni `<table>` di dati va avvolta in `<div class="table-responsive">`**.
È un accorgimento di markup (non CSS), quindi va messo nel template dove sta la tabella; non c'è modo
pulito di farlo lato CSS su una `<table>` nuda senza rompere il layout della tabella.

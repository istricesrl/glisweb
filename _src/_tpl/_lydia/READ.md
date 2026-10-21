# documentazione del template Lydia
Lydia è il template Twig per il **sito pubblico con un'area riservata**: testata con logo e due menu, barra
delle categorie con la ricerca, immagini di testata ( carosello o jumbotron ), contenuto con percorso e galleria,
e le pagine per entrare, gestire il proprio account e reimpostare la password. È su **Bootstrap 4** ( 4.5.2 ):
le classi vanno scritte in sintassi BS4 ( `data-toggle`, `ml-auto`, `form-row`, `btn-block`, `sr-only` ) e non
convertite a BS5 finché il template dichiara quella versione in `etc/template.yaml`.

Fra le pagine standard l'unica che oggi lo usa è `password.reinsert` ( `_src/_inc/_pages/_password.it-IT.php` );
le altre pagine che nominano Lydia ( carrello, schede prodotto, risultati di ricerca, area utente, la versione
`en-GB` di `password.reinsert` ) puntano ancora a `_src/_templates/_lydia/`, cioè alla versione HTML della linea
vecchia, e non a questo template.

# file del template

file                                    | descrizione
----------------------------------------|-----------------------------------------------------------------------------------
etc/template.yaml                       | configurazione: menu, CSS e JS ( Bootstrap 4.5.2, jQuery, Colorbox, lazysizes, reCAPTCHA )
css/main.css                            | foglio di stile del template
js/main.js                              | Javascript del template: aggancia Colorbox alla galleria
lib/default.twig                        | posto per le macro proprie del template ( oggi vuoto )
ext/main.twig                           | lo schema base, esteso da tutti gli altri schemi
default.twig                            | lo schema di default: il contenuto della pagina
home.twig                               | lo schema della home page, per ora uguale a default.twig
user.twig                               | lo schema dell'area utente, per ora uguale a default.twig
login.twig                              | lo schema del login ( include `inc/login.twig` )
account.twig                            | il modulo dell'account: dati anagrafici e cambio password ( ramo `__account__` )
password.reset.twig                     | la reimpostazione della password in tre passaggi ( ramo `__pwreset__` )
inc/header.twig                         | il logo
inc/navbar.twig                         | i due menu della testata: `icons` e `main`
inc/categorie.twig                      | il menu `categorie` nella barra grigia
inc/search.twig                         | la casella di ricerca, verso la pagina `ricerche.risultati`
inc/megamenu.twig                       | il menu `mega`, solo se la pagina lo ha
inc/sottomenu.twig                      | il menu `sottomenu`
inc/carousel.twig                       | il carosello delle immagini di ruolo `carousel`
inc/jumbotron.twig                      | il jumbotron con la prima immagine di ruolo `jumbotron`
inc/breadcrumbs.twig                    | il percorso *sei qui >*
inc/gallery.twig                        | la galleria delle immagini di ruolo `gallery`
inc/login.twig                          | il contenitore del modulo di accesso
inc/login.accesso.twig                  | il modulo di accesso ( ramo `__login__` ), con i link a reimpostazione e registrazione
inc/footer.1.twig                       | la prima fascia del piede: la firma
inc/footer.2.twig                       | la seconda fascia del piede: i link a `privacy`, `fornitura` e `affiliazioni`
inc/flags.twig                          | segnaposto per il selettore delle lingue, oggi non incluso da nessuno schema

# configurazione

## menu
I menu si dichiarano in `template.menu` e le pagine ci entrano con la chiave `menu` della loro definizione:
`icons` e `main` in testata, `categorie` nella barra grigia, `mega` sotto la barra ( il blocco compare solo se
`page.template.menu.mega` è valorizzato ) e `sottomenu`. Su schermo stretto i due menu della testata si aprono
con un solo pulsante, quello delle categorie e il menu esteso col proprio; il sottomenu resta sempre visibile.

## logo
Il logo si legge da `site.metadati.logo`, un percorso relativo alla root del sito, nello stesso posto in cui
Athena legge il tema ( `site.metadati.theme` ); se il sito non lo dichiara si usa quello del framework
( `_src/_img/_logo/_istrice-bn.png` ). Il testo alternativo è il nome del sito nella lingua corrente
( `site.name` ).

```json
"metadati": { "logo": "src/img/logo.png" }
```

## immagini della pagina
La libreria `_src/_twig/_lib/_default.twig` non ha macro per carosello, jumbotron e galleria ( erano in
`_src/_html/_bin/_default.html`, per la linea vecchia ): il markup sta nei tre `inc/`, e le singole immagini le
disegna `cms.image()` con i formati di `image.formats`.

ruolo           | dove compare              | cosa usa
----------------|---------------------------|---------------------------------------------------------------------------
`carousel`      | sotto la barra, a scorrere | per ogni immagine `h1`, `h2`, `cappello` come didascalia; `metadati.link` ( per lingua ) e `metadati.target` per il collegamento
`jumbotron`     | sotto la barra, fissa      | la prima immagine come sfondo; i testi dai metadati della pagina `jt_h3`, `jt_h1`, `jt_h1_href`, `jt_h2`, `jt_content`, `jt_action`, `jt_href`, `jt_target`, `jt_col_class`
`gallery`       | sotto il contenuto         | le miniature, che Colorbox apre ingrandite


# moduli

Tutti e tre i moduli usano `cms.formButton()`, che con le chiavi reCAPTCHA del sito ( `google.profile.recaptcha` )
aggiunge il token nel ramo del modulo.

modulo              | ramo          | gestito da
--------------------|---------------|-----------------------------------------------------------------------------
accesso             | `__login__`   | `_src/_config/_210.auth.php`
account             | `__account__` | `_mod/_0010.anagrafica/_src/_inc/_macro/_account.php`
reimpostazione      | `__pwreset__` | `_src/_inc/_macro/_password.reset.php`

Nel modulo dell'account i campi della nuova password nascono disabilitati e si attivano quando si scrive la
password corrente ( `also-required` ), e devono coincidere ( `required-equals` ): sono gli attributi di
`_src/_js/_lib/_form.js`. Se è attivo il modulo `0350.registrazione` il modulo di accesso mostra anche il link
*registrati* verso la pagina `registrazione`, come fa Athena.

I testi dei moduli di accesso, dell'account e del reset della password vengono dal dizionario `tr.generic`
( `trn.trw()` di `_src/_twig/_lib/_translation.twig` ), con il testo italiano come ripiego ( opzione `d` ) per le
lingue in cui la chiave non è tradotta: oggi il dizionario è completo per it-IT, en-GB e fr-FR. Athena ha
ancora i testi scritti in italiano nel template.

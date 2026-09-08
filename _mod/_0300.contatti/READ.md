# modulo contatti

> **nota** — capitolo travasato il 2026-09-08 dalla documentazione Doxygen `.dox`, ferma al
> 2024. I riferimenti sono stati verificati contro il codice e il database di oggi;
> dove il testo non e' stato riverificato riga per riga, va letto come una traccia da confermare,
> non come una descrizione garantita.


   Panoramica dei modulo contatti.

   introduzione
   ============
   Questo modulo consente la gestione di blocchi dati sotto la gerarchia __contatti__ specificando per ognuno varie strategie di elaborazione. Il modulo opera
   a livello di controller perché i moduli contatti possono trovarsi in molte pagine del sito e possono essercene anche più di uno per sito o addirittura per pagina.

   logica di funzionamento
   -----------------------
   Il modulo gestisce, a livello di controller, pacchetti dati etichettati opportunamente. Il modulo supporta nativamente alcuni comportamenti di base (salvataggio
   sul database, invio via mail) ed è estensibile con controller custom che possono aggiungere ulteriori comportamenti. Il modulo non è legato a una specifica pagina
   in quanto su un sito, e persino su una singola pagina, possono esserci più form di contatti.

   moduli di contatto
   ==================
   Il moduolo contatti serve sostanzialmente a gestire pacchetti dati inviati da form presenti sul sito, identificati da una chiave specifica. In altre parole,
   il modulo gestisce i dati inviati da form simili a questo:
```html
   <form method="post" action="" id="esempioform">
       <input type="text" name="__contatti__[esempio][mail]">
       <input type="submit">
   </form>
```
   La presenza nella $_REQUEST della chiave riservata __contatti__ fa saltare al pacchetto dati la controller di default, e innesca il lavoro del modulo contatti
   che si svolge essenzialmente nel file _mod/_0300.contatti/_src/_config/_750.controller.php.

   gestione di default
   -------------------

   [...] un modulo del tipo:
```html
   <form method="post" action="" id="esempioform">
       <input type="text" name="__contatti__[esempio][nome]">
       <input type="text" name="__contatti__[esempio][mail]">
       <input type="submit">
   </form>
```
   [...] modificare la configurazione del modulo come segue:
```json
   "contatti": {
       "esempio": {
           "mail": {
               "interna": {
                   "destinatari":
                       { "webmaster": "webmaster@sito.bho" }
               }
           }
       }
   }
```
   [...] personalizzare il template di ringraziamento di default:
```json
   "mail": {
       "tpl": {
           "DEFAULT_RINGRAZIAMENTO_CONTATTI": {
               "it-IT": {
                   "from": { "GlisWeb": "noreply@glisweb.videoarts.eu" },
                   "oggetto": "grazie per la tua richiesta!",
                   "testo": "grazie per averci contattati! ti ricontatteremo il prima possibile"
               }
           }
       }
   }
```
   [...] personalizzare soltanto il mittente della mail di default:
```json
   "mail": {
       "tpl": {
           "DEFAULT_CONTATTI": {
               "it-IT": {
                   "from": { "GlisWeb": "noreply@glisweb.videoarts.eu" }
               }
           }
       }
   }
```
   [...] specificare una o più controller custom da attivare all'invio del modulo:
```json
   "contatti": {
       "esempio": {
           "controller": [
               "percorso/per/la/controller.php"
           ]
       }
   }
```
   gestione dei dati in arrivo
   ===========================

   invio di mail
   -------------
   Nella composizione del template, si tenga presente che i dati inviati tramite il modulo sono accessibili tramite la chiave dati, quindi ad esempio per il modulo
   visto nel paragrafo precedente il valore inserito dall'utente nel campo __contatti__[esempio][mail] sarà disponibile nel template come:
```html
   {{ dati.mail }}
```
   Ovviamente, la gerarchia di $ct è disponibile sotto la chiave ct, ad esempio il nome del sito corrente è disponibile in:
```html
   {{ ct.site.name[ ct.localization.language.ietf ] }}
```
   [...] definizione completa del template delle mail:

   
```
{php}
$cf['contatti']['esempio'] = array(
    'mail' => array(
           'interna' => array(
               'destinatari' => array( 'webmaster' => 'info@' . $cf['site']['domain'] ),
               'language' => 'it-IT',
               'exclude' => array( '__status__' ),
   		    'template' => array(
                   'type' => 'twig',
                   'it-IT' => array(
                       'from' => array( 'GlisWeb' => 'noreply@glisweb.videoarts.eu' ),
                       'oggetto' => 'invio modulo: {{ dati.modulo }}',
                       'testo' => '<ul>{% for k,v in dati %}<li><b>{{ k }}:</b> {{ v }}</li>{% endfor %}</ul>'
                   )
   		    )
           )
    )
   );
```
   [...] specifica di un template standard tramite PHP:

   
```
{php}
$cf['contatti']['esempio'] = array(
    'mail' => array(
           'interna' => array(
               'destinatari' => array( 'webmaster' => 'info@' . $cf['site']['domain'] ),
               'language' => 'it-IT',
               'exclude' => array( '__status__' ),
               'template' => 'DEFAULT_CONTATTI'
           )
    )
   );
```
   [...] oppure tramite JSON:
```json
   "contatti": {
     "esempio": {
       "mail": [
         {
           "destinatari": { "webmaster": "fabio.mosti@istricesrl.it" },
           "language": "it-IT",
           "exclude": [ "__status__" ],
           "template": "DEFAULT_CONTATTI"
         }
       ]
     }
   }
```
   [...] in questo caso è poi necessario specificare il mittente:
```json
   "mail": {
     "tpl": {
       "DEFAULT_CONTATTI": {
         "it-IT": {
           "from": { "prova": "noreply@{{ ct.site.fqdn }}" }
         }
       }
     }
   }
```
   invio di un messaggio su Slack
   ------------------------------

   [...] creare un modulo che invii i dati tramite Slack (per il nome del webhook si faccia riferimento a $cf['slack]['profile]['webhooks]):
```json
   "contatti": {
       "esempio": {
           "slack": {
               "webhook": "nomeWebHook"
           }
       }
   }
```
   salvataggio sul database
   ------------------------

   feedback all'utente
   ===================
```html
   {% if request.__contatti__.esempio.__status__ == 'OK' %}
   <!-- qui inserire il testo di ringraziamento, è tutto ok -->
   {% else %}
   <!-- qui inserire il modulo da compilare, non è stato ricevuto alcun modulo dal backend -->
   {% endif %}
```
   privacy dei moduli
   ==================
   Dal momento che il modulo contatti riceve dati dall'utente potenzialmente suscettibili di rientrare nel regolamento sulla protezione dei dati personali,
   il framework prevede alcuni strumenti per semplificare le operazioni di raccolta e gestione del consenso. In particolare, è disponibile una macro che genera
   le spunte da aggiungere ai moduli di contatto a partire dalla configurazione:
```json
   "privacy": {

     [...]

     "moduli": {
       "esempio": {
         "titolo": {
           "it-IT": "modulo di richiesta informazioni"
         },
         "descrizione": {
           "it-IT": "Questo modulo può essere utilizzato dagli utenti per richiedere informazioni."
         },
           "consensi": {
           "PRIVACY_POLICY": {
             "informativa": {
               "it-IT": "risposta all'utente"
             },
             "label": {
               "it-IT": "la privacy e cookie policy del sito"
             },
             "action": "letto_e_accetto",
             "page": "privacy",
             "required": true
           }
         }
       }
     }
   }
```
```html
   {% import '_bin/_privacy.html' as prv %}
   <form method="post" action="" id="esempioform">
       <input type="text" name="__contatti__[esempio][mail]">
       {{ prv.checkConsensi( '__contatti__', 'esempio', privacy.moduli.esempio, localization.language.ietf, tr, pages, session ) }}
       <input type="submit">
   </form>
```
   utilizzo di reCAPTCHA
   =====================
   Per utilizzare reCAPTCHA oltre ovviamente alle chiavi pubblica e privata che dovete inserire nella configurazione, vi servono poche cose nel contesto del
   modulo che volete proteggere:

   - l'inclusione del codice di reCAPTCHA
   - un campo hidden con un nome convenzionale che contenga il valore da trasmettere al backend
   - una funzione JavaScript che si occupi di inserire il valore nel campo hidden e di fare il submit del form
   - un bottone che inneschi la funzione Javascript

   Premesso che il codice di reCAPTCHA si può includere normalmente specificandolo fra i JS della pagina o direttamente del template, facciamo qualche
   esempio relativo al codice del form; iniziamo dal campo hidden:

   <input type="hidden" name="prefissoModulo[nomeModulo][__recaptcha_token__]" value="" id="nomeFormRecaptchaToken">
```html
   {% import '_bin/_privacy.html' as prv %}
   <form action="" id="esempioform" method="post">
       <div class="row">
           <div class="col-12 col-md"><input class="form-control" name="__contatti__[esempio][mail]" placeholder="E-MAIL" required="1" type="email"></div>
       </div>
       {{ prv.checkConsensi( '__contatti__', 'esempio', privacy.moduli.esempio, localization.language.ietf, tr, pages, session ) }}
       {{ cms.formButton( 'RICHIEDI INFO', 'button', 'btn-secondary', '', '', '', 'esempioform', google.profile.recaptcha, '__contatti__', 'esempio' ) }}
   </form>
```

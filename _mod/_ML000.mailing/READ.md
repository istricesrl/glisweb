# modulo mailing

Il modulo spedisce **newsletter**: un *mailing* è un messaggio ( mittente, oggetto e testo per lingua, più
gli allegati ) mandato agli indirizzi iscritti a una o più **liste**. È la conversione al canone nuovo di
`_7000.mailing`: stesse tabelle, stessi task, template Twig in `_src/_tpl/_athena/`; le mail le mette in coda
`queueMailFromTemplate()` e le spedisce la coda di `_MA000.mail`, come prima.

Rispetto a `_7000.mailing` cambiano cinque cose, tutte correzioni:

- la **disiscrizione** revoca davvero il consenso ( prima la pagina rispondeva "disiscrizione effettuata"
  senza scrivere niente );
- le mail portano gli header `List-Unsubscribe` e `List-Unsubscribe-Post` corretti, e un link di
  disiscrizione in fondo al testo se il testo non ne ha uno;
- c'è un **form pubblico di iscrizione**;
- popolazione delle liste, preparazione dei destinatari, generazione delle mail ed esportazione rispettano il
  **consenso**;
- rigenerare i destinatari non manda **due volte** la stessa mail allo stesso indirizzo.

## dipendenze

| modulo | a cosa serve |
|---|---|
| `_MA000.mail` | la coda che spedisce le mail; senza, i mailing si generano ma non partono |
| `_CO000.contenuti` | la scheda *contenuti* del mailing ( mittente, oggetto, testo ); senza, il mailing non ha testo |
| `_FI000.file` | la scheda *file* del mailing, per gli allegati |
| `_AT000.attivita` | la scheda *follow-up*, che crea un'attività per ogni destinatario con anagrafica |
| `_TE000.template` | l'azione *applica template*, che copia sul mailing i contenuti di un template mail |
| `_CT000.contatti` o `_0300.contatti` | il form pubblico di iscrizione |
| `_AN000.anagrafica` | la scheda *liste* dell'indirizzo mail in anagrafica |

Le schede relazionali le dichiarano i moduli che possiedono la tabella ( `_CO000.contenuti` e `_FI000.file`
hanno `_src/_inc/_pages/_mailing.it-IT.php` ), e le inserisce fra le schede del mailing `mailing.form`, solo
se il modulo è attivo: è lo stesso schema delle schede dei template mail.

## il consenso

La regola sta in un posto solo, `_src/_lib/_mailing.utils.php`, e la applicano tutti i passaggi che
scelgono a chi scrivere.

Il consenso che conta è `INVIO_COMUNICAZIONI_MARKETING`, nella tabella `anagrafica_consensi`. Una riga di
consenso sta **sull'anagrafica** ( `id_anagrafica` ) oppure **sul singolo indirizzo** ( `id_mail`, colonna
aggiunta dalla patch `_202610011500.consensi.mail.sql` ): chi si iscrive dal sito non ha un'anagrafica, e il
link di disiscrizione arriva a un indirizzo, non a una persona.

- un indirizzo **senza nessuna riga** di consenso **riceve** la newsletter: le liste esistenti e le
  anagrafiche importate non hanno righe, e pretenderle svuoterebbe le liste;
- un indirizzo è **escluso** se **l'ultima** riga fra quelle del suo indirizzo e quelle della sua anagrafica
  non è un consenso prestato. L'ultima, perché chi si era tolto e si riscrive torna a riceverla;
- la regola guarda la **stringa dell'indirizzo**, non la riga di `mail`: la tabella ammette lo stesso
  indirizzo più volte ( una per anagrafica, e senza limiti quelle senza anagrafica ), e una revoca deve
  valere per tutte le copie;
- una riga con `se_prestato` a `NULL` conta come **revoca**: è così che le scrive chi passa da
  `mysqlInsertRow()`, che trasforma lo zero in `NULL`.

> **attenzione** — chi si era tolto con uno strumento precedente, e non ha lasciato una riga di revoca in
> `anagrafica_consensi`, per questo modulo non si è mai tolto. Prima di importare liste da un altro sistema
> conviene importarne anche le disiscrizioni, come righe con `se_prestato = 0` sull'indirizzo.

| funzione | cosa fa |
|---|---|
| `mailingCondizioneConsenso( $alias )` | la condizione SQL da mettere nel `WHERE` di una query sulla tabella `mail` |
| `mailingSeConsenso( $idMail )` | la stessa regola per un indirizzo solo |
| `mailingRegistraConsenso( $idMail, $prestato, $nota )` | scrive il consenso o la revoca sull'indirizzo, una riga per indirizzo che si aggiorna; la storia va nel log `mailing` |

La revoca per una **persona** ( tutti i suoi indirizzi ) è una riga sull'anagrafica in `anagrafica_consensi`, e
da interfaccia si scrive nella linguetta *privacy* della scheda anagrafica di `_AN000.anagrafica`, che mostra in
sola lettura anche i consensi registrati sui singoli indirizzi della persona.

## il giro di un mailing

1. si crea il mailing, gli si assegnano le liste e la data di invio, e nella scheda *contenuti* il testo;
2. **prepara invio** ( scheda azioni ) lancia `_genera.elenco.destinatari.php`, che copia in `mailing_mail`
   un indirizzo per riga. Gli indirizzi si raggruppano per stringa: chi è in due liste, o compare due volte
   nella tabella `mail`, entra una volta sola. Si può rilanciare: chi c'è già resta, chi si è iscritto nel
   frattempo si aggiunge, e un indirizzo già presente con un'altra riga di `mail` non rientra;
3. il task `_genera.mail.php` prende una riga di `mailing_mail` per giro, controlla di nuovo il consenso
   ( se è stato revocato dopo la preparazione toglie la riga e passa oltre ), compone la mail e la mette in
   coda con la data di invio del mailing e con `ordine` 10, così le mail transazionali ( `ordine` NULL ) passano
   prima anche quando il mailing ha migliaia di righe;
4. la coda di `_MA000.mail` la spedisce e scrive `mailing_mail.timestamp_invio`.

> **attenzione** — `_genera.mail.php` va schedulato a mano sul deploy, come gli altri task: una riga nella
> tabella `task` con percorso `_mod/_ML000.mailing/_src/_api/_task/_genera.mail.php`. Chi passa da
> `_7000.mailing` deve aggiornare il percorso della riga esistente.

## la disiscrizione

Il link in fondo alle mail e l'URL dell'header `List-Unsubscribe` portano alla pagina `disiscrizione` con
due parametri: `isc`, l'id della riga di `mail`, e `mtk`, l'md5 dell'id seguito dall'indirizzo. La pagina
controlla il token e:

- con un **GET** chiede conferma con un bottone: i link delle mail li aprono anche i filtri antispam dei
  server di posta, e se bastasse aprirli la lista perderebbe iscritti che non hanno cliccato niente;
- con un **POST** revoca il consenso sull'indirizzo. È anche la richiesta che manda il client di posta per la
  disiscrizione con un clic ( RFC 8058 ).

L'header `List-Unsubscribe` ha anche un `mailto:` al mittente del mailing, se il mittente è un indirizzo
semplice; le richieste che arrivano per posta vanno lavorate a mano.

Se il testo del mailing contiene già `mtk=` il piede non si aggiunge: il testo può mettere il link dove
vuole con `{{ row.disiscrizione }}`.

## il form pubblico di iscrizione

Si include nel template del sito con:

```twig
{% include '_inc/_mailing.iscrizione.twig' %}
```

Il form spedisce `__ct__[newsletter][mail]` al modulo contatti, che dopo il controllo antispam salva il
contatto e chiama la controller `_src/_inc/_controllers/_form/_newsletter.php`. La controller:

- rifiuta un indirizzo non valido o senza il consenso `INVIO_COMUNICAZIONI_MARKETING`;
- riusa la riga di `mail` con lo stesso indirizzo, preferendo quella senza anagrafica, oppure ne crea una
  senza anagrafica;
- la iscrive alle liste configurate, creandole se sono indicate per nome e non esistono;
- registra il consenso sull'indirizzo.

| configurazione | default | descrizione |
|---|---|---|
| `contatti.newsletter.liste` | `[ "newsletter" ]` | le liste, per id o per nome; se il form spedisce anche `lista`, e il valore è fra queste, l'indirizzo va solo in quella |
| `privacy.moduli.newsletter` | `PRIVACY_POLICY` e `INVIO_COMUNICAZIONI_MARKETING`, obbligatori | i consensi chiesti dal form; si cambiano da configurazione o dalla tabella `consensi_moduli` |

## i file del modulo

### /_mod/_ML000.mailing/_src/_api/_job/_importazione.iscritti.php
Job di importazione degli iscritti da CSV ( modello in `/_usr/_examples/_csv/iscritti.import.csv` ): crea o
ritrova anagrafica, indirizzo e liste, e iscrive l'indirizzo. Indirizzo, lista e iscrizione si cercano prima
di inserirli, quindi reimportare lo stesso file non crea doppioni.

### /_mod/_ML000.mailing/_src/_api/_job/_importazione.iscritti.mailchimp.php
Job di importazione dell'export degli iscritti di MailChimp ( colonna `Email Address` ) nella lista indicata,
per nome o per id.

### /_mod/_ML000.mailing/_src/_api/_print/_lista.csv.php
Esporta in CSV gli iscritti alla lista `__lista__`, con le colonne che il job di importazione sa rileggere,
lasciando fuori chi ha revocato il consenso. Richiede `GESTIONE_COMUNICAZIONI`.

### /_mod/_ML000.mailing/_src/_api/_task/_genera.elenco.destinatari.php
Prepara i destinatari del mailing `idMailing`, come descritto sopra. Richiede `GESTIONE_COMUNICAZIONI`.

### /_mod/_ML000.mailing/_src/_api/_task/_genera.mail.php
Genera una mail per giro, come descritto sopra; con `mt` e `mid` manda una prova all'indirizzo `mt` senza
toccare `mailing_mail`. Richiede `GESTIONE_COMUNICAZIONI`.

### /_mod/_ML000.mailing/_src/_api/_task/_importazione.iscritti.start.php
### /_mod/_ML000.mailing/_src/_api/_task/_importazione.iscritti.mailchimp.start.php
Creano i job di importazione sul file caricato in `var/contenuti/upload/`. Richiedono `GESTIONE_IMPORT`.

### /_mod/_ML000.mailing/_src/_api/_task/_lista.popola.categoria.php
Iscrive alla lista `__lista__` gli indirizzi delle anagrafiche della categoria `__categoria__`, tranne quelli
che hanno revocato il consenso. Richiede `GESTIONE_COMUNICAZIONI`.

### /_mod/_ML000.mailing/_src/_api/_task/_mailing.template.applica.php
Copia sul mailing `__mailing__` i contenuti del template `__template__`, sostituendo quelli nelle stesse
lingue. Richiede `GESTIONE_COMUNICAZIONI`.

### /_mod/_ML000.mailing/_src/_config/_030.common.php
Registra il form `newsletter` presso il modulo contatti.

### /_mod/_ML000.mailing/_src/_config/_060.privacy.php
Dichiara i consensi del form `newsletter`.

### /_mod/_ML000.mailing/_src/_inc/_controllers/_form/_newsletter.php
La controller del form pubblico di iscrizione.

### /_mod/_ML000.mailing/_src/_inc/_macro/_disiscrizione.php
La macro della pagina di disiscrizione.

### /_mod/_ML000.mailing/_src/_lib/_mailing.utils.php
Le funzioni del consenso.

### /_mod/_ML000.mailing/_src/_twig/_inc/_mailing.iscrizione.twig
Il form pubblico di iscrizione.

## da `_7000.mailing` a `_ML000.mailing`

- si attiva `mod/ML000.mailing` e si toglie `mod/7000.mailing`: le tabelle sono le stesse, i dati restano;
- si applicano le patch `_202610011500.consensi.mail.sql` e `_202610011600.consensi.anagrafica.sql`;
- si aggiorna il percorso della riga di `task` che genera le mail;
- le pagine `template.mailing.*` di `_7000.mailing` non ci sono più: i template mail sono quelli di
  `_TE000.template`, e si applicano al mailing con l'azione *applica template*;

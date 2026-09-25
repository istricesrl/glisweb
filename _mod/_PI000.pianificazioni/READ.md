# modulo pianificazioni

> **nota** — modulo creato il 2026-09-25 come versione di nuova generazione di `_0100.pianificazioni`,
> che resta congelato per i deploy che lo usano. Ne riprende la pianificazione "per modello" ( le
> colonne `model_*` della tabella `pianificazioni`, rimessa nello schema con la patch
> `_202609251400.pianificazioni.sql` ) e la completa; la pianificazione "per duplicazione" della fase
> precedente ( workspace JSON, `mysqlDuplicateRowRecursive()` ) non c'è.

## a cosa serve

Una pianificazione crea da sola, a intervalli regolari, un oggetto a partire da un modello: una fattura ogni mese con le
sue righe e i suoi pagamenti, una todo ogni lunedì, mercoledì e venerdì, un rinnovo del contratto ogni anno. Le entità
pianificabili sono quelle dell'enum `pianificazioni.entita`: documenti, todo, attivita, rinnovi, documenti_articoli e
pagamenti ( queste ultime due come righe e pagamenti aggiunti a un documento esistente ). Il meccanismo è descritto in
`_usr/_docs/_read/122.esecuzione.pianificazioni.md`, la tabella in `_usr/_docs/_read/313.database.p.md`.

## come si usa

1. da strumenti → pianificazioni si crea una pianificazione: entità, nome, periodicità e cadenza ( con i giorni della
   settimana per la settimanale e lo schema per le mensili ), data da cui è attiva, data del primo oggetto, data di fine
   ( compresa, facoltativa ), giorni di anticipo con cui creare gli oggetti e giorni di cui allungarla da sola;
2. nella scheda modello si compila l'oggetto: per un documento tipologia, sezionale, nome, emittente e destinatario, e
   nel sub form le righe ( nome, quantità, importo, reparto ) e i pagamenti ( modalità, importo, differimento ). Nei
   campi di testo si possono usare le variabili Twig della data dell'oggetto ( `{{ dt.now.nome_mese }} {{ dt.now.anno }}` )
   e, nell'importo dei pagamenti, `{{ dt.articoli.totale }}`, il totale ivato delle righe;
3. il cron crea gli oggetti scaduti a ogni passata ( terzo blocco di `_src/_api/_cron.php` ); dalla scheda strumenti li si
   può creare subito, o fermare la pianificazione a una data; la scheda oggetti creati li elenca, ciascuno con il link
   al suo form nel modulo che lo gestisce.

Esempio, una fattura mensile di canone: entità documenti, periodicità mensile, cadenza 1, primo oggetto il 31/01, modello
con tipologia fattura, sezionale `{{ dt.now.anno }}`, nome `canone {{ dt.now.nome_mese }} {{ dt.now.anno }}`, una riga
da 100,00 al reparto IVA 22% e un pagamento `{{ dt.articoli.totale }}` a 30 giorni fine mese. Le fatture escono il 31/01,
il 28/02, il 31/03, il 30/04..., numerate in ordine, e il pagamento della prima scade il 28/02.

## debug

Il task si chiama a mano con `/task/PI000.pianificazioni/pianificazioni.populate?id=<id>&d=<Y-m-d>`: `id` elabora quella
pianificazione anche se non è scaduta, `d` lavora come se oggi fosse quella data. L'output JSON contiene le date
calcolate, gli oggetti creati e gli errori; da cron lo stesso contenuto va in `var/log/pianificazioni/<id>/`. Se una
pianificazione non parte, i campi da guardare sono `data_avvio` ( dev'essere passata ), `data_elaborazione` ( se è oggi è
già stata elaborata ), `token` ( un lock più vecchio di dieci minuti viene liberato da solo ) e `data_ultimo_oggetto` ( le
date fino a questa compresa non si ricreano ).

## cosa non fa

- non duplica oggetti esistenti con i loro figli, come faceva la fase per duplicazione di `_0100.pianificazioni`: il
  modello sta nelle colonne `model_*`;
- non cancella mai documenti: il task di interruzione li elenca e li lascia dove sono;
- non pianifica un'entità se nessuno dei moduli che la gestiscono è attivo: la tendina del form propone solo le entità
  disponibili, e il task salta, scrivendolo nel log, le pianificazioni esistenti di un'entità il cui modulo è stato
  spento. I moduli di ciascuna entità sono nel capitolo 122; i documenti vogliono `_DO000.documenti` o
  `_0400.documenti`, i due moduli che hanno `generaProssimoNumeroDocumento()` per numerarli.

## insieme a _0100.pianificazioni

I due moduli lavorano sulla stessa tabella, e un deploy che passa al modulo nuovo può avere attivi tutti e due per un
po'. Perché gli oggetti non vengano creati due volte, i task di `_0100.pianificazioni` che generano o allungano le
pianificazioni ( `pianificazioni.populate`, `pianificazioni.extend` e `pianificazioni.progetti.extend` ) controllano
all'inizio se `_PI000.pianificazioni` è attivo e, se lo è, scrivono nel log `pianificazioni` che lasciano il lavoro a
lui e non bloccano né toccano nessuna riga. È l'unica modifica fatta a `_0100` dopo il suo congelamento; i suoi task che
non generano ( check, clean, stop, detach, populate.flag ) e la copia `_pianificazioni.populate.old.php` della fase per
duplicazione restano come sono.

## i file del modulo

### /_mod/_PI000.pianificazioni/_src/_api/_task/_pianificazioni.populate.php
Questo task crea gli oggetti di una pianificazione: quella indicata con `id`, oppure la prima scaduta. Lo include
anche il blocco delle pianificazioni di `_src/_api/_cron.php`, una volta per ogni pianificazione scaduta.

### /_mod/_PI000.pianificazioni/_src/_api/_task/_pianificazioni.stop.php
Questo task ferma una pianificazione a una data, e a richiesta cancella gli oggetti successivi ( mai i documenti ).

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.form.modello.php
Questa è la macro della scheda modello del form delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.form.oggetti.php
Questa è la macro della scheda oggetti creati del form delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.form.php
Questa è la macro del form delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.form.tools.php
Questa è la macro della scheda strumenti del form delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.tools.php
Questa è la macro della scheda strumenti della vista delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.view.php
Questa è la macro della vista delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_inc/_pages/_pianificazioni.it-IT.php
In questo file vengono definite le pagine del modulo pianificazioni, sotto strumenti accanto a task e job.

### /_mod/_PI000.pianificazioni/_src/_lib/_pianificazioni.utils.php
Questa libreria contiene le funzioni che calcolano le date ancora da creare e creano gli oggetti.

### /_mod/_PI000.pianificazioni/_src/_tpl/_athena/inc/pianificazioni.form.tools.modal.ferma.twig
Questo è il modal con cui si ferma una pianificazione.

### /_mod/_PI000.pianificazioni/_src/_tpl/_athena/lib/pianificazioni.form.modello.sub.twig
Questa libreria contiene il sub form delle pianificazioni figlie, il modello delle righe e dei pagamenti di un documento.

### /_mod/_PI000.pianificazioni/_src/_tpl/_athena/pianificazioni.form.modello.twig
Questo è il template della scheda modello del form delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_tpl/_athena/pianificazioni.form.oggetti.twig
Questo è il template della scheda oggetti creati del form delle pianificazioni.

### /_mod/_PI000.pianificazioni/_src/_tpl/_athena/pianificazioni.form.twig
Questo è il template del form delle pianificazioni.

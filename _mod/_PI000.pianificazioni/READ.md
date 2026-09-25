# modulo pianificazioni

> **nota** — modulo creato il 2026-09-25 come versione di nuova generazione di `_0100.pianificazioni`,
> che resta congelato per i deploy che lo usano. Ne riprende la pianificazione "per modello" ( le
> colonne `model_*` della tabella `pianificazioni`, rimessa nello schema con la patch
> `_202609251400.pianificazioni.sql` ) e la completa; la pianificazione "per duplicazione" della fase
> precedente ( workspace JSON, `mysqlDuplicateRowRecursive()` ) non c'è.

## i file del modulo

### /_mod/_PI000.pianificazioni/_src/_api/_task/_pianificazioni.populate.php
Questo task crea gli oggetti di una pianificazione: quella indicata con `id`, oppure la prima scaduta. Lo include
anche il blocco delle pianificazioni di `_src/_api/_cron.php`, una volta per ogni pianificazione scaduta.

### /_mod/_PI000.pianificazioni/_src/_api/_task/_pianificazioni.stop.php
Questo task ferma una pianificazione a una data, e a richiesta cancella gli oggetti successivi ( mai i documenti ).

### /_mod/_PI000.pianificazioni/_src/_inc/_macro/_pianificazioni.form.modello.php
Questa è la macro della scheda modello del form delle pianificazioni.

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

### /_mod/_PI000.pianificazioni/_src/_tpl/_athena/pianificazioni.form.twig
Questo è il template del form delle pianificazioni.

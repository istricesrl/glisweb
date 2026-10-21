# modulo offerte

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## com'è fatto

Il modulo è costruito sul modello di `DO010.fatture`: le pagine stanno sotto
`commerciale.ciclo.attivo` ( modulo `02000.commerciale` ) invece che sotto
`amministrazione.ciclo.attivo`, e il filtro è `se_offerta = 1` in `tipologie_documenti` invece di
`se_fattura = 1`. Le tipologie si leggono con `mysqlSelectColumn()` e passano a `__restrict__` come
lista `IN`, così elenco e tendina della scheda usano lo stesso criterio. Le righe si aprono e si
inseriscono con la scheda riga di `DO000.documenti` ( `amministrazione.archivio.documenti.articoli.form` ),
che quindi va attivato insieme a questo modulo.

Rispetto alle fatture mancano, di proposito, le linguette **pagamenti** e **relazioni** e, nella
testata, i riquadri dell'esigibilità IVA e dei riferimenti per la pubblica amministrazione, che
servono al documento fiscale e non a un'offerta.

## i file del modulo

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.articoli.view.php
Questa è la macro della view delle righe delle offerte: filtra `documenti_articoli_view` sulla
tipologia del documento ( `id_tipologia` ) con le tipologie che hanno `se_offerta = 1`.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.archiviazione.php
Questa è la macro della scheda archiviazione della pagina di gestione delle offerte.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.documenti.articoli.php
Questa è la macro della scheda righe della pagina di gestione delle offerte; apre e inserisce le righe
con `amministrazione.archivio.documenti.articoli.form`.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.php
Questa è la macro della pagina di gestione delle offerte: tendina delle tipologie con
`se_offerta = 1`, condizioni di pagamento e sedi di emittente e destinatario.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione delle offerte ( gruppo stampe PDF ).

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione delle offerte.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.tools.php
Questa è la macro della scheda strumenti della view delle offerte.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.view.archiviate.php
Questa è la macro della view delle offerte archiviate.

### /_mod/_DO040.offerte/_src/_inc/_macro/_commerciale.ciclo.attivo.offerte.view.php
Questa è la macro della view delle offerte non archiviate.

### /_mod/_DO040.offerte/_src/_inc/_pages/_commerciale.it-IT.php
In questo file vengono dichiarate le pagine relative alle offerte per il modulo commerciale.

### /_mod/_DO040.offerte/_src/_tpl/_athena/commerciale.ciclo.attivo.offerte.form.archiviazione.twig
Template della scheda di archiviazione dell'offerta: data e note di archiviazione.

### /_mod/_DO040.offerte/_src/_tpl/_athena/commerciale.ciclo.attivo.offerte.form.documenti.articoli.twig
Template della linguetta righe della scheda: il sotto-elenco delle righe dell'offerta.

### /_mod/_DO040.offerte/_src/_tpl/_athena/commerciale.ciclo.attivo.offerte.form.twig
Template della testata dell'offerta: dati generali, condizioni di pagamento, emittente e
destinatario con le loro sedi.

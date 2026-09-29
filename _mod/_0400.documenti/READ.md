# modulo documenti

> **nota** — capitolo travasato il 2026-09-08 dalla documentazione Doxygen `.dox`, ferma al
> 2024. I riferimenti sono stati verificati contro il codice e il database di oggi;
> dove il testo non e' stato riverificato riga per riga, va letto come una traccia da confermare,
> non come una descrizione garantita.


Panoramica dei modulo documenti.

introduzione
============

logica di funzionamento
-----------------------

debug del sistema di interscambio
---------------------------------

[...] si può anche chiamare il task task/0400.documenti/download.note.attive specificando i parametri idAzienda e idDocumento [...]

[...] per attivare manualmente il job di download delle note chiamare il task task/0400.documenti/download.note.attive.start [...]

fattura elettronica
-------------------

L'XML della fattura elettronica lo genera `/_mod/_0400.documenti/_src/_api/_print/_fattura.xml.php`
( via `print/0400.documenti/fattura.xml` ), nel formato FatturaPA con l'attributo versione `FPR12`
per i privati e `FPA12` per la pubblica amministrazione. È il solo file del framework che la
genera: i moduli della linea nuova ( `_DO000.documenti`, `_DO010.fatture` ) gestiscono i documenti
ma non hanno ancora una stampa XML. Il 2026-09-29 il tracciato è stato confrontato con le specifiche
tecniche 1.9.1, in vigore dal 15 maggio 2026, che usano ancora lo schema 1.2.3 della 1.9: il
namespace e l'attributo versione restano quelli della 1.2, e le novità ( i tipi documento `TD28` e
`TD29`, il regime `RF20`, le nature di dettaglio da `N2.1` a `N7`, la modalità di pagamento `MP23` )
sono codici che arrivano dal database. Quelli che mancavano ai dati di base li porta la patch
`/_usr/_database/_patch/_202609291300.fatturapa.codici.sql`.

Prima di restituire il file la stampa lo valida contro lo schema ufficiale con `xmlValidate()`, e lo
passa per i controlli che lo schema non fa ma lo SDI sì, o che le specifiche chiedono per il tipo di
documento: la nota di credito `TD04` senza fattura collegata, la fattura differita `TD24` senza DDT,
le nature generiche `N2`, `N3` e `N6` ( errore SDI 00445 ), la fattura collegata con una data
successiva a quella del documento ( 00418 ), la ritenuta senza causale, il contributo di cassa senza
aliquota IVA. Dal 2026-09-30 gli errori fermano **solo l'invio allo SDI**: con il parametro `f`, quello
del task `_fattura.invia.sdi.php`, al posto del percorso del file arrivano gli errori in JSON nella
chiave `errori`. La visualizzazione ( nessun parametro ) mostra errori e avvisi in due riquadri sopra
la fattura, e il download ( parametro `d` ) scarica comunque il file; in tutti e tre i casi gli errori
vanno nel log `xml`. Gli **avvisi** sono cose da verificare che non fermano niente, come il bollo che
forse è dovuto ( righe senza IVA oltre 77,47 euro e niente bollo virtuale ). Fino al 2026-09-29 un file
non valido non si poteva nemmeno guardare né scaricare. La visualizzazione trasforma l'XML in HTML sul
server con `xmlTransform()` e il foglio di stile ufficiale, perché i browser stanno abbandonando XSLT:
solo se sul server manca l'estensione xsl l'XML viene mandato con il riferimento `<?xml-stylesheet?>`
al foglio, la trasformazione la fa il browser, e errori e avvisi stanno in un commento in testa al file.

Dal 2026-09-30 il tracciato ha anche i blocchi condizionati che mancavano, con i dati raccolti dalla
scheda **dati fiscali** dei documenti ( qui, in `_DO000.documenti` e in `_DO010.fatture` ) e portati
ai deploy esistenti dalla patch `/_usr/_database/_patch/_202609301800.fatturapa.blocchi.sql`:

blocco                   | dati
-------------------------|--------------------------------------------------------------------------
DatiRitenuta             | `documenti_ritenute`: tipo ( tabella standard `ritenute`, RT01 - RT06 ), aliquota, causale della CU, importo se non si calcola; le righe con `se_ritenuta` hanno `Ritenuta` SI
DatiBollo                | `documenti.se_bollo_virtuale` e `documenti.importo_bollo`
DatiCassaPrevidenziale   | `documenti_casse_previdenziali`: cassa ( tabella standard `casse_previdenziali`, TC01 - TC22 ), aliquota, imponibile e importo se non si calcolano, aliquota IVA, `se_ritenuta`
DatiFattureCollegate     | le relazioni del documento con il ruolo *fattura collegata* ( `ruoli_documenti.se_xml` )
DatiDDT                  | le relazioni con il ruolo *DDT collegato* verso documenti di tipologia `se_trasporto`

I calcoli li fa `generaContenutiDocumento()`: il contributo di cassa sul totale delle righe tranne
quelle con natura `N1` ( spese escluse ex art. 15 ), la ritenuta sulle righe soggette e sui contributi
soggetti ( se nessuna riga è segnata, su tutte tranne le `N1` ); il contributo entra nel riepilogo della
sua aliquota e nel totale del documento. `RiferimentoNumeroLinea` di fatture collegate e DDT si scrive
solo quando alcune righe, e non tutte, sono legate alle righe del documento collegato
( `relazioni_documenti_articoli` ).

In questo modulo la scheda dati fiscali è la linguetta *dati fiscali* delle fatture e delle note di
credito ( macro `_documenti.form.dati.fiscali.php`, template `documenti.form.dati.fiscali.html` con i
sotto moduli di `bin/documenti.form.dati.fiscali.sub.html` ), e la casella *soggetta a ritenuta* sta
nelle schede delle righe di fatture, note di credito e documenti.

Le aliquote 35 ( art. 71 con `N3.6` invece di `N3.3` ), 57 e 58 ( natura generica `N6` ) dal
2026-09-30 sono **archiviate** ( `iva.timestamp_archiviazione` ): restano per i documenti già emessi,
ma le tendine dei reparti e delle aliquote dei documenti non le propongono più, e una fattura che le
usa ancora si vede e si scarica ma non si invia. Al loro posto ci sono la 60 ( `N3.3`, cessioni verso
San Marino ) e le 61 - 69 ( `N6.1` - `N6.9` ).

Gli schemi e i fogli di stile stanno in `_src/_xml/`, divisi come nel core in `_xsd/` e `_xsl/`.
Sono i file ufficiali dell'Agenzia delle Entrate ( pubblicati su fatturapa.gov.it ) senza
modifiche al contenuto, così che la prossima versione si possa sostituire file per file: lo schema
ha il nome originale, i fogli di stile quello che avevano già nel framework, con la versione
aggiornata ( l'Agenzia li distribuisce come `Foglio_di_stile_fattura_ordinaria_ver1.2.3.xsl` e
simili ).

### /_mod/_0400.documenti/_src/_xml/_xsd/Schema_VFPR12_v1.2.3.xsd
Lo schema ufficiale della fattura elettronica ordinaria, versione 1.2.3, nella revisione delle
specifiche 1.9 ( conosce `TD28`, `TD29` e `RF20` ). Importa lo schema delle firme XML con l'URL del
W3C: `xmlValidate()` lo trova in `/_src/_xml/_xsd/xmldsig-core-schema.xsd`, senza andare in rete.
Riverificato il 2026-09-30: le specifiche 1.9.1 ( in vigore dal 15 maggio 2026: il controllo 00327 sui
gruppi IVA, la stringa `ESENZSPORT` facoltativa, fino a 300 codici destinatario, le procedure di
accreditamento dei canali ) non cambiano lo schema, e il file ha lo stesso SHA-256 ( `75565fdf…73db1` )
della copia che accompagna l'Allegato A 1.9 e la rappresentazione tabellare in un repository pubblico
che le ripubblica, perché fatturapa.gov.it e agenziaentrate.gov.it non erano raggiungibili dalla rete di
lavoro.

### /_mod/_0400.documenti/_src/_xml/_xsl/fatturaordinaria_v1.2.3.xsl
Il foglio di stile ufficiale per le fatture fra privati, quello che `_fattura.xml.php` usa quando
il destinatario non è una pubblica amministrazione. Conosce tutti i tipi documento fino a `TD29`, i
regimi fino a `RF20`, le nature di dettaglio e le modalità di pagamento fino a `MP23`, e
nell'intestazione mostra correttamente «Codice identificativo destinatario».

### /_mod/_0400.documenti/_src/_xml/_xsl/fatturaPA_v1.2.3.xsl
Il foglio di stile ufficiale per le fatture verso la pubblica amministrazione, quello che
`_fattura.xml.php` usa quando il destinatario ha `se_pubblica_amministrazione`. È identico al
precedente salvo le etichette della PA; non ha le descrizioni di `TD28` e `TD29`, che non si
emettono verso una PA.

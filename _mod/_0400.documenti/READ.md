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

Prima di restituire il file la stampa lo valida contro lo schema ufficiale con `xmlValidate()`: un
file che non lo supera verrebbe scartato dallo SDI, e al suo posto arrivano gli errori, in JSON nella
chiave `errori` quando la chiamata è quella del task di invio ( parametro `f` ), come testo negli
altri casi. La visualizzazione ( nessun parametro ) trasforma l'XML in HTML sul server con
`xmlTransform()` e il foglio di stile ufficiale, perché i browser stanno abbandonando XSLT: solo se
sul server manca l'estensione xsl l'XML viene mandato con il riferimento `<?xml-stylesheet?>` al
foglio, e la trasformazione la fa il browser.

> **attenzione** — restano fuori dal tracciato `DatiBollo` ( obbligatori sulle operazioni senza IVA
> sopra 77,47 euro ), `DatiFattureCollegate`, `DatiDDT` ( necessari per le fatture differite `TD24` ),
> `DatiRitenuta` e `DatiCassaPrevidenziale`. Nei dati di base le aliquote 57 e 58 hanno ancora la
> natura generica `N6`, che lo SDI scarta dal 2021, e la 35 ( art. 71, San Marino ) ha `N3.6` invece
> di `N3.3`. La validazione non le ferma, perché lo schema accetta ancora `N6`: lo scarto arriva
> dallo SDI, che controlla anche quello che lo schema non dice.

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

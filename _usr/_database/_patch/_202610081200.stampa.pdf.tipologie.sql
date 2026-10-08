-- 2026-10-08 — modello di stampa PDF per ogni tipologia di documento
--
-- Richiesta di Fabio dell'08/10/2026: ogni tipologia di documento deve avere una sua stampa standard, che i deploy
-- possono personalizzare. La stampa la fa generaDocumentoPdf() ( _mod/_0400.documenti/_src/_lib/_pdf.tools.add.php ),
-- che sceglie il modello da tipologie_documenti.stampa_pdf: il nome del modello diventa la funzione che disegna
-- ( 'nota.credito' -> generaNotaCreditoPdf() ), e una tipologia figlia senza modello usa quello del genitore.
--
-- Qui si valorizzano le sole tipologie radice che hanno un modello dedicato; le figlie restano NULL ed ereditano, e le
-- tipologie senza modello restano NULL perche' generaDocumentoPdf() ripiega da sola sul generico. Si scrive solo dove
-- stampa_pdf e' ancora vuoto, quindi un deploy che ha gia' scelto un modello suo non si vede sovrascrivere niente.
--
-- Solo gli id da 1 a 8: piu' su gli id non vogliono dire la stessa cosa da un deploy all'altro ( il 34 e' la missione
-- su bernispa ma "acquisti da San Marino" su polmasi, il 29 e' una figlia di fattura su tre deploy e la distinta su
-- altri due ), e un modello assegnato per id scavalcherebbe quello ereditato. La copertina della missione la assegna
-- bernispa nelle sue patch.
--
-- IDEMPOTENTE.

-- | 202610081200

UPDATE `tipologie_documenti` SET `stampa_pdf` = 'fattura' WHERE `id` = 1 AND `stampa_pdf` IS NULL;
UPDATE `tipologie_documenti` SET `stampa_pdf` = 'nota.credito' WHERE `id` = 3 AND `stampa_pdf` IS NULL;
UPDATE `tipologie_documenti` SET `stampa_pdf` = 'ddt' WHERE `id` = 4 AND `stampa_pdf` IS NULL;
UPDATE `tipologie_documenti` SET `stampa_pdf` = 'proforma' WHERE `id` = 5 AND `stampa_pdf` IS NULL;
UPDATE `tipologie_documenti` SET `stampa_pdf` = 'offerta' WHERE `id` = 6 AND `stampa_pdf` IS NULL;
UPDATE `tipologie_documenti` SET `stampa_pdf` = 'ordine' WHERE `id` = 7 AND `stampa_pdf` IS NULL;
UPDATE `tipologie_documenti` SET `stampa_pdf` = 'ricevuta' WHERE `id` = 8 AND `stampa_pdf` IS NULL;

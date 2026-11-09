-- 2026-11-09 — tipologie_documenti: tabella standard, stessi id su tutti i deploy, codice_sdi, flag di classe dalla radice
--
-- Schema canonico, punto 6, riga 202, decisione di Fabio del 09/11/2026 ( opzione A ): "questa tabella va distribuita
-- tramite dataserver perché impatta la fatturazione elettronica e altre funzionalità del programma", quindi le 38 righe
-- hanno gli stessi id ovunque. Fino a oggi gli id dal 29 in su cambiavano da deploy a deploy: TD28 / TD29 stavano a
-- 29/30, 34/35, 35/36 o 37/38. La numerazione canonica è quella di bernispa, l'unico database con documenti su quelle
-- righe ( 34 missione, 35 missione di prelievo, 36 missione di movimentazione, 37 TD28, 38 TD29 ): le righe che questa
-- patch sposta non hanno documenti su nessun database misurato, e le chiavi entranti sono comunque ON UPDATE CASCADE.
--
-- Cosa fa:
-- - aggiunge codice_sdi dopo codice, con la sua KEY, e ci copia i codici TD che oggi stanno in codice;
-- - riordina le colonne ( nome, sigla, icone, flag di classe, qualità, numerazione, stampa_pdf ), allarga nome a
--   char(255), toglie le KEY su nome, sigla, numerazione e sui singoli flag e ricrea indice;
-- - porta TD28 a 37, TD29 a 38 e la missione di prelievo a 35, riconoscendole per nome;
-- - inserisce le righe canoniche che mancano ( INSERT IGNORE ) e mette la missione di prelievo sotto la missione;
-- - valorizza codice sulle righe senza codice SdI, riconoscendole da id E nome, solo dove codice è ancora vuoto.
--
-- Cosa NON fa, e perché: sulle righe col codice SdI codice resta il TipoDocumento. Lo leggono così, su tutti i deploy
-- oldstable, l'XML della fattura elettronica ( _0400.documenti, _fattura.xml.php ), le stampe e l'importazione delle
-- fatture passive ( _archivium.utils.php ), e le patch devono restare compatibili col codice che gira la notte stessa.
-- Il codice del framework su quelle righe ( FATTURA, NOTA_DI_CREDITO, FATTURA_TDnn... ) e la UNIQUE KEY codice arrivano
-- con una patch successiva, dopo che quei lettori sono passati a codice_sdi ( punto 8 ); fino ad allora resta la KEY
-- codice non unica. Non toglie colonne né chiavi esterne: stampa_xml ( mai valorizzata ), la coda di audit e le FK
-- 98/99 escono dal canone ma restano sui database fino al punto 12.
--
-- IDEMPOTENTE: colonne e chiavi con IF ( NOT ) EXISTS, indice si toglie e si ricrea, gli spostamenti di id con
-- UPDATE IGNORE e solo dove l'id è diverso, INSERT IGNORE, gli UPDATE toccano solo valori ancora vuoti.

-- | 202611091500

-- tipologie_documenti: codice_sdi, nome a char(255), colonne riordinate, via le KEY su nome, sigla, numerazione e flag
ALTER TABLE `tipologie_documenti`
	ADD COLUMN IF NOT EXISTS `codice_sdi` char(32) DEFAULT NULL AFTER `codice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice_sdi`,
	MODIFY `sigla` char(16) DEFAULT NULL AFTER `nome`,
	MODIFY `html_entity` char(8) DEFAULT NULL AFTER `sigla`,
	MODIFY `font_awesome` char(16) DEFAULT NULL AFTER `html_entity`,
	MODIFY `se_fattura` tinyint(1) DEFAULT NULL AFTER `font_awesome`,
	MODIFY `se_nota_credito` tinyint(1) DEFAULT NULL AFTER `se_fattura`,
	MODIFY `se_nota_debito` tinyint(1) DEFAULT NULL AFTER `se_nota_credito`,
	MODIFY `se_pro_forma` tinyint(1) DEFAULT NULL AFTER `se_nota_debito`,
	MODIFY `se_offerta` tinyint(1) DEFAULT NULL AFTER `se_pro_forma`,
	MODIFY `se_ordine` tinyint(1) DEFAULT NULL AFTER `se_offerta`,
	MODIFY `se_missione` tinyint(1) DEFAULT NULL AFTER `se_ordine`,
	MODIFY `se_ricevuta` tinyint(1) DEFAULT NULL AFTER `se_missione`,
	MODIFY `se_trasporto` tinyint(1) DEFAULT NULL AFTER `se_ricevuta`,
	MODIFY `se_ecommerce` tinyint(1) DEFAULT NULL AFTER `se_trasporto`,
	MODIFY `numerazione` char(1) DEFAULT NULL AFTER `se_ecommerce`,
	MODIFY `stampa_pdf` char(255) DEFAULT NULL AFTER `numerazione`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `sigla`,
	DROP INDEX IF EXISTS `numerazione`,
	DROP INDEX IF EXISTS `se_fattura`,
	DROP INDEX IF EXISTS `se_nota_credito`,
	DROP INDEX IF EXISTS `se_nota_debito`,
	DROP INDEX IF EXISTS `se_pro_forma`,
	DROP INDEX IF EXISTS `se_offerta`,
	DROP INDEX IF EXISTS `se_ordine`,
	DROP INDEX IF EXISTS `se_missione`,
	DROP INDEX IF EXISTS `se_ricevuta`,
	DROP INDEX IF EXISTS `se_trasporto`,
	DROP INDEX IF EXISTS `se_ecommerce`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611091501

-- tipologie_documenti: la KEY di codice_sdi e indice
ALTER TABLE `tipologie_documenti`
	ADD KEY IF NOT EXISTS `codice_sdi` (`codice_sdi`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`html_entity`,`font_awesome`,`se_fattura`,`se_nota_credito`,`se_nota_debito`,`se_pro_forma`,`se_offerta`,`se_ordine`,`se_missione`,`se_ricevuta`,`se_trasporto`,`se_ecommerce`);

-- | 202611091502

-- tipologie_documenti: il TipoDocumento in codice_sdi
UPDATE `tipologie_documenti` SET `codice_sdi` = `codice` WHERE `codice_sdi` IS NULL AND `codice` LIKE 'TD%';

-- | 202611091503

-- tipologie_documenti: le righe che sui deploy hanno un id diverso dal canone
UPDATE IGNORE `tipologie_documenti` SET `id` = 37
	WHERE `id` <> 37 AND `id_genitore` = 1 AND `nome` = 'acquisti da San Marino con IVA (fattura cartacea)';
UPDATE IGNORE `tipologie_documenti` SET `id` = 38
	WHERE `id` <> 38 AND `id_genitore` = 1 AND `nome` = 'comunicazione per omessa o irregolare fatturazione';
UPDATE IGNORE `tipologie_documenti` SET `id` = 35
	WHERE `id` <> 35 AND `nome` = 'missione di prelievo';

-- | 202611091504

-- tipologie_documenti: le righe canoniche che mancano ( sulle righe col codice SdI codice resta il TipoDocumento, vedi sopra )
INSERT IGNORE INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `codice_sdi`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_nota_debito`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_missione`, `se_ricevuta`, `se_trasporto`, `se_ecommerce`, `numerazione`, `stampa_pdf`) VALUES
	(1, NULL, NULL, 'TD01', 'TD01', 'fattura', 'fatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'F', 'fattura'),
	(2, 1, NULL, 'TD01', 'TD01', 'fattura accompagnatoria', 'fatt. acc.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'F', NULL),
	(3, NULL, NULL, 'TD04', 'TD04', 'nota di credito', 'n. di credito', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'nota.credito'),
	(4, NULL, NULL, 'DOCUMENTO_DI_TRASPORTO', NULL, 'documento di trasporto', 'DDT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'T', 'ddt'),
	(5, NULL, NULL, 'PRO_FORMA', NULL, 'pro forma', 'profroma', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 'P', 'proforma'),
	(6, NULL, NULL, 'OFFERTA', NULL, 'offerta', 'off.', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 'O', 'offerta'),
	(7, NULL, NULL, 'ORDINE', NULL, 'ordine', 'ord.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'E', 'ordine'),
	(8, NULL, NULL, 'RICEVUTA', NULL, 'ricevuta', 'ric.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, 'R', 'ricevuta'),
	(9, NULL, NULL, 'SCONTRINO', NULL, 'scontrino', 'scontr.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'S', 'documento.generico'),
	(10, NULL, NULL, 'DOCUMENTO_DI_RITIRO', NULL, 'documento di ritiro', 'doc. di ritiro', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'G', 'documento.generico'),
	(11, NULL, NULL, 'DOCUMENTO_DI_CONSEGNA', NULL, 'documento di consegna', 'doc. di consegna', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'H', 'documento.generico'),
	(12, NULL, NULL, 'DOCUMENTO_DI_RESO', NULL, 'documento di reso', 'doc. di reso', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'I', 'documento.generico'),
	(13, NULL, NULL, 'TD02', 'TD02', 'acconto/anticipo su fattura', 'acc.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'documento.generico'),
	(14, NULL, NULL, 'TD03', 'TD03', 'acconto/anticipo su parcella', 'acc.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'documento.generico'),
	(15, NULL, NULL, 'TD05', 'TD05', 'nota di debito', 'n. di debito', NULL, NULL, 1, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'documento.generico'),
	(16, NULL, NULL, 'TD06', 'TD06', 'parcella', 'parcella', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', 'documento.generico'),
	(17, 1, NULL, 'TD16', 'TD16', 'integrazione fattura reverse charge interno', 'integr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(18, 1, NULL, 'TD17', 'TD17', 'integrazione autofattura acquisto servizi dall\'estero', 'integr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(19, 1, NULL, 'TD18', 'TD18', 'integrazione per acquisto beni intracomunitari', 'integr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(20, 1, NULL, 'TD19', 'TD19', 'integrazione/autofattura per acquisto beni', 'integr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(21, 1, NULL, 'TD20', 'TD20', 'autofattura per regolarizzazione e integrazione fatture', 'autofatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(22, 1, NULL, 'TD21', 'TD21', 'autofattura per splafonamento', 'autofatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(23, 1, NULL, 'TD22', 'TD22', 'estrazione beni da deposito IVA', 'estr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(24, 1, NULL, 'TD23', 'TD23', 'estrazione beni da deposito IVA con versamento dell\'IVA', 'estr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(25, 1, NULL, 'TD24', 'TD24', 'fattura differita ex art. 21 c. 4 terzo per. lett. a d.P.R. 633/1972', 'fatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(26, 1, NULL, 'TD25', 'TD25', 'fattura differita ex art. 21 c. 4 terzo per. lett. b d.P.R. 633/1972', 'fatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(27, 1, NULL, 'TD26', 'TD26', 'cessione beni ammortizzabili e per passaggi interni', 'fatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(28, 1, NULL, 'TD27', 'TD27', 'fattura per autoconsumo o cessioni gratuite senza rivalsa', 'fatt.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(29, NULL, NULL, 'DISTINTA', NULL, 'distinta', 'dist.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'D', 'documento.generico'),
	(30, 29, NULL, 'DISTINTA_ANALITICA', NULL, 'distinta analitica', 'dist. anal.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'D', NULL),
	(31, 29, NULL, 'DISTINTA_EASY', NULL, 'distinta easy', 'dist. easy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'D', NULL),
	(32, 29, NULL, 'DISTINTA_ITALIA_ESTERO', NULL, 'distinta Italia / estero contest, racc. market, ass. market', 'dist. Ita / est', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'D', NULL),
	(33, 29, NULL, 'ORDINE_DI_PRODUZIONE', NULL, 'ordine di produzione', 'ordine di prod.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P', NULL),
	(34, NULL, NULL, 'MISSIONE', NULL, 'missione', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'M', 'copertina.missione'),
	(35, 34, NULL, 'MISSIONE_DI_PRELIEVO', NULL, 'missione di prelievo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(36, 34, NULL, 'MISSIONE_DI_MOVIMENTAZIONE', NULL, 'missione di movimentazione', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	(37, 1, NULL, 'TD28', 'TD28', 'acquisti da San Marino con IVA (fattura cartacea)', 'integr.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL),
	(38, 1, NULL, 'TD29', 'TD29', 'comunicazione per omessa o irregolare fatturazione', 'comunic.', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'F', NULL);

-- | 202611091505

-- tipologie_documenti: la missione di prelievo, che alcuni deploy hanno come radice, sotto la missione
UPDATE `tipologie_documenti` SET `id_genitore` = 34
	WHERE `id_genitore` IS NULL AND ( id, nome ) IN ( ( 35, 'missione di prelievo' ), ( 36, 'missione di movimentazione' ) )
	AND EXISTS ( SELECT 1 FROM ( SELECT id FROM `tipologie_documenti` WHERE id = 34 AND nome = 'missione' ) AS m );

-- | 202611091506

-- tipologie_documenti: codice sulle righe senza codice SdI
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DOCUMENTO_DI_TRASPORTO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 4, 'documento di trasporto' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'PRO_FORMA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 5, 'pro forma' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'OFFERTA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 6, 'offerta' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'ORDINE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 7, 'ordine' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'RICEVUTA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 8, 'ricevuta' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'SCONTRINO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 9, 'scontrino' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DOCUMENTO_DI_RITIRO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 10, 'documento di ritiro' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DOCUMENTO_DI_CONSEGNA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 11, 'documento di consegna' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DOCUMENTO_DI_RESO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 12, 'documento di reso' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DISTINTA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 29, 'distinta' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DISTINTA_ANALITICA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 30, 'distinta analitica' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DISTINTA_EASY' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 31, 'distinta easy' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'DISTINTA_ITALIA_ESTERO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 32, 'distinta Italia / estero contest, racc. market, ass. market' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'ORDINE_DI_PRODUZIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 33, 'ordine di produzione' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'MISSIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 34, 'missione' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'MISSIONE_DI_PRELIEVO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 35, 'missione di prelievo' ) );
UPDATE IGNORE `tipologie_documenti` SET `codice` = 'MISSIONE_DI_MOVIMENTAZIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 36, 'missione di movimentazione' ) );

-- | FINE

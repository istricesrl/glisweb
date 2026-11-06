-- 2026-11-06 — tipologie_anagrafica: codice, nome a char(255), la natura dalla radice
--
-- Schema canonico, punto 6, riga 191, decisione di Fabio del 06/11/2026: le radici di tipologie_anagrafica sono le tre
-- nature del framework ( persone fisiche, persone giuridiche, pubblica amministrazione ), sotto ciascuna l'utente fa
-- crescere un albero aperto di forme di cortesia ( "spett. dott. comm.", "preg.mo avv." ). I flag della natura valgono
-- sulla radice e la vista tipologie_anagrafica_view li dà ereditati a ogni riga; il 050 li ripete sulle sue righe per i
-- lettori che leggono la tabella, e la riga 5 spettabile, sotto persone giuridiche, non lo faceva.
--
-- Cosa fa:
-- - aggiunge codice, dopo ordine, con la UNIQUE KEY codice, allarga nome a char(255) e sposta sigla dopo le icone;
-- - toglie la KEY nome e le KEY sui singoli flag e ricrea indice con sigla e i flag;
-- - valorizza codice sulle nove righe che il 050 carica, riconoscendole da id E nome, e solo dove codice e' ancora vuoto;
-- - accende se_persona_giuridica sulla 5 spettabile figlia della 2, se e' ancora vuoto.
--
-- Cosa NON fa: non toglie colonne. note e se_ecommerce, mai lette ne' valorizzate, escono dal canone ma restano sui
-- database fino al punto 12; la vista nuova ( 090 ) non le legge piu'.
--
-- IDEMPOTENTE: colonne e chiavi con IF ( NOT ) EXISTS, indice e codice si tolgono e si ricreano, gli UPDATE toccano solo
-- righe con codice o flag ancora vuoti; UPDATE IGNORE salta la riga il cui codice e' gia' usato da un'altra.

-- | 202611061210

-- tipologie_anagrafica: codice, nome a char(255), sigla dopo le icone, via le KEY su nome e flag
ALTER TABLE `tipologie_anagrafica`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	MODIFY `sigla` char(32) DEFAULT NULL AFTER `font_awesome`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_persona_fisica`,
	DROP INDEX IF EXISTS `se_persona_giuridica`,
	DROP INDEX IF EXISTS `se_pubblica_amministrazione`,
	DROP INDEX IF EXISTS `se_ecommerce`,
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611061211

-- tipologie_anagrafica: la UNIQUE codice e indice
ALTER TABLE `tipologie_anagrafica`
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`sigla`,`se_persona_fisica`,`se_persona_giuridica`,`se_pubblica_amministrazione`);

-- | 202611061212

-- tipologie_anagrafica: codice sulle righe del 050
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'PERSONE_FISICHE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 1, 'persone fisiche' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'PERSONE_GIURIDICHE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 2, 'persone giuridiche' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'SIGNOR' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 3, 'signor' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'SIGNORA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 4, 'signora' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'SPETTABILE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 5, 'spettabile' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'PUBBLICA_AMMINISTRAZIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 6, 'pubblica amministrazione' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'GENTILISSIMO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 7, 'gentilissimo' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'GENTILISSIMA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 8, 'gentilissima' ) );
UPDATE IGNORE `tipologie_anagrafica` SET `codice` = 'SPETTABILE_PA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 9, 'spettabile' ) );

-- | 202611061213

-- tipologie_anagrafica: se_persona_giuridica sulla 5 spettabile, figlia di persone giuridiche
UPDATE `tipologie_anagrafica` SET `se_persona_giuridica` = 1
	WHERE `se_persona_giuridica` IS NULL AND `id_genitore` = 2 AND ( id, nome ) IN ( ( 5, 'spettabile' ) );

-- | FINE

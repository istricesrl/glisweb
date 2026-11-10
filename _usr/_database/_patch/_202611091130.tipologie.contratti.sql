-- 2026-11-09 — tipologie_contratti: codice, id_articolo, nome a char(255), i flag di classe dalla radice
--
-- Schema canonico, punto 6, riga 200, decisione di Fabio del 09/11/2026 ( opzione A2 ): le radici di tipologie_contratti
-- sono i generi del framework ( vendita, locazione, tesseramento, abbonamento, iscrizione, affiliazione, servizi ), sotto
-- ciascuna l'utente fa crescere le sue tipologie. I flag di classe valgono sulla radice e la vista tipologie_contratti_view
-- li dà ereditati a ogni riga; se_acquisto e se_locazione sono i flag di classe di vendita e locazione, che il 050 non
-- accendeva. Le modalità ( se_libero, se_prenotazione, se_scalare ) e le qualità ( se_immobili, se_online ) sono della riga.
-- id_articolo entra col meccanismo canonico d'acquisto ( 27/10 ), accanto a id_prodotto.
--
-- Cosa fa:
-- - aggiunge codice, dopo ordine, con la UNIQUE KEY codice, e id_articolo, dopo id_prodotto, con la sua KEY;
-- - allarga nome a char(255) e riordina i flag: classi, modalità, qualità;
-- - toglie la KEY nome e le KEY sui singoli flag e ricrea indice col modello della famiglia;
-- - toglie le FK _03 e _04 di id_progetto e id_categoria_progetti e mette la _03 su id_articolo, SET NULL;
-- - valorizza codice sulle sette righe che il 050 carica, riconoscendole da id E nome, e solo dove codice e' ancora vuoto;
-- - accende se_acquisto sulla radice 1 vendita e se_locazione sulla radice 2 locazione, se ancora vuoti.
--
-- Cosa NON fa: non toglie colonne. id_progetto e id_categoria_progetti ( il corso e la disciplina, mai valorizzati,
-- superati dal metadato abbonamento|discipline ) escono dal canone ma restano sui database fino al punto 12, con le
-- loro KEY; la vista nuova ( 090 ) non le legge piu'.
--
-- IDEMPOTENTE: colonne e chiavi con IF ( NOT ) EXISTS, indice, codice e la FK _03 si tolgono e si ricreano, gli UPDATE
-- toccano solo righe con codice o flag ancora vuoti; UPDATE IGNORE salta la riga il cui codice e' gia' usato da un'altra.

-- | 202611091130

-- tipologie_contratti: via le FK di corso e disciplina, e la _03 che passa a id_articolo
ALTER TABLE `tipologie_contratti`
	DROP FOREIGN KEY IF EXISTS `tipologie_contratti_ibfk_03_nofollow`,
	DROP FOREIGN KEY IF EXISTS `tipologie_contratti_ibfk_04_nofollow`;

-- | 202611091131

-- tipologie_contratti: codice, id_articolo, nome a char(255), flag riordinati, via le KEY su nome e flag
ALTER TABLE `tipologie_contratti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL AFTER `id_prodotto`,
	MODIFY `se_tesseramento` tinyint(1) DEFAULT NULL AFTER `font_awesome`,
	MODIFY `se_abbonamento` tinyint(1) DEFAULT NULL AFTER `se_tesseramento`,
	MODIFY `se_iscrizione` tinyint(1) DEFAULT NULL AFTER `se_abbonamento`,
	MODIFY `se_affiliazione` tinyint(1) DEFAULT NULL AFTER `se_iscrizione`,
	MODIFY `se_acquisto` tinyint(1) DEFAULT NULL AFTER `se_affiliazione`,
	MODIFY `se_locazione` tinyint(1) DEFAULT NULL AFTER `se_acquisto`,
	MODIFY `se_libero` tinyint(1) DEFAULT NULL AFTER `se_locazione`,
	MODIFY `se_prenotazione` tinyint(1) DEFAULT NULL AFTER `se_libero`,
	MODIFY `se_scalare` tinyint(1) DEFAULT NULL AFTER `se_prenotazione`,
	MODIFY `se_immobili` tinyint(1) DEFAULT NULL AFTER `se_scalare`,
	MODIFY `se_online` tinyint(1) DEFAULT NULL AFTER `se_immobili`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `se_tesseramento`,
	DROP INDEX IF EXISTS `se_abbonamento`,
	DROP INDEX IF EXISTS `se_iscrizione`,
	DROP INDEX IF EXISTS `se_immobili`,
	DROP INDEX IF EXISTS `se_acquisto`,
	DROP INDEX IF EXISTS `se_locazione`,
	DROP INDEX IF EXISTS `se_libero`,
	DROP INDEX IF EXISTS `se_prenotazione`,
	DROP INDEX IF EXISTS `se_scalare`,
	DROP INDEX IF EXISTS `se_affiliazione`,
	DROP INDEX IF EXISTS `se_online`,
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611091132

-- tipologie_contratti: la UNIQUE codice, la KEY di id_articolo e indice
ALTER TABLE `tipologie_contratti`
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_tesseramento`,`se_abbonamento`,`se_iscrizione`,`se_affiliazione`,`se_acquisto`,`se_locazione`,`se_libero`,`se_prenotazione`,`se_scalare`,`se_immobili`,`se_online`);

-- | 202611091133

-- tipologie_contratti: la FK di id_articolo
ALTER TABLE `tipologie_contratti`
	ADD CONSTRAINT `tipologie_contratti_ibfk_03_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611091134

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'VENDITA' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 1, 'vendita' ) );

-- | 202611091135

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'LOCAZIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 2, 'locazione' ) );

-- | 202611091136

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'TESSERAMENTO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 3, 'tesseramento' ) );

-- | 202611091137

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'ABBONAMENTO' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 4, 'abbonamento' ) );

-- | 202611091138

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'ISCRIZIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 5, 'iscrizione' ) );

-- | 202611091139

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'AFFILIAZIONE' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 6, 'affiliazione' ) );

-- | 202611091140

-- tipologie_contratti: codice sulle righe del 050
UPDATE IGNORE `tipologie_contratti` SET `codice` = 'SERVIZI' WHERE `codice` IS NULL AND ( id, nome ) IN ( ( 7, 'servizi' ) );

-- | 202611091141

-- tipologie_contratti: i flag di classe di vendita e locazione, sulle loro radici
UPDATE `tipologie_contratti` SET `se_acquisto` = 1
	WHERE `se_acquisto` IS NULL AND `id_genitore` IS NULL AND ( id, nome ) IN ( ( 1, 'vendita' ) );

-- | 202611091142

-- tipologie_contratti: i flag di classe di vendita e locazione, sulle loro radici
UPDATE `tipologie_contratti` SET `se_locazione` = 1
	WHERE `se_locazione` IS NULL AND `id_genitore` IS NULL AND ( id, nome ) IN ( ( 2, 'locazione' ) );

-- | FINE

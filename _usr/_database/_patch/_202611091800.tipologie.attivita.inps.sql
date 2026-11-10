-- 2026-11-09 — tipologie_attivita_inps: modello delle tipologie, codice_inps, radici ORDINARIO e STRAORDINARIO
--
-- Schema canonico, punto 6, riga 194, decisione di Fabio del 09/11/2026 ( opzione A ): la tabella segue il modello
-- delle tipologie_* ( ordine, icone, unica, indice, vista completa ). Il codice della voce nel gestionale paghe è un
-- codice esterno e passa in codice_inps; codice resta per le righe del framework, e il 050 carica le due radici
-- ORDINARIO ( 1, con se_quadratura ) e STRAORDINARIO ( 2 ), che _8100.cartellini oggi cerca per id.
--
-- Cosa fa:
-- - aggiunge ordine, html_entity, font_awesome e codice_inps, rimette codice e nome nell'ordine del modello e rende
--   nome facoltativo come nelle altre tipologie;
-- - copia codice in codice_inps dove codice_inps è vuoto, e svuota codice dove non è un codice del framework
--   ( la tabella è vuota su tutti i database letti il 09/11/2026: è una rete, non un travaso );
-- - rinomina la UNIQUE unico in unica, toglie la KEY se_quadratura, aggiunge le KEY ordine, codice_inps e indice;
-- - inserisce le due radici se mancano, e dà il codice alle righe 1 e 2 se si chiamano ordinario e straordinario;
-- - ricrea la vista con tutte le colonne e il percorso come etichetta.
--
-- Cosa NON fa: non tocca le chiavi esterne ( costi_contratti_ibfk_02_nofollow resta NO ACTION ) né attivita, che non
-- ha più la colonna id_tipologia_inps letta dai legacy ( RAMI.md del canone, da decidere col modulo risorse umane ).
--
-- IDEMPOTENTE: colonne e chiavi con IF ( NOT ) EXISTS, indice si toglie e si ricrea, gli UPDATE toccano solo righe da
-- sistemare, INSERT IGNORE salta le righe già presenti; la vista è CREATE OR REPLACE.

-- | 202611091800

-- tipologie_attivita_inps: colonne del modello e codice_inps
ALTER TABLE `tipologie_attivita_inps`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id_genitore`,
	MODIFY `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL AFTER `html_entity`,
	ADD COLUMN IF NOT EXISTS `codice_inps` char(32) DEFAULT NULL AFTER `font_awesome`,
	MODIFY `se_quadratura` tinyint(1) DEFAULT NULL AFTER `codice_inps`;

-- | 202611091801

-- tipologie_attivita_inps: il codice paghe passa in codice_inps
UPDATE `tipologie_attivita_inps`
	SET codice_inps = codice
	WHERE codice IS NOT NULL AND codice_inps IS NULL AND codice NOT IN ( 'ORDINARIO', 'STRAORDINARIO' );

-- | 202611091802

-- tipologie_attivita_inps: codice libero per le righe del framework
UPDATE `tipologie_attivita_inps`
	SET codice = NULL
	WHERE codice IS NOT NULL AND codice_inps = codice;

-- | 202611091803

-- tipologie_attivita_inps: chiavi tolte
ALTER TABLE `tipologie_attivita_inps`
	DROP INDEX IF EXISTS `unico`,
	DROP INDEX IF EXISTS `se_quadratura`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611091804

-- tipologie_attivita_inps: chiavi del modello
ALTER TABLE `tipologie_attivita_inps`
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `codice_inps` (`codice_inps`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`codice_inps`,`se_quadratura`);

-- | 202611091805

-- tipologie_attivita_inps: codice sulle righe del 050 già presenti
UPDATE IGNORE `tipologie_attivita_inps` JOIN (
		SELECT 1 AS id, 'ordinario' AS nome, 'ORDINARIO' AS codice
		UNION ALL SELECT 2 AS id, 'straordinario' AS nome, 'STRAORDINARIO' AS codice
	) AS c050 ON c050.id = `tipologie_attivita_inps`.id AND c050.nome = `tipologie_attivita_inps`.nome
	SET `tipologie_attivita_inps`.codice = c050.codice
	WHERE `tipologie_attivita_inps`.codice IS NULL;

-- | 202611091806

-- tipologie_attivita_inps: radici del 050
INSERT IGNORE INTO `tipologie_attivita_inps` (`id`, `id_genitore`, `ordine`, `codice`, `nome`, `html_entity`, `font_awesome`, `codice_inps`, `se_quadratura`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ORDINARIO',	'ordinario',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'STRAORDINARIO',	'straordinario',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL);

-- | FINE

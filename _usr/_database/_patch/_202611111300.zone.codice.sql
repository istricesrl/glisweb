-- 2026-11-11 — zone: codice, la zona di default trovata per codice
--
-- Schema canonico, punto 6, riga 238, decisione di Fabio del 11/11/2026 ( opzione A ): zone e' una tabella assistita, e la
-- zona di default caricata dall'installazione ( id 1, nome DEFAULT ), su cui stanno le regole che valgono dove non c'e' una
-- zona piu' specifica, si trova per codice e non per id ( niente id cablati nel codice, regola del 05/11/2026 ).
--
-- Cosa fa: aggiunge codice ( char(32), UNIQUE ) dopo id_tipologia, allarga nome a char(255), da' il codice DEFAULT alla
-- zona di default dove c'e' ( riconosciuta da id e nome ), rifa' le chiavi nella forma dei classificatori ( unica su
-- id_genitore e nome, codice, indice ), ricrea la vista con codice, note e i flag della tipologia.
--
-- Cosa NON fa: non inserisce la zona di default dove manca ( la tabella e' assistita: l'utente puo' averla tolta ), non
-- tocca le FK, non toglie la lettura dell'id 1 dal legacy _4170.ecommerce ( migrazione dei moduli ).
--
-- IDEMPOTENTE.

-- | 202611111300

-- zone: codice e nome piu' largo
ALTER TABLE `zone`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id_tipologia`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`;

-- | 202611111301

-- zone: il codice della zona di default
UPDATE `zone` SET `codice` = 'DEFAULT' WHERE `id` = 1 AND `nome` = 'DEFAULT' AND `codice` IS NULL;

-- | 202611111302

-- zone: chiavi
ALTER TABLE `zone`
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY `codice` (`codice`),
	ADD KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`codice`,`nome`);

-- | 202611111303

-- zone_view
CREATE OR REPLACE VIEW zone_view AS
	SELECT
		zone.id,
		zone.id_genitore,
		zone.id_tipologia,
		tipologie_zone.nome AS tipologia,
		tipologie_zone.se_ecommerce,
		tipologie_zone.se_commerciale,
		tipologie_zone.se_immobiliare,
		zone.codice,
		zone.nome,
		zone.note,
		zone.id_account_inserimento,
		zone.id_account_aggiornamento,
		zone_path( zone.id ) AS __label__
	FROM zone
		LEFT JOIN tipologie_zone ON tipologie_zone.id = zone.id_tipologia
;

-- | FINE

-- 2026-10-01 — caratteristiche.se_edifici e se_indirizzi
--
-- COSA SI VEDEVA. Le schede caratteristiche di edifici e indirizzi del modulo V300.immobiliari leggono
-- caratteristiche_view WHERE se_edifici = 1 e WHERE se_indirizzi = 1, ma caratteristiche aveva solo se_immobili: le
-- tendine si fermavano con 1054 Unknown column. Edifici e indirizzi possono avere caratteristiche diverse dagli
-- immobili ( un ascensore e' dell'edificio, un piano dell'immobile ), quindi hanno un flag ciascuno.
--
-- COSA FA. Aggiunge le due colonne, vuote, dopo se_immobili, e rifa' caratteristiche_view con le colonne nuove.
--
-- IDEMPOTENTE.

-- | 202610011830

ALTER TABLE `caratteristiche`
    ADD COLUMN IF NOT EXISTS `se_edifici` tinyint(1) DEFAULT NULL AFTER `se_immobili`,
    ADD COLUMN IF NOT EXISTS `se_indirizzi` tinyint(1) DEFAULT NULL AFTER `se_edifici`;

-- | 202610011831

-- caratteristiche_view, con se_edifici e se_indirizzi
CREATE OR REPLACE VIEW `caratteristiche_view` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.html_entity,
		caratteristiche.font_awesome,
		caratteristiche.se_prodotti,
		caratteristiche.se_articoli,
		caratteristiche.se_immobili,
		caratteristiche.se_edifici,
		caratteristiche.se_indirizzi,
		caratteristiche.se_categorie_prodotti,
		caratteristiche.id_account_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche_path(
            caratteristiche.id
        ) AS __label__
	FROM caratteristiche
;

-- | FINE FILE

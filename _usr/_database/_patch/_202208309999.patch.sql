--
-- PATCH
--

--| 202208300010
ALTER TABLE `banner_azioni` DROP KEY `indice`;

--| 202208300020
ALTER TABLE `banner_azioni`
    ADD COLUMN `token` char(128) DEFAULT NULL AFTER `timestamp_azione`, 
    ADD KEY `token` (`token`),
	ADD KEY `indice` (`id`,`id_pagina`,`id_banner`,`azione`,`timestamp_azione`,`token`);

--| 202208300030
CREATE OR REPLACE VIEW `banner_azioni_view` AS
	SELECT
		banner_azioni.id,
		banner_azioni.id_banner,
		banner_azioni.id_pagina,
		banner_azioni.azione,
		banner_azioni.timestamp_azione,
		banner_azioni.token,
		banner_azioni.id_account_inserimento,
		banner_azioni.id_account_aggiornamento,
		concat(
			banner_azioni.azione,
			' di ',
			banner.nome
		) AS __label__
	FROM banner_azioni
		LEFT JOIN banner ON banner.id = banner_azioni.id_banner
;

--| 202208300040
ALTER TABLE`immobili_anagrafica`    ADD COLUMN `note` text AFTER `ordine`;

--| 202208300050
ALTER TABLE `tipologie_contratti` 
	ADD COLUMN `se_libero` INT(1) NULL DEFAULT NULL AFTER `se_locazione`,
	ADD COLUMN `se_prenotazione` INT(1) NULL DEFAULT NULL AFTER `se_libero`, 
	ADD COLUMN `se_scalare` INT(1) NULL DEFAULT NULL AFTER `se_prenotazione`,
	ADD KEY `se_libero` (`se_libero`),
  	ADD KEY `se_prenotazione`(`se_prenotazione`),
  	ADD KEY `se_scalare`(`se_scalare`);

--| 202208300060
CREATE OR REPLACE VIEW `tipologie_contratti_view` AS
	SELECT
		tipologie_contratti.id,
		tipologie_contratti.id_genitore,
		tipologie_contratti.ordine,
		tipologie_contratti.nome,
		tipologie_contratti.html_entity,
		tipologie_contratti.font_awesome,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		tipologie_contratti.se_libero,
		tipologie_contratti.se_prenotazione,
		tipologie_contratti.se_scalare,
		tipologie_contratti.id_account_inserimento,
		tipologie_contratti.id_account_aggiornamento,
		tipologie_contratti_path( tipologie_contratti.id ) AS __label__
	FROM tipologie_contratti
;

--| FINE
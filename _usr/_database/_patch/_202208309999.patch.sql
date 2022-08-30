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

--| FINE
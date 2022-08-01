--
-- PATCH
--

--| 202208010010
ALTER TABLE `carrelli` 
ADD `ordine_pagamento` CHAR(128) NULL DEFAULT NULL AFTER `codice_pagamento`,
ADD `utm_id` CHAR(128) NULL DEFAULT NULL AFTER `importo_pagamento`,
ADD `utm_source` CHAR(128) NULL DEFAULT NULL AFTER `utm_id`,
ADD `utm_medium` CHAR(128) NULL DEFAULT NULL AFTER `utm_source`,
ADD `utm_campaign` CHAR(128) NULL DEFAULT NULL AFTER `utm_medium`,
ADD `utm_term` CHAR(128) NULL DEFAULT NULL AFTER `utm_campaign`,
ADD `utm_content` CHAR(128) NULL DEFAULT NULL AFTER `utm_term`,
ADD `id_reseller` int(11) NULL DEFAULT NULL AFTER `utm_content`,
ADD `id_affiliato` int(11) NULL DEFAULT NULL AFTER `id_reseller`,
ADD KEY `ordine_pagamento` ( `ordine_pagamento` ),
ADD KEY `utm_id` ( `utm_id` ),
ADD KEY `utm_source` ( `utm_source` ),
ADD KEY `utm_medium` ( `utm_medium` ),
ADD KEY `utm_campaign` ( `utm_campaign` ),
ADD KEY `utm_term` ( `utm_term` ),
ADD KEY `utm_content` ( `utm_content` ),
ADD KEY `id_reseller` ( `id_reseller` ),
ADD KEY `id_affiliato` ( `id_affiliato` ),
ADD CONSTRAINT `carrelli_ibfk_08_nofollow`          FOREIGN KEY (`id_reseller`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `carrelli_ibfk_09_nofollow`          FOREIGN KEY (`id_affiliato`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202208010020
ALTER TABLE `contatti` 
ADD `utm_id` CHAR(128) NULL DEFAULT NULL AFTER `id_ranking`,
ADD `utm_source` CHAR(128) NULL DEFAULT NULL AFTER `utm_id`,
ADD `utm_medium` CHAR(128) NULL DEFAULT NULL AFTER `utm_source`,
ADD `utm_campaign` CHAR(128) NULL DEFAULT NULL AFTER `utm_medium`,
ADD `utm_term` CHAR(128) NULL DEFAULT NULL AFTER `utm_campaign`,
ADD `utm_content` CHAR(128) NULL DEFAULT NULL AFTER `utm_term`,
ADD KEY `utm_id` ( `utm_id` ),
ADD KEY `utm_source` ( `utm_source` ),
ADD KEY `utm_medium` ( `utm_medium` ),
ADD KEY `utm_campaign` ( `utm_campaign` ),
ADD KEY `utm_term` ( `utm_term` ),
ADD KEY `utm_content` ( `utm_content` );


CREATE OR REPLACE VIEW contatti_view AS
	SELECT
		contatti.id,
		contatti.id_tipologia,
		tipologie_contatti.nome AS tipologia,
		contatti.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		contatti.id_inviante,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS inviante,
		contatti.id_ranking,
		ranking.nome AS ranking,
        contatti.utm_id,
        contatti.utm_source,
        contatti.utm_medium,
        contatti.utm_campaign,
        contatti.utm_term,
        contatti.utm_content,
		contatti.nome,
		contatti.timestamp_contatto,
		contatti.id_account_inserimento,
		contatti.id_account_aggiornamento,
		concat(
			tipologie_contatti.nome,
			' / ',
			contatti.nome
		) AS __label__
	FROM contatti
		LEFT JOIN tipologie_contatti ON tipologie_contatti.id = contatti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = contatti.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = contatti.id_inviante
		LEFT JOIN ranking ON ranking.id = contatti.id_ranking
;

--| FINE
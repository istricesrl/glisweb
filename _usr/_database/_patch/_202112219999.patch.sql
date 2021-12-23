--
-- PATCH
--

--| 202112210000
ALTER TABLE `chiavi` ADD `id_tipologia` int DEFAULT NULL AFTER `id_licenza`;

--| 202112210010
ALTER TABLE `chiavi` ADD KEY `id_tipologia` (`id_tipologia`);

--| 202112210020
ALTER TABLE `chiavi` ADD CONSTRAINT `chiavi_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_chiavi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202112210030
CREATE OR REPLACE VIEW chiavi_view AS
	SELECT
		chiavi.id,
		chiavi.id_licenza,
		licenze.nome AS licenza,
        chiavi.id_tipologia,
        tipologie_chiavi.nome AS tipologia,
		chiavi.codice,
		chiavi.seriale,
		chiavi.nome,
		chiavi.id_account_inserimento,
		chiavi.id_account_aggiornamento,
		chiavi.nome AS __label__
	FROM chiavi
		LEFT JOIN licenze ON licenze.id = chiavi.id_licenza
        LEFT JOIN tipologie_chiavi ON tipologie_chiavi.id = chiavi.id_tipologia
;

--| FINE FILE

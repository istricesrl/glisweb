--
-- PATCH
--

--| 202205110100
CREATE OR REPLACE VIEW discipline_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_disciplina,
		categorie_progetti.se_classe,
		categorie_progetti.se_fascia,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	WHERE categorie_progetti.se_disciplina = 1
	GROUP BY categorie_progetti.id
;

--| 202205110110
CREATE OR REPLACE VIEW fasce_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_disciplina,
		categorie_progetti.se_classe,
		categorie_progetti.se_fascia,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	WHERE categorie_progetti.se_fascia = 1
	GROUP BY categorie_progetti.id
;


--| 202205110120
CREATE OR REPLACE VIEW livelli_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_disciplina,
		categorie_progetti.se_classe,
		categorie_progetti.se_fascia,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	WHERE categorie_progetti.se_classe = 1
	GROUP BY categorie_progetti.id
;

--| 202205110130
CREATE TABLE `refresh_view_statiche` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entita` char(64) NOT NULL,
  `note` text,
  `timestamp_prenotazione` int(11) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entita` (`entita`),
  KEY `timestamp_prenotazione` (`timestamp_prenotazione`),
  KEY `token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--| FINE FILE
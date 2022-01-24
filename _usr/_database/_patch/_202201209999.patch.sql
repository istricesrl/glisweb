--
-- PATCH
--

--| 202201201125
ALTER TABLE `categorie_risorse`
  ADD `id_sito` int(11) DEFAULT NULL AFTER  `se_cacheable`;

--| 202201201126
CREATE OR REPLACE VIEW categorie_risorse_view AS
	SELECT
		categorie_risorse.id,
		categorie_risorse.id_genitore,
		categorie_risorse.ordine,
		categorie_risorse.nome,
		categorie_risorse.template,
		categorie_risorse.schema_html,
		categorie_risorse.tema_css,
		categorie_risorse.se_sitemap,
		categorie_risorse.se_cacheable,
		categorie_risorse.id_sito,
		categorie_risorse.id_pagina,
		count( c1.id ) AS figli,
		count( risorse_categorie.id ) AS membri,
		categorie_risorse.id_account_inserimento,
		categorie_risorse.id_account_aggiornamento,
		categorie_risorse_path( categorie_risorse.id ) AS __label__
	FROM categorie_risorse
		LEFT JOIN categorie_risorse AS c1 ON c1.id_genitore = categorie_risorse.id
		LEFT JOIN risorse_categorie ON risorse_categorie.id_categoria = categorie_risorse.id
	GROUP BY categorie_risorse.id
;


--| FINE FILE
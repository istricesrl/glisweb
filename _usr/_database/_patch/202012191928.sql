CREATE OR REPLACE VIEW categorie_anagrafica_view AS
	SELECT
		categorie_anagrafica.*,
		count( anagrafica_categorie.id ) AS membri,
	 	categorie_anagrafica_path( categorie_anagrafica.id ) AS __label__
	FROM categorie_anagrafica
	LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
	GROUP BY categorie_anagrafica.id
	ORDER BY __label__
;
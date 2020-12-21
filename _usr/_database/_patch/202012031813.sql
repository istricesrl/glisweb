CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
	prodotti.*,
	tipologie_pubblicazione.se_pubblicato,
	tipologie_pubblicazione.nome AS pubblicazione,
	group_concat( DISTINCT categorie_prodotti_view.__label__ SEPARATOR ' | ' ) AS categorie,
	produttori.denominazione AS produttore,
	marchi.nome AS marchio,
	concat_ws( ' ', prodotti.id, prodotti.nome ) AS __label__
	FROM prodotti
	INNER JOIN tipologie_pubblicazione ON tipologie_pubblicazione.id = prodotti.id_tipologia_pubblicazione
	LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
	LEFT JOIN categorie_prodotti_view ON categorie_prodotti_view.id = prodotti_categorie.id_categoria
	LEFT JOIN anagrafica AS produttori ON produttori.id = prodotti.id_produttore
	LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
	GROUP BY prodotti.id
	ORDER BY __label__
;
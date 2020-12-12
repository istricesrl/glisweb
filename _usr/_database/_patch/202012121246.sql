CREATE OR REPLACE VIEW `immagini_view` AS
	SELECT
	immagini.*,
	ruoli_immagini.nome AS ruolo,
	coalesce(
		if((eventi.nome is not null), concat('evento | ',eventi.nome), NULL),
		if((pagine.nome is not null), concat('pagina | ',pagine.nome), NULL),
		if((prodotti.nome is not null), concat('prodotto | ',prodotti.nome), NULL),
		if((categorie_prodotti.nome is not null), concat('categoria prodotti | ',categorie_prodotti.nome), NULL)
	) AS `associato`,
	immagini.path AS __label__
	FROM immagini
	LEFT JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo
	LEFT JOIN eventi ON eventi.id = immagini.id_evento
	LEFT JOIN pagine ON pagine.id = immagini.id_pagina
	LEFT JOIN prodotti ON prodotti.id = immagini.id_prodotto
	LEFT JOIN categorie_prodotti ON categorie_prodotti.id = immagini.id_categoria_prodotti
	ORDER BY __label__
;
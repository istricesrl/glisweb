CREATE OR REPLACE VIEW `video_view` AS
    SELECT
    video.*,
    ruoli_video.nome AS ruolo,
    coalesce(
	if((eventi.nome is not null), concat('evento | ',eventi.nome), NULL),
	if((pagine.nome is not null), concat('pagina | ',pagine.nome), NULL),
	if((prodotti.nome is not null), concat('prodotto | ',prodotti.nome), NULL),
	if((categorie_prodotti.nome is not null), concat('categoria prodotti | ',categorie_prodotti.nome), NULL)
    ) AS `associato`,
    video.nome AS __label__
    FROM video
    LEFT JOIN ruoli_video ON ruoli_video.id = video.id_ruolo
    LEFT JOIN eventi ON eventi.id = video.id_evento
    LEFT JOIN pagine ON pagine.id = video.id_pagina
    LEFT JOIN prodotti ON prodotti.id = video.id_prodotto
    LEFT JOIN categorie_prodotti ON categorie_prodotti.id = video.id_categoria_prodotti
    ORDER BY __label__
;
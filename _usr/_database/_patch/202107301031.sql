CREATE OR REPLACE VIEW `articoli_view` AS
    SELECT
    articoli.*,
    taglie.it,
    tipologie_taglie.nome AS tipologia_taglia,
    udm.sigla AS udm,
    prodotti.se_ore,
    prodotti.se_matricola,
    concat_ws( ' ', articoli.id, articoli.nome ) AS __label__,
    concat( prodotti.nome, ' - ', articoli.nome ) AS nome_articolo
    FROM articoli
    LEFT JOIN taglie ON taglie.id = articoli.id_taglia
    LEFT JOIN tipologie_taglie ON tipologie_taglie.id = taglie.id_tipologia
    LEFT JOIN udm ON udm.id = articoli.id_udm
    LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
    ORDER BY __label__
;
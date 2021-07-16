CREATE OR REPLACE VIEW `articoli_caratteristiche_view` AS
    SELECT
    articoli_caratteristiche.*,
    articoli_caratteristiche.id AS __label__,
    caratteristiche_prodotti.nome AS caratteristica
    FROM
    articoli_caratteristiche
    LEFT JOIN caratteristiche_prodotti ON caratteristiche_prodotti.id = articoli_caratteristiche.id_caratteristica
;
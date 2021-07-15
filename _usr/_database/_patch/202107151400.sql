CREATE OR REPLACE VIEW `prodotti_caratteristiche_view` AS
    SELECT
    prodotti_caratteristiche.*,
    prodotti_caratteristiche.id AS __label__,
    caratteristiche_prodotti.nome AS caratteristica
    FROM
    prodotti_caratteristiche
    LEFT JOIN caratteristiche_prodotti ON caratteristiche_prodotti.id = prodotti_caratteristiche.id_caratteristica
;
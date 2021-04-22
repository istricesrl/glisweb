CREATE OR REPLACE VIEW `articoli_caratteristiche_view` AS
    SELECT
    articoli_caratteristiche.*,
    articoli_caratteristiche.id AS __label__
    FROM
    articoli_caratteristiche
;

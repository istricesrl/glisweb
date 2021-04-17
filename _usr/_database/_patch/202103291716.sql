CREATE OR REPLACE VIEW `listini_view` AS
    SELECT
    listini.*,
    listini.nome AS __label__
    FROM listini
    ORDER BY __label__
;
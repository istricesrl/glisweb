CREATE OR REPLACE VIEW `metadati_view` AS
    SELECT
    metadati.*,
    lingue.ietf,
    concat( metadati.nome, ':', metadati.testo ) AS __label__
    FROM metadati
    LEFT JOIN lingue ON lingue.id = metadati.id_lingua
    ORDER BY __label__
;
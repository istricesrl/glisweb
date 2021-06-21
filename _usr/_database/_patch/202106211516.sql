CREATE OR REPLACE VIEW `matricole_view` AS
    SELECT
    matricole.*,
    concat( lpad(matricole.id, 11, '0'), ' ', matricole.nome )	AS __label__
    FROM matricole
    ORDER BY __label__
;
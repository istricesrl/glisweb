CREATE OR REPLACE VIEW `matricole_view` AS
    SELECT
    matricole.*,
    concat( 'MAT.',lpad(matricole.id, 15, '0') ) AS __label__
    FROM matricole
    ORDER BY __label__
;
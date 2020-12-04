CREATE OR REPLACE VIEW `anagrafica_provenienze_view` AS
    SELECT
    anagrafica_provenienze.*,
    anagrafica_provenienze.id AS __label__
    FROM anagrafica_provenienze
    ORDER BY __label__
;
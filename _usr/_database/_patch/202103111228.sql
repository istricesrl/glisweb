CREATE OR REPLACE VIEW `risorse_anagrafica_view` AS
    SELECT
    risorse_anagrafica.*,
    risorse_anagrafica.id AS __label__
    FROM risorse_anagrafica
    ORDER BY __label__
;
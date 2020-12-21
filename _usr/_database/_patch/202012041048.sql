CREATE OR REPLACE VIEW `anagrafica_servizi_contatto_view` AS
    SELECT
    anagrafica_servizi_contatto.*,
    anagrafica_servizi_contatto.id AS __label__
    FROM anagrafica_servizi_contatto
    ORDER BY __label__
;

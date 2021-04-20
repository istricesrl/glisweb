CREATE OR REPLACE VIEW `obiettivi_anagrafica_view` AS
    SELECT
    obiettivi_anagrafica.*,
    obiettivi_anagrafica.id AS __label__
    FROM obiettivi_anagrafica
;
CREATE OR REPLACE VIEW `pubblicazione_view` AS
    SELECT
    pubblicazione.*,
    pubblicazione.id AS __label__
    FROM pubblicazione
    ORDER BY __label__
;
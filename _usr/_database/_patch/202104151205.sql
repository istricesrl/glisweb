CREATE OR REPLACE VIEW `codici_tracking_view` AS
    SELECT
    codici_tracking.*,
    codici_tracking.nome AS __label__
    FROM codici_tracking
    ORDER BY __label__
;
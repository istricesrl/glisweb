CREATE OR REPLACE VIEW `obiettivi_tracking_view` AS
    SELECT
    obiettivi_tracking.*,
    obiettivi_tracking.id AS __label__
    FROM obiettivi_tracking
;
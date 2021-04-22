CREATE OR REPLACE VIEW `strategie_view` AS
    SELECT
    strategie.*,
    strategie.nome AS __label__
    FROM strategie
    ORDER BY __label__
;

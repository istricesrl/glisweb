CREATE OR REPLACE VIEW `fasi_strategie_view` AS
    SELECT
    fasi_strategie.*,
    strategie.nome AS strategia,
    fasi_strategie.nome AS __label__
    FROM fasi_strategie
    LEFT JOIN strategie ON strategie.id = fasi_strategie.id_strategia
    ORDER BY __label__
;
CREATE OR REPLACE VIEW `obiettivi_view` AS
    SELECT
    obiettivi.*,
    fasi_strategie.nome AS fase,
    obiettivi.nome AS __label__
    FROM obiettivi
    LEFT JOIN fasi_strategie ON fasi_strategie.id = obiettivi.id_fase_strategia 
    ORDER BY __label__
;
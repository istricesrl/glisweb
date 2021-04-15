CREATE OR REPLACE VIEW `obiettivi_tipologie_attivita_view` AS
    SELECT
    obiettivi_tipologie_attivita.*,
    obiettivi_tipologie_attivita.id AS __label__
    FROM obiettivi_tipologie_attivita
;
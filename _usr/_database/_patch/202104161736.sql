CREATE OR REPLACE VIEW `obiettivi_tipologie_progetti_view` AS
    SELECT
    obiettivi_tipologie_progetti.*,
    obiettivi_tipologie_progetti.id AS __label__
    FROM obiettivi_tipologie_progetti
;
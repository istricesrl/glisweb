CREATE OR REPLACE VIEW `pause_progetti_view` AS
SELECT pause_progetti.*, progetti.nome as progetto, pause_progetti.id AS __label__
FROM pause_progetti LEFT JOIN progetti ON pause_progetti.id_progetto = progetti.id
ORDER BY __label__;
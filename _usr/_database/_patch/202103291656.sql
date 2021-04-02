CREATE OR REPLACE VIEW `listini_gruppi_view` AS
    SELECT
    listini_gruppi.*,
    listini_gruppi.id AS __label__
    FROM
    listini_gruppi
;
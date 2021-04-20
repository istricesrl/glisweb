CREATE OR REPLACE VIEW `file_view` AS
    SELECT
    file.*,
    file.path AS __label__
    FROM file
    ORDER BY __label__
;

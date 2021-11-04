ALTER TABLE `ruoli_file` ADD `se_mail` INT(1) NULL DEFAULT NULL ;

DROP TABLE IF EXISTS `ruoli_file_view`;
CREATE OR REPLACE VIEW ruoli_file_view AS
    SELECT
	ruoli_file.*,
	ruoli_file.nome AS __label__
    FROM ruoli_file
    ORDER BY __label__
;

DELIMITER $$
CREATE
    DEFINER = CURRENT_USER()
    FUNCTION `mastri_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
    NOT DETERMINISTIC
    READS SQL DATA
    SQL SECURITY DEFINER
    BEGIN

	DECLARE path char( 255 ) DEFAULT '';
	DECLARE step char( 255 ) DEFAULT '';
	DECLARE separatore varchar( 8 ) DEFAULT ' > ';
	DECLARE righe int( 11 ) DEFAULT 0;

	WHILE ( p1 IS NOT NULL ) DO

	    SELECT
		mastri.id_genitore,
		mastri.nome,
		count( mastri.id )
	    FROM mastri
	    WHERE mastri.id = p1
	    INTO p1, step, righe;

	    IF( p1 IS NULL ) THEN
		SET separatore = '';
	    END IF;

	    SET path = concat( separatore, step, path );

	END WHILE;

	RETURN path;

END$$
DELIMITER ;
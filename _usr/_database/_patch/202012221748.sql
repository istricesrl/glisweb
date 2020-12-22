DELIMITER $$
CREATE
    DEFINER = CURRENT_USER()
    FUNCTION `ruoli_anagrafica_path`( `p1` INT( 11 ) ) RETURNS CHAR( 255 ) CHARSET utf8 COLLATE utf8_general_ci
    NOT DETERMINISTIC
    READS SQL DATA
    SQL SECURITY DEFINER
    BEGIN

	-- PARAMETRI
	-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole ottenere il path

	-- DIPENDENZE
	-- nessuna

	-- TEST
	-- SELECT ruoli_anagrafica_path( <id> ) AS path

	DECLARE path char( 255 ) DEFAULT '';
	DECLARE step char( 255 ) DEFAULT '';
	DECLARE separatore varchar( 8 ) DEFAULT ' > ';
	DECLARE righe int( 11 ) DEFAULT 0;

	WHILE ( p1 IS NOT NULL ) DO

	    SELECT
		ruoli_anagrafica.id_genitore,
		ruoli_anagrafica.nome,
		count( ruoli_anagrafica.id )
	    FROM ruoli_anagrafica
	    WHERE ruoli_anagrafica.id = p1
	    INTO p1, step, righe;

	    IF( p1 IS NULL ) THEN
		SET separatore = '';
	    END IF;

	    SET path = concat( separatore, step, path );

	END WHILE;

	RETURN path;

END$$
DELIMITER ;
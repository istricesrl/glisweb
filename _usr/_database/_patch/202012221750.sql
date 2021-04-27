DELIMITER $$
CREATE
    DEFINER = CURRENT_USER()
    FUNCTION `ruoli_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS TINYINT( 1 )
    NOT DETERMINISTIC
    READS SQL DATA
    SQL SECURITY DEFINER
    BEGIN

	-- PARAMETRI
	-- p1 int( 11 ) -> l'id dell'oggetto per il quale si vuole verificare il path
	-- p2 int( 11 ) -> l'id dell'oggetto da cercare nel path

	-- DIPENDENZE
	-- nessuna

	-- TEST
	-- SELECT ruoli_anagrafica_path_check( <id1>, <id2> ) AS check

	WHILE ( p1 IS NOT NULL ) DO

	    IF( p1 = p2 ) THEN
		RETURN 1;
	    END IF;

	    SELECT
		ruoli_anagrafica.id_genitore
	    FROM ruoli_anagrafica
	    WHERE ruoli_anagrafica.id = p1
	    INTO p1;

	END WHILE;

	RETURN 0;

END$$
DELIMITER ;
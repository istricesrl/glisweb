
DELIMITER ;;

DROP FUNCTION IF EXISTS `categorie_anagrafica_path`;;
CREATE FUNCTION `categorie_anagrafica_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_anagrafica.id_genitore,
				categorie_anagrafica.nome
			FROM categorie_anagrafica
			WHERE categorie_anagrafica.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `categorie_anagrafica_path_check`;;
CREATE FUNCTION `categorie_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_anagrafica.id_genitore
			FROM categorie_anagrafica
			WHERE categorie_anagrafica.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `categorie_anagrafica_path_find_ancestor`;;
CREATE FUNCTION `categorie_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_anagrafica.id_genitore,
				categorie_anagrafica.id
			FROM categorie_anagrafica
			WHERE categorie_anagrafica.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `categorie_notizie_path`;;
CREATE FUNCTION `categorie_notizie_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_notizie.id_genitore,
				categorie_notizie.nome
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `categorie_notizie_path_check`;;
CREATE FUNCTION `categorie_notizie_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_notizie.id_genitore
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `categorie_notizie_path_find_ancestor`;;
CREATE FUNCTION `categorie_notizie_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_notizie.id_genitore,
				categorie_notizie.id
			FROM categorie_notizie
			WHERE categorie_notizie.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `categorie_prodotti_path`;;
CREATE FUNCTION `categorie_prodotti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_prodotti.id_genitore,
				categorie_prodotti.nome
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `categorie_prodotti_path_check`;;
CREATE FUNCTION `categorie_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_prodotti.id_genitore
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `categorie_prodotti_path_find_ancestor`;;
CREATE FUNCTION `categorie_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_prodotti.id_genitore,
				categorie_prodotti.id
			FROM categorie_prodotti
			WHERE categorie_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `categorie_progetti_path`;;
CREATE FUNCTION `categorie_progetti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_progetti.id_genitore,
				categorie_progetti.nome
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `categorie_progetti_path_check`;;
CREATE FUNCTION `categorie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_progetti.id_genitore
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `categorie_progetti_path_find_ancestor`;;
CREATE FUNCTION `categorie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_progetti.id_genitore,
				categorie_progetti.id
			FROM categorie_progetti
			WHERE categorie_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `categorie_risorse_path`;;
CREATE FUNCTION `categorie_risorse_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.nome
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `categorie_risorse_path_check`;;
CREATE FUNCTION `categorie_risorse_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				categorie_risorse.id_genitore
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `categorie_risorse_path_find_ancestor`;;
CREATE FUNCTION `categorie_risorse_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				categorie_risorse.id_genitore,
				categorie_risorse.id
			FROM categorie_risorse
			WHERE categorie_risorse.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `colori_path`;;
CREATE FUNCTION `colori_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.nome
			FROM colori
			WHERE colori.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `colori_path_check`;;
CREATE FUNCTION `colori_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				colori.id_genitore
			FROM colori
			WHERE colori.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `colori_path_find_ancestor`;;
CREATE FUNCTION `colori_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				colori.id_genitore,
				colori.id
			FROM colori
			WHERE colori.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `gruppi_path`;;
CREATE FUNCTION `gruppi_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				gruppi.id_genitore,
				gruppi.nome
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `gruppi_path_check`;;
CREATE FUNCTION `gruppi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				gruppi.id_genitore
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `gruppi_path_find_ancestor`;;
CREATE FUNCTION `gruppi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				gruppi.id_genitore,
				gruppi.id
			FROM gruppi
			WHERE gruppi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `luoghi_path`;;
CREATE FUNCTION `luoghi_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				luoghi.id_genitore,
				luoghi.nome
			FROM luoghi
			WHERE luoghi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `luoghi_path_check`;;
CREATE FUNCTION `luoghi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				luoghi.id_genitore
			FROM luoghi
			WHERE luoghi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `luoghi_path_find_ancestor`;;
CREATE FUNCTION `luoghi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				luoghi.id_genitore,
				luoghi.id
			FROM luoghi
			WHERE luoghi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `mastri_path`;;
CREATE FUNCTION `mastri_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				mastri.id_genitore,
				mastri.nome
			FROM mastri
			WHERE mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `mastri_path_check`;;
CREATE FUNCTION `mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				mastri.id_genitore
			FROM mastri
			WHERE mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `mastri_path_find_ancestor`;;
CREATE FUNCTION `mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				mastri.id_genitore,
				mastri.id
			FROM mastri
			WHERE mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `organizzazioni_path`;;
CREATE FUNCTION `organizzazioni_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				organizzazioni.id_genitore,
				coalesce(
					anagrafica.soprannome,
					anagrafica.denominazione,
					concat( anagrafica.cognome, ' ', anagrafica.nome ),
					'' )
			FROM organizzazioni
			LEFT JOIN anagrafica ON anagrafica.id = organizzazioni.id_anagrafica
			WHERE organizzazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `organizzazioni_path_check`;;
CREATE FUNCTION `organizzazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				organizzazioni.id_genitore
			FROM organizzazioni
			WHERE organizzazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `organizzazioni_path_find_ancestor`;;
CREATE FUNCTION `organizzazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				organizzazioni.id_genitore,
				organizzazioni.id
			FROM organizzazioni
			WHERE organizzazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `pagine_path`;;
CREATE FUNCTION `pagine_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pagine.id_genitore,
				pagine.nome
			FROM pagine
			WHERE pagine.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `pagine_path_check`;;
CREATE FUNCTION `pagine_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				pagine.id_genitore
			FROM pagine
			WHERE pagine.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `pagine_path_find_ancestor`;;
CREATE FUNCTION `pagine_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				pagine.id_genitore,
				pagine.id
			FROM pagine
			WHERE pagine.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_anagrafica_path`;;
CREATE FUNCTION `ruoli_anagrafica_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_anagrafica.id_genitore,
				ruoli_anagrafica.nome
			FROM ruoli_anagrafica
			WHERE ruoli_anagrafica.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_anagrafica_path_check`;;
CREATE FUNCTION `ruoli_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




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

END;;


DROP FUNCTION IF EXISTS `ruoli_anagrafica_path_find_ancestor`;;
CREATE FUNCTION `ruoli_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_anagrafica.id_genitore,
				ruoli_anagrafica.id
			FROM ruoli_anagrafica
			WHERE ruoli_anagrafica.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_audio_path`;;
CREATE FUNCTION `ruoli_audio_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_audio.id_genitore,
				ruoli_audio.nome
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_audio_path_check`;;
CREATE FUNCTION `ruoli_audio_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_audio.id_genitore
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `ruoli_audio_path_find_ancestor`;;
CREATE FUNCTION `ruoli_audio_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_audio.id_genitore,
				ruoli_audio.id
			FROM ruoli_audio
			WHERE ruoli_audio.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_file_path`;;
CREATE FUNCTION `ruoli_file_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_file.id_genitore,
				ruoli_file.nome
			FROM ruoli_file
			WHERE ruoli_file.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_file_path_check`;;
CREATE FUNCTION `ruoli_file_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_file.id_genitore
			FROM ruoli_file
			WHERE ruoli_file.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `ruoli_file_path_find_ancestor`;;
CREATE FUNCTION `ruoli_file_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_file.id_genitore,
				ruoli_file.id
			FROM ruoli_file
			WHERE ruoli_file.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_immagini_path`;;
CREATE FUNCTION `ruoli_immagini_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_immagini.id_genitore,
				ruoli_immagini.nome
			FROM ruoli_immagini
			WHERE ruoli_immagini.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_immagini_path_check`;;
CREATE FUNCTION `ruoli_immagini_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_immagini.id_genitore
			FROM ruoli_immagini
			WHERE ruoli_immagini.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `ruoli_immagini_path_find_ancestor`;;
CREATE FUNCTION `ruoli_immagini_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_immagini.id_genitore,
				ruoli_immagini.id
			FROM ruoli_immagini
			WHERE ruoli_immagini.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_indirizzi_path`;;
CREATE FUNCTION `ruoli_indirizzi_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_indirizzi.id_genitore,
				ruoli_indirizzi.nome
			FROM ruoli_indirizzi
			WHERE ruoli_indirizzi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_indirizzi_path_check`;;
CREATE FUNCTION `ruoli_indirizzi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_indirizzi.id_genitore
			FROM ruoli_indirizzi
			WHERE ruoli_indirizzi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `ruoli_indirizzi_path_find_ancestor`;;
CREATE FUNCTION `ruoli_indirizzi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_indirizzi.id_genitore,
				ruoli_indirizzi.id
			FROM ruoli_indirizzi
			WHERE ruoli_indirizzi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_prodotti_path`;;
CREATE FUNCTION `ruoli_prodotti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_prodotti.id_genitore,
				ruoli_prodotti.nome
			FROM ruoli_prodotti
			WHERE ruoli_prodotti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_prodotti_path_check`;;
CREATE FUNCTION `ruoli_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_prodotti.id_genitore
			FROM ruoli_prodotti
			WHERE ruoli_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `ruoli_prodotti_path_find_ancestor`;;
CREATE FUNCTION `ruoli_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_prodotti.id_genitore,
				ruoli_prodotti.id
			FROM ruoli_prodotti
			WHERE ruoli_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `ruoli_video_path`;;
CREATE FUNCTION `ruoli_video_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_video.id_genitore,
				ruoli_video.nome
			FROM ruoli_video
			WHERE ruoli_video.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `ruoli_video_path_check`;;
CREATE FUNCTION `ruoli_video_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				ruoli_video.id_genitore
			FROM ruoli_video
			WHERE ruoli_video.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `ruoli_video_path_find_ancestor`;;
CREATE FUNCTION `ruoli_video_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				ruoli_video.id_genitore,
				ruoli_video.id
			FROM ruoli_video
			WHERE ruoli_video.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `settori_path`;;
CREATE FUNCTION `settori_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				settori.id_genitore,
				concat( settori.ateco, ' ', settori.nome )
			FROM settori
			WHERE settori.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `settori_path_check`;;
CREATE FUNCTION `settori_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				settori.id_genitore
			FROM settori
			WHERE settori.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `settori_path_find_ancestor`;;
CREATE FUNCTION `settori_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				settori.id_genitore,
				settori.id
			FROM settori
			WHERE settori.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `software_path`;;
CREATE FUNCTION `software_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				software.id_genitore,
				software.nome
			FROM software
			WHERE software.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `software_path_check`;;
CREATE FUNCTION `software_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				software.id_genitore
			FROM software
			WHERE software.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `software_path_find_ancestor`;;
CREATE FUNCTION `software_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				software.id_genitore,
				software.id
			FROM software
			WHERE software.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_anagrafica_path`;;
CREATE FUNCTION `tipologie_anagrafica_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_anagrafica.id_genitore,
				tipologie_anagrafica.nome
			FROM tipologie_anagrafica
			WHERE tipologie_anagrafica.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_check`;;
CREATE FUNCTION `tipologie_anagrafica_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_anagrafica.id_genitore
			FROM tipologie_anagrafica
			WHERE tipologie_anagrafica.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_anagrafica_path_find_ancestor`;;
CREATE FUNCTION `tipologie_anagrafica_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_anagrafica.id_genitore,
				tipologie_anagrafica.id
			FROM tipologie_anagrafica
			WHERE tipologie_anagrafica.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_attivita_path`;;
CREATE FUNCTION `tipologie_attivita_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_attivita.id_genitore,
				tipologie_attivita.nome
			FROM tipologie_attivita
			WHERE tipologie_attivita.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_attivita_path_check`;;
CREATE FUNCTION `tipologie_attivita_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_attivita.id_genitore
			FROM tipologie_attivita
			WHERE tipologie_attivita.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_attivita_path_find_ancestor`;;
CREATE FUNCTION `tipologie_attivita_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_attivita.id_genitore,
				tipologie_attivita.id
			FROM tipologie_attivita
			WHERE tipologie_attivita.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_chiavi_path`;;
CREATE FUNCTION `tipologie_chiavi_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_chiavi.id_genitore,
				tipologie_chiavi.nome
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_chiavi_path_check`;;
CREATE FUNCTION `tipologie_chiavi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_chiavi.id_genitore
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_chiavi_path_find_ancestor`;;
CREATE FUNCTION `tipologie_chiavi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_chiavi.id_genitore,
				tipologie_chiavi.id
			FROM tipologie_chiavi
			WHERE tipologie_chiavi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_contatti_path`;;
CREATE FUNCTION `tipologie_contatti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_contatti.id_genitore,
				tipologie_contatti.nome
			FROM tipologie_contatti
			WHERE tipologie_contatti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_contatti_path_check`;;
CREATE FUNCTION `tipologie_contatti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_contatti.id_genitore
			FROM tipologie_contatti
			WHERE tipologie_contatti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_contatti_path_find_ancestor`;;
CREATE FUNCTION `tipologie_contatti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_contatti.id_genitore,
				tipologie_contatti.id
			FROM tipologie_contatti
			WHERE tipologie_contatti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;


DROP FUNCTION IF EXISTS `tipologie_documenti_path`;;
CREATE FUNCTION `tipologie_documenti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti.id_genitore,
				tipologie_documenti.nome
			FROM tipologie_documenti
			WHERE tipologie_documenti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_documenti_path_check`;;
CREATE FUNCTION `tipologie_documenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_documenti.id_genitore
			FROM tipologie_documenti
			WHERE tipologie_documenti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_documenti_path_find_ancestor`;;
CREATE FUNCTION `tipologie_documenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_documenti.id_genitore,
				tipologie_documenti.id
			FROM tipologie_documenti
			WHERE tipologie_documenti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_indirizzi_path`;;
CREATE FUNCTION `tipologie_indirizzi_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_indirizzi.id_genitore,
				tipologie_indirizzi.nome
			FROM tipologie_indirizzi
			WHERE tipologie_indirizzi.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_indirizzi_path_check`;;
CREATE FUNCTION `tipologie_indirizzi_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_indirizzi.id_genitore
			FROM tipologie_indirizzi
			WHERE tipologie_indirizzi.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_indirizzi_path_find_ancestor`;;
CREATE FUNCTION `tipologie_indirizzi_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_indirizzi.id_genitore,
				tipologie_indirizzi.id
			FROM tipologie_indirizzi
			WHERE tipologie_indirizzi.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_licenze_path`;;
CREATE FUNCTION `tipologie_licenze_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_licenze.id_genitore,
				tipologie_licenze.nome
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_licenze_path_check`;;
CREATE FUNCTION `tipologie_licenze_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_licenze.id_genitore
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_licenze_path_find_ancestor`;;
CREATE FUNCTION `tipologie_licenze_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_licenze.id_genitore,
				tipologie_licenze.id
			FROM tipologie_licenze
			WHERE tipologie_licenze.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_mastri_path`;;
CREATE FUNCTION `tipologie_mastri_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_mastri.id_genitore,
				tipologie_mastri.nome
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_mastri_path_check`;;
CREATE FUNCTION `tipologie_mastri_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_mastri.id_genitore
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_mastri_path_find_ancestor`;;
CREATE FUNCTION `tipologie_mastri_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_mastri.id_genitore,
				tipologie_mastri.id
			FROM tipologie_mastri
			WHERE tipologie_mastri.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_notizie_path`;;
CREATE FUNCTION `tipologie_notizie_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_notizie.id_genitore,
				tipologie_notizie.nome
			FROM tipologie_notizie
			WHERE tipologie_notizie.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_notizie_path_check`;;
CREATE FUNCTION `tipologie_notizie_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_notizie.id_genitore
			FROM tipologie_notizie
			WHERE tipologie_notizie.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_notizie_path_find_ancestor`;;
CREATE FUNCTION `tipologie_notizie_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_notizie.id_genitore,
				tipologie_notizie.id
			FROM tipologie_notizie
			WHERE tipologie_notizie.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_pagamenti_path`;;
CREATE FUNCTION `tipologie_pagamenti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pagamenti.id_genitore,
				tipologie_pagamenti.nome
			FROM tipologie_pagamenti
			WHERE tipologie_pagamenti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_pagamenti_path_check`;;
CREATE FUNCTION `tipologie_pagamenti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_pagamenti.id_genitore
			FROM tipologie_pagamenti
			WHERE tipologie_pagamenti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_pagamenti_path_find_ancestor`;;
CREATE FUNCTION `tipologie_pagamenti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pagamenti.id_genitore,
				tipologie_pagamenti.id
			FROM tipologie_pagamenti
			WHERE tipologie_pagamenti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_popup_path`;;
CREATE FUNCTION `tipologie_popup_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_popup.id_genitore,
				tipologie_popup.nome
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_popup_path_check`;;
CREATE FUNCTION `tipologie_popup_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_popup.id_genitore
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_popup_path_find_ancestor`;;
CREATE FUNCTION `tipologie_popup_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_popup.id_genitore,
				tipologie_popup.id
			FROM tipologie_popup
			WHERE tipologie_popup.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_prodotti_path`;;
CREATE FUNCTION `tipologie_prodotti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_prodotti.id_genitore,
				tipologie_prodotti.nome
			FROM tipologie_prodotti
			WHERE tipologie_prodotti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_prodotti_path_check`;;
CREATE FUNCTION `tipologie_prodotti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_prodotti.id_genitore
			FROM tipologie_prodotti
			WHERE tipologie_prodotti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_prodotti_path_find_ancestor`;;
CREATE FUNCTION `tipologie_prodotti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_prodotti.id_genitore,
				tipologie_prodotti.id
			FROM tipologie_prodotti
			WHERE tipologie_prodotti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_progetti_path`;;
CREATE FUNCTION `tipologie_progetti_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_progetti.id_genitore,
				tipologie_progetti.nome
			FROM tipologie_progetti
			WHERE tipologie_progetti.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_progetti_path_check`;;
CREATE FUNCTION `tipologie_progetti_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_progetti.id_genitore
			FROM tipologie_progetti
			WHERE tipologie_progetti.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_progetti_path_find_ancestor`;;
CREATE FUNCTION `tipologie_progetti_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_progetti.id_genitore,
				tipologie_progetti.id
			FROM tipologie_progetti
			WHERE tipologie_progetti.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path`;;
CREATE FUNCTION `tipologie_pubblicazioni_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pubblicazioni.id_genitore,
				tipologie_pubblicazioni.nome
			FROM tipologie_pubblicazioni
			WHERE tipologie_pubblicazioni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path_check`;;
CREATE FUNCTION `tipologie_pubblicazioni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_pubblicazioni.id_genitore
			FROM tipologie_pubblicazioni
			WHERE tipologie_pubblicazioni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_pubblicazioni_path_find_ancestor`;;
CREATE FUNCTION `tipologie_pubblicazioni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_pubblicazioni.id_genitore,
				tipologie_pubblicazioni.id
			FROM tipologie_pubblicazioni
			WHERE tipologie_pubblicazioni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_risorse_path`;;
CREATE FUNCTION `tipologie_risorse_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_risorse.id_genitore,
				tipologie_risorse.nome
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_risorse_path_check`;;
CREATE FUNCTION `tipologie_risorse_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_risorse.id_genitore
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_risorse_path_find_ancestor`;;
CREATE FUNCTION `tipologie_risorse_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_risorse.id_genitore,
				tipologie_risorse.id
			FROM tipologie_risorse
			WHERE tipologie_risorse.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_telefoni_path`;;
CREATE FUNCTION `tipologie_telefoni_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_telefoni.id_genitore,
				tipologie_telefoni.nome
			FROM tipologie_telefoni
			WHERE tipologie_telefoni.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_telefoni_path_check`;;
CREATE FUNCTION `tipologie_telefoni_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_telefoni.id_genitore
			FROM tipologie_telefoni
			WHERE tipologie_telefoni.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_telefoni_path_find_ancestor`;;
CREATE FUNCTION `tipologie_telefoni_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_telefoni.id_genitore,
				tipologie_telefoni.id
			FROM tipologie_telefoni
			WHERE tipologie_telefoni.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_todo_path`;;
CREATE FUNCTION `tipologie_todo_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_todo.id_genitore,
				tipologie_todo.nome
			FROM tipologie_todo
			WHERE tipologie_todo.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_todo_path_check`;;
CREATE FUNCTION `tipologie_todo_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_todo.id_genitore
			FROM tipologie_todo
			WHERE tipologie_todo.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_todo_path_find_ancestor`;;
CREATE FUNCTION `tipologie_todo_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_todo.id_genitore,
				tipologie_todo.id
			FROM tipologie_todo
			WHERE tipologie_todo.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP FUNCTION IF EXISTS `tipologie_url_path`;;
CREATE FUNCTION `tipologie_url_path`( `p1` INT( 11 ) ) RETURNS text CHARSET utf8mb3
    READS SQL DATA
BEGIN




		DECLARE path text DEFAULT '';
		DECLARE step char( 255 ) DEFAULT '';
		DECLARE separatore varchar( 8 ) DEFAULT ' > ';

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_url.id_genitore,
				tipologie_url.nome
			FROM tipologie_url
			WHERE tipologie_url.id = p1
			INTO p1, step;

			IF( p1 IS NULL ) THEN
				SET separatore = '';
			END IF;

			SET path = concat( separatore, step, path );

		END WHILE;

		RETURN path;

END;;

DROP FUNCTION IF EXISTS `tipologie_url_path_check`;;
CREATE FUNCTION `tipologie_url_path_check`( `p1` INT( 11 ), `p2` INT( 11 ) ) RETURNS tinyint(1)
    READS SQL DATA
BEGIN




		WHILE ( p1 IS NOT NULL ) DO

			IF( p1 = p2 ) THEN
				RETURN 1;
			END IF;

			SELECT
				tipologie_url.id_genitore
			FROM tipologie_url
			WHERE tipologie_url.id = p1
			INTO p1;

		END WHILE;

		RETURN 0;

END;;

DROP FUNCTION IF EXISTS `tipologie_url_path_find_ancestor`;;
CREATE FUNCTION `tipologie_url_path_find_ancestor`( `p1` INT( 11 ) ) RETURNS int
    READS SQL DATA
BEGIN




		DECLARE p2 int( 11 ) DEFAULT NULL;

		WHILE ( p1 IS NOT NULL ) DO

			SELECT
				tipologie_url.id_genitore,
				tipologie_url.id
			FROM tipologie_url
			WHERE tipologie_url.id = p1
			INTO p1, p2;

		END WHILE;

		RETURN p2;

END;;

DROP PROCEDURE IF EXISTS `anagrafica_view_static`;;
CREATE PROCEDURE `anagrafica_view_static`( IN `i` INT(11) )
BEGIN


            IF i IS NULL THEN

                DELETE FROM anagrafica_view_static;
                
                REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view;

            ELSE
            
                DELETE FROM anagrafica_view_static WHERE anagrafica_view_static.id = i;

                INSERT INTO anagrafica_view_static SELECT * FROM anagrafica_view WHERE anagrafica_view.id = i;
            
            END IF;


    END;;

DELIMITER ;


CREATE TABLE `__acl_anagrafica__` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_entita` int NOT NULL,
  `id_gruppo` int NOT NULL,
  `id_account` int DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_anagrafica___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_anagrafica___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `__acl_attivita__` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_entita` int NOT NULL,
  `id_gruppo` int NOT NULL,
  `id_account` int DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_attivita___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_attivita___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `__acl_pagine__` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_entita` int NOT NULL,
  `id_gruppo` int NOT NULL,
  `id_account` int DEFAULT NULL,
  `permesso` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_entita`,`id_gruppo`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_entita` (`id_entita`),
  KEY `id_account` (`id_account`),
  CONSTRAINT `__acl_pagine___ibfk_01_nofollow` FOREIGN KEY (`id_entita`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_pagine___ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `__acl_pagine___ibfk_03_nofollow` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



CREATE TABLE `account` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int DEFAULT NULL,
  `id_mail` int DEFAULT NULL,
  `username` char(64) NOT NULL,
  `password` char(128) DEFAULT NULL,
  `se_attivo` int DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_login` int DEFAULT NULL,
  `timestamp_cambio_password` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`username`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_mail` (`id_mail`),
  KEY `se_attivo` (`se_attivo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`username`,`id_mail`,`password`,`se_attivo`,`token`),
  KEY `indice_token` (`id`,`token`),
  CONSTRAINT `account_ibfk_01_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_ibfk_02_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `account_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `account_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `account_gruppi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_account` int NOT NULL,
  `id_gruppo` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `se_amministratore` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_account`,`id_gruppo`),
  KEY `id_account` (`id_account`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_account`,`id_gruppo`,`ordine`),
  CONSTRAINT `account_gruppi_ibfk_01` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `account_gruppi_attribuzione` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_account` int NOT NULL,
  `id_gruppo` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `entita` char(64) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_account`,`id_gruppo`,`entita`),
  KEY `id_account` (`id_account`),
  KEY `id_gruppo` (`id_gruppo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_account`,`id_gruppo`,`ordine`,`entita`),
  CONSTRAINT `account_gruppi_attribuzione_ibfk_01` FOREIGN KEY (`id_account`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_attribuzione_ibfk_02_nofollow` FOREIGN KEY (`id_gruppo`) REFERENCES `gruppi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_attribuzione_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `account_gruppi_attribuzione_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `account_gruppi_attribuzione_view` (`id` int, `id_account` int, `id_gruppo` int, `ordine` int, `entita` char(64), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(166));


CREATE TABLE `account_gruppi_view` (`id` int, `id_account` int, `account` char(64), `id_gruppo` int, `gruppo` char(32), `ordine` int, `se_amministratore` tinyint(1), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(99));


CREATE TABLE `account_view` (`id` int, `id_anagrafica` int, `anagrafica` varchar(320), `id_mail` int, `mail` char(128), `username` char(64), `password` char(128), `se_attivo` int, `token` char(128), `timestamp_login` int, `timestamp_cambio_password` int, `gruppi` text, `id_gruppi` text, `id_gruppi_attribuzione` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(64));


CREATE TABLE `anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` enum('M','F','-') NOT NULL DEFAULT '-',
  `stato_civile` char(128) DEFAULT NULL,
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `codice_sdi` char(32) DEFAULT NULL,
  `id_pec_sdi` int DEFAULT NULL,
  `id_regime` int DEFAULT NULL,
  `note_amministrative` text,
  `luogo_nascita` char(128) DEFAULT NULL,
  `stato_nascita` char(128) DEFAULT NULL,
  `id_stato_nascita` int DEFAULT NULL,
  `comune_nascita` char(128) DEFAULT NULL,
  `id_comune_nascita` int DEFAULT NULL,
  `giorno_nascita` int DEFAULT NULL,
  `mese_nascita` int DEFAULT NULL,
  `anno_nascita` int DEFAULT NULL,
  `id_ranking` int DEFAULT NULL,
  `id_agente` int DEFAULT NULL,
  `id_responsabile_operativo` int DEFAULT NULL,
  `note_commerciali` text,
  `condizioni_vendita` text,
  `condizioni_acquisto` text,
  `note` text,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text,
  `recapiti` text,
  `se_importata` int DEFAULT NULL,
  `se_stampa_privacy` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`codice`),
  UNIQUE KEY `unica_persone` (`nome`,`cognome`,`codice_fiscale`),
  UNIQUE KEY `unica_aziende` (`denominazione`,`partita_iva`,`codice_fiscale`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pec_sdi` (`id_pec_sdi`),
  KEY `id_regime` (`id_regime`),
  KEY `id_stato_nascita` (`id_stato_nascita`),
  KEY `id_comune_nascita` (`id_comune_nascita`),
  KEY `id_ranking` (`id_ranking`),
  KEY `id_agente` (`id_agente`),
  KEY `id_responsabile_operativo` (`id_responsabile_operativo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `se_importata` (`se_importata`),
  KEY `se_stampa_privacy` (`se_stampa_privacy`),
  KEY `data_archiviazione` (`data_archiviazione`),
  KEY `indice` (`id`,`codice`,`nome`,`cognome`,`id_tipologia`,`denominazione`,`se_stampa_privacy`,`codice_fiscale`,`partita_iva`),
  KEY `indice_riferimento` (`id`,`riferimento`),
  KEY `indice_archiviazione` (`id`,`data_archiviazione`),
  CONSTRAINT `anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_anagrafica` (`id`),
  CONSTRAINT `anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_pec_sdi`) REFERENCES `mail` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_regime`) REFERENCES `regimi` (`id`),
  CONSTRAINT `anagrafica_ibfk_04_nofollow` FOREIGN KEY (`id_stato_nascita`) REFERENCES `stati` (`id`),
  CONSTRAINT `anagrafica_ibfk_05_nofollow` FOREIGN KEY (`id_comune_nascita`) REFERENCES `comuni` (`id`),
  CONSTRAINT `anagrafica_ibfk_06_nofollow` FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`),
  CONSTRAINT `anagrafica_ibfk_07_nofollow` FOREIGN KEY (`id_agente`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_08_nofollow` FOREIGN KEY (`id_responsabile_operativo`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `anagrafica_archiviati_view` (`id` int, `tipologia` char(64), `codice` char(32), `riferimento` char(32), `nome` char(64), `cognome` char(255), `denominazione` char(255), `soprannome` char(128), `sesso` enum('M','F','-'), `codice_fiscale` char(32), `partita_iva` char(32), `ranking` varchar(254), `recapiti` text, `se_prospect` int, `se_lead` int, `se_cliente` int, `se_fornitore` int, `se_produttore` int, `se_collaboratore` int, `se_interno` int, `se_esterno` int, `se_agente` int, `se_concorrente` int, `se_azienda_gestita` int, `se_amministrazione` int, `se_notizie` int, `categorie` text, `telefoni` text, `mail` text, `data_archiviazione` date, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(320));


CREATE TABLE `anagrafica_attivi_view` (`id` int, `tipologia` char(64), `codice` char(32), `riferimento` char(32), `nome` char(64), `cognome` char(255), `denominazione` char(255), `soprannome` char(128), `sesso` enum('M','F','-'), `codice_fiscale` char(32), `partita_iva` char(32), `ranking` varchar(254), `recapiti` text, `se_prospect` int, `se_lead` int, `se_cliente` int, `se_fornitore` int, `se_produttore` int, `se_collaboratore` int, `se_interno` int, `se_esterno` int, `se_agente` int, `se_concorrente` int, `se_azienda_gestita` int, `se_amministrazione` int, `se_notizie` int, `categorie` text, `telefoni` text, `mail` text, `data_archiviazione` date, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(320));


CREATE TABLE `anagrafica_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_categoria`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_categoria`,`ordine`),
  CONSTRAINT `anagrafica_categorie_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_anagrafica` (`id`),
  CONSTRAINT `anagrafica_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `anagrafica_categorie_view` (`id` int, `id_anagrafica` int, `id_categoria` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `anagrafica_cittadinanze` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `id_stato` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_stato`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_stato` (`id_stato`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_stato`,`ordine`,`data_inizio`,`data_fine`),
  CONSTRAINT `anagrafica_cittadinanze_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_cittadinanze_ibfk_02_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`),
  CONSTRAINT `anagrafica_cittadinanze_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_cittadinanze_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `anagrafica_cittadinanze_view` (`id` int, `id_anagrafica` int, `id_stato` int, `data_inizio` date, `data_fine` date, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(451));


CREATE TABLE `anagrafica_indirizzi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `id_indirizzo` int NOT NULL,
  `id_ruolo` int DEFAULT NULL,
  `interno` char(8) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_indirizzo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_indirizzo`,`id_ruolo`),
  CONSTRAINT `anagrafica_indirizzi_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_indirizzi_ibfk_02_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `anagrafica_indirizzi_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_indirizzi` (`id`),
  CONSTRAINT `anagrafica_indirizzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_indirizzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `anagrafica_indirizzi_view` (`id` int, `id_anagrafica` int, `id_indirizzo` int, `id_ruolo` int, `ruolo` char(32), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `anagrafica_settori` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `id_settore` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`id_settore`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_settore` (`id_settore`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`id_settore`,`ordine`),
  CONSTRAINT `anagrafica_settori_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `anagrafica_settori_ibfk_02_nofollow` FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`),
  CONSTRAINT `anagrafica_settori_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `anagrafica_settori_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `anagrafica_settori_view` (`id` int, `id_anagrafica` int, `id_settore` int, `settore` char(128), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(451));


CREATE TABLE `anagrafica_view` (`id` int, `tipologia` char(64), `codice` char(32), `riferimento` char(32), `nome` char(64), `cognome` char(255), `denominazione` char(255), `soprannome` char(128), `sesso` enum('M','F','-'), `codice_fiscale` char(32), `partita_iva` char(32), `ranking` varchar(254), `recapiti` text, `se_prospect` int, `se_lead` int, `se_cliente` int, `se_fornitore` int, `se_produttore` int, `se_collaboratore` int, `se_interno` int, `se_esterno` int, `se_agente` int, `se_concorrente` int, `se_azienda_gestita` int, `se_amministrazione` int, `se_notizie` int, `categorie` text, `telefoni` text, `mail` text, `data_archiviazione` date, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(320));


CREATE TABLE `anagrafica_view_static` (
  `id` int NOT NULL,
  `tipologia` char(32) DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `riferimento` char(32) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `cognome` char(255) DEFAULT NULL,
  `denominazione` char(255) DEFAULT NULL,
  `soprannome` char(128) DEFAULT NULL,
  `sesso` char(1) NOT NULL DEFAULT '-',
  `codice_fiscale` char(32) DEFAULT NULL,
  `partita_iva` char(32) DEFAULT NULL,
  `ranking` char(128) DEFAULT NULL,
  `recapiti` text,
  `se_prospect` int DEFAULT NULL,
  `se_lead` int DEFAULT NULL,
  `se_cliente` int DEFAULT NULL,
  `se_fornitore` int DEFAULT NULL,
  `se_produttore` int DEFAULT NULL,
  `se_collaboratore` int DEFAULT NULL,
  `se_interno` int DEFAULT NULL,
  `se_esterno` int DEFAULT NULL,
  `se_agente` int DEFAULT NULL,
  `se_concorrente` int DEFAULT NULL,
  `se_azienda_gestita` int DEFAULT NULL,
  `se_amministrazione` int DEFAULT NULL,
  `se_notizie` int DEFAULT NULL,
  `categorie` text,
  `telefoni` text,
  `mail` text,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `__label__` char(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;


CREATE TABLE `articoli` (
  `id` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `ordine` int DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `id_reparto` int DEFAULT NULL,
  `id_taglia` int DEFAULT NULL,
  `id_colore` int DEFAULT NULL,
  `larghezza` int DEFAULT NULL,
  `lunghezza` int DEFAULT NULL,
  `altezza` int DEFAULT NULL,
  `peso` int DEFAULT NULL,
  `volume` int DEFAULT NULL,
  `capacita` int DEFAULT NULL,
  `durata` int DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_reparto` (`id_reparto`),
  KEY `id_taglia` (`id_taglia`),
  KEY `id_colore` (`id_colore`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`ean`,`isbn`,`id_prodotto`,`id_reparto`,`id_taglia`,`id_colore`),
  KEY `indice_dimensioni` (`id`,`ordine`,`ean`,`isbn`,`id_prodotto`,`id_reparto`,`larghezza`,`lunghezza`,`altezza`,`peso`,`volume`,`capacita`),
  CONSTRAINT `articoli_ibfk_01_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articoli_ibfk_02_nofollow` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `articoli_ibfk_03_nofollow` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`),
  CONSTRAINT `articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `articoli_caratteristiche` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_articolo` char(32) NOT NULL,
  `id_caratteristica` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `valore` decimal(5,2) DEFAULT NULL,
  `note` text,
  `se_assente` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_articolo`,`id_caratteristica`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `indice` (`id`,`id_articolo`,`id_caratteristica`,`ordine`,`valore`,`se_assente`),
  CONSTRAINT `articoli_caratteristiche_ibfk_01` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articoli_caratteristiche_ibfk_02_nofollow` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `articoli_caratteristiche_view` (`id` int, `id_articolo` char(32), `id_caratteristica` int, `ordine` int, `valore` decimal(5,2), `se_assente` int, `__label__` varchar(106));


CREATE TABLE `articoli_view` (`id` char(32), `id_prodotto` char(32), `ordine` int, `ean` char(32), `isbn` char(32), `id_reparto` int, `id_taglia` int, `id_colore` int, `larghezza` int, `lunghezza` int, `altezza` int, `peso` int, `volume` int, `capacita` int, `nome` char(128), `__label__` varchar(198));


CREATE TABLE `attivita` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `referenti` char(255) DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `id_luogo` int DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `note_programmazione` text,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `token` char(128) NOT NULL,
  `timestamp_calcolo_sostituti` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_todo` (`id_todo`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`),
  KEY `indice_scadenza` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_scadenza`,`ora_scadenza`),
  KEY `indice_programmazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`),
  KEY `indice_attivita` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`data_attivita`,`ora_inizio`,`ora_fine`),
  KEY `indice_mastri` (`id`,`id_tipologia`,`id_mastro_provenienza`,`id_mastro_destinazione`),
  KEY `indice_sostituti` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_progetto`,`id_todo`,`timestamp_calcolo_sostituti`),
  KEY `indice_token` (`id`,`token`),
  CONSTRAINT `attivita_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_attivita` (`id`),
  CONSTRAINT `attivita_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `attivita_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_05_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_06_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`),
  CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`),
  CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`),
  CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`),
  CONSTRAINT `attivita_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `attivita_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `attivita_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `indirizzo` char(128), `id_luogo` int, `luogo` text, `data_scadenza` date, `ora_scadenza` time, `data_programmazione` date, `ora_inizio_programmazione` time, `ora_fine_programmazione` time, `ore_programmazione` decimal(5,2), `data_attivita` date, `giorno_attivita` int, `mese_attivita` int, `anno_attivita` int, `ora_inizio` time, `latitudine_ora_inizio` decimal(11,7), `longitudine_ora_inizio` decimal(11,7), `ora_fine` time, `latitudine_ora_fine` decimal(11,7), `longitudine_ora_fine` decimal(11,7), `ore` decimal(5,2), `nome` char(255), `id_progetto` char(32), `progetto` char(255), `id_todo` int, `todo` char(255), `id_mastro_provenienza` int, `mastro_provenienza` char(64), `id_mastro_destinazione` int, `mastro_destinazione` char(64), `token` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `audio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lingua` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `id_embed` int DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `nome` char(64) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`path`),
  UNIQUE KEY `unica_codice_embed` (`codice_embed`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_embed` (`id_embed`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_file` (`id_file`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`),
  KEY `indice_anagrafica` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`,`id_anagrafica`),
  KEY `indice_pagine` (`id`,`id_ruolo`,`id_lingua`,`ordine`,`path`,`codice_embed`,`id_embed`,`id_pagina`,`id_file`,`id_risorsa`),
  CONSTRAINT `audio_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `audio_ibfk_02_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_audio` (`id`),
  CONSTRAINT `audio_ibfk_03` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_04` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_05` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_06` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_07` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_08` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_09` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `audio_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `audio_view` (`id` int, `id_lingua` int, `lingua` char(128), `id_ruolo` int, `ruolo` char(64), `ordine` int, `path` char(255), `id_embed` int, `embed` char(64), `codice_embed` char(128), `embed_custom` char(128), `nome` char(64), `target` char(255), `id_anagrafica` int, `id_pagina` int, `id_file` int, `id_risorsa` int, `id_prodotto` char(32), `id_categoria_prodotti` int, `id_notizia` int, `id_categoria_notizie` int, `__label__` varchar(195));


CREATE TABLE `caratteristiche_prodotti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `font_awesome` char(24) DEFAULT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `se_categoria` int DEFAULT NULL,
  `se_prodotto` int DEFAULT NULL,
  `se_articolo` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`se_categoria`,`se_prodotto`,`se_articolo`),
  CONSTRAINT `caratteristiche_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `caratteristiche_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `caratteristiche_prodotti_view` (`id` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(24), `se_categoria` int, `se_prodotto` int, `se_articolo` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(64));


CREATE TABLE `categorie_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `se_lead` int DEFAULT NULL,
  `se_prospect` int DEFAULT NULL,
  `se_cliente` int DEFAULT NULL,
  `se_fornitore` int DEFAULT NULL,
  `se_produttore` int DEFAULT NULL,
  `se_collaboratore` int DEFAULT NULL,
  `se_interno` int DEFAULT NULL,
  `se_esterno` int DEFAULT NULL,
  `se_agente` int DEFAULT NULL,
  `se_concorrente` int DEFAULT NULL,
  `se_azienda_gestita` int DEFAULT NULL,
  `se_amministrazione` int DEFAULT NULL,
  `se_produzione` int DEFAULT NULL,
  `se_notizie` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_lead` (`se_lead`),
  KEY `se_prospect` (`se_prospect`),
  KEY `se_cliente` (`se_cliente`),
  KEY `se_fornitore` (`se_fornitore`),
  KEY `se_produttore` (`se_produttore`),
  KEY `se_collaboratore` (`se_collaboratore`),
  KEY `se_interno` (`se_interno`),
  KEY `se_esterno` (`se_esterno`),
  KEY `se_agente` (`se_agente`),
  KEY `se_concorrente` (`se_concorrente`),
  KEY `se_azienda_gestita` (`se_azienda_gestita`),
  KEY `se_amministrazione` (`se_amministrazione`),
  KEY `se_notizie` (`se_notizie`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`se_lead`,`se_prospect`,`se_cliente`,`se_fornitore`,`se_produttore`,`se_collaboratore`,`se_interno`,`se_esterno`,`se_agente`,`se_concorrente`,`se_azienda_gestita`,`se_amministrazione`),
  CONSTRAINT `categorie_anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `categorie_anagrafica_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `se_prospect` int, `se_lead` int, `se_cliente` int, `se_fornitore` int, `se_produttore` int, `se_collaboratore` int, `se_interno` int, `se_esterno` int, `se_agente` int, `se_concorrente` int, `se_azienda_gestita` int, `se_amministrazione` int, `se_notizie` int, `figli` bigint, `membri` bigint, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);

CREATE TABLE `categorie_notizie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_sito` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_sito` (`id_sito`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`),
  CONSTRAINT `categorie_notizie_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `categorie_notizie_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(255), `template` char(255), `schema_html` char(128), `tema_css` char(128), `id_sito` int, `id_pagina` int, `figli` bigint, `membri` bigint, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `categorie_prodotti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_sito` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_sito` (`id_sito`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_sito`,`id_pagina`),
  CONSTRAINT `categorie_prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `categorie_prodotti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(255), `template` char(255), `schema_html` char(128), `tema_css` char(128), `id_sito` int, `id_pagina` int, `figli` bigint, `membri` bigint, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `categorie_progetti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`),
  CONSTRAINT `categorie_progetti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `categorie_progetti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(255), `figli` bigint, `membri` bigint, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `categorie_risorse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(128) DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`id_pagina`),
  CONSTRAINT `categorie_risorse_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_risorse_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `categorie_risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `categorie_risorse_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `figli` bigint, `membri` bigint, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `chiavi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_licenza` int DEFAULT NULL,
  `id_tipologia` int DEFAULT NULL,
  `codice` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `seriale` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `nome` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_licenza`,`codice`),
  KEY `codice` (`codice`),
  KEY `seriale` (`seriale`),
  KEY `id_licenza` (`id_licenza`),
  KEY `indice` (`id`,`codice`,`seriale`,`nome`,`id_licenza`),
  KEY `chiavi_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `chiavi_ibfk_99_nofollow` (`id_account_aggiornamento`),
  KEY `id_tipologia` (`id_tipologia`),
  CONSTRAINT `chiavi_ibfk_01_nofollow` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `chiavi_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_chiavi` (`id`),
  CONSTRAINT `chiavi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `chiavi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `chiavi_view` (`id` int, `id_licenza` int, `licenza` char(32), `id_tipologia` int, `tipologia` char(32), `codice` char(32), `seriale` char(32), `nome` char(32), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(32));


CREATE TABLE `colori` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(16) NOT NULL,
  `hex` char(8) DEFAULT NULL,
  `r` int DEFAULT NULL,
  `g` int DEFAULT NULL,
  `b` int DEFAULT NULL,
  `ral` char(16) DEFAULT NULL,
  `pantone` char(8) DEFAULT NULL,
  `c` decimal(5,2) DEFAULT NULL,
  `m` decimal(5,2) DEFAULT NULL,
  `y` decimal(5,2) DEFAULT NULL,
  `k` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_hex` (`nome`,`hex`),
  UNIQUE KEY `unica_rgb` (`nome`,`r`,`g`,`b`),
  UNIQUE KEY `unica_ral` (`nome`,`ral`),
  UNIQUE KEY `unica_pantone` (`nome`,`pantone`),
  UNIQUE KEY `unica_cmyk` (`nome`,`c`,`m`,`y`,`k`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`nome`,`id_genitore`,`hex`,`r`,`g`,`b`),
  KEY `indice_ral` (`id`,`nome`,`id_genitore`,`ral`),
  KEY `indice_pantone` (`id`,`nome`,`id_genitore`,`pantone`),
  KEY `indice_cmyk` (`id`,`nome`,`id_genitore`,`c`,`m`,`y`,`k`),
  CONSTRAINT `colori_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `colori_view` (`id` int, `id_genitore` int, `nome` char(16), `hex` char(8), `r` int, `g` int, `b` int, `ral` char(16), `pantone` char(8), `c` decimal(5,2), `m` decimal(5,2), `y` decimal(5,2), `k` decimal(5,2), `__label__` text);


CREATE TABLE `comuni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_provincia` int NOT NULL,
  `nome` varchar(254) NOT NULL,
  `codice_istat` char(12) DEFAULT NULL,
  `codice_catasto` char(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_istat` (`codice_istat`),
  UNIQUE KEY `unica_catasto` (`codice_catasto`),
  KEY `id_provincia` (`id_provincia`),
  KEY `indice` (`id`,`id_provincia`,`nome`,`codice_istat`,`codice_catasto`),
  CONSTRAINT `comuni_ibfk_01_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `comuni_view` (`id` int, `id_provincia` int, `provincia` varchar(254), `sigla_provincia` char(8), `id_regione` int, `regione` char(32), `id_stato` int, `stato` char(128), `nome` varchar(254), `codice_istat` char(12), `codice_catasto` char(4), `__label__` varchar(394));


CREATE TABLE `contatti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_inviante` int DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `json` text,
  `timestamp_contatto` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_inviante` (`id_inviante`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `timestamp_contatto` (`timestamp_contatto`),
  KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_inviante`,`nome`,`timestamp_contatto`),
  CONSTRAINT `contatti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contatti` (`id`),
  CONSTRAINT `contatti_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_03_nofollow` FOREIGN KEY (`id_inviante`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contatti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `contatti_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `id_anagrafica` int, `anagrafica` varchar(320), `id_inviante` int, `inviante` varchar(320), `nome` char(255), `timestamp_contatto` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(290));


CREATE TABLE `contenuti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lingua` int NOT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_caratteristica_prodotti` int DEFAULT NULL,
  `id_marchio` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `id_immagine` int DEFAULT NULL,
  `id_video` int DEFAULT NULL,
  `id_audio` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_popup` int DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_template` int DEFAULT NULL,
  `id_colore` int DEFAULT NULL,
  `path_custom` char(255) DEFAULT NULL,
  `url_custom` char(255) DEFAULT NULL,
  `rewrite_custom` char(255) DEFAULT NULL,
  `title` char(255) DEFAULT NULL,
  `keywords` text,
  `description` text,
  `alt` char(255) DEFAULT NULL,
  `og_title` char(255) DEFAULT NULL,
  `og_type` char(255) DEFAULT NULL,
  `og_image` char(255) DEFAULT NULL,
  `og_audio` char(255) DEFAULT NULL,
  `og_video` char(255) DEFAULT NULL,
  `og_determiner` char(255) DEFAULT NULL,
  `og_description` char(255) DEFAULT NULL,
  `cappello` text,
  `h1` char(255) DEFAULT NULL,
  `h2` char(255) DEFAULT NULL,
  `h3` char(255) DEFAULT NULL,
  `abstract` text,
  `testo` text,
  `applicazioni` text,
  `specifiche` text,
  `label_menu` char(255) DEFAULT NULL,
  `mittente_nome` char(128) DEFAULT NULL,
  `mittente_mail` char(128) DEFAULT NULL,
  `destinatario_nome` char(128) DEFAULT NULL,
  `destinatario_mail` char(128) DEFAULT NULL,
  `destinatario_cc_nome` char(128) DEFAULT NULL,
  `destinatario_cc_mail` char(128) DEFAULT NULL,
  `destinatario_ccn_nome` char(128) DEFAULT NULL,
  `destinatario_ccn_mail` char(128) DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`),
  UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`),
  UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`),
  UNIQUE KEY `unica_caratteristica_prodotti` (`id_lingua`,`id_caratteristica_prodotti`),
  UNIQUE KEY `unica_marchio` (`id_lingua`,`id_marchio`),
  UNIQUE KEY `unica_file` (`id_lingua`,`id_file`),
  UNIQUE KEY `unica_immagine` (`id_lingua`,`id_immagine`),
  UNIQUE KEY `unica_video` (`id_lingua`,`id_video`),
  UNIQUE KEY `unica_audio` (`id_lingua`,`id_audio`),
  UNIQUE KEY `unica_risorsa` (`id_lingua`,`id_risorsa`),
  UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`),
  UNIQUE KEY `unica_pagina` (`id_lingua`,`id_pagina`),
  UNIQUE KEY `unica_popup` (`id_lingua`,`id_popup`),
  UNIQUE KEY `unica_indirizzo` (`id_lingua`,`id_indirizzo`),
  UNIQUE KEY `unica_notizia` (`id_lingua`,`id_notizia`),
  UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`),
  UNIQUE KEY `unica_template` (`id_lingua`,`id_template`),
  UNIQUE KEY `unica_colore` (`id_lingua`,`id_colore`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_caratteristica_prodotti` (`id_caratteristica_prodotti`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_file` (`id_file`),
  KEY `id_immagine` (`id_immagine`),
  KEY `id_video` (`id_video`),
  KEY `id_audio` (`id_audio`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_popup` (`id_popup`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_template` (`id_template`),
  KEY `id_colore` (`id_colore`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_lingua`),
  KEY `indice_anagrafica` (`id`,`id_lingua`,`id_anagrafica`),
  KEY `indice_prodotti` (`id`,`id_lingua`,`id_prodotto`,`id_articolo`,`id_categoria_prodotti`,`id_marchio`),
  KEY `indice_immagini` (`id`,`id_lingua`,`id_immagine`),
  KEY `indice_file` (`id`,`id_lingua`,`id_file`),
  KEY `indice_risorse` (`id`,`id_lingua`,`id_risorsa`,`id_categoria_risorse`),
  KEY `indice_pagine` (`id`,`id_lingua`,`id_pagina`,`id_popup`),
  KEY `indice_notizie` (`id`,`id_lingua`,`id_notizia`,`id_categoria_notizie`),
  KEY `indice_video` (`id`,`id_lingua`,`id_video`),
  KEY `indice_audio` (`id`,`id_lingua`,`id_audio`),
  KEY `indice_template` (`id`,`id_lingua`,`id_template`),
  KEY `indice_colore` (`id`,`id_lingua`,`id_colore`),
  CONSTRAINT `contenuti_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `contenuti_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_03` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_05` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_06` FOREIGN KEY (`id_caratteristica_prodotti`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_07` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_08` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_09` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_10` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_11` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_12` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_13` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_14` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_15` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_16` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_17` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_18` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_20` FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_21` FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contenuti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `contenuti_view` (`id` int, `id_lingua` int, `id_anagrafica` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `id_caratteristica_prodotti` int, `id_marchio` int, `id_file` int, `id_immagine` int, `id_video` int, `id_audio` int, `id_risorsa` int, `id_categoria_risorse` int, `id_pagina` int, `id_popup` int, `id_indirizzo` int, `id_notizia` int, `id_categoria_notizie` int, `id_template` int, `id_colore` int, `title` char(255), `h1` char(255), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(386));


CREATE TABLE `continenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codice` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `nome` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `indice` (`id`,`codice`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `continenti_view` (`id` int, `codice` char(2), `nome` char(32), `__label__` char(32));


CREATE TABLE `coupon` (
  `id` char(32) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `timestamp_inizio` int DEFAULT NULL,
  `timestamp_fine` int DEFAULT NULL,
  `sconto_percentuale` decimal(5,2) DEFAULT NULL,
  `sconto_fisso` decimal(15,2) DEFAULT NULL,
  `se_multiuso` int DEFAULT '1',
  `se_globale` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`timestamp_inizio`,`timestamp_fine`,`sconto_percentuale`,`sconto_fisso`,`se_multiuso`,`se_globale`),
  CONSTRAINT `coupon_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `coupon_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `coupon_categorie_prodotti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_categoria`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_categoria`,`ordine`),
  CONSTRAINT `coupon_categorie_prodotti_ibfk_01` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_categorie_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_categorie_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `coupon_categorie_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `coupon_categorie_prodotti_view` (`id` int, `id_coupon` char(32), `id_categoria` int, `categoria` char(255), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `coupon_listini` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_listino` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_listino`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_listino` (`id_listino`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_listino`,`ordine`),
  CONSTRAINT `coupon_listini_ibfk_01` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_listini_ibfk_02_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_listini_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `coupon_listini_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `coupon_listini_view` (`id` int, `id_coupon` char(32), `id_listino` int, `listino` char(64), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(322));


CREATE TABLE `coupon_marchi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_marchio` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_marchio`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_marchio`,`ordine`),
  CONSTRAINT `coupon_marchi_ibfk_01` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_marchi_ibfk_02_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `coupon_marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `coupon_marchi_view` (`id` int, `id_coupon` char(32), `id_marchio` int, `marchio` char(64), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(322));


CREATE TABLE `coupon_prodotti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_coupon` char(32) NOT NULL,
  `id_prodotto` char(32) NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_coupon`,`id_prodotto`),
  KEY `id_coupon` (`id_coupon`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_coupon`,`id_prodotto`,`ordine`),
  CONSTRAINT `coupon_prodotti_ibfk_01` FOREIGN KEY (`id_coupon`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coupon_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `coupon_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `coupon_prodotti_view` (`id` int, `id_coupon` char(32), `id_prodotto` char(32), `prodotto` char(128), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(386));


CREATE TABLE `coupon_view` (`id` char(32), `nome` char(255), `timestamp_inizio` int, `data_ora_inizio` varchar(10), `timestamp_fine` int, `data_ora_fine` varchar(10), `sconto_percentuale` decimal(5,2), `sconto_fisso` decimal(15,2), `se_multiuso` int, `se_globale` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(255));


CREATE TABLE `documenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `numero` int NOT NULL,
  `data` date NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_emittente` int NOT NULL,
  `id_sede_emittente` int DEFAULT NULL,
  `id_destinatario` int NOT NULL,
  `id_sede_destinatario` int DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_sede_emittente` (`id_sede_emittente`),
  KEY `id_destinatario` (`id_destinatario`),
  KEY `id_sede_destinatario` (`id_sede_destinatario`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`numero`,`data`,`id_emittente`,`id_sede_emittente`,`id_destinatario`,`id_sede_destinatario`),
  CONSTRAINT `documenti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`),
  CONSTRAINT `documenti_ibfk_02_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `documenti_ibfk_03_nofollow` FOREIGN KEY (`id_sede_emittente`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `documenti_ibfk_04_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `documenti_ibfk_05_nofollow` FOREIGN KEY (`id_sede_destinatario`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `documenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `documenti_articoli` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_tipologia` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `id_documento` int DEFAULT NULL,
  `data` date NOT NULL,
  `id_destinatario` int DEFAULT NULL,
  `id_emittente` int DEFAULT NULL,
  `id_reparto` int DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `id_attivita` int DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `id_udm` int DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `id_listino` int DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `id_iva` int DEFAULT NULL,
  `nome` text,
  `specifiche` char(255) DEFAULT NULL,
  `testo` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_documento` (`id_documento`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_destinatario` (`id_destinatario`),
  KEY `id_reparto` (`id_reparto`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_todo` (`id_todo`),
  KEY `id_attivita` (`id_attivita`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_udm` (`id_udm`),
  KEY `id_listino` (`id_listino`),
  KEY `id_iva` (`id_iva`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `data` (`data`),
  KEY `quantita` (`quantita`),
  KEY `importo_netto_totale` (`importo_netto_totale`),
  KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_todo`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`),
  KEY `indice_progetto_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
  KEY `indice_progetto_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_progetto`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_iva`),
  KEY `indice_todo_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
  KEY `indice_todo_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_todo`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_iva`),
  KEY `indice_attivita_quantita` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_udm`,`quantita`),
  KEY `indice_attivita_valore` (`id`,`id_genitore`,`id_tipologia`,`ordine`,`id_documento`,`data`,`id_emittente`,`id_destinatario`,`id_reparto`,`id_attivita`,`id_articolo`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`importo_netto_totale`,`id_iva`),
  CONSTRAINT `documenti_articoli_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `documenti_articoli` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_documenti` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_03` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_04_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_05_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_06_nofollow` FOREIGN KEY (`id_reparto`) REFERENCES `reparti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_07_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_08_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_09_nofollow` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_10_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_11_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_12_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_13_nofollow` FOREIGN KEY (`id_udm`) REFERENCES `udm` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_14_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_15_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `documenti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `documenti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `documenti_articoli_view` (`id` int, `id_genitore` int, `id_tipologia` int, `tipologia` char(255), `ordine` int, `id_documento` int, `data` date, `id_emittente` int, `emittente` varchar(320), `id_destinatario` int, `destinatario` varchar(320), `id_reparto` int, `id_progetto` char(32), `id_todo` int, `id_attivita` int, `id_articolo` char(32), `id_mastro_provenienza` int, `mastro_provenienza` char(64), `id_mastro_destinazione` int, `mastro_destinazione` char(64), `id_udm` int, `quantita` decimal(9,2), `id_listino` int, `id_valuta` int, `valuta` char(1), `importo_netto_totale` decimal(9,2), `id_iva` int, `iva` char(64), `nome` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `documenti_view` (`id` int, `id_tipologia` int, `tipologia` char(255), `numero` int, `data` date, `nome` char(255), `id_emittente` int, `emittente` varchar(320), `id_destinatario` int, `destinatario` varchar(320), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `embed` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(64) NOT NULL,
  `se_audio` int DEFAULT NULL,
  `se_video` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`,`se_audio`,`se_video`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `embed_view` (`id` int, `nome` char(64), `se_audio` int, `se_video` int, `__label__` char(64));


CREATE TABLE `file` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ordine` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_template` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_lingua` int DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `url` char(255) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_todo` (`id_todo`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_template` (`id_template`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_notizia` (`id_notizia`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_risorsa` (`id_risorsa`,`id_ruolo`,`path`),
  UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`path`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_todo` (`id_todo`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_template` (`id_template`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_lingua` (`id_lingua`),
  KEY `path` (`path`),
  KEY `url` (`url`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_ruolo`,`id_lingua`,`path`,`url`),
  KEY `indice_anagrafica` (`id`,`id_ruolo`,`id_anagrafica`,`id_lingua`,`path`,`url`),
  KEY `indice_prodotti` (`id`,`id_ruolo`,`id_prodotto`,`id_lingua`,`path`,`url`),
  KEY `indice_articoli` (`id`,`id_ruolo`,`id_articolo`,`id_lingua`,`path`,`url`),
  KEY `indice_categorie_prodotti` (`id`,`id_ruolo`,`id_categoria_prodotti`,`id_lingua`,`path`,`url`),
  KEY `indice_todo` (`id`,`id_ruolo`,`id_todo`,`id_lingua`,`path`,`url`),
  KEY `indice_pagine` (`id`,`id_ruolo`,`id_pagina`,`id_lingua`,`path`,`url`),
  KEY `indice_template` (`id`,`id_ruolo`,`id_template`,`id_lingua`,`path`,`url`),
  KEY `indice_notizie` (`id`,`id_ruolo`,`id_notizia`,`id_lingua`,`path`,`url`),
  KEY `indice_categorie_notizie` (`id`,`id_ruolo`,`id_categoria_notizie`,`id_lingua`,`path`,`url`),
  KEY `indice_risorse` (`id`,`id_ruolo`,`id_risorsa`,`id_lingua`,`path`,`url`),
  KEY `indice_categorie_risorse` (`id`,`id_ruolo`,`id_categoria_risorse`,`id_lingua`,`path`,`url`),
  CONSTRAINT `file_ibfk_01_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_file` (`id`),
  CONSTRAINT `file_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_03` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_04` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_05` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_06` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_07` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_08` FOREIGN KEY (`id_template`) REFERENCES `template` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_09` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_11` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_12` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_13_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `file_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `file_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `file_view` ();


CREATE TABLE `gruppi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_organizzazione` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_organizzazione` (`id_organizzazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_organizzazione`,`nome`),
  CONSTRAINT `gruppi_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `gruppi` (`id`),
  CONSTRAINT `gruppi_ibfk_02` FOREIGN KEY (`id_organizzazione`) REFERENCES `organizzazioni` (`id`),
  CONSTRAINT `gruppi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `gruppi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `gruppi_view` (`id` int, `id_genitore` int, `id_organizzazione` int, `nome` char(32), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `iban` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `intestazione` char(255) DEFAULT NULL,
  `iban` char(27) NOT NULL,
  `note` text NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`iban`),
  CONSTRAINT `iban_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `iban_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `iban_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `iban_view` (`id` int, `id_anagrafica` int, `anagrafica` varchar(320), `intestazione` char(255), `iban` char(27), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(347));


CREATE TABLE `immagini` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `id_lingua` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `taglio` char(64) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `path` char(255) NOT NULL,
  `path_alternativo` char(255) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_scalamento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_risorse` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_notizie` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_indirizzi` (`id_indirizzo`,`id_ruolo`,`id_lingua`,`path`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_file` (`id_file`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `path` (`path`),
  KEY `path_alternativo` (`path_alternativo`),
  KEY `token` (`token`),
  KEY `timestamp_scalamento` (`timestamp_scalamento`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_anagrafica` (`id`,`id_anagrafica`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_pagine` (`id`,`id_pagina`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_file` (`id`,`id_file`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_prodotti` (`id`,`id_prodotto`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_articoli` (`id`,`id_articolo`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_risorse` (`id`,`id_risorsa`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_notizie` (`id`,`id_notizia`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  KEY `indice_indirizzi` (`id`,`id_indirizzo`,`id_lingua`,`id_ruolo`,`ordine`,`path`,`path_alternativo`,`token`,`timestamp_scalamento`),
  CONSTRAINT `immagini_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_03` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_05` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_06` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_07` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_08` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_09` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_11` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_12_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `immagini_ibfk_13_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_immagini` (`id`),
  CONSTRAINT `immagini_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `immagini_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `immagini_view` (`id` int, `id_anagrafica` int, `id_pagina` int, `id_file` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `id_risorsa` int, `id_categoria_risorse` int, `id_notizia` int, `id_categoria_notizie` int, `id_indirizzo` int, `id_lingua` int, `lingua` char(128), `id_ruolo` int, `ruolo` char(64), `ordine` int, `orientamento` enum('L','P'), `taglio` char(64), `nome` char(32), `path` char(255), `path_alternativo` char(255), `token` char(128), `timestamp_scalamento` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(371));


CREATE TABLE `indirizzi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_comune` int NOT NULL,
  `localita` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `indirizzo` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `civico` char(16) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `cap` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `note` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `latitudine` decimal(11,7) DEFAULT NULL,
  `longitudine` decimal(11,7) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `timestamp_geolocalizzazione` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_comune`,`indirizzo`,`civico`,`cap`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_comune` (`id_comune`),
  KEY `timestamp_geolocalizzazione` (`timestamp_geolocalizzazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_comune`,`indirizzo`,`civico`,`cap`,`timestamp_geolocalizzazione`),
  CONSTRAINT `indirizzi_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi` (`id`),
  CONSTRAINT `indirizzi_ibfk_02_nofollow` FOREIGN KEY (`id_comune`) REFERENCES `comuni` (`id`),
  CONSTRAINT `indirizzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `indirizzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `indirizzi_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `id_comune` int, `comune` varchar(254), `id_provincia` int, `provincia` varchar(254), `id_regione` int, `regione` char(32), `id_stato` int, `stato` char(128), `localita` char(128), `indirizzo` char(128), `civico` char(16), `cap` char(11), `latitudine` decimal(11,7), `longitudine` decimal(11,7), `token` char(128), `timestamp_geolocalizzazione` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `iva` (
  `id` int NOT NULL AUTO_INCREMENT,
  `aliquota` decimal(5,2) NOT NULL,
  `nome` char(64) NOT NULL,
  `descrizione` text,
  `codice` char(8) DEFAULT NULL,
  `timestamp_archiviazione` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aliquota` (`aliquota`),
  KEY `timestamp_archiviazione` (`timestamp_archiviazione`),
  KEY `indice` (`id`,`aliquota`,`nome`,`codice`,`timestamp_archiviazione`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `iva_view` (`id` int, `aliquota` decimal(5,2), `nome` char(64), `codice` char(8), `timestamp_archiviazione` int, `__label__` char(64));


CREATE TABLE `job` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  `job` char(255) NOT NULL,
  `timestamp_apertura` int DEFAULT NULL,
  `totale` int DEFAULT NULL,
  `corrente` int DEFAULT NULL,
  `iterazioni` int DEFAULT NULL,
  `delay` int DEFAULT NULL,
  `workspace` text,
  `token` char(254) DEFAULT NULL,
  `se_foreground` int DEFAULT NULL,
  `timestamp_esecuzione` int DEFAULT NULL,
  `timestamp_completamento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `timestamp_apertura` (`timestamp_apertura`),
  KEY `timestamp_esecuzione` (`timestamp_esecuzione`),
  KEY `timestamp_completamento` (`timestamp_completamento`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`job`,`totale`,`corrente`,`iterazioni`,`delay`,`token`,`timestamp_apertura`,`timestamp_esecuzione`,`timestamp_completamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `job_view` (`id` int, `nome` char(255), `job` char(255), `totale` int, `corrente` int, `iterazioni` int, `delay` int, `token` char(254), `se_foreground` int, `timestamp_apertura` int, `data_ora_apertura` varchar(21), `timestamp_esecuzione` int, `data_ora_esecuzione` varchar(21), `timestamp_completamento` int, `data_ora_completamento` varchar(21), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `licenze` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_rivenditore` int DEFAULT NULL,
  `codice` char(254) DEFAULT NULL,
  `postazioni` int NOT NULL,
  `nome` char(32) DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `testo` text,
  `giorni_validita` int DEFAULT NULL,
  `giorni_rinnovo` int DEFAULT NULL,
  `timestamp_distribuzione` int DEFAULT NULL,
  `timestamp_inizio` int DEFAULT NULL,
  `timestamp_fine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `codice` (`codice`),
  KEY `nome` (`nome`),
  KEY `giorni_validita` (`giorni_validita`),
  KEY `giorni_rinnovo` (`giorni_rinnovo`),
  KEY `timestamp_distribuzione` (`timestamp_distribuzione`),
  KEY `timestamp_inizio` (`timestamp_inizio`),
  KEY `timestamp_fine` (`timestamp_fine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id_anagrafica`,`id_tipologia`,`id_rivenditore`,`codice`,`postazioni`,`nome`,`giorni_validita`,`giorni_rinnovo`,`timestamp_distribuzione`,`timestamp_inizio`,`timestamp_fine`),
  KEY `licenze_ibfk_03_nofollow` (`id_rivenditore`),
  CONSTRAINT `licenze_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_licenze` (`id`),
  CONSTRAINT `licenze_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `licenze_ibfk_03_nofollow` FOREIGN KEY (`id_rivenditore`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `licenze_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `licenze_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `licenze_software` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_licenza` int NOT NULL,
  `id_software` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_licenza`,`id_software`),
  KEY `id_licenza` (`id_licenza`),
  KEY `id_software` (`id_software`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_licenza`,`id_software`,`ordine`),
  CONSTRAINT `licenze_software_ibfk_01_nofollow` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `licenze_software_ibfk_02_nofollow` FOREIGN KEY (`id_software`) REFERENCES `software` (`id`),
  CONSTRAINT `licenze_software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `licenze_software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `licenze_software_view` (`id` int, `id_licenza` int, `id_software` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(163));


CREATE TABLE `licenze_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `id_anagrafica` int, `anagrafica` varchar(320), `id_rivenditore` int, `rivenditore` varchar(320), `codice` char(254), `postazioni` int, `nome` char(32), `note` char(254), `testo` text, `giorni_validita` int, `giorni_rinnovo` int, `timestamp_distribuzione` int, `timestamp_inizio` int, `timestamp_fine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(32));


CREATE TABLE `lingue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `note` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `iso6391alpha2` char(36) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `iso6393alpha3` char(36) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ietf` char(36) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_nome` (`nome`),
  UNIQUE KEY `unica_iso6391alpha2` (`iso6391alpha2`),
  UNIQUE KEY `unica_iso6393alpha3` (`iso6393alpha3`),
  UNIQUE KEY `unica_ietf` (`ietf`),
  KEY `indice` (`id`,`nome`,`iso6391alpha2`,`iso6393alpha3`,`ietf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `lingue_view` (`id` int, `nome` char(128), `iso6391alpha2` char(36), `iso6393alpha3` char(36), `ietf` char(36), `__label__` char(128));


CREATE TABLE `listini` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_valuta` int NOT NULL,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_valuta`,`nome`),
  KEY `id_valuta` (`id_valuta`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_valuta`,`nome`),
  CONSTRAINT `listini_ibfk_01_nofollow` FOREIGN KEY (`id_valuta`) REFERENCES `valute` (`id`),
  CONSTRAINT `listini_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `listini_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `listini_clienti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_listino` int NOT NULL,
  `id_cliente` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_listino`,`id_cliente`),
  KEY `id_listino` (`id_listino`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_listino`,`id_cliente`,`ordine`),
  CONSTRAINT `listini_clienti_ibfk_01_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`),
  CONSTRAINT `listini_clienti_ibfk_02_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `listini_clienti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `listini_clienti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `listini_view` (`id` int, `id_listino` int, `listino` varchar(68), `id_cliente` int, `cliente` varchar(320), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(391));


CREATE TABLE `luoghi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `nome` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_indirizzo`,`nome`),
  CONSTRAINT `luoghi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `luoghi_ibfk_02_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `luoghi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `luoghi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `luoghi_view` (`id` int, `id_genitore` int, `id_indirizzo` int, `indirizzo` text, `nome` char(255), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `macro` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_pagina` int NOT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `macro` char(64) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_pagina` (`id_pagina`,`macro`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`macro`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`macro`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`macro`),
  UNIQUE KEY `unica_notizia` (`id_notizia`,`macro`),
  UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`macro`),
  UNIQUE KEY `unica_risorsa` (`id_risorsa`,`macro`),
  UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`macro`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `indice` (`id`,`ordine`,`macro`),
  KEY `indice_pagine` (`id`,`id_pagina`,`ordine`,`macro`),
  KEY `indice_prodotti` (`id`,`id_prodotto`,`ordine`,`macro`),
  KEY `indice_articoli` (`id`,`id_articolo`,`ordine`,`macro`),
  KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`ordine`,`macro`),
  KEY `indice_notizie` (`id`,`id_notizia`,`ordine`,`macro`),
  KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`ordine`,`macro`),
  KEY `indice_risorse` (`id`,`id_risorsa`,`ordine`,`macro`),
  KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`ordine`,`macro`),
  KEY `macro_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `macro_ibfk_99_nofollow` (`id_account_aggiornamento`),
  CONSTRAINT `macro_ibfk_01` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_02` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_03` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_04` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_05` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_06` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_07` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_08` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `macro_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `macro_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `macro_view` (`id` int, `id_pagina` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `macro` char(64), `__label__` char(64));


CREATE TABLE `mail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `indirizzo` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `se_pec` tinyint(1) DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`indirizzo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_anagrafica`,`indirizzo`,`se_notifiche`,`se_pec`),
  CONSTRAINT `mail_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mail_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `mail_out` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_mail` int DEFAULT NULL,
  `id_mailing` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_composizione` int NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int DEFAULT '0',
  `timestamp_invio` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_mail`,`id_mailing`),
  KEY `id_mail` (`id_mail`),
  KEY `id_mailing` (`id_mailing`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_mail`,`id_mailing`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`),
  CONSTRAINT `mail_out_ibfk_01_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mail_out_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_out_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `mail_out_view` (`id` int, `id_mail` int, `id_mailing` int, `ordine` int, `timestamp_composizione` int, `mittente` char(254), `destinatari` text, `destinatari_cc` text, `destinatari_bcc` text, `oggetto` char(254), `allegati` text, `headers` text, `server` char(128), `host` char(254), `port` char(6), `user` char(254), `password` char(254), `token` char(128), `tentativi` int, `timestamp_invio` int, `data_ora_invio` varchar(10), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);



CREATE TABLE `mail_sent` (
  `id` int NOT NULL,
  `id_mail` int DEFAULT NULL,
  `id_mailing` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_composizione` int NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int DEFAULT '0',
  `timestamp_invio` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_mail`,`id_mailing`),
  KEY `id_mail` (`id_mail`),
  KEY `id_mailing` (`id_mailing`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_mail`,`id_mailing`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`),
  CONSTRAINT `mail_sent_ibfk_01_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mail_sent_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_sent_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `mail_sent_view` (`id` int, `id_mail` int, `id_mailing` int, `ordine` int, `timestamp_composizione` int, `mittente` char(254), `destinatari` text, `destinatari_cc` text, `destinatari_bcc` text, `oggetto` char(254), `allegati` text, `headers` text, `server` char(128), `host` char(254), `port` char(6), `user` char(254), `password` char(254), `token` char(128), `tentativi` int, `timestamp_invio` int, `data_ora_invio` varchar(10), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `mail_view` (`id` int, `id_anagrafica` int, `anagrafica` varchar(320), `indirizzo` char(128), `se_notifiche` tinyint(1), `se_pec` tinyint(1), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(449));


CREATE TABLE `marchi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`),
  CONSTRAINT `marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `marchi_view` (`id` int, `nome` char(64), `__label__` char(64));


CREATE TABLE `mastri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_tipologia` int NOT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`nome`),
  CONSTRAINT `mastri_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `mastri` (`id`),
  CONSTRAINT `mastri_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_mastri` (`id`),
  CONSTRAINT `mastri_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mastri_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `mastri_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `nome` char(64), `__label__` text);


CREATE TABLE `menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lingua` int NOT NULL,
  `id_pagina` int NOT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `target` char(16) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_lingua`,`id_pagina`,`menu`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`menu`),
  UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`menu`),
  UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`menu`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `indice` (`id`,`id_lingua`,`id_pagina`,`ordine`,`menu`,`nome`,`target`,`sottopagine`),
  KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`menu`,`nome`),
  KEY `indice_categorie_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`menu`,`nome`),
  KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`menu`,`nome`),
  KEY `menu_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `menu_ibfk_99_nofollow` (`id_account_aggiornamento`),
  CONSTRAINT `menu_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `menu_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_03` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_04` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_05` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `menu_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `menu_view` (`id` int, `id_lingua` int, `id_pagina` int, `id_categoria_prodotti` int, `id_categoria_notizie` int, `id_categoria_risorse` int, `ordine` int, `menu` char(32), `nome` char(128), `target` char(16), `sottopagine` char(32), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(216));


CREATE TABLE `metadati` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lingua` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_immagine` int DEFAULT NULL,
  `id_video` int DEFAULT NULL,
  `id_audio` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `testo` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`,`nome`),
  UNIQUE KEY `unica_pagina` (`id_lingua`,`id_pagina`,`nome`),
  UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`,`nome`),
  UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`,`nome`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`nome`),
  UNIQUE KEY `unica_notizia` (`id_lingua`,`id_notizia`,`nome`),
  UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`nome`),
  UNIQUE KEY `unica_risorsa` (`id_lingua`,`id_risorsa`,`nome`),
  UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`nome`),
  UNIQUE KEY `unica_immagine` (`id_lingua`,`id_immagine`,`nome`),
  UNIQUE KEY `unica_video` (`id_lingua`,`id_video`,`nome`),
  UNIQUE KEY `unica_audio` (`id_lingua`,`id_audio`,`nome`),
  UNIQUE KEY `unica_file` (`id_lingua`,`id_file`,`nome`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_immagine` (`id_immagine`),
  KEY `id_video` (`id_video`),
  KEY `id_audio` (`id_audio`),
  KEY `id_file` (`id_file`),
  KEY `indice` (`id`,`id_lingua`,`nome`,`testo`(255)),
  KEY `indice_anagrafica` (`id`,`id_lingua`,`id_anagrafica`,`nome`,`testo`(255)),
  KEY `indice_pagina` (`id`,`id_lingua`,`id_pagina`,`nome`,`testo`(255)),
  KEY `indice_prodotti` (`id`,`id_lingua`,`id_prodotto`,`nome`,`testo`(255)),
  KEY `indice_articoli` (`id`,`id_lingua`,`id_articolo`,`nome`,`testo`(255)),
  KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`nome`,`testo`(255)),
  KEY `indice_notizie` (`id`,`id_lingua`,`id_notizia`,`nome`,`testo`(255)),
  KEY `indice_categoria_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`nome`,`testo`(255)),
  KEY `indice_risorse` (`id`,`id_lingua`,`id_risorsa`,`nome`,`testo`(255)),
  KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`nome`,`testo`(255)),
  KEY `indice_immagini` (`id`,`id_lingua`,`id_immagine`,`nome`,`testo`(255)),
  KEY `indice_video` (`id`,`id_lingua`,`id_video`,`nome`,`testo`(255)),
  KEY `indice_audio` (`id`,`id_lingua`,`id_audio`,`nome`,`testo`(255)),
  KEY `indice_file` (`id`,`id_lingua`,`id_file`,`nome`,`testo`(255)),
  KEY `metadati_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `metadati_ibfk_99_nofollow` (`id_account_aggiornamento`),
  CONSTRAINT `metadati_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `metadati_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_03` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_05` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_06` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_07` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_08` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_09` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_10` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_11` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_12` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_13` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_14` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `metadati_view` (`id` int, `id_lingua` int, `ietf` char(36), `id_anagrafica` int, `id_pagina` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `id_notizia` int, `id_categoria_notizie` int, `id_risorsa` int, `id_categoria_risorse` int, `id_immagine` int, `id_video` int, `id_audio` int, `id_file` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `notizie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`nome`),
  CONSTRAINT `notizie_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_notizie` (`id`),
  CONSTRAINT `notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `notizie_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_notizia` int NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_notizia`,`id_categoria`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_notizia`,`id_categoria`,`ordine`),
  CONSTRAINT `notizie_categorie_ibfk_01` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_categorie_ibfk_02` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `notizie_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `notizie_categorie_view` (`id` int, `id_notizia` int, `notizia` char(255), `id_categoria` int, `categoria` text, `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `notizie_view` (`id` int, `id_tipologia` int, `tipologia` char(255), `nome` char(255), `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(255));


CREATE TABLE `organizzazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`id_anagrafica`,`id_ruolo`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`id_anagrafica`,`id_ruolo`),
  CONSTRAINT `organizzazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `organizzazioni` (`id`),
  CONSTRAINT `organizzazioni_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `organizzazioni_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`),
  CONSTRAINT `organizzazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `organizzazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `organizzazioni_view` (`id` int, `id_genitore` int, `ordine` int, `id_anagrafica` int, `anagrafica` varchar(320), `id_ruolo` int, `ruolo` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `pagamenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `id_documento` int DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `id_iban` int DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `id_iva` int DEFAULT NULL,
  `id_listino` int DEFAULT NULL,
  `timestamp_pagamento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `ordine` (`ordine`),
  KEY `id_documento` (`id_documento`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_iban` (`id_iban`),
  KEY `id_listino` (`id_listino`),
  KEY `id_iva` (`id_iva`),
  KEY `timestamp_pagamento` (`timestamp_pagamento`),
  KEY `importo_netto_totale` (`importo_netto_totale`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_documento`,`timestamp_pagamento`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`id_iban`,`importo_netto_totale`,`id_iva`),
  CONSTRAINT `pagamenti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pagamenti` (`id`),
  CONSTRAINT `pagamenti_ibfk_02` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`),
  CONSTRAINT `pagamenti_ibfk_03_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`),
  CONSTRAINT `pagamenti_ibfk_04_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`),
  CONSTRAINT `pagamenti_ibfk_05_nofollow` FOREIGN KEY (`id_iban`) REFERENCES `iban` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pagamenti_ibfk_06_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`),
  CONSTRAINT `pagamenti_ibfk_07_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `pagamenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pagamenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pagamenti_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `ordine` int, `nome` char(255), `note` text, `id_documento` int, `id_mastro_provenienza` int, `mastro_provenienza` char(64), `id_mastro_destinazione` int, `mastro_destinazione` char(64), `id_iban` int, `importo_netto_totale` decimal(9,2), `id_iva` int, `iva` char(64), `id_listino` int, `listino` char(64), `timestamp_pagamento` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(255));


CREATE TABLE `pagine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_sito` int NOT NULL DEFAULT '1',
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `id_contenuti` int DEFAULT NULL,
  `se_sitemap` int DEFAULT NULL,
  `se_cacheable` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_sito` (`id_sito`),
  KEY `nome` (`nome`),
  KEY `id_contenuti` (`id_contenuti`),
  KEY `se_sitemap` (`se_sitemap`),
  KEY `se_cacheable` (`se_cacheable`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_sito`,`nome`,`template`,`schema_html`,`tema_css`,`se_sitemap`,`se_cacheable`,`id_contenuti`),
  CONSTRAINT `pagine_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`),
  CONSTRAINT `pagine_ibfk_02_nofollow` FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`),
  CONSTRAINT `pagine_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `pagine_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pagine_view` (`id` int, `id_genitore` int, `id_sito` int, `nome` char(255), `template` char(255), `schema_html` char(128), `tema_css` char(32), `id_contenuti` int, `se_sitemap` int, `se_cacheable` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `periodicita` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pianificazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `id_attivita` int DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `id_periodicita` int NOT NULL,
  `cadenza` int DEFAULT NULL,
  `se_lunedi` int DEFAULT NULL,
  `se_martedi` int DEFAULT NULL,
  `se_mercoledi` int DEFAULT NULL,
  `se_giovedi` int DEFAULT NULL,
  `se_venerdi` int DEFAULT NULL,
  `se_sabato` int DEFAULT NULL,
  `se_domenica` int DEFAULT NULL,
  `schema_ripetizione` int DEFAULT NULL,
  `data_elaborazione` date DEFAULT NULL,
  `giorni_estensione` int DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `workspace` text,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_progetto` (`id_progetto`),
  UNIQUE KEY `unica_todo` (`id_todo`),
  UNIQUE KEY `unica_attivita` (`id_attivita`),
  KEY `id_periodicita` (`id_periodicita`),
  KEY `nome` (`nome`),
  KEY `token` (`token`),
  KEY `data_fine` (`data_fine`),
  KEY `data_elaborazione` (`data_elaborazione`),
  KEY `indice` (`id`,`nome`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  KEY `indice_progetto` (`id`,`id_progetto`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  KEY `indice_todo` (`id`,`id_todo`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  KEY `indice_attivita` (`id`,`id_attivita`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  CONSTRAINT `pianificazioni_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pianificazioni_ibfk_02` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`),
  CONSTRAINT `pianificazioni_ibfk_03` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pianificazioni_ibfk_04_nofollow` FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pianificazioni_view` (`id` int, `id_progetto` char(32), `id_todo` int, `id_attivita` int, `nome` char(255), `id_periodicita` int, `periodicita` char(255), `cadenza` int, `se_lunedi` int, `se_martedi` int, `se_mercoledi` int, `se_giovedi` int, `se_venerdi` int, `se_sabato` int, `se_domenica` int, `schema_ripetizione` int, `data_elaborazione` date, `giorni_estensione` int, `data_fine` date, `workspace` text, `token` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `popup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `id_sito` int DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` text,
  `html_id` char(128) DEFAULT NULL,
  `html_class` char(128) DEFAULT NULL,
  `html_class_attivazione` char(128) DEFAULT NULL,
  `n_scroll` int DEFAULT NULL,
  `n_secondi` int DEFAULT NULL,
  `template` char(128) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `se_ovunque` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_sito` (`id_sito`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_sito`,`nome`,`html_id`,`html_class`,`html_class_attivazione`,`n_scroll`,`n_secondi`,`template`,`schema_html`,`se_ovunque`),
  CONSTRAINT `popup_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_popup` (`id`),
  CONSTRAINT `popup_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `popup_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `popup_pagine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_pagina` int NOT NULL,
  `id_popup` int NOT NULL,
  `se_presente` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_pagina`,`id_popup`),
  KEY `id_popup` (`id_popup`),
  KEY `id_pagina` (`id_pagina`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_pagina`,`id_popup`,`se_presente`),
  CONSTRAINT `popup_pagine_ibfk_01` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`),
  CONSTRAINT `popup_pagine_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`),
  CONSTRAINT `popup_pagine_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `popup_pagine_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `popup_pagine_view` (`id` int, `id_popup` int, `id_pagina` int, `se_presente` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `popup_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_sito` int, `nome` char(128), `html_id` char(128), `html_class` char(128), `html_class_attivazione` char(128), `n_scroll` int, `n_secondi` int, `template` char(128), `schema_html` char(128), `se_ovunque` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(128));


CREATE TABLE `prezzi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int NOT NULL,
  `id_iva` int NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_listino`,`id_iva`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`id_listino`,`id_iva`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_listino` (`id_listino`),
  KEY `id_iva` (`id_iva`),
  KEY `prezzo` (`prezzo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_prodotto`,`id_articolo`,`prezzo`,`id_listino`,`id_iva`),
  KEY `indice_prodotti` (`id`,`id_prodotto`,`prezzo`,`id_listino`,`id_iva`),
  KEY `indice_articoli` (`id`,`id_articolo`,`prezzo`,`id_listino`,`id_iva`),
  CONSTRAINT `prezzi_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prezzi_ibfk_02` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prezzi_ibfk_03_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`),
  CONSTRAINT `prezzi_ibfk_04_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `prezzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `prezzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prezzi_view` (`id` int, `id_prodotto` char(32), `id_articolo` char(32), `prezzo` decimal(16,5), `id_listino` int, `listino` char(64), `valuta` char(3), `id_iva` int, `iva` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `prodotti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int NOT NULL,
  `nome` char(128) NOT NULL,
  `note` text,
  `note_codifica` text,
  `id_marchio` int DEFAULT NULL,
  `id_produttore` int DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_produttore` (`id_produttore`),
  KEY `nome` (`nome`),
  KEY `codice_produttore` (`codice_produttore`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_marchio`,`id_produttore`,`nome`,`codice_produttore`),
  CONSTRAINT `prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_prodotti` (`id`),
  CONSTRAINT `prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`),
  CONSTRAINT `prodotti_ibfk_03_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prodotti_caratteristiche` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_caratteristica` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_prodotto`,`id_caratteristica`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_prodotto`,`id_caratteristica`,`ordine`),
  CONSTRAINT `prodotti_caratteristiche_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_caratteristiche_ibfk_02_nofollow` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_caratteristiche_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_caratteristiche_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prodotti_caratteristiche_view` (`id` int, `id_prodotto` char(32), `id_caratteristica` int, `caratteristica` char(64), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(99));


CREATE TABLE `prodotti_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_categoria` int NOT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_prodotto`,`id_categoria`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_prodotto`,`id_categoria`,`id_ruolo`,`ordine`),
  CONSTRAINT `prodotti_categorie_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_categorie_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_prodotti` (`id`),
  CONSTRAINT `prodotti_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prodotti_categorie_view` (`id` int, `id_prodotto` char(32), `id_categoria` int, `categoria` text, `id_ruolo` int, `ruolo` char(32), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `prodotti_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `se_prodotto` tinyint(1), `se_servizio` tinyint(1), `nome` char(128), `id_marchio` int, `marchio` char(64), `id_produttore` int, `produttore` varchar(320), `codice_produttore` char(64), `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(161));


CREATE TABLE `progetti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int NOT NULL,
  `id_pianificazione` int DEFAULT NULL,
  `id_cliente` int NOT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `entrate_previste` decimal(16,2) DEFAULT NULL,
  `ore_previste` decimal(16,2) DEFAULT NULL,
  `costi_previsti` decimal(16,2) DEFAULT NULL,
  `note_previsioni` text,
  `entrate_accettazione` decimal(16,2) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `note_accettazione` text,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text,
  `entrate_totali` decimal(16,2) DEFAULT NULL,
  `ore_totali` decimal(16,2) DEFAULT NULL,
  `uscite_totali` decimal(16,2) DEFAULT NULL,
  `note_totali` text,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `nome` (`nome`),
  KEY `data_accettazione` (`data_accettazione`),
  KEY `data_chiusura` (`data_chiusura`),
  KEY `data_archiviazione` (`data_archiviazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_pianificazione`,`id_cliente`,`id_indirizzo`,`nome`,`data_accettazione`,`data_chiusura`,`data_archiviazione`),
  CONSTRAINT `progetti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_progetti` (`id`),
  CONSTRAINT `progetti_ibfk_02_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`),
  CONSTRAINT `progetti_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `progetti_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `progetti_amministrazione_archivio_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_amministrazione_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int NOT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_anagrafica`,`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_anagrafica`,`id_ruolo`,`ordine`),
  CONSTRAINT `progetti_anagrafica_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`),
  CONSTRAINT `progetti_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `progetti_anagrafica_view` (`id` int, `id_progetto` char(32), `progetto` char(255), `id_anagrafica` int, `anagrafica` varchar(320), `id_ruolo` int, `ruolo` char(128), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_categoria`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_categoria`,`ordine`),
  CONSTRAINT `progetti_categorie_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `progetti_categorie_view` (`id` int, `id_progetto` char(32), `progetto` char(255), `id_categoria` int, `categoria` text, `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `progetti_commerciale_archivio_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_commerciale_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_produzione_archivio_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_produzione_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `provincie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_regione` int NOT NULL,
  `nome` varchar(254) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `codice_istat` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_regione`,`nome`),
  UNIQUE KEY `unica_sigla` (`sigla`),
  UNIQUE KEY `unica_codice_istat` (`codice_istat`),
  KEY `id_regione` (`id_regione`),
  KEY `nome` (`nome`),
  KEY `codice_istat` (`codice_istat`),
  KEY `indice` (`id`,`id_regione`,`nome`,`sigla`,`codice_istat`),
  CONSTRAINT `provincie_ibfk_01_nofollow` FOREIGN KEY (`id_regione`) REFERENCES `regioni` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `provincie_view` (`id` int, `id_regione` int, `regione` char(32), `id_stato` int, `stato` char(128), `nome` varchar(254), `sigla` char(8), `codice_istat` char(3), `__label__` varchar(394));


CREATE TABLE `pubblicazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_popup` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `timestamp_inizio` int DEFAULT NULL,
  `timestamp_fine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_popup` (`id_popup`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `timestamp_inizio` (`timestamp_inizio`),
  KEY `timestamp_fine` (`timestamp_fine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_prodotto`,`id_categoria_prodotti`,`id_notizia`,`id_categoria_notizie`,`id_pagina`,`id_popup`,`timestamp_inizio`,`timestamp_fine`),
  CONSTRAINT `pubblicazioni_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pubblicazioni` (`id`),
  CONSTRAINT `pubblicazioni_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_03` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_05` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_06` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_07` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_08` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_09` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pubblicazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pubblicazioni_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `ordine` int, `id_prodotto` char(32), `id_categoria_prodotti` int, `id_notizia` int, `id_categoria_notizie` int, `id_pagina` int, `id_popup` int, `timestamp_inizio` int, `timestamp_fine` int, `__label__` varchar(56));


CREATE TABLE `ranking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(254) NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `nome` (`nome`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`ordine`),
  CONSTRAINT `ranking_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `ranking_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ranking_view` (`id` int, `nome` varchar(254), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(254));


CREATE TABLE `redirect` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_sito` int DEFAULT NULL,
  `codice` int NOT NULL,
  `sorgente` char(255) NOT NULL,
  `destinazione` char(255) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_sito`,`sorgente`),
  KEY `id_sito` (`id_sito`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`codice`,`sorgente`,`destinazione`),
  CONSTRAINT `redirect_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `redirect_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `redirect_view` (`id` int, `id_sito` int, `codice` int, `sorgente` char(255), `destinazione` char(255), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `regimi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `indice` (`id`,`nome`,`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `regimi_view` (`id` int, `nome` char(32), `codice` char(8), `__label__` varchar(41));


CREATE TABLE `regioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_stato` int NOT NULL,
  `nome` char(32) NOT NULL,
  `codice_istat` char(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`codice_istat`),
  KEY `id_stato` (`id_stato`),
  KEY `indice` (`id`,`id_stato`,`nome`,`codice_istat`),
  CONSTRAINT `regioni_ibfk_01_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `regioni_view` (`id` int, `id_stato` int, `stato` char(128), `codice_istat` char(2), `__label__` varchar(161));


CREATE TABLE `reparti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_iva` int NOT NULL,
  `id_settore` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_iva` (`id_iva`),
  KEY `id_settore` (`id_settore`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_iva`,`id_settore`,`nome`),
  CONSTRAINT `reparti_ibfk_01_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `reparti_ibfk_02_nofollow` FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`),
  CONSTRAINT `reparti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `reparti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `reparti_view` (`id` int, `id_iva` int, `iva` decimal(5,2), `id_settore` int, `settore` text, `nome` char(64), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(64));


CREATE TABLE `risorse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `codice` char(6) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_testata` int DEFAULT NULL,
  `giorno_pubblicazione` int DEFAULT NULL,
  `mese_pubblicazione` int DEFAULT NULL,
  `anno_pubblicazione` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_testata` (`id_testata`),
  KEY `giorno_pubblicazione` (`giorno_pubblicazione`),
  KEY `mese_pubblicazione` (`mese_pubblicazione`),
  KEY `anno_pubblicazione` (`anno_pubblicazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`giorno_pubblicazione`,`mese_pubblicazione`,`anno_pubblicazione`),
  CONSTRAINT `risorse_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_risorse` (`id`),
  CONSTRAINT `risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `risorse_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_risorsa` int NOT NULL,
  `id_anagrafica` int NOT NULL,
  `id_ruolo` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_risorsa`,`id_anagrafica`,`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_anagrafica`,`id_ruolo`,`ordine`),
  CONSTRAINT `risorse_anagrafica_ibfk_01` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `risorse_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`),
  CONSTRAINT `risorse_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `risorse_anagrafica_view` (`id` int, `id_risorsa` int, `risorsa` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `id_ruolo` int, `ruolo` text, `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `risorse_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_risorsa` int NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_categoria`,`ordine`),
  CONSTRAINT `risorse_categorie_ibfk_01` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `risorse_categorie_view` (`id` int, `id_risorsa` int, `risorsa` char(64), `id_categoria` int, `categorie_risorse_path( risorse_categorie.id_categoria )` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `risorse_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `codice` char(6), `nome` char(64), `id_testata` int, `testata` int, `giorno_pubblicazione` int, `mese_pubblicazione` int, `anno_pubblicazione` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(71));


CREATE TABLE `ruoli_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_organizzazioni` int DEFAULT NULL,
  `se_risorse` int DEFAULT NULL,
  `se_progetti` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_organizzazioni` (`se_organizzazioni`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_progetti` (`se_progetti`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`se_organizzazioni`,`se_risorse`,`se_progetti`),
  CONSTRAINT `ruoli_anagrafica_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_anagrafica_view` (`id` int, `id_genitore` int, `nome` char(128), `se_organizzazioni` int, `se_risorse` int, `se_progetti` int, `__label__` text);


CREATE TABLE `mail_sent` (
  `id` int NOT NULL,
  `id_mail` int DEFAULT NULL,
  `id_mailing` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_composizione` int NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `destinatari_cc` text,
  `destinatari_bcc` text,
  `oggetto` char(254) NOT NULL,
  `corpo` text NOT NULL,
  `allegati` text,
  `headers` text,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int DEFAULT '0',
  `timestamp_invio` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_mail`,`id_mailing`),
  KEY `id_mail` (`id_mail`),
  KEY `id_mailing` (`id_mailing`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_mail`,`id_mailing`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`),
  CONSTRAINT `mail_sent_ibfk_01_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mail_sent_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mail_sent_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `mail_sent_view` (`id` int, `id_mail` int, `id_mailing` int, `ordine` int, `timestamp_composizione` int, `mittente` char(254), `destinatari` text, `destinatari_cc` text, `destinatari_bcc` text, `oggetto` char(254), `allegati` text, `headers` text, `server` char(128), `host` char(254), `port` char(6), `user` char(254), `password` char(254), `token` char(128), `tentativi` int, `timestamp_invio` int, `data_ora_invio` varchar(10), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `mail_view` (`id` int, `id_anagrafica` int, `anagrafica` varchar(320), `indirizzo` char(128), `se_notifiche` tinyint(1), `se_pec` tinyint(1), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(449));


CREATE TABLE `marchi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`),
  CONSTRAINT `marchi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `marchi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `marchi_view` (`id` int, `nome` char(64), `__label__` char(64));


CREATE TABLE `mastri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_tipologia` int NOT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_tipologia`,`nome`),
  CONSTRAINT `mastri_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `mastri` (`id`),
  CONSTRAINT `mastri_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_mastri` (`id`),
  CONSTRAINT `mastri_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `mastri_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `mastri_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `nome` char(64), `__label__` text);


CREATE TABLE `menu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lingua` int NOT NULL,
  `id_pagina` int NOT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `target` char(16) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_lingua`,`id_pagina`,`menu`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`menu`),
  UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`menu`),
  UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`menu`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `indice` (`id`,`id_lingua`,`id_pagina`,`ordine`,`menu`,`nome`,`target`,`sottopagine`),
  KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`menu`,`nome`),
  KEY `indice_categorie_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`menu`,`nome`),
  KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`menu`,`nome`),
  KEY `menu_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `menu_ibfk_99_nofollow` (`id_account_aggiornamento`),
  CONSTRAINT `menu_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `menu_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_03` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_04` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_05` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menu_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `menu_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `menu_view` (`id` int, `id_lingua` int, `id_pagina` int, `id_categoria_prodotti` int, `id_categoria_notizie` int, `id_categoria_risorse` int, `ordine` int, `menu` char(32), `nome` char(128), `target` char(16), `sottopagine` char(32), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(216));


CREATE TABLE `metadati` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lingua` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_immagine` int DEFAULT NULL,
  `id_video` int DEFAULT NULL,
  `id_audio` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `testo` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_lingua`,`id_anagrafica`,`nome`),
  UNIQUE KEY `unica_pagina` (`id_lingua`,`id_pagina`,`nome`),
  UNIQUE KEY `unica_prodotto` (`id_lingua`,`id_prodotto`,`nome`),
  UNIQUE KEY `unica_articolo` (`id_lingua`,`id_articolo`,`nome`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_lingua`,`id_categoria_prodotti`,`nome`),
  UNIQUE KEY `unica_notizia` (`id_lingua`,`id_notizia`,`nome`),
  UNIQUE KEY `unica_categoria_notizie` (`id_lingua`,`id_categoria_notizie`,`nome`),
  UNIQUE KEY `unica_risorsa` (`id_lingua`,`id_risorsa`,`nome`),
  UNIQUE KEY `unica_categoria_risorse` (`id_lingua`,`id_categoria_risorse`,`nome`),
  UNIQUE KEY `unica_immagine` (`id_lingua`,`id_immagine`,`nome`),
  UNIQUE KEY `unica_video` (`id_lingua`,`id_video`,`nome`),
  UNIQUE KEY `unica_audio` (`id_lingua`,`id_audio`,`nome`),
  UNIQUE KEY `unica_file` (`id_lingua`,`id_file`,`nome`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_immagine` (`id_immagine`),
  KEY `id_video` (`id_video`),
  KEY `id_audio` (`id_audio`),
  KEY `id_file` (`id_file`),
  KEY `indice` (`id`,`id_lingua`,`nome`,`testo`(255)),
  KEY `indice_anagrafica` (`id`,`id_lingua`,`id_anagrafica`,`nome`,`testo`(255)),
  KEY `indice_pagina` (`id`,`id_lingua`,`id_pagina`,`nome`,`testo`(255)),
  KEY `indice_prodotti` (`id`,`id_lingua`,`id_prodotto`,`nome`,`testo`(255)),
  KEY `indice_articoli` (`id`,`id_lingua`,`id_articolo`,`nome`,`testo`(255)),
  KEY `indice_categorie_prodotti` (`id`,`id_lingua`,`id_categoria_prodotti`,`nome`,`testo`(255)),
  KEY `indice_notizie` (`id`,`id_lingua`,`id_notizia`,`nome`,`testo`(255)),
  KEY `indice_categoria_notizie` (`id`,`id_lingua`,`id_categoria_notizie`,`nome`,`testo`(255)),
  KEY `indice_risorse` (`id`,`id_lingua`,`id_risorsa`,`nome`,`testo`(255)),
  KEY `indice_categorie_risorse` (`id`,`id_lingua`,`id_categoria_risorse`,`nome`,`testo`(255)),
  KEY `indice_immagini` (`id`,`id_lingua`,`id_immagine`,`nome`,`testo`(255)),
  KEY `indice_video` (`id`,`id_lingua`,`id_video`,`nome`,`testo`(255)),
  KEY `indice_audio` (`id`,`id_lingua`,`id_audio`,`nome`,`testo`(255)),
  KEY `indice_file` (`id`,`id_lingua`,`id_file`,`nome`,`testo`(255)),
  KEY `metadati_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `metadati_ibfk_99_nofollow` (`id_account_aggiornamento`),
  CONSTRAINT `metadati_ibfk_01_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `metadati_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_03` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_05` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_06` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_07` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_08` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_09` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_10` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_11` FOREIGN KEY (`id_immagine`) REFERENCES `immagini` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_12` FOREIGN KEY (`id_video`) REFERENCES `video` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_13` FOREIGN KEY (`id_audio`) REFERENCES `audio` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_14` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `metadati_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `metadati_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `metadati_view` (`id` int, `id_lingua` int, `ietf` char(36), `id_anagrafica` int, `id_pagina` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `id_notizia` int, `id_categoria_notizie` int, `id_risorsa` int, `id_categoria_risorse` int, `id_immagine` int, `id_video` int, `id_audio` int, `id_file` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `notizie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`nome`),
  CONSTRAINT `notizie_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_notizie` (`id`),
  CONSTRAINT `notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `notizie_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_notizia` int NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_notizia`,`id_categoria`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_notizia`,`id_categoria`,`ordine`),
  CONSTRAINT `notizie_categorie_ibfk_01` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_categorie_ibfk_02` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notizie_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `notizie_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `notizie_categorie_view` (`id` int, `id_notizia` int, `notizia` char(255), `id_categoria` int, `categoria` text, `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `notizie_view` (`id` int, `id_tipologia` int, `tipologia` char(255), `nome` char(255), `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(255));


CREATE TABLE `organizzazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`id_anagrafica`,`id_ruolo`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`id_anagrafica`,`id_ruolo`),
  CONSTRAINT `organizzazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `organizzazioni` (`id`),
  CONSTRAINT `organizzazioni_ibfk_02` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `organizzazioni_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`),
  CONSTRAINT `organizzazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `organizzazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `organizzazioni_view` (`id` int, `id_genitore` int, `ordine` int, `id_anagrafica` int, `anagrafica` varchar(320), `id_ruolo` int, `ruolo` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `pagamenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `id_documento` int DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `id_iban` int DEFAULT NULL,
  `importo_netto_totale` decimal(9,2) NOT NULL,
  `id_iva` int DEFAULT NULL,
  `id_listino` int DEFAULT NULL,
  `timestamp_pagamento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `ordine` (`ordine`),
  KEY `id_documento` (`id_documento`),
  KEY `id_mastro_provenienza` (`id_mastro_provenienza`),
  KEY `id_mastro_destinazione` (`id_mastro_destinazione`),
  KEY `id_iban` (`id_iban`),
  KEY `id_listino` (`id_listino`),
  KEY `id_iva` (`id_iva`),
  KEY `timestamp_pagamento` (`timestamp_pagamento`),
  KEY `importo_netto_totale` (`importo_netto_totale`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_documento`,`timestamp_pagamento`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_listino`,`id_iban`,`importo_netto_totale`,`id_iva`),
  CONSTRAINT `pagamenti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pagamenti` (`id`),
  CONSTRAINT `pagamenti_ibfk_02` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`),
  CONSTRAINT `pagamenti_ibfk_03_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`),
  CONSTRAINT `pagamenti_ibfk_04_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`),
  CONSTRAINT `pagamenti_ibfk_05_nofollow` FOREIGN KEY (`id_iban`) REFERENCES `iban` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pagamenti_ibfk_06_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`),
  CONSTRAINT `pagamenti_ibfk_07_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `pagamenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pagamenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pagamenti_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `ordine` int, `nome` char(255), `note` text, `id_documento` int, `id_mastro_provenienza` int, `mastro_provenienza` char(64), `id_mastro_destinazione` int, `mastro_destinazione` char(64), `id_iban` int, `importo_netto_totale` decimal(9,2), `id_iva` int, `iva` char(64), `id_listino` int, `listino` char(64), `timestamp_pagamento` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(255));


CREATE TABLE `pagine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_sito` int NOT NULL DEFAULT '1',
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `template` char(255) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `tema_css` char(32) DEFAULT NULL,
  `id_contenuti` int DEFAULT NULL,
  `se_sitemap` int DEFAULT NULL,
  `se_cacheable` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_sito` (`id_sito`),
  KEY `nome` (`nome`),
  KEY `id_contenuti` (`id_contenuti`),
  KEY `se_sitemap` (`se_sitemap`),
  KEY `se_cacheable` (`se_cacheable`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_sito`,`nome`,`template`,`schema_html`,`tema_css`,`se_sitemap`,`se_cacheable`,`id_contenuti`),
  CONSTRAINT `pagine_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `pagine` (`id`),
  CONSTRAINT `pagine_ibfk_02_nofollow` FOREIGN KEY (`id_contenuti`) REFERENCES `contenuti` (`id`),
  CONSTRAINT `pagine_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `pagine_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pagine_view` (`id` int, `id_genitore` int, `id_sito` int, `nome` char(255), `template` char(255), `schema_html` char(128), `tema_css` char(32), `id_contenuti` int, `se_sitemap` int, `se_cacheable` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `periodicita` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pianificazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `id_attivita` int DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text,
  `id_periodicita` int NOT NULL,
  `cadenza` int DEFAULT NULL,
  `se_lunedi` int DEFAULT NULL,
  `se_martedi` int DEFAULT NULL,
  `se_mercoledi` int DEFAULT NULL,
  `se_giovedi` int DEFAULT NULL,
  `se_venerdi` int DEFAULT NULL,
  `se_sabato` int DEFAULT NULL,
  `se_domenica` int DEFAULT NULL,
  `schema_ripetizione` int DEFAULT NULL,
  `data_elaborazione` date DEFAULT NULL,
  `giorni_estensione` int DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `workspace` text,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_progetto` (`id_progetto`),
  UNIQUE KEY `unica_todo` (`id_todo`),
  UNIQUE KEY `unica_attivita` (`id_attivita`),
  KEY `id_periodicita` (`id_periodicita`),
  KEY `nome` (`nome`),
  KEY `token` (`token`),
  KEY `data_fine` (`data_fine`),
  KEY `data_elaborazione` (`data_elaborazione`),
  KEY `indice` (`id`,`nome`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  KEY `indice_progetto` (`id`,`id_progetto`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  KEY `indice_todo` (`id`,`id_todo`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  KEY `indice_attivita` (`id`,`id_attivita`,`id_periodicita`,`cadenza`,`se_lunedi`,`se_martedi`,`se_mercoledi`,`se_giovedi`,`se_venerdi`,`se_sabato`,`se_domenica`,`schema_ripetizione`,`data_elaborazione`,`giorni_estensione`,`data_fine`,`token`),
  CONSTRAINT `pianificazioni_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pianificazioni_ibfk_02` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`),
  CONSTRAINT `pianificazioni_ibfk_03` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pianificazioni_ibfk_04_nofollow` FOREIGN KEY (`id_periodicita`) REFERENCES `periodicita` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pianificazioni_view` (`id` int, `id_progetto` char(32), `id_todo` int, `id_attivita` int, `nome` char(255), `id_periodicita` int, `periodicita` char(255), `cadenza` int, `se_lunedi` int, `se_martedi` int, `se_mercoledi` int, `se_giovedi` int, `se_venerdi` int, `se_sabato` int, `se_domenica` int, `schema_ripetizione` int, `data_elaborazione` date, `giorni_estensione` int, `data_fine` date, `workspace` text, `token` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `popup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `id_sito` int DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` text,
  `html_id` char(128) DEFAULT NULL,
  `html_class` char(128) DEFAULT NULL,
  `html_class_attivazione` char(128) DEFAULT NULL,
  `n_scroll` int DEFAULT NULL,
  `n_secondi` int DEFAULT NULL,
  `template` char(128) DEFAULT NULL,
  `schema_html` char(128) DEFAULT NULL,
  `se_ovunque` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_sito` (`id_sito`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_sito`,`nome`,`html_id`,`html_class`,`html_class_attivazione`,`n_scroll`,`n_secondi`,`template`,`schema_html`,`se_ovunque`),
  CONSTRAINT `popup_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_popup` (`id`),
  CONSTRAINT `popup_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `popup_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `popup_pagine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_pagina` int NOT NULL,
  `id_popup` int NOT NULL,
  `se_presente` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_pagina`,`id_popup`),
  KEY `id_popup` (`id_popup`),
  KEY `id_pagina` (`id_pagina`),
  KEY `se_presente` (`se_presente`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_pagina`,`id_popup`,`se_presente`),
  CONSTRAINT `popup_pagine_ibfk_01` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`),
  CONSTRAINT `popup_pagine_ibfk_02_nofollow` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`),
  CONSTRAINT `popup_pagine_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `popup_pagine_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `popup_pagine_view` (`id` int, `id_popup` int, `id_pagina` int, `se_presente` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `popup_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_sito` int, `nome` char(128), `html_id` char(128), `html_class` char(128), `html_class_attivazione` char(128), `n_scroll` int, `n_secondi` int, `template` char(128), `schema_html` char(128), `se_ovunque` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(128));


CREATE TABLE `prezzi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `prezzo` decimal(16,5) NOT NULL,
  `id_listino` int NOT NULL,
  `id_iva` int NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_listino`,`id_iva`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`id_listino`,`id_iva`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_listino` (`id_listino`),
  KEY `id_iva` (`id_iva`),
  KEY `prezzo` (`prezzo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_prodotto`,`id_articolo`,`prezzo`,`id_listino`,`id_iva`),
  KEY `indice_prodotti` (`id`,`id_prodotto`,`prezzo`,`id_listino`,`id_iva`),
  KEY `indice_articoli` (`id`,`id_articolo`,`prezzo`,`id_listino`,`id_iva`),
  CONSTRAINT `prezzi_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prezzi_ibfk_02` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prezzi_ibfk_03_nofollow` FOREIGN KEY (`id_listino`) REFERENCES `listini` (`id`),
  CONSTRAINT `prezzi_ibfk_04_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `prezzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`),
  CONSTRAINT `prezzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prezzi_view` (`id` int, `id_prodotto` char(32), `id_articolo` char(32), `prezzo` decimal(16,5), `id_listino` int, `listino` char(64), `valuta` char(3), `id_iva` int, `iva` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `prodotti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int NOT NULL,
  `nome` char(128) NOT NULL,
  `note` text,
  `note_codifica` text,
  `id_marchio` int DEFAULT NULL,
  `id_produttore` int DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_marchio` (`id_marchio`),
  KEY `id_produttore` (`id_produttore`),
  KEY `nome` (`nome`),
  KEY `codice_produttore` (`codice_produttore`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_marchio`,`id_produttore`,`nome`,`codice_produttore`),
  CONSTRAINT `prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_prodotti` (`id`),
  CONSTRAINT `prodotti_ibfk_02_nofollow` FOREIGN KEY (`id_marchio`) REFERENCES `marchi` (`id`),
  CONSTRAINT `prodotti_ibfk_03_nofollow` FOREIGN KEY (`id_produttore`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prodotti_caratteristiche` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_caratteristica` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `note` text,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_prodotto`,`id_caratteristica`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_prodotto`,`id_caratteristica`,`ordine`),
  CONSTRAINT `prodotti_caratteristiche_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_caratteristiche_ibfk_02_nofollow` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_caratteristiche_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_caratteristiche_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prodotti_caratteristiche_view` (`id` int, `id_prodotto` char(32), `id_caratteristica` int, `caratteristica` char(64), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(99));


CREATE TABLE `prodotti_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_prodotto` char(32) NOT NULL,
  `id_categoria` int NOT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_prodotto`,`id_categoria`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_prodotto`,`id_categoria`,`id_ruolo`,`ordine`),
  CONSTRAINT `prodotti_categorie_ibfk_01` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `prodotti_categorie_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_prodotti` (`id`),
  CONSTRAINT `prodotti_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `prodotti_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `prodotti_categorie_view` (`id` int, `id_prodotto` char(32), `id_categoria` int, `categoria` text, `id_ruolo` int, `ruolo` char(32), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `prodotti_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `se_prodotto` tinyint(1), `se_servizio` tinyint(1), `nome` char(128), `id_marchio` int, `marchio` char(64), `id_produttore` int, `produttore` varchar(320), `codice_produttore` char(64), `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(161));


CREATE TABLE `progetti` (
  `id` char(32) NOT NULL,
  `id_tipologia` int NOT NULL,
  `id_pianificazione` int DEFAULT NULL,
  `id_cliente` int NOT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `note` text,
  `entrate_previste` decimal(16,2) DEFAULT NULL,
  `ore_previste` decimal(16,2) DEFAULT NULL,
  `costi_previsti` decimal(16,2) DEFAULT NULL,
  `note_previsioni` text,
  `entrate_accettazione` decimal(16,2) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `note_accettazione` text,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text,
  `entrate_totali` decimal(16,2) DEFAULT NULL,
  `ore_totali` decimal(16,2) DEFAULT NULL,
  `uscite_totali` decimal(16,2) DEFAULT NULL,
  `note_totali` text,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `nome` (`nome`),
  KEY `data_accettazione` (`data_accettazione`),
  KEY `data_chiusura` (`data_chiusura`),
  KEY `data_archiviazione` (`data_archiviazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_pianificazione`,`id_cliente`,`id_indirizzo`,`nome`,`data_accettazione`,`data_chiusura`,`data_archiviazione`),
  CONSTRAINT `progetti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_progetti` (`id`),
  CONSTRAINT `progetti_ibfk_02_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`),
  CONSTRAINT `progetti_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `progetti_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `progetti_amministrazione_archivio_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_amministrazione_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int NOT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_anagrafica`,`id_ruolo`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_anagrafica`,`id_ruolo`,`ordine`),
  CONSTRAINT `progetti_anagrafica_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`),
  CONSTRAINT `progetti_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `progetti_anagrafica_view` (`id` int, `id_progetto` char(32), `progetto` char(255), `id_anagrafica` int, `anagrafica` varchar(320), `id_ruolo` int, `ruolo` char(128), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_progetto` char(32) NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_progetto`,`id_categoria`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_progetto`,`id_categoria`,`ordine`),
  CONSTRAINT `progetti_categorie_ibfk_01` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `progetti_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `progetti_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `progetti_categorie_view` (`id` int, `id_progetto` char(32), `progetto` char(255), `id_categoria` int, `categoria` text, `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `progetti_commerciale_archivio_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_commerciale_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_produzione_archivio_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_produzione_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `progetti_view` (`id` char(32), `id_tipologia` int, `tipologia` char(64), `id_pianificazione` int, `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `nome` char(255), `entrate_previste` decimal(16,2), `ore_previste` decimal(16,2), `costi_previsti` decimal(16,2), `entrate_accettazione` decimal(16,2), `data_accettazione` date, `data_chiusura` date, `entrate_totali` decimal(16,2), `uscite_totali` decimal(16,2), `data_archiviazione` date, `categorie` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `provincie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_regione` int NOT NULL,
  `nome` varchar(254) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `codice_istat` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_regione`,`nome`),
  UNIQUE KEY `unica_sigla` (`sigla`),
  UNIQUE KEY `unica_codice_istat` (`codice_istat`),
  KEY `id_regione` (`id_regione`),
  KEY `nome` (`nome`),
  KEY `codice_istat` (`codice_istat`),
  KEY `indice` (`id`,`id_regione`,`nome`,`sigla`,`codice_istat`),
  CONSTRAINT `provincie_ibfk_01_nofollow` FOREIGN KEY (`id_regione`) REFERENCES `regioni` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `provincie_view` (`id` int, `id_regione` int, `regione` char(32), `id_stato` int, `stato` char(128), `nome` varchar(254), `sigla` char(8), `codice_istat` char(3), `__label__` varchar(394));


CREATE TABLE `pubblicazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_popup` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `note` char(254) DEFAULT NULL,
  `timestamp_inizio` int DEFAULT NULL,
  `timestamp_fine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_popup` (`id_popup`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `timestamp_inizio` (`timestamp_inizio`),
  KEY `timestamp_fine` (`timestamp_fine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_prodotto`,`id_categoria_prodotti`,`id_notizia`,`id_categoria_notizie`,`id_pagina`,`id_popup`,`timestamp_inizio`,`timestamp_fine`),
  CONSTRAINT `pubblicazioni_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_pubblicazioni` (`id`),
  CONSTRAINT `pubblicazioni_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_03` FOREIGN KEY (`id_popup`) REFERENCES `popup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_05` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_06` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_07` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_08` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_09` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pubblicazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `pubblicazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `pubblicazioni_view` (`id` int, `id_tipologia` int, `tipologia` char(32), `ordine` int, `id_prodotto` char(32), `id_categoria_prodotti` int, `id_notizia` int, `id_categoria_notizie` int, `id_pagina` int, `id_popup` int, `timestamp_inizio` int, `timestamp_fine` int, `__label__` varchar(56));


CREATE TABLE `ranking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(254) NOT NULL,
  `ordine` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `nome` (`nome`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`nome`,`ordine`),
  CONSTRAINT `ranking_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `ranking_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ranking_view` (`id` int, `nome` varchar(254), `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(254));


CREATE TABLE `redirect` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_sito` int DEFAULT NULL,
  `codice` int NOT NULL,
  `sorgente` char(255) NOT NULL,
  `destinazione` char(255) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_sito`,`sorgente`),
  KEY `id_sito` (`id_sito`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`codice`,`sorgente`,`destinazione`),
  CONSTRAINT `redirect_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `redirect_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `redirect_view` (`id` int, `id_sito` int, `codice` int, `sorgente` char(255), `destinazione` char(255), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `regimi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` char(32) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `indice` (`id`,`nome`,`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `regimi_view` (`id` int, `nome` char(32), `codice` char(8), `__label__` varchar(41));


CREATE TABLE `regioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_stato` int NOT NULL,
  `nome` char(32) NOT NULL,
  `codice_istat` char(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`codice_istat`),
  KEY `id_stato` (`id_stato`),
  KEY `indice` (`id`,`id_stato`,`nome`,`codice_istat`),
  CONSTRAINT `regioni_ibfk_01_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `regioni_view` (`id` int, `id_stato` int, `stato` char(128), `codice_istat` char(2), `__label__` varchar(161));


CREATE TABLE `reparti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_iva` int NOT NULL,
  `id_settore` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_iva` (`id_iva`),
  KEY `id_settore` (`id_settore`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_iva`,`id_settore`,`nome`),
  CONSTRAINT `reparti_ibfk_01_nofollow` FOREIGN KEY (`id_iva`) REFERENCES `iva` (`id`),
  CONSTRAINT `reparti_ibfk_02_nofollow` FOREIGN KEY (`id_settore`) REFERENCES `settori` (`id`),
  CONSTRAINT `reparti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `reparti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `reparti_view` (`id` int, `id_iva` int, `iva` decimal(5,2), `id_settore` int, `settore` text, `nome` char(64), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(64));


CREATE TABLE `risorse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `codice` char(6) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text,
  `id_testata` int DEFAULT NULL,
  `giorno_pubblicazione` int DEFAULT NULL,
  `mese_pubblicazione` int DEFAULT NULL,
  `anno_pubblicazione` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_testata` (`id_testata`),
  KEY `giorno_pubblicazione` (`giorno_pubblicazione`),
  KEY `mese_pubblicazione` (`mese_pubblicazione`),
  KEY `anno_pubblicazione` (`anno_pubblicazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_testata`,`giorno_pubblicazione`,`mese_pubblicazione`,`anno_pubblicazione`),
  CONSTRAINT `risorse_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_risorse` (`id`),
  CONSTRAINT `risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `risorse_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_risorsa` int NOT NULL,
  `id_anagrafica` int NOT NULL,
  `id_ruolo` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_risorsa`,`id_anagrafica`,`id_ruolo`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_anagrafica`,`id_ruolo`,`ordine`),
  CONSTRAINT `risorse_anagrafica_ibfk_01` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_anagrafica_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `risorse_anagrafica_ibfk_03_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_anagrafica` (`id`),
  CONSTRAINT `risorse_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `risorse_anagrafica_view` (`id` int, `id_risorsa` int, `risorsa` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `id_ruolo` int, `ruolo` text, `ordine` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `risorse_categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_risorsa` int NOT NULL,
  `id_categoria` int NOT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria` (`id_categoria`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_risorsa`,`id_categoria`,`ordine`),
  CONSTRAINT `risorse_categorie_ibfk_01` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_categorie_ibfk_02_nofollow` FOREIGN KEY (`id_categoria`) REFERENCES `categorie_risorse` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `risorse_categorie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `risorse_categorie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `risorse_categorie_view` (`id` int, `id_risorsa` int, `risorsa` char(64), `id_categoria` int, `categorie_risorse_path( risorse_categorie.id_categoria )` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `risorse_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `codice` char(6), `nome` char(64), `id_testata` int, `testata` int, `giorno_pubblicazione` int, `mese_pubblicazione` int, `anno_pubblicazione` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(71));


CREATE TABLE `ruoli_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_organizzazioni` int DEFAULT NULL,
  `se_risorse` int DEFAULT NULL,
  `se_progetti` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_organizzazioni` (`se_organizzazioni`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_progetti` (`se_progetti`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`se_organizzazioni`,`se_risorse`,`se_progetti`),
  CONSTRAINT `ruoli_anagrafica_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_anagrafica_view` (`id` int, `id_genitore` int, `nome` char(128), `se_organizzazioni` int, `se_risorse` int, `se_progetti` int, `__label__` text);


CREATE TABLE `ruoli_audio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int DEFAULT NULL,
  `se_pagine` int DEFAULT NULL,
  `se_prodotti` int DEFAULT NULL,
  `se_articoli` int DEFAULT NULL,
  `se_categorie_prodotti` int DEFAULT NULL,
  `se_notizie` int DEFAULT NULL,
  `se_categorie_notizie` int DEFAULT NULL,
  `se_risorse` int DEFAULT NULL,
  `se_categorie_risorse` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_anagrafica` (`se_anagrafica`),
  KEY `se_pagine` (`se_pagine`),
  KEY `se_prodotti` (`se_prodotti`),
  KEY `se_articoli` (`se_articoli`),
  KEY `se_categorie_prodotti` (`se_categorie_prodotti`),
  KEY `se_notizie` (`se_notizie`),
  KEY `se_categorie_notizie` (`se_categorie_notizie`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_categorie_risorse` (`se_categorie_risorse`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`),
  CONSTRAINT `ruoli_audio_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_audio` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_audio_view` (`id` int, `id_genitore` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_anagrafica` int, `se_pagine` int, `se_prodotti` int, `se_articoli` int, `se_categorie_prodotti` int, `se_notizie` int, `se_categorie_notizie` int, `se_risorse` int, `se_categorie_risorse` int, `__label__` text);


CREATE TABLE `ruoli_file` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int DEFAULT NULL,
  `se_pagine` int DEFAULT NULL,
  `se_template` int DEFAULT NULL,
  `se_prodotti` int DEFAULT NULL,
  `se_articoli` int DEFAULT NULL,
  `se_categorie_prodotti` int DEFAULT NULL,
  `se_notizie` int DEFAULT NULL,
  `se_categorie_notizie` int DEFAULT NULL,
  `se_risorse` int DEFAULT NULL,
  `se_categorie_risorse` int DEFAULT NULL,
  `se_mail` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_anagrafica` (`se_anagrafica`),
  KEY `se_pagine` (`se_pagine`),
  KEY `se_template` (`se_template`),
  KEY `se_prodotti` (`se_prodotti`),
  KEY `se_articoli` (`se_articoli`),
  KEY `se_categorie_prodotti` (`se_categorie_prodotti`),
  KEY `se_notizie` (`se_notizie`),
  KEY `se_categorie_notizie` (`se_categorie_notizie`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_categorie_risorse` (`se_categorie_risorse`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_template`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`),
  CONSTRAINT `ruoli_file_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_file_view` (`id` int, `id_genitore` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_anagrafica` int, `se_pagine` int, `se_prodotti` int, `se_articoli` int, `se_categorie_prodotti` int, `se_notizie` int, `se_categorie_notizie` int, `se_risorse` int, `se_categorie_risorse` int, `se_mail` int, `__label__` text);


CREATE TABLE `ruoli_immagini` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine_scalamento` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int DEFAULT NULL,
  `se_pagine` int DEFAULT NULL,
  `se_prodotti` int DEFAULT NULL,
  `se_articoli` int DEFAULT NULL,
  `se_categorie_prodotti` int DEFAULT NULL,
  `se_notizie` int DEFAULT NULL,
  `se_categorie_notizie` int DEFAULT NULL,
  `se_risorse` int DEFAULT NULL,
  `se_categorie_risorse` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine_scalamento` (`ordine_scalamento`),
  KEY `se_anagrafica` (`se_anagrafica`),
  KEY `se_pagine` (`se_pagine`),
  KEY `se_prodotti` (`se_prodotti`),
  KEY `se_articoli` (`se_articoli`),
  KEY `se_categorie_prodotti` (`se_categorie_prodotti`),
  KEY `se_notizie` (`se_notizie`),
  KEY `se_categorie_notizie` (`se_categorie_notizie`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_categorie_risorse` (`se_categorie_risorse`),
  KEY `indice` (`id`,`id_genitore`,`ordine_scalamento`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`),
  CONSTRAINT `ruoli_immagini_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_immagini` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_immagini_view` (`id` int, `id_genitore` int, `ordine_scalamento` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_anagrafica` int, `se_pagine` int, `se_prodotti` int, `se_articoli` int, `se_categorie_prodotti` int, `se_notizie` int, `se_categorie_notizie` int, `se_risorse` int, `se_categorie_risorse` int, `__label__` text);


CREATE TABLE `ruoli_indirizzi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_sede_legale` int DEFAULT NULL,
  `se_sede_operativa` int DEFAULT NULL,
  `se_residenza` int DEFAULT NULL,
  `se_domicilio` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_sede_legale` (`se_sede_legale`),
  KEY `se_sede_operativa` (`se_sede_operativa`),
  KEY `se_residenza` (`se_residenza`),
  KEY `se_domicilio` (`se_domicilio`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_sede_legale`,`se_sede_operativa`,`se_residenza`,`se_domicilio`),
  CONSTRAINT `ruoli_indirizzi_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_indirizzi_view` (`id` int, `id_genitore` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `se_sede_legale` int, `se_sede_operativa` int, `se_residenza` int, `se_domicilio` int, `__label__` text);


CREATE TABLE `ruoli_prodotti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`nome`),
  CONSTRAINT `ruoli_prodotti_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_prodotti_view` (`id` int, `id_genitore` int, `nome` char(32), `__label__` text);


CREATE TABLE `ruoli_video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int DEFAULT NULL,
  `se_pagine` int DEFAULT NULL,
  `se_prodotti` int DEFAULT NULL,
  `se_articoli` int DEFAULT NULL,
  `se_categorie_prodotti` int DEFAULT NULL,
  `se_notizie` int DEFAULT NULL,
  `se_categorie_notizie` int DEFAULT NULL,
  `se_risorse` int DEFAULT NULL,
  `se_categorie_risorse` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `se_anagrafica` (`se_anagrafica`),
  KEY `se_pagine` (`se_pagine`),
  KEY `se_prodotti` (`se_prodotti`),
  KEY `se_articoli` (`se_articoli`),
  KEY `se_categorie_prodotti` (`se_categorie_prodotti`),
  KEY `se_notizie` (`se_notizie`),
  KEY `se_categorie_notizie` (`se_categorie_notizie`),
  KEY `se_risorse` (`se_risorse`),
  KEY `se_categorie_risorse` (`se_categorie_risorse`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_pagine`,`se_prodotti`,`se_articoli`,`se_categorie_prodotti`,`se_notizie`,`se_categorie_notizie`,`se_risorse`,`se_categorie_risorse`),
  CONSTRAINT `ruoli_video_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `ruoli_video` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `ruoli_video_view` (`id` int, `id_genitore` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_anagrafica` int, `se_pagine` int, `se_prodotti` int, `se_articoli` int, `se_categorie_prodotti` int, `se_notizie` int, `se_categorie_notizie` int, `se_risorse` int, `se_categorie_risorse` int, `__label__` text);


CREATE TABLE `settori` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `soprannome` char(64) DEFAULT NULL,
  `ateco` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`ateco`),
  KEY `id_genitore` (`id_genitore`),
  KEY `nome` (`nome`),
  KEY `ateco` (`ateco`),
  KEY `indice` (`id`,`id_genitore`,`nome`,`soprannome`,`ateco`),
  CONSTRAINT `settori_ibfk_01` FOREIGN KEY (`id_genitore`) REFERENCES `settori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `settori_view` (`id` int, `id_genitore` int, `nome` char(128), `soprannome` char(64), `ateco` char(32), `__label__` text);


CREATE TABLE `sms_out` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_telefono` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_composizione` int NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `corpo` text NOT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int DEFAULT '0',
  `timestamp_invio` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_telefono` (`id_telefono`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_telefono`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`),
  CONSTRAINT `sms_out_ibfk_01_nofollow` FOREIGN KEY (`id_telefono`) REFERENCES `telefoni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sms_out_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `sms_out_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `sms_out_view` (`id` int, `id_telefono` int, `ordine` int, `timestamp_composizione` int, `mittente` char(254), `destinatari` text, `corpo` text, `server` char(128), `host` char(254), `port` char(6), `user` char(254), `password` char(254), `token` char(128), `tentativi` int, `timestamp_invio` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `sms_sent` (
  `id` int NOT NULL,
  `id_telefono` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `timestamp_composizione` int NOT NULL,
  `mittente` char(254) NOT NULL,
  `destinatari` text NOT NULL,
  `corpo` text NOT NULL,
  `server` char(128) DEFAULT NULL,
  `host` char(254) DEFAULT NULL,
  `port` char(6) DEFAULT NULL,
  `user` char(254) DEFAULT NULL,
  `password` char(254) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `tentativi` int DEFAULT '0',
  `timestamp_invio` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_telefono` (`id_telefono`),
  KEY `timestamp_composizione` (`timestamp_composizione`),
  KEY `timestamp_invio` (`timestamp_invio`),
  KEY `token` (`token`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_telefono`,`timestamp_composizione`,`timestamp_invio`,`token`,`tentativi`),
  CONSTRAINT `sms_sent_ibfk_01_nofollow` FOREIGN KEY (`id_telefono`) REFERENCES `telefoni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sms_sent_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `sms_sent_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `sms_sent_view` (`id` int, `id_telefono` int, `ordine` int, `timestamp_composizione` int, `mittente` char(254), `destinatari` text, `corpo` text, `server` char(128), `host` char(254), `port` char(6), `user` char(254), `password` char(254), `token` char(128), `tentativi` int, `timestamp_invio` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` mediumtext);


CREATE TABLE `software` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `json` text,
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `id_articolo` (`id_articolo`),
  KEY `json` (`json`(255)),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`id_articolo`,`nome`,`json`(255)),
  CONSTRAINT `software_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `software` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `software_ibfk_02_nofollow` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `software_view` (`id` int, `id_genitore` int, `id_articolo` char(32), `articolo` varchar(259), `json` text, `nome` char(128), `note` text, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `stati` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_continente` int DEFAULT NULL,
  `nome` char(128) NOT NULL,
  `note` char(128) DEFAULT NULL,
  `iso31661alpha2` char(2) DEFAULT NULL,
  `iso31661alpha3` char(3) DEFAULT NULL,
  `codice_istat` char(4) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`codice_istat`),
  UNIQUE KEY `unica_iso31661alpha2` (`iso31661alpha2`),
  UNIQUE KEY `unica_iso31661alpha3` (`iso31661alpha3`),
  KEY `id_continente` (`id_continente`),
  KEY `indice` (`id`,`id_continente`,`nome`,`iso31661alpha2`,`iso31661alpha3`,`codice_istat`),
  CONSTRAINT `stati_ibfk_01_nofollow` FOREIGN KEY (`id_continente`) REFERENCES `continenti` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `stati_lingue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_stato` int NOT NULL,
  `id_lingua` int NOT NULL,
  `ordine` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_stato`,`id_lingua`),
  KEY `id_stato` (`id_stato`),
  KEY `id_lingua` (`id_lingua`),
  KEY `ordine` (`ordine`),
  KEY `indice` (`id`,`id_stato`,`id_lingua`,`ordine`),
  CONSTRAINT `stati_lingue_ibfk_01_nofollow` FOREIGN KEY (`id_stato`) REFERENCES `stati` (`id`),
  CONSTRAINT `stati_lingue_ibfk_02_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `stati_lingue_view` (`id` int, `id_stato` int, `stato` char(128), `id_lingua` int, `lingua` char(128), `ordine` int, `__label__` varchar(257));


CREATE TABLE `stati_view` (`id` int, `id_continente` int, `continente` char(32), `nome` char(128), `iso31661alpha2` char(2), `iso31661alpha3` char(3), `codice_istat` char(4), `data_archiviazione` date, `__label__` varchar(161));


CREATE TABLE `task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `minuto` int DEFAULT NULL,
  `ora` int DEFAULT NULL,
  `giorno_del_mese` int DEFAULT NULL,
  `mese` int DEFAULT NULL,
  `giorno_della_settimana` int DEFAULT NULL,
  `settimana` int DEFAULT NULL,
  `task` char(255) NOT NULL,
  `iterazioni` int DEFAULT NULL,
  `delay` int DEFAULT NULL,
  `token` char(254) DEFAULT NULL,
  `timestamp_esecuzione` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `minuto` (`minuto`),
  KEY `ora` (`ora`),
  KEY `giorno_del_mese` (`giorno_del_mese`),
  KEY `mese` (`mese`),
  KEY `giorno_della_settimana` (`giorno_della_settimana`),
  KEY `settimana` (`settimana`),
  KEY `task` (`task`),
  KEY `iterazioni` (`iterazioni`),
  KEY `delay` (`delay`),
  KEY `token` (`token`),
  KEY `timestamp_esecuzione` (`timestamp_esecuzione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`minuto`,`ora`,`giorno_del_mese`,`mese`,`giorno_della_settimana`,`settimana`,`task`,`iterazioni`,`delay`,`token`,`timestamp_esecuzione`),
  CONSTRAINT `task_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `task_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `task_view` (`id` int, `minuto` int, `ora` int, `giorno_del_mese` int, `mese` int, `giorno_della_settimana` int, `settimana` int, `task` char(255), `iterazioni` int, `delay` int, `token` char(254), `timestamp_esecuzione` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(342));


CREATE TABLE `telefoni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int NOT NULL,
  `id_tipologia` int DEFAULT NULL,
  `numero` char(32) NOT NULL,
  `note` text,
  `se_notifiche` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_anagrafica`,`numero`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `numero` (`numero`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id_anagrafica`,`id_tipologia`,`numero`,`se_notifiche`),
  CONSTRAINT `telefoni_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `telefoni_ibfk_02_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_telefoni` (`id`),
  CONSTRAINT `telefoni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `telefoni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `telefoni_view` (`id` int, `id_anagrafica` int, `anagrafica` varchar(320), `id_tipologia` int, `tipologia` char(32), `numero` char(32), `se_notifiche` tinyint(1), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(386));


CREATE TABLE `template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ruolo` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `tipo` char(32) NOT NULL,
  `note` text,
  `se_mail` int DEFAULT NULL,
  `se_sms` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`ruolo`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`ruolo`,`nome`,`tipo`,`se_mail`,`se_sms`),
  CONSTRAINT `template_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `template_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `template_view` (`id` int, `ruolo` char(32), `nome` char(128), `tipo` char(32), `note` text, `se_mail` int, `se_sms` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` char(32));


CREATE TABLE `testate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`),
  KEY `indice` (`id`,`nome`),
  KEY `testate_ibfk_98_nofollow` (`id_account_inserimento`),
  KEY `testate_ibfk_99_nofollow` (`id_account_aggiornamento`),
  CONSTRAINT `testate_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `testate_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `testate_view` (`id` int, `nome` int, `__label__` int);


CREATE TABLE `tipologie_anagrafica` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_persona_fisica` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_persona_fisica`),
  CONSTRAINT `tipologie_anagrafica_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_anagrafica_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_persona_fisica` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_attivita` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_anagrafica` int DEFAULT NULL,
  `se_agenda` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_anagrafica`,`se_agenda`),
  CONSTRAINT `tipologie_attivita_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_attivita` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_attivita_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_attivita_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_attivita_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_anagrafica` int, `se_agenda` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_chiavi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`),
  CONSTRAINT `tipologie_chiavi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_chiavi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_chiavi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_chiavi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_chiavi_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_contatti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`),
  CONSTRAINT `tipologie_contatti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_contatti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_contatti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_contatti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_documenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `codice` char(8) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_fattura` int DEFAULT NULL,
  `se_nota_credito` int DEFAULT NULL,
  `se_trasporto` int DEFAULT NULL,
  `se_pro_forma` int DEFAULT NULL,
  `se_offerta` int DEFAULT NULL,
  `se_ordine` int DEFAULT NULL,
  `se_ricevuta` int DEFAULT NULL,
  `stampa_xml` char(255) DEFAULT NULL,
  `stampa_pdf` char(255) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`,`se_fattura`,`se_nota_credito`,`se_trasporto`,`se_pro_forma`,`se_offerta`,`se_ordine`,`se_ricevuta`),
  CONSTRAINT `tipologie_documenti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_documenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_documenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_documenti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(255), `html_entity` char(8), `font_awesome` char(16), `se_fattura` int, `se_nota_credito` int, `se_trasporto` int, `se_pro_forma` int, `se_offerta` int, `se_ordine` int, `se_ricevuta` int, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_indirizzi` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_indirizzi_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_indirizzi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_indirizzi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_indirizzi_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_licenze` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`),
  CONSTRAINT `tipologie_licenze_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_licenze` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_licenze_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_licenze_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_licenze_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_mastri` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_mastri_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_mastri` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_mastri_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_mastri_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_mastri_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_notizie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_notizie_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_notizie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_notizie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_notizie_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(255), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_pagamenti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`),
  CONSTRAINT `tipologie_pagamenti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pagamenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_pagamenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_pagamenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_pagamenti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_popup` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_popup_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_popup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_popup_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_popup_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_popup_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_prodotti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_colori` tinyint(1) DEFAULT NULL,
  `se_taglie` tinyint(1) DEFAULT NULL,
  `se_dimensioni` tinyint(1) DEFAULT NULL,
  `se_imballo` tinyint(1) DEFAULT NULL,
  `se_spedizione` tinyint(1) DEFAULT NULL,
  `se_trasporto` tinyint(1) DEFAULT NULL,
  `se_prodotto` tinyint(1) DEFAULT NULL,
  `se_servizio` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_colori`,`se_taglie`,`se_dimensioni`,`se_imballo`,`se_spedizione`,`se_trasporto`,`se_prodotto`,`se_servizio`),
  CONSTRAINT `tipologie_prodotti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_prodotti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_prodotti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_prodotti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `se_colori` tinyint(1), `se_taglie` tinyint(1), `se_dimensioni` tinyint(1), `se_imballo` tinyint(1), `se_spedizione` tinyint(1), `se_trasporto` tinyint(1), `se_prodotto` tinyint(1), `se_servizio` tinyint(1), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_progetti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_progetti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_progetti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_pubblicazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_bozza` int DEFAULT NULL,
  `se_pubblicato` int DEFAULT NULL,
  `se_evidenza` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_bozza`,`se_pubblicato`,`se_evidenza`),
  CONSTRAINT `tipologie_pubblicazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_pubblicazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_pubblicazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_pubblicazioni_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_risorse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_risorse_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_risorse_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_telefoni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_telefoni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_telefoni_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_todo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_todo_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_todo_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_todo_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_todo_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_url_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_url` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_url_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_url_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_url_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `todo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `id_luogo` int DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` year DEFAULT NULL,
  `settimana_programmazione` int DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `note_programmazione` text,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_contatto` int DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pianificazione` int DEFAULT NULL,
  `note_pianificazione` text,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_contatto` (`id_contatto`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_scadenza`,`ora_scadenza`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`data_chiusura`,`id_contatto`,`id_progetto`),
  KEY `indice_pianificazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`),
  KEY `indice_archiviazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`,`data_archiviazione`),
  CONSTRAINT `todo_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_todo` (`id`),
  CONSTRAINT `todo_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `todo_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `todo_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `todo_ibfk_05_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`),
  CONSTRAINT `todo_ibfk_06_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`),
  CONSTRAINT `todo_ibfk_07_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`),
  CONSTRAINT `todo_ibfk_08_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`),
  CONSTRAINT `todo_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `todo_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `indirizzo` text, `id_luogo` int, `luogo` text, `data_scadenza` date, `ora_scadenza` time, `data_programmazione` date, `ora_inizio_programmazione` time, `ora_fine_programmazione` time, `anno_programmazione` year, `settimana_programmazione` int, `ore_programmazione` decimal(5,2), `data_chiusura` date, `nome` char(255), `id_contatto` int, `id_progetto` char(32), `id_pianificazione` int, `data_archiviazione` date, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `udm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `conversione` float DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `note` text,
  `se_lunghezza` int DEFAULT NULL,
  `se_peso` int DEFAULT NULL,
  `se_quantita` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`sigla`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`conversione`,`nome`,`sigla`,`se_lunghezza`,`se_peso`,`se_quantita`),
  CONSTRAINT `udm_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `udm` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `udm_view` (`id` int, `id_genitore` bigint, `conversione` float, `nome` char(32), `sigla` char(8), `se_lunghezza` int, `se_peso` int, `se_quantita` int, `__label__` char(8));


CREATE TABLE `url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `url` char(255) NOT NULL,
  `nome` char(128) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_tipologia`,`id_anagrafica`,`url`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `url` (`url`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`url`),
  CONSTRAINT `url_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_url` (`id`),
  CONSTRAINT `url_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `url_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `url_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `url_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `url` char(255), `nome` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `valute` (
  `id` int NOT NULL AUTO_INCREMENT,
  `iso4217` char(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `utf8` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`iso4217`),
  KEY `indice` (`id`,`iso4217`,`html_entity`,`utf8`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `valute_view` (`id` int, `iso4217` char(3), `html_entity` char(8), `utf8` char(1), `__label__` char(3));


CREATE TABLE `video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_lingua` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `id_embed` int DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `ratio` char(8) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_risorse` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_notizie` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_file` (`id_file`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_embed` (`id_embed`),
  KEY `path` (`path`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_anagrafica` (`id`,`id_anagrafica`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_pagine` (`id`,`id_pagina`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_file` (`id`,`id_file`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_prodotti` (`id`,`id_prodotto`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_articoli` (`id`,`id_articolo`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_risorse` (`id`,`id_risorsa`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_notizie` (`id`,`id_notizia`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  CONSTRAINT `video_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_03` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_05` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_06` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_07` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_08` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_09` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_11_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `video_ibfk_12_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_video` (`id`),
  CONSTRAINT `video_ibfk_13_nofollow` FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`),
  CONSTRAINT `video_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `video_view` (`id` int, `id_anagrafica` int, `id_pagina` int, `id_file` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `id_risorsa` int, `id_categoria_risorse` int, `id_notizia` int, `id_categoria_notizie` int, `id_lingua` int, `lingua` char(128), `id_ruolo` int, `ruolo` char(64), `ordine` int, `nome` char(32), `path` char(255), `id_embed` int, `codice_embed` char(128), `embed_custom` char(128), `target` char(255), `orientamento` enum('L','P'), `ratio` char(8), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(371));


DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `account_gruppi_attribuzione_view` AS select `account_gruppi_attribuzione`.`id` AS `id`,`account_gruppi_attribuzione`.`id_account` AS `id_account`,`account_gruppi_attribuzione`.`id_gruppo` AS `id_gruppo`,`account_gruppi_attribuzione`.`ordine` AS `ordine`,`account_gruppi_attribuzione`.`entita` AS `entita`,`account_gruppi_attribuzione`.`id_account_inserimento` AS `id_account_inserimento`,`account_gruppi_attribuzione`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`account`.`username`,' / ',`gruppi`.`nome`,' / ',`account_gruppi_attribuzione`.`entita`) AS `__label__` from ((`account_gruppi_attribuzione` left join `account` on((`account`.`id` = `account_gruppi_attribuzione`.`id_account`))) left join `gruppi` on((`gruppi`.`id` = `account_gruppi_attribuzione`.`id_gruppo`)));

DROP TABLE IF EXISTS `account_gruppi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `account_gruppi_view` AS select `account_gruppi`.`id` AS `id`,`account_gruppi`.`id_account` AS `id_account`,`account`.`username` AS `account`,`account_gruppi`.`id_gruppo` AS `id_gruppo`,`gruppi`.`nome` AS `gruppo`,`account_gruppi`.`ordine` AS `ordine`,`account_gruppi`.`se_amministratore` AS `se_amministratore`,`account_gruppi`.`id_account_inserimento` AS `id_account_inserimento`,`account_gruppi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`account`.`username`,' / ',`gruppi`.`nome`) AS `__label__` from ((`account_gruppi` left join `account` on((`account`.`id` = `account_gruppi`.`id_account`))) left join `gruppi` on((`gruppi`.`id` = `account_gruppi`.`id_gruppo`)));

DROP TABLE IF EXISTS `account_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `account_view` AS select `account`.`id` AS `id`,`account`.`id_anagrafica` AS `id_anagrafica`,coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),NULL) AS `anagrafica`,`account`.`id_mail` AS `id_mail`,`mail`.`indirizzo` AS `mail`,`account`.`username` AS `username`,`account`.`password` AS `password`,`account`.`se_attivo` AS `se_attivo`,`account`.`token` AS `token`,`account`.`timestamp_login` AS `timestamp_login`,`account`.`timestamp_cambio_password` AS `timestamp_cambio_password`,group_concat(`gruppi`.`nome` order by `gruppi`.`id` ASC separator '|') AS `gruppi`,group_concat(`gruppi`.`id` order by `gruppi`.`id` ASC separator '|') AS `id_gruppi`,group_concat(distinct concat(`account_gruppi_attribuzione`.`entita`,'#',`account_gruppi_attribuzione`.`id_gruppo`) order by `account_gruppi_attribuzione`.`entita` ASC,`account_gruppi_attribuzione`.`id_gruppo` ASC separator '|') AS `id_gruppi_attribuzione`,`account`.`id_account_inserimento` AS `id_account_inserimento`,`account`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`account`.`username` AS `__label__` from (((((`account` left join `anagrafica` on((`anagrafica`.`id` = `account`.`id_anagrafica`))) left join `mail` on((`mail`.`id` = `account`.`id_mail`))) left join `account_gruppi` on((`account_gruppi`.`id_account` = `account`.`id`))) left join `account_gruppi_attribuzione` on((`account_gruppi_attribuzione`.`id_account` = `account`.`id`))) left join `gruppi` on((`gruppi`.`id` = `account_gruppi`.`id_gruppo`))) group by `account`.`id`;

DROP TABLE IF EXISTS `anagrafica_archiviati_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_archiviati_view` AS select `anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`nome` AS `tipologia`,`anagrafica`.`codice` AS `codice`,`anagrafica`.`riferimento` AS `riferimento`,`anagrafica`.`nome` AS `nome`,`anagrafica`.`cognome` AS `cognome`,`anagrafica`.`denominazione` AS `denominazione`,`anagrafica`.`soprannome` AS `soprannome`,`anagrafica`.`sesso` AS `sesso`,`anagrafica`.`codice_fiscale` AS `codice_fiscale`,`anagrafica`.`partita_iva` AS `partita_iva`,`ranking`.`nome` AS `ranking`,`anagrafica`.`recapiti` AS `recapiti`,max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,max(`categorie_anagrafica`.`se_agente`) AS `se_agente`,max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,max(`categorie_anagrafica`.`se_azienda_gestita`) AS `se_azienda_gestita`,max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,`anagrafica`.`data_archiviazione` AS `data_archiviazione`,`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'') AS `__label__` from ((((((`anagrafica` left join `tipologie_anagrafica` on((`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))) left join `ranking` on((`ranking`.`id` = `anagrafica`.`id_ranking`))) left join `anagrafica_categorie` on((`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))) left join `categorie_anagrafica` on((`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))) left join `telefoni` on((`telefoni`.`id_anagrafica` = `anagrafica`.`id`))) left join `mail` on((`mail`.`id_anagrafica` = `anagrafica`.`id`))) where (`anagrafica`.`data_archiviazione` is not null) group by `anagrafica`.`id`;

DROP TABLE IF EXISTS `anagrafica_attivi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_attivi_view` AS select `anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`nome` AS `tipologia`,`anagrafica`.`codice` AS `codice`,`anagrafica`.`riferimento` AS `riferimento`,`anagrafica`.`nome` AS `nome`,`anagrafica`.`cognome` AS `cognome`,`anagrafica`.`denominazione` AS `denominazione`,`anagrafica`.`soprannome` AS `soprannome`,`anagrafica`.`sesso` AS `sesso`,`anagrafica`.`codice_fiscale` AS `codice_fiscale`,`anagrafica`.`partita_iva` AS `partita_iva`,`ranking`.`nome` AS `ranking`,`anagrafica`.`recapiti` AS `recapiti`,max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,max(`categorie_anagrafica`.`se_agente`) AS `se_agente`,max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,max(`categorie_anagrafica`.`se_azienda_gestita`) AS `se_azienda_gestita`,max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,`anagrafica`.`data_archiviazione` AS `data_archiviazione`,`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'') AS `__label__` from ((((((`anagrafica` left join `tipologie_anagrafica` on((`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))) left join `ranking` on((`ranking`.`id` = `anagrafica`.`id_ranking`))) left join `anagrafica_categorie` on((`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))) left join `categorie_anagrafica` on((`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))) left join `telefoni` on((`telefoni`.`id_anagrafica` = `anagrafica`.`id`))) left join `mail` on((`mail`.`id_anagrafica` = `anagrafica`.`id`))) where (`anagrafica`.`data_archiviazione` is null) group by `anagrafica`.`id`;

DROP TABLE IF EXISTS `anagrafica_categorie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_categorie_view` AS select `anagrafica_categorie`.`id` AS `id`,`anagrafica_categorie`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_categorie`.`id_categoria` AS `id_categoria`,`anagrafica_categorie`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_categorie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',`categorie_anagrafica_path`(`anagrafica_categorie`.`id_categoria`)) AS `__label__` from (`anagrafica_categorie` left join `anagrafica` on((`anagrafica`.`id` = `anagrafica_categorie`.`id_anagrafica`)));

DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_cittadinanze_view` AS select `anagrafica_cittadinanze`.`id` AS `id`,`anagrafica_cittadinanze`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_cittadinanze`.`id_stato` AS `id_stato`,`anagrafica_cittadinanze`.`data_inizio` AS `data_inizio`,`anagrafica_cittadinanze`.`data_fine` AS `data_fine`,`anagrafica_cittadinanze`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_cittadinanze`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',`stati`.`nome`) AS `__label__` from ((`anagrafica_cittadinanze` join `anagrafica` on((`anagrafica`.`id` = `anagrafica_cittadinanze`.`id_anagrafica`))) join `stati` on((`stati`.`id` = `anagrafica_cittadinanze`.`id_stato`)));

DROP TABLE IF EXISTS `anagrafica_indirizzi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_indirizzi_view` AS select `anagrafica_indirizzi`.`id` AS `id`,`anagrafica_indirizzi`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_indirizzi`.`id_indirizzo` AS `id_indirizzo`,`anagrafica_indirizzi`.`id_ruolo` AS `id_ruolo`,`ruoli_indirizzi`.`nome` AS `ruolo`,`anagrafica_indirizzi`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_indirizzi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',coalesce(`anagrafica_indirizzi`.`note`,`anagrafica_indirizzi`.`id_indirizzo`),' / ',`indirizzi`.`indirizzo`,' ',`comuni`.`nome`,' ',`provincie`.`sigla`) AS `__label__` from (((((`anagrafica_indirizzi` join `anagrafica` on((`anagrafica`.`id` = `anagrafica_indirizzi`.`id_anagrafica`))) left join `ruoli_indirizzi` on((`ruoli_indirizzi`.`id` = `anagrafica_indirizzi`.`id_ruolo`))) left join `indirizzi` on((`indirizzi`.`id` = `anagrafica_indirizzi`.`id_indirizzo`))) left join `comuni` on((`comuni`.`id` = `indirizzi`.`id_comune`))) left join `provincie` on((`provincie`.`id` = `comuni`.`id_provincia`)));

DROP TABLE IF EXISTS `anagrafica_settori_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_settori_view` AS select `anagrafica_settori`.`id` AS `id`,`anagrafica_settori`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_settori`.`id_settore` AS `id_settore`,`settori`.`nome` AS `settore`,`anagrafica_settori`.`ordine` AS `ordine`,`anagrafica_settori`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_settori`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',`settori`.`nome`) AS `__label__` from ((`anagrafica_settori` left join `anagrafica` on((`anagrafica`.`id` = `anagrafica_settori`.`id_anagrafica`))) left join `settori` on((`settori`.`id` = `anagrafica_settori`.`id_settore`)));

DROP TABLE IF EXISTS `anagrafica_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_view` AS select `anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`nome` AS `tipologia`,`anagrafica`.`codice` AS `codice`,`anagrafica`.`riferimento` AS `riferimento`,`anagrafica`.`nome` AS `nome`,`anagrafica`.`cognome` AS `cognome`,`anagrafica`.`denominazione` AS `denominazione`,`anagrafica`.`soprannome` AS `soprannome`,`anagrafica`.`sesso` AS `sesso`,`anagrafica`.`codice_fiscale` AS `codice_fiscale`,`anagrafica`.`partita_iva` AS `partita_iva`,`ranking`.`nome` AS `ranking`,`anagrafica`.`recapiti` AS `recapiti`,max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,max(`categorie_anagrafica`.`se_agente`) AS `se_agente`,max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,max(`categorie_anagrafica`.`se_azienda_gestita`) AS `se_azienda_gestita`,max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,`anagrafica`.`data_archiviazione` AS `data_archiviazione`,`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'') AS `__label__` from ((((((`anagrafica` left join `tipologie_anagrafica` on((`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))) left join `ranking` on((`ranking`.`id` = `anagrafica`.`id_ranking`))) left join `anagrafica_categorie` on((`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))) left join `categorie_anagrafica` on((`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))) left join `telefoni` on((`telefoni`.`id_anagrafica` = `anagrafica`.`id`))) left join `mail` on((`mail`.`id_anagrafica` = `anagrafica`.`id`))) group by `anagrafica`.`id`;


CREATE TABLE `tipologie_progetti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_progetti_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_progetti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_progetti_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_pubblicazioni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_bozza` int DEFAULT NULL,
  `se_pubblicato` int DEFAULT NULL,
  `se_evidenza` int DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_bozza`,`se_pubblicato`,`se_evidenza`),
  CONSTRAINT `tipologie_pubblicazioni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_pubblicazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_pubblicazioni_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_pubblicazioni_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_pubblicazioni_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_risorse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_risorse_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_risorse_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_risorse_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_risorse_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_telefoni` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_telefoni_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_telefoni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_telefoni_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(32), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_todo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_todo_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_todo` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_todo_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_todo_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_todo_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `tipologie_url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`nome`),
  KEY `id_genitore` (`id_genitore`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`),
  CONSTRAINT `tipologie_url_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `tipologie_url` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_url_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_url_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `tipologie_url_view` (`id` int, `id_genitore` int, `ordine` int, `nome` char(64), `html_entity` char(8), `font_awesome` char(16), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `todo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `id_luogo` int DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `note_scadenza` text,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `anno_programmazione` year DEFAULT NULL,
  `settimana_programmazione` int DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `note_programmazione` text,
  `data_chiusura` date DEFAULT NULL,
  `note_chiusura` text,
  `nome` char(255) NOT NULL,
  `testo` text,
  `id_contatto` int DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_pianificazione` int DEFAULT NULL,
  `note_pianificazione` text,
  `data_archiviazione` date DEFAULT NULL,
  `note_archiviazione` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_indirizzo` (`id_indirizzo`),
  KEY `id_luogo` (`id_luogo`),
  KEY `id_contatto` (`id_contatto`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_pianificazione` (`id_pianificazione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_scadenza`,`ora_scadenza`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`data_chiusura`,`id_contatto`,`id_progetto`),
  KEY `indice_pianificazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`),
  KEY `indice_archiviazione` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_indirizzo`,`id_luogo`,`data_programmazione`,`ora_inizio_programmazione`,`ora_fine_programmazione`,`anno_programmazione`,`settimana_programmazione`,`id_contatto`,`id_progetto`,`id_pianificazione`,`data_archiviazione`),
  CONSTRAINT `todo_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_todo` (`id`),
  CONSTRAINT `todo_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `todo_ibfk_03_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `todo_ibfk_04_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`),
  CONSTRAINT `todo_ibfk_05_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`),
  CONSTRAINT `todo_ibfk_06_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`),
  CONSTRAINT `todo_ibfk_07_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`),
  CONSTRAINT `todo_ibfk_08_nofollow` FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`),
  CONSTRAINT `todo_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `todo_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `todo_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `id_cliente` int, `cliente` varchar(320), `id_indirizzo` int, `indirizzo` text, `id_luogo` int, `luogo` text, `data_scadenza` date, `ora_scadenza` time, `data_programmazione` date, `ora_inizio_programmazione` time, `ora_fine_programmazione` time, `anno_programmazione` year, `settimana_programmazione` int, `ore_programmazione` decimal(5,2), `data_chiusura` date, `nome` char(255), `id_contatto` int, `id_progetto` char(32), `id_pianificazione` int, `data_archiviazione` date, `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `udm` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_genitore` int DEFAULT NULL,
  `conversione` float DEFAULT NULL,
  `nome` char(32) NOT NULL,
  `sigla` char(8) DEFAULT NULL,
  `note` text,
  `se_lunghezza` int DEFAULT NULL,
  `se_peso` int DEFAULT NULL,
  `se_quantita` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_genitore`,`sigla`),
  KEY `id_genitore` (`id_genitore`),
  KEY `indice` (`id`,`id_genitore`,`conversione`,`nome`,`sigla`,`se_lunghezza`,`se_peso`,`se_quantita`),
  CONSTRAINT `udm_ibfk_01_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `udm` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `udm_view` (`id` int, `id_genitore` bigint, `conversione` float, `nome` char(32), `sigla` char(8), `se_lunghezza` int, `se_peso` int, `se_quantita` int, `__label__` char(8));


CREATE TABLE `url` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `url` char(255) NOT NULL,
  `nome` char(128) NOT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_tipologia`,`id_anagrafica`,`url`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `url` (`url`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`url`),
  CONSTRAINT `url_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_url` (`id`),
  CONSTRAINT `url_ibfk_02_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `url_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `url_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `url_view` (`id` int, `id_tipologia` int, `tipologia` char(64), `id_anagrafica` int, `anagrafica` varchar(320), `url` char(255), `nome` char(128), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` text);


CREATE TABLE `valute` (
  `id` int NOT NULL AUTO_INCREMENT,
  `iso4217` char(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `utf8` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`iso4217`),
  KEY `indice` (`id`,`iso4217`,`html_entity`,`utf8`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `valute_view` (`id` int, `iso4217` char(3), `html_entity` char(8), `utf8` char(1), `__label__` char(3));


CREATE TABLE `video` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_anagrafica` int DEFAULT NULL,
  `id_pagina` int DEFAULT NULL,
  `id_file` int DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `id_categoria_prodotti` int DEFAULT NULL,
  `id_risorsa` int DEFAULT NULL,
  `id_categoria_risorse` int DEFAULT NULL,
  `id_notizia` int DEFAULT NULL,
  `id_categoria_notizie` int DEFAULT NULL,
  `id_lingua` int DEFAULT NULL,
  `id_ruolo` int DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `path` char(255) DEFAULT NULL,
  `id_embed` int DEFAULT NULL,
  `codice_embed` char(128) DEFAULT NULL,
  `embed_custom` char(128) DEFAULT NULL,
  `target` char(255) DEFAULT NULL,
  `orientamento` enum('L','P') DEFAULT NULL,
  `ratio` char(8) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_pagina` (`id_pagina`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_file` (`id_file`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_prodotto` (`id_prodotto`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_articolo` (`id_articolo`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_prodotti` (`id_categoria_prodotti`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_risorse` (`id_risorsa`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_risorse` (`id_categoria_risorse`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_notizie` (`id_notizia`,`id_ruolo`,`id_lingua`,`path`),
  UNIQUE KEY `unica_categoria_notizie` (`id_categoria_notizie`,`id_ruolo`,`id_lingua`,`path`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_pagina` (`id_pagina`),
  KEY `id_file` (`id_file`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_categoria_prodotti` (`id_categoria_prodotti`),
  KEY `id_risorsa` (`id_risorsa`),
  KEY `id_categoria_risorse` (`id_categoria_risorse`),
  KEY `id_notizia` (`id_notizia`),
  KEY `id_categoria_notizie` (`id_categoria_notizie`),
  KEY `id_lingua` (`id_lingua`),
  KEY `id_ruolo` (`id_ruolo`),
  KEY `id_embed` (`id_embed`),
  KEY `path` (`path`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_anagrafica` (`id`,`id_anagrafica`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_pagine` (`id`,`id_pagina`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_file` (`id`,`id_file`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_prodotti` (`id`,`id_prodotto`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_articoli` (`id`,`id_articolo`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_categorie_prodotti` (`id`,`id_categoria_prodotti`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_risorse` (`id`,`id_risorsa`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_categorie_risorse` (`id`,`id_categoria_risorse`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_notizie` (`id`,`id_notizia`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  KEY `indice_categorie_notizie` (`id`,`id_categoria_notizie`,`id_lingua`,`id_ruolo`,`path`,`id_embed`,`codice_embed`,`embed_custom`,`target`,`orientamento`,`ratio`,`nome`,`ordine`),
  CONSTRAINT `video_ibfk_01` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_02` FOREIGN KEY (`id_pagina`) REFERENCES `pagine` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_03` FOREIGN KEY (`id_file`) REFERENCES `file` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_04` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_05` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_06` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_07` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_08` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_09` FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_10` FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_11_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`),
  CONSTRAINT `video_ibfk_12_nofollow` FOREIGN KEY (`id_ruolo`) REFERENCES `ruoli_video` (`id`),
  CONSTRAINT `video_ibfk_13_nofollow` FOREIGN KEY (`id_embed`) REFERENCES `embed` (`id`),
  CONSTRAINT `video_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `video_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE `video_view` (`id` int, `id_anagrafica` int, `id_pagina` int, `id_file` int, `id_prodotto` char(32), `id_articolo` char(32), `id_categoria_prodotti` int, `id_risorsa` int, `id_categoria_risorse` int, `id_notizia` int, `id_categoria_notizie` int, `id_lingua` int, `lingua` char(128), `id_ruolo` int, `ruolo` char(64), `ordine` int, `nome` char(32), `path` char(255), `id_embed` int, `codice_embed` char(128), `embed_custom` char(128), `target` char(255), `orientamento` enum('L','P'), `ratio` char(8), `id_account_inserimento` int, `id_account_aggiornamento` int, `__label__` varchar(371));


DROP TABLE IF EXISTS `account_gruppi_attribuzione_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `account_gruppi_attribuzione_view` AS select `account_gruppi_attribuzione`.`id` AS `id`,`account_gruppi_attribuzione`.`id_account` AS `id_account`,`account_gruppi_attribuzione`.`id_gruppo` AS `id_gruppo`,`account_gruppi_attribuzione`.`ordine` AS `ordine`,`account_gruppi_attribuzione`.`entita` AS `entita`,`account_gruppi_attribuzione`.`id_account_inserimento` AS `id_account_inserimento`,`account_gruppi_attribuzione`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`account`.`username`,' / ',`gruppi`.`nome`,' / ',`account_gruppi_attribuzione`.`entita`) AS `__label__` from ((`account_gruppi_attribuzione` left join `account` on((`account`.`id` = `account_gruppi_attribuzione`.`id_account`))) left join `gruppi` on((`gruppi`.`id` = `account_gruppi_attribuzione`.`id_gruppo`)));

DROP TABLE IF EXISTS `account_gruppi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `account_gruppi_view` AS select `account_gruppi`.`id` AS `id`,`account_gruppi`.`id_account` AS `id_account`,`account`.`username` AS `account`,`account_gruppi`.`id_gruppo` AS `id_gruppo`,`gruppi`.`nome` AS `gruppo`,`account_gruppi`.`ordine` AS `ordine`,`account_gruppi`.`se_amministratore` AS `se_amministratore`,`account_gruppi`.`id_account_inserimento` AS `id_account_inserimento`,`account_gruppi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`account`.`username`,' / ',`gruppi`.`nome`) AS `__label__` from ((`account_gruppi` left join `account` on((`account`.`id` = `account_gruppi`.`id_account`))) left join `gruppi` on((`gruppi`.`id` = `account_gruppi`.`id_gruppo`)));

DROP TABLE IF EXISTS `account_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `account_view` AS select `account`.`id` AS `id`,`account`.`id_anagrafica` AS `id_anagrafica`,coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),NULL) AS `anagrafica`,`account`.`id_mail` AS `id_mail`,`mail`.`indirizzo` AS `mail`,`account`.`username` AS `username`,`account`.`password` AS `password`,`account`.`se_attivo` AS `se_attivo`,`account`.`token` AS `token`,`account`.`timestamp_login` AS `timestamp_login`,`account`.`timestamp_cambio_password` AS `timestamp_cambio_password`,group_concat(`gruppi`.`nome` order by `gruppi`.`id` ASC separator '|') AS `gruppi`,group_concat(`gruppi`.`id` order by `gruppi`.`id` ASC separator '|') AS `id_gruppi`,group_concat(distinct concat(`account_gruppi_attribuzione`.`entita`,'#',`account_gruppi_attribuzione`.`id_gruppo`) order by `account_gruppi_attribuzione`.`entita` ASC,`account_gruppi_attribuzione`.`id_gruppo` ASC separator '|') AS `id_gruppi_attribuzione`,`account`.`id_account_inserimento` AS `id_account_inserimento`,`account`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`account`.`username` AS `__label__` from (((((`account` left join `anagrafica` on((`anagrafica`.`id` = `account`.`id_anagrafica`))) left join `mail` on((`mail`.`id` = `account`.`id_mail`))) left join `account_gruppi` on((`account_gruppi`.`id_account` = `account`.`id`))) left join `account_gruppi_attribuzione` on((`account_gruppi_attribuzione`.`id_account` = `account`.`id`))) left join `gruppi` on((`gruppi`.`id` = `account_gruppi`.`id_gruppo`))) group by `account`.`id`;

DROP TABLE IF EXISTS `anagrafica_archiviati_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_archiviati_view` AS select `anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`nome` AS `tipologia`,`anagrafica`.`codice` AS `codice`,`anagrafica`.`riferimento` AS `riferimento`,`anagrafica`.`nome` AS `nome`,`anagrafica`.`cognome` AS `cognome`,`anagrafica`.`denominazione` AS `denominazione`,`anagrafica`.`soprannome` AS `soprannome`,`anagrafica`.`sesso` AS `sesso`,`anagrafica`.`codice_fiscale` AS `codice_fiscale`,`anagrafica`.`partita_iva` AS `partita_iva`,`ranking`.`nome` AS `ranking`,`anagrafica`.`recapiti` AS `recapiti`,max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,max(`categorie_anagrafica`.`se_agente`) AS `se_agente`,max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,max(`categorie_anagrafica`.`se_azienda_gestita`) AS `se_azienda_gestita`,max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,`anagrafica`.`data_archiviazione` AS `data_archiviazione`,`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'') AS `__label__` from ((((((`anagrafica` left join `tipologie_anagrafica` on((`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))) left join `ranking` on((`ranking`.`id` = `anagrafica`.`id_ranking`))) left join `anagrafica_categorie` on((`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))) left join `categorie_anagrafica` on((`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))) left join `telefoni` on((`telefoni`.`id_anagrafica` = `anagrafica`.`id`))) left join `mail` on((`mail`.`id_anagrafica` = `anagrafica`.`id`))) where (`anagrafica`.`data_archiviazione` is not null) group by `anagrafica`.`id`;

DROP TABLE IF EXISTS `anagrafica_attivi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_attivi_view` AS select `anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`nome` AS `tipologia`,`anagrafica`.`codice` AS `codice`,`anagrafica`.`riferimento` AS `riferimento`,`anagrafica`.`nome` AS `nome`,`anagrafica`.`cognome` AS `cognome`,`anagrafica`.`denominazione` AS `denominazione`,`anagrafica`.`soprannome` AS `soprannome`,`anagrafica`.`sesso` AS `sesso`,`anagrafica`.`codice_fiscale` AS `codice_fiscale`,`anagrafica`.`partita_iva` AS `partita_iva`,`ranking`.`nome` AS `ranking`,`anagrafica`.`recapiti` AS `recapiti`,max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,max(`categorie_anagrafica`.`se_agente`) AS `se_agente`,max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,max(`categorie_anagrafica`.`se_azienda_gestita`) AS `se_azienda_gestita`,max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,`anagrafica`.`data_archiviazione` AS `data_archiviazione`,`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'') AS `__label__` from ((((((`anagrafica` left join `tipologie_anagrafica` on((`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))) left join `ranking` on((`ranking`.`id` = `anagrafica`.`id_ranking`))) left join `anagrafica_categorie` on((`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))) left join `categorie_anagrafica` on((`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))) left join `telefoni` on((`telefoni`.`id_anagrafica` = `anagrafica`.`id`))) left join `mail` on((`mail`.`id_anagrafica` = `anagrafica`.`id`))) where (`anagrafica`.`data_archiviazione` is null) group by `anagrafica`.`id`;

DROP TABLE IF EXISTS `anagrafica_categorie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_categorie_view` AS select `anagrafica_categorie`.`id` AS `id`,`anagrafica_categorie`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_categorie`.`id_categoria` AS `id_categoria`,`anagrafica_categorie`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_categorie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',`categorie_anagrafica_path`(`anagrafica_categorie`.`id_categoria`)) AS `__label__` from (`anagrafica_categorie` left join `anagrafica` on((`anagrafica`.`id` = `anagrafica_categorie`.`id_anagrafica`)));

DROP TABLE IF EXISTS `anagrafica_cittadinanze_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_cittadinanze_view` AS select `anagrafica_cittadinanze`.`id` AS `id`,`anagrafica_cittadinanze`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_cittadinanze`.`id_stato` AS `id_stato`,`anagrafica_cittadinanze`.`data_inizio` AS `data_inizio`,`anagrafica_cittadinanze`.`data_fine` AS `data_fine`,`anagrafica_cittadinanze`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_cittadinanze`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',`stati`.`nome`) AS `__label__` from ((`anagrafica_cittadinanze` join `anagrafica` on((`anagrafica`.`id` = `anagrafica_cittadinanze`.`id_anagrafica`))) join `stati` on((`stati`.`id` = `anagrafica_cittadinanze`.`id_stato`)));

DROP TABLE IF EXISTS `anagrafica_indirizzi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_indirizzi_view` AS select `anagrafica_indirizzi`.`id` AS `id`,`anagrafica_indirizzi`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_indirizzi`.`id_indirizzo` AS `id_indirizzo`,`anagrafica_indirizzi`.`id_ruolo` AS `id_ruolo`,`ruoli_indirizzi`.`nome` AS `ruolo`,`anagrafica_indirizzi`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_indirizzi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',coalesce(`anagrafica_indirizzi`.`note`,`anagrafica_indirizzi`.`id_indirizzo`),' / ',`indirizzi`.`indirizzo`,' ',`comuni`.`nome`,' ',`provincie`.`sigla`) AS `__label__` from (((((`anagrafica_indirizzi` join `anagrafica` on((`anagrafica`.`id` = `anagrafica_indirizzi`.`id_anagrafica`))) left join `ruoli_indirizzi` on((`ruoli_indirizzi`.`id` = `anagrafica_indirizzi`.`id_ruolo`))) left join `indirizzi` on((`indirizzi`.`id` = `anagrafica_indirizzi`.`id_indirizzo`))) left join `comuni` on((`comuni`.`id` = `indirizzi`.`id_comune`))) left join `provincie` on((`provincie`.`id` = `comuni`.`id_provincia`)));

DROP TABLE IF EXISTS `anagrafica_settori_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_settori_view` AS select `anagrafica_settori`.`id` AS `id`,`anagrafica_settori`.`id_anagrafica` AS `id_anagrafica`,`anagrafica_settori`.`id_settore` AS `id_settore`,`settori`.`nome` AS `settore`,`anagrafica_settori`.`ordine` AS `ordine`,`anagrafica_settori`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica_settori`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`anagrafica`.`denominazione`,concat(`anagrafica`.`cognome`,' ',`anagrafica`.`nome`),''),' / ',`settori`.`nome`) AS `__label__` from ((`anagrafica_settori` left join `anagrafica` on((`anagrafica`.`id` = `anagrafica_settori`.`id_anagrafica`))) left join `settori` on((`settori`.`id` = `anagrafica_settori`.`id_settore`)));

DROP TABLE IF EXISTS `anagrafica_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anagrafica_view` AS select `anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`nome` AS `tipologia`,`anagrafica`.`codice` AS `codice`,`anagrafica`.`riferimento` AS `riferimento`,`anagrafica`.`nome` AS `nome`,`anagrafica`.`cognome` AS `cognome`,`anagrafica`.`denominazione` AS `denominazione`,`anagrafica`.`soprannome` AS `soprannome`,`anagrafica`.`sesso` AS `sesso`,`anagrafica`.`codice_fiscale` AS `codice_fiscale`,`anagrafica`.`partita_iva` AS `partita_iva`,`ranking`.`nome` AS `ranking`,`anagrafica`.`recapiti` AS `recapiti`,max(`categorie_anagrafica`.`se_prospect`) AS `se_prospect`,max(`categorie_anagrafica`.`se_lead`) AS `se_lead`,max(`categorie_anagrafica`.`se_cliente`) AS `se_cliente`,max(`categorie_anagrafica`.`se_fornitore`) AS `se_fornitore`,max(`categorie_anagrafica`.`se_produttore`) AS `se_produttore`,max(`categorie_anagrafica`.`se_collaboratore`) AS `se_collaboratore`,max(`categorie_anagrafica`.`se_interno`) AS `se_interno`,max(`categorie_anagrafica`.`se_esterno`) AS `se_esterno`,max(`categorie_anagrafica`.`se_agente`) AS `se_agente`,max(`categorie_anagrafica`.`se_concorrente`) AS `se_concorrente`,max(`categorie_anagrafica`.`se_azienda_gestita`) AS `se_azienda_gestita`,max(`categorie_anagrafica`.`se_amministrazione`) AS `se_amministrazione`,max(`categorie_anagrafica`.`se_notizie`) AS `se_notizie`,group_concat(distinct `categorie_anagrafica_path`(`categorie_anagrafica`.`id`) separator ' | ') AS `categorie`,group_concat(distinct `telefoni`.`numero` separator ' | ') AS `telefoni`,group_concat(distinct `mail`.`indirizzo` separator ' | ') AS `mail`,`anagrafica`.`data_archiviazione` AS `data_archiviazione`,`anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,coalesce(`anagrafica`.`soprannome`,`anagrafica`.`denominazione`,concat_ws(' ',coalesce(`anagrafica`.`cognome`,''),coalesce(`anagrafica`.`nome`,'')),'') AS `__label__` from ((((((`anagrafica` left join `tipologie_anagrafica` on((`tipologie_anagrafica`.`id` = `anagrafica`.`id_tipologia`))) left join `ranking` on((`ranking`.`id` = `anagrafica`.`id_ranking`))) left join `anagrafica_categorie` on((`anagrafica_categorie`.`id_anagrafica` = `anagrafica`.`id`))) left join `categorie_anagrafica` on((`categorie_anagrafica`.`id` = `anagrafica_categorie`.`id_categoria`))) left join `telefoni` on((`telefoni`.`id_anagrafica` = `anagrafica`.`id`))) left join `mail` on((`mail`.`id_anagrafica` = `anagrafica`.`id`))) group by `anagrafica`.`id`;


DROP TABLE IF EXISTS `luoghi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `luoghi_view` AS select `luoghi`.`id` AS `id`,`luoghi`.`id_genitore` AS `id_genitore`,`luoghi`.`id_indirizzo` AS `id_indirizzo`,concat_ws(' ',`indirizzi`.`indirizzo`,`indirizzi`.`civico`,`indirizzi`.`cap`,`indirizzi`.`localita`,`comuni`.`nome`,`provincie`.`sigla`) AS `indirizzo`,`luoghi`.`nome` AS `nome`,`luoghi`.`id_account_inserimento` AS `id_account_inserimento`,`luoghi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`luoghi_path`(`luoghi`.`id`) AS `__label__` from (((`luoghi` left join `indirizzi` on((`indirizzi`.`id` = `luoghi`.`id_indirizzo`))) left join `comuni` on((`comuni`.`id` = `indirizzi`.`id_comune`))) left join `provincie` on((`provincie`.`id` = `comuni`.`id_provincia`)));

DROP TABLE IF EXISTS `macro_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `macro_view` AS select `macro`.`id` AS `id`,`macro`.`id_pagina` AS `id_pagina`,`macro`.`id_prodotto` AS `id_prodotto`,`macro`.`id_articolo` AS `id_articolo`,`macro`.`id_categoria_prodotti` AS `id_categoria_prodotti`,`macro`.`macro` AS `macro`,`macro`.`macro` AS `__label__` from `macro`;

DROP TABLE IF EXISTS `mail_out_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `mail_out_view` AS select `mail_out`.`id` AS `id`,`mail_out`.`id_mail` AS `id_mail`,`mail_out`.`id_mailing` AS `id_mailing`,`mail_out`.`ordine` AS `ordine`,`mail_out`.`timestamp_composizione` AS `timestamp_composizione`,`mail_out`.`mittente` AS `mittente`,`mail_out`.`destinatari` AS `destinatari`,`mail_out`.`destinatari_cc` AS `destinatari_cc`,`mail_out`.`destinatari_bcc` AS `destinatari_bcc`,`mail_out`.`oggetto` AS `oggetto`,`mail_out`.`allegati` AS `allegati`,`mail_out`.`headers` AS `headers`,`mail_out`.`server` AS `server`,`mail_out`.`host` AS `host`,`mail_out`.`port` AS `port`,`mail_out`.`user` AS `user`,`mail_out`.`password` AS `password`,`mail_out`.`token` AS `token`,`mail_out`.`tentativi` AS `tentativi`,`mail_out`.`timestamp_invio` AS `timestamp_invio`,date_format(from_unixtime(`mail_out`.`timestamp_invio`),'%Y-%m-%d') AS `data_ora_invio`,`mail_out`.`id_account_inserimento` AS `id_account_inserimento`,`mail_out`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`mail_out`.`destinatari`,' / ',`mail_out`.`oggetto`) AS `__label__` from `mail_out`;

DROP TABLE IF EXISTS `mail_sent_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `mail_sent_view` AS select `mail_sent`.`id` AS `id`,`mail_sent`.`id_mail` AS `id_mail`,`mail_sent`.`id_mailing` AS `id_mailing`,`mail_sent`.`ordine` AS `ordine`,`mail_sent`.`timestamp_composizione` AS `timestamp_composizione`,`mail_sent`.`mittente` AS `mittente`,`mail_sent`.`destinatari` AS `destinatari`,`mail_sent`.`destinatari_cc` AS `destinatari_cc`,`mail_sent`.`destinatari_bcc` AS `destinatari_bcc`,`mail_sent`.`oggetto` AS `oggetto`,`mail_sent`.`allegati` AS `allegati`,`mail_sent`.`headers` AS `headers`,`mail_sent`.`server` AS `server`,`mail_sent`.`host` AS `host`,`mail_sent`.`port` AS `port`,`mail_sent`.`user` AS `user`,`mail_sent`.`password` AS `password`,`mail_sent`.`token` AS `token`,`mail_sent`.`tentativi` AS `tentativi`,`mail_sent`.`timestamp_invio` AS `timestamp_invio`,date_format(from_unixtime(`mail_sent`.`timestamp_invio`),'%Y-%m-%d') AS `data_ora_invio`,`mail_sent`.`id_account_inserimento` AS `id_account_inserimento`,`mail_sent`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`mail_sent`.`destinatari`,' / ',`mail_sent`.`oggetto`) AS `__label__` from `mail_sent`;

DROP TABLE IF EXISTS `mail_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `mail_view` AS select `mail`.`id` AS `id`,`mail`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`mail`.`indirizzo` AS `indirizzo`,`mail`.`se_notifiche` AS `se_notifiche`,`mail`.`se_pec` AS `se_pec`,`mail`.`id_account_inserimento` AS `id_account_inserimento`,`mail`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),''),' ',`mail`.`indirizzo`) AS `__label__` from (`mail` left join `anagrafica` `a1` on((`a1`.`id` = `mail`.`id_anagrafica`)));

DROP TABLE IF EXISTS `marchi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `marchi_view` AS select `marchi`.`id` AS `id`,`marchi`.`nome` AS `nome`,`marchi`.`nome` AS `__label__` from `marchi`;

DROP TABLE IF EXISTS `mastri_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `mastri_view` AS select `mastri`.`id` AS `id`,`mastri`.`id_tipologia` AS `id_tipologia`,`tipologie_mastri`.`nome` AS `tipologia`,`mastri`.`nome` AS `nome`,`mastri_path`(`mastri`.`id`) AS `__label__` from (`mastri` left join `tipologie_mastri` on((`tipologie_mastri`.`id` = `mastri`.`id_tipologia`)));

DROP TABLE IF EXISTS `menu_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `menu_view` AS select `menu`.`id` AS `id`,`menu`.`id_lingua` AS `id_lingua`,`menu`.`id_pagina` AS `id_pagina`,`menu`.`id_categoria_prodotti` AS `id_categoria_prodotti`,`menu`.`id_categoria_notizie` AS `id_categoria_notizie`,`menu`.`id_categoria_risorse` AS `id_categoria_risorse`,`menu`.`ordine` AS `ordine`,`menu`.`menu` AS `menu`,`menu`.`nome` AS `nome`,`menu`.`target` AS `target`,`menu`.`sottopagine` AS `sottopagine`,`menu`.`id_account_inserimento` AS `id_account_inserimento`,`menu`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' / ',`menu`.`menu`,`menu`.`ordine`,`lingue`.`ietf`,`menu`.`nome`) AS `__label__` from (`menu` join `lingue` on((`lingue`.`id` = `menu`.`id_lingua`)));

DROP TABLE IF EXISTS `metadati_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `metadati_view` AS select `metadati`.`id` AS `id`,`metadati`.`id_lingua` AS `id_lingua`,`lingue`.`ietf` AS `ietf`,`metadati`.`id_anagrafica` AS `id_anagrafica`,`metadati`.`id_pagina` AS `id_pagina`,`metadati`.`id_prodotto` AS `id_prodotto`,`metadati`.`id_articolo` AS `id_articolo`,`metadati`.`id_categoria_prodotti` AS `id_categoria_prodotti`,`metadati`.`id_notizia` AS `id_notizia`,`metadati`.`id_categoria_notizie` AS `id_categoria_notizie`,`metadati`.`id_risorsa` AS `id_risorsa`,`metadati`.`id_categoria_risorse` AS `id_categoria_risorse`,`metadati`.`id_immagine` AS `id_immagine`,`metadati`.`id_video` AS `id_video`,`metadati`.`id_audio` AS `id_audio`,`metadati`.`id_file` AS `id_file`,`metadati`.`id_account_inserimento` AS `id_account_inserimento`,`metadati`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`metadati`.`nome`,':',`metadati`.`testo`) AS `__label__` from (`metadati` left join `lingue` on((`lingue`.`id` = `metadati`.`id_lingua`)));

DROP TABLE IF EXISTS `notizie_categorie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `notizie_categorie_view` AS select `notizie_categorie`.`id` AS `id`,`notizie_categorie`.`id_notizia` AS `id_notizia`,`notizie`.`nome` AS `notizia`,`notizie_categorie`.`id_categoria` AS `id_categoria`,`categorie_notizie_path`(`notizie_categorie`.`id_categoria`) AS `categoria`,`notizie_categorie`.`ordine` AS `ordine`,`notizie_categorie`.`id_account_inserimento` AS `id_account_inserimento`,`notizie_categorie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`notizie`.`nome`,' / ',`categorie_notizie_path`(`notizie_categorie`.`id_categoria`)) AS `__label__` from (`notizie_categorie` left join `notizie` on((`notizie`.`id` = `notizie_categorie`.`id_notizia`)));

DROP TABLE IF EXISTS `notizie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `notizie_view` AS select `notizie`.`id` AS `id`,`notizie`.`id_tipologia` AS `id_tipologia`,`tipologie_notizie`.`nome` AS `tipologia`,`notizie`.`nome` AS `nome`,group_concat(`categorie_notizie`.`nome` separator '|') AS `categorie`,`notizie`.`id_account_inserimento` AS `id_account_inserimento`,`notizie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`notizie`.`nome` AS `__label__` from (((`notizie` left join `tipologie_notizie` on((`tipologie_notizie`.`id` = `notizie`.`id_tipologia`))) left join `notizie_categorie` on((`notizie_categorie`.`id_notizia` = `notizie`.`id`))) left join `categorie_notizie` on((`categorie_notizie`.`id` = `notizie_categorie`.`id_categoria`))) group by `notizie`.`id`;

DROP TABLE IF EXISTS `organizzazioni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `organizzazioni_view` AS select `organizzazioni`.`id` AS `id`,`organizzazioni`.`id_genitore` AS `id_genitore`,`organizzazioni`.`ordine` AS `ordine`,`organizzazioni`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`organizzazioni`.`id_ruolo` AS `id_ruolo`,`ruoli_anagrafica`.`nome` AS `ruolo`,`organizzazioni`.`id_account_inserimento` AS `id_account_inserimento`,`organizzazioni`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`organizzazioni_path`(`organizzazioni`.`id`),`ruoli_anagrafica`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from ((`organizzazioni` left join `anagrafica` `a1` on((`a1`.`id` = `organizzazioni`.`id_anagrafica`))) left join `ruoli_anagrafica` on((`ruoli_anagrafica`.`id` = `organizzazioni`.`id_ruolo`)));

DROP TABLE IF EXISTS `pagamenti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `pagamenti_view` AS select `pagamenti`.`id` AS `id`,`pagamenti`.`id_tipologia` AS `id_tipologia`,`tipologie_pagamenti`.`nome` AS `tipologia`,`pagamenti`.`ordine` AS `ordine`,`pagamenti`.`nome` AS `nome`,`pagamenti`.`note` AS `note`,`pagamenti`.`id_documento` AS `id_documento`,`pagamenti`.`id_mastro_provenienza` AS `id_mastro_provenienza`,`m1`.`nome` AS `mastro_provenienza`,`pagamenti`.`id_mastro_destinazione` AS `id_mastro_destinazione`,`m2`.`nome` AS `mastro_destinazione`,`pagamenti`.`id_iban` AS `id_iban`,`pagamenti`.`importo_netto_totale` AS `importo_netto_totale`,`pagamenti`.`id_iva` AS `id_iva`,`iva`.`nome` AS `iva`,`pagamenti`.`id_listino` AS `id_listino`,`listini`.`nome` AS `listino`,`pagamenti`.`timestamp_pagamento` AS `timestamp_pagamento`,`pagamenti`.`id_account_inserimento` AS `id_account_inserimento`,`pagamenti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`pagamenti`.`nome` AS `__label__` from (((((`pagamenti` left join `tipologie_pagamenti` on((`tipologie_pagamenti`.`id` = `pagamenti`.`id_tipologia`))) left join `mastri` `m1` on((`m1`.`id` = `pagamenti`.`id_mastro_provenienza`))) left join `mastri` `m2` on((`m2`.`id` = `pagamenti`.`id_mastro_destinazione`))) left join `iva` on((`iva`.`id` = `pagamenti`.`id_iva`))) left join `listini` on((`listini`.`id` = `pagamenti`.`id_listino`)));

DROP TABLE IF EXISTS `pagine_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `pagine_view` AS select `pagine`.`id` AS `id`,`pagine`.`id_genitore` AS `id_genitore`,`pagine`.`id_sito` AS `id_sito`,`pagine`.`nome` AS `nome`,`pagine`.`template` AS `template`,`pagine`.`schema_html` AS `schema_html`,`pagine`.`tema_css` AS `tema_css`,`pagine`.`id_contenuti` AS `id_contenuti`,`pagine`.`se_sitemap` AS `se_sitemap`,`pagine`.`se_cacheable` AS `se_cacheable`,`pagine`.`id_account_inserimento` AS `id_account_inserimento`,`pagine`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`pagine_path`(`pagine`.`id`) AS `__label__` from `pagine`;

DROP TABLE IF EXISTS `pianificazioni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `pianificazioni_view` AS select `pianificazioni`.`id` AS `id`,`pianificazioni`.`id_progetto` AS `id_progetto`,`pianificazioni`.`id_todo` AS `id_todo`,`pianificazioni`.`id_attivita` AS `id_attivita`,`pianificazioni`.`nome` AS `nome`,`pianificazioni`.`id_periodicita` AS `id_periodicita`,`periodicita`.`nome` AS `periodicita`,`pianificazioni`.`cadenza` AS `cadenza`,`pianificazioni`.`se_lunedi` AS `se_lunedi`,`pianificazioni`.`se_martedi` AS `se_martedi`,`pianificazioni`.`se_mercoledi` AS `se_mercoledi`,`pianificazioni`.`se_giovedi` AS `se_giovedi`,`pianificazioni`.`se_venerdi` AS `se_venerdi`,`pianificazioni`.`se_sabato` AS `se_sabato`,`pianificazioni`.`se_domenica` AS `se_domenica`,`pianificazioni`.`schema_ripetizione` AS `schema_ripetizione`,`pianificazioni`.`data_elaborazione` AS `data_elaborazione`,`pianificazioni`.`giorni_estensione` AS `giorni_estensione`,`pianificazioni`.`data_fine` AS `data_fine`,`pianificazioni`.`workspace` AS `workspace`,`pianificazioni`.`token` AS `token`,`pianificazioni`.`id_account_inserimento` AS `id_account_inserimento`,`pianificazioni`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`pianificazioni`.`nome`,`periodicita`.`nome`,`pianificazioni`.`cadenza`) AS `__label__` from (`pianificazioni` left join `periodicita` on((`periodicita`.`id` = `pianificazioni`.`id_periodicita`)));

DROP TABLE IF EXISTS `popup_pagine_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `popup_pagine_view` AS select `popup_pagine`.`id` AS `id`,`popup_pagine`.`id_popup` AS `id_popup`,`popup_pagine`.`id_pagina` AS `id_pagina`,`popup_pagine`.`se_presente` AS `se_presente`,`popup_pagine`.`id_account_inserimento` AS `id_account_inserimento`,`popup_pagine`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`popup`.`nome`,' / ',`pagine_path`(`popup_pagine`.`id_pagina`),' / ',coalesce(`popup_pagine`.`se_presente`,0)) AS `__label__` from (`popup_pagine` left join `popup` on((`popup`.`id` = `popup_pagine`.`id_popup`)));

DROP TABLE IF EXISTS `popup_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `popup_view` AS select `popup`.`id` AS `id`,`popup`.`id_tipologia` AS `id_tipologia`,`tipologie_popup`.`nome` AS `tipologia`,`popup`.`id_sito` AS `id_sito`,`popup`.`nome` AS `nome`,`popup`.`html_id` AS `html_id`,`popup`.`html_class` AS `html_class`,`popup`.`html_class_attivazione` AS `html_class_attivazione`,`popup`.`n_scroll` AS `n_scroll`,`popup`.`n_secondi` AS `n_secondi`,`popup`.`template` AS `template`,`popup`.`schema_html` AS `schema_html`,`popup`.`se_ovunque` AS `se_ovunque`,`popup`.`id_account_inserimento` AS `id_account_inserimento`,`popup`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`popup`.`nome` AS `__label__` from (`popup` left join `tipologie_popup` on((`tipologie_popup`.`id` = `popup`.`id_tipologia`)));

DROP TABLE IF EXISTS `prezzi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `prezzi_view` AS select `prezzi`.`id` AS `id`,`prezzi`.`id_prodotto` AS `id_prodotto`,`prezzi`.`id_articolo` AS `id_articolo`,`prezzi`.`prezzo` AS `prezzo`,`prezzi`.`id_listino` AS `id_listino`,`listini`.`nome` AS `listino`,`valute`.`iso4217` AS `valuta`,`prezzi`.`id_iva` AS `id_iva`,`iva`.`descrizione` AS `iva`,`prezzi`.`id_account_inserimento` AS `id_account_inserimento`,`prezzi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`prezzi`.`id_prodotto`,`prezzi`.`id_articolo`,`prezzi`.`prezzo`,`listini`.`nome`,`valute`.`iso4217`,`iva`.`descrizione`) AS `__label__` from (((`prezzi` left join `listini` on((`listini`.`id` = `prezzi`.`id_listino`))) left join `valute` on((`valute`.`id` = `listini`.`id_valuta`))) left join `iva` on((`iva`.`id` = `prezzi`.`id_iva`)));

DROP TABLE IF EXISTS `prodotti_caratteristiche_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `prodotti_caratteristiche_view` AS select `prodotti_caratteristiche`.`id` AS `id`,`prodotti_caratteristiche`.`id_prodotto` AS `id_prodotto`,`prodotti_caratteristiche`.`id_caratteristica` AS `id_caratteristica`,`caratteristiche_prodotti`.`nome` AS `caratteristica`,`prodotti_caratteristiche`.`ordine` AS `ordine`,`prodotti_caratteristiche`.`id_account_inserimento` AS `id_account_inserimento`,`prodotti_caratteristiche`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`prodotti_caratteristiche`.`id_prodotto`,' / ',`caratteristiche_prodotti`.`nome`) AS `__label__` from (`prodotti_caratteristiche` left join `caratteristiche_prodotti` on((`caratteristiche_prodotti`.`id` = `prodotti_caratteristiche`.`id_caratteristica`)));

DROP TABLE IF EXISTS `prodotti_categorie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `prodotti_categorie_view` AS select `prodotti_categorie`.`id` AS `id`,`prodotti_categorie`.`id_prodotto` AS `id_prodotto`,`prodotti_categorie`.`id_categoria` AS `id_categoria`,`categorie_prodotti_path`(`prodotti_categorie`.`id_categoria`) AS `categoria`,`prodotti_categorie`.`id_ruolo` AS `id_ruolo`,`ruoli_prodotti`.`nome` AS `ruolo`,`prodotti_categorie`.`ordine` AS `ordine`,`prodotti_categorie`.`id_account_inserimento` AS `id_account_inserimento`,`prodotti_categorie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`prodotti_categorie`.`id_prodotto`,`ruoli_prodotti`.`nome`,`categorie_prodotti_path`(`prodotti_categorie`.`id_categoria`)) AS `__label__` from (`prodotti_categorie` left join `ruoli_prodotti` on((`ruoli_prodotti`.`id` = `prodotti_categorie`.`id_ruolo`)));

DROP TABLE IF EXISTS `prodotti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `prodotti_view` AS select `prodotti`.`id` AS `id`,`prodotti`.`id_tipologia` AS `id_tipologia`,`tipologie_prodotti`.`nome` AS `tipologia`,`tipologie_prodotti`.`se_prodotto` AS `se_prodotto`,`tipologie_prodotti`.`se_servizio` AS `se_servizio`,`prodotti`.`nome` AS `nome`,`prodotti`.`id_marchio` AS `id_marchio`,`marchi`.`nome` AS `marchio`,`prodotti`.`id_produttore` AS `id_produttore`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `produttore`,`prodotti`.`codice_produttore` AS `codice_produttore`,group_concat(distinct `categorie_prodotti_path`(`prodotti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`prodotti`.`id_account_inserimento` AS `id_account_inserimento`,`prodotti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`prodotti`.`id`,`prodotti`.`nome`) AS `__label__` from ((((`prodotti` left join `tipologie_prodotti` on((`tipologie_prodotti`.`id` = `prodotti`.`id_tipologia`))) left join `marchi` on((`marchi`.`id` = `prodotti`.`id_marchio`))) left join `anagrafica` `a1` on((`a1`.`id` = `prodotti`.`id_produttore`))) left join `prodotti_categorie` on((`prodotti_categorie`.`id_prodotto` = `prodotti`.`id`))) group by `prodotti`.`id`;

DROP TABLE IF EXISTS `progetti_amministrazione_archivio_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_amministrazione_archivio_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) where ((`progetti`.`data_accettazione` is not null) and (`progetti`.`data_chiusura` is not null) and (`progetti`.`data_archiviazione` is not null)) group by `progetti`.`id`;

DROP TABLE IF EXISTS `progetti_amministrazione_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_amministrazione_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) where ((`progetti`.`data_accettazione` is not null) and (`progetti`.`data_chiusura` is not null) and (`progetti`.`data_archiviazione` is null)) group by `progetti`.`id`;

DROP TABLE IF EXISTS `progetti_anagrafica_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_anagrafica_view` AS select `progetti_anagrafica`.`id` AS `id`,`progetti_anagrafica`.`id_progetto` AS `id_progetto`,`progetti`.`nome` AS `progetto`,`progetti_anagrafica`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`progetti_anagrafica`.`id_ruolo` AS `id_ruolo`,`ruoli_anagrafica`.`nome` AS `ruolo`,`progetti_anagrafica`.`ordine` AS `ordine`,`progetti_anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`progetti_anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),''),`ruoli_anagrafica`.`nome`) AS `__label__` from (((`progetti_anagrafica` left join `progetti` on((`progetti`.`id` = `progetti_anagrafica`.`id_progetto`))) left join `anagrafica` `a1` on((`a1`.`id` = `progetti_anagrafica`.`id_anagrafica`))) left join `ruoli_anagrafica` on((`ruoli_anagrafica`.`id` = `progetti_anagrafica`.`id_ruolo`)));

DROP TABLE IF EXISTS `progetti_categorie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_categorie_view` AS select `progetti_categorie`.`id` AS `id`,`progetti_categorie`.`id_progetto` AS `id_progetto`,`progetti`.`nome` AS `progetto`,`progetti_categorie`.`id_categoria` AS `id_categoria`,`categorie_progetti_path`(`progetti_categorie`.`id_categoria`) AS `categoria`,`progetti_categorie`.`ordine` AS `ordine`,`progetti_categorie`.`id_account_inserimento` AS `id_account_inserimento`,`progetti_categorie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`nome`,`categorie_progetti_path`(`progetti_categorie`.`id_categoria`)) AS `__label__` from (`progetti_categorie` left join `progetti` on((`progetti`.`id` = `progetti_categorie`.`id_progetto`)));

DROP TABLE IF EXISTS `progetti_commerciale_archivio_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_commerciale_archivio_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) where ((`progetti`.`data_accettazione` is null) and (`progetti`.`data_chiusura` is null) and (`progetti`.`data_archiviazione` is not null)) group by `progetti`.`id`;

DROP TABLE IF EXISTS `progetti_commerciale_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_commerciale_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) where ((`progetti`.`data_accettazione` is null) and (`progetti`.`data_chiusura` is null) and (`progetti`.`data_archiviazione` is null)) group by `progetti`.`id`;

DROP TABLE IF EXISTS `progetti_produzione_archivio_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_produzione_archivio_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) where ((`progetti`.`data_accettazione` is not null) and (`progetti`.`data_chiusura` is null) and (`progetti`.`data_archiviazione` is not null)) group by `progetti`.`id`;

DROP TABLE IF EXISTS `progetti_produzione_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_produzione_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) where ((`progetti`.`data_accettazione` is not null) and (`progetti`.`data_chiusura` is null) and (`progetti`.`data_archiviazione` is null)) group by `progetti`.`id`;

DROP TABLE IF EXISTS `progetti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `progetti_view` AS select `progetti`.`id` AS `id`,`progetti`.`id_tipologia` AS `id_tipologia`,`tipologie_progetti`.`nome` AS `tipologia`,`progetti`.`id_pianificazione` AS `id_pianificazione`,`progetti`.`id_cliente` AS `id_cliente`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `cliente`,`progetti`.`id_indirizzo` AS `id_indirizzo`,`progetti`.`nome` AS `nome`,`progetti`.`entrate_previste` AS `entrate_previste`,`progetti`.`ore_previste` AS `ore_previste`,`progetti`.`costi_previsti` AS `costi_previsti`,`progetti`.`entrate_accettazione` AS `entrate_accettazione`,`progetti`.`data_accettazione` AS `data_accettazione`,`progetti`.`data_chiusura` AS `data_chiusura`,`progetti`.`entrate_totali` AS `entrate_totali`,`progetti`.`uscite_totali` AS `uscite_totali`,`progetti`.`data_archiviazione` AS `data_archiviazione`,group_concat(distinct `categorie_progetti_path`(`progetti_categorie`.`id_categoria`) separator ' | ') AS `categorie`,`progetti`.`id_account_inserimento` AS `id_account_inserimento`,`progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`progetti`.`id`,`progetti`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from (((`progetti` left join `anagrafica` `a1` on((`a1`.`id` = `progetti`.`id_cliente`))) left join `tipologie_progetti` on((`tipologie_progetti`.`id` = `progetti`.`id_tipologia`))) left join `progetti_categorie` on((`progetti_categorie`.`id_progetto` = `progetti`.`id`))) group by `progetti`.`id`;

DROP TABLE IF EXISTS `provincie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `provincie_view` AS select `provincie`.`id` AS `id`,`provincie`.`id_regione` AS `id_regione`,`regioni`.`nome` AS `regione`,`regioni`.`id_stato` AS `id_stato`,`stati`.`nome` AS `stato`,`provincie`.`nome` AS `nome`,`provincie`.`sigla` AS `sigla`,`provincie`.`codice_istat` AS `codice_istat`,concat_ws(' ',`provincie`.`nome`,concat('(',`provincie`.`sigla`,')'),`stati`.`nome`) AS `__label__` from ((`provincie` join `regioni` on((`regioni`.`id` = `provincie`.`id_regione`))) join `stati` on((`stati`.`id` = `regioni`.`id_stato`)));

DROP TABLE IF EXISTS `pubblicazioni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `pubblicazioni_view` AS select `pubblicazioni`.`id` AS `id`,`pubblicazioni`.`id_tipologia` AS `id_tipologia`,`tipologie_pubblicazioni`.`nome` AS `tipologia`,`pubblicazioni`.`ordine` AS `ordine`,`pubblicazioni`.`id_prodotto` AS `id_prodotto`,`pubblicazioni`.`id_categoria_prodotti` AS `id_categoria_prodotti`,`pubblicazioni`.`id_notizia` AS `id_notizia`,`pubblicazioni`.`id_categoria_notizie` AS `id_categoria_notizie`,`pubblicazioni`.`id_pagina` AS `id_pagina`,`pubblicazioni`.`id_popup` AS `id_popup`,`pubblicazioni`.`timestamp_inizio` AS `timestamp_inizio`,`pubblicazioni`.`timestamp_fine` AS `timestamp_fine`,concat_ws(' ',`tipologie_pubblicazioni`.`nome`,`pubblicazioni`.`timestamp_inizio`,`pubblicazioni`.`timestamp_fine`) AS `__label__` from (`pubblicazioni` left join `tipologie_pubblicazioni` on((`tipologie_pubblicazioni`.`id` = `pubblicazioni`.`id_tipologia`)));

DROP TABLE IF EXISTS `ranking_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ranking_view` AS select `ranking`.`id` AS `id`,`ranking`.`nome` AS `nome`,`ranking`.`ordine` AS `ordine`,`ranking`.`id_account_inserimento` AS `id_account_inserimento`,`ranking`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`ranking`.`nome` AS `__label__` from `ranking`;

DROP TABLE IF EXISTS `redirect_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `redirect_view` AS select `redirect`.`id` AS `id`,`redirect`.`id_sito` AS `id_sito`,`redirect`.`codice` AS `codice`,`redirect`.`sorgente` AS `sorgente`,`redirect`.`destinazione` AS `destinazione`,`redirect`.`id_account_inserimento` AS `id_account_inserimento`,`redirect`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`redirect`.`sorgente`,`redirect`.`codice`,`redirect`.`destinazione`) AS `__label__` from `redirect`;

DROP TABLE IF EXISTS `regimi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `regimi_view` AS select `regimi`.`id` AS `id`,`regimi`.`nome` AS `nome`,`regimi`.`codice` AS `codice`,concat_ws(' ',`regimi`.`nome`,`regimi`.`codice`) AS `__label__` from `regimi`;

DROP TABLE IF EXISTS `regioni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `regioni_view` AS select `regioni`.`id` AS `id`,`regioni`.`id_stato` AS `id_stato`,`stati`.`nome` AS `stato`,`regioni`.`codice_istat` AS `codice_istat`,concat_ws(' ',`regioni`.`nome`,`stati`.`nome`) AS `__label__` from (`regioni` left join `stati` on((`stati`.`id` = `regioni`.`id_stato`)));

DROP TABLE IF EXISTS `reparti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `reparti_view` AS select `reparti`.`id` AS `id`,`reparti`.`id_iva` AS `id_iva`,`iva`.`aliquota` AS `iva`,`reparti`.`id_settore` AS `id_settore`,`settori_path`(`reparti`.`id_settore`) AS `settore`,`reparti`.`nome` AS `nome`,`reparti`.`id_account_inserimento` AS `id_account_inserimento`,`reparti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`reparti`.`nome` AS `__label__` from (`reparti` left join `iva` on((`iva`.`id` = `reparti`.`id_iva`)));

DROP TABLE IF EXISTS `risorse_anagrafica_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `risorse_anagrafica_view` AS select `risorse_anagrafica`.`id` AS `id`,`risorse_anagrafica`.`id_risorsa` AS `id_risorsa`,`risorse`.`nome` AS `risorsa`,`risorse_anagrafica`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`risorse_anagrafica`.`id_ruolo` AS `id_ruolo`,`ruoli_anagrafica_path`(`risorse_anagrafica`.`id_ruolo`) AS `ruolo`,`risorse_anagrafica`.`ordine` AS `ordine`,`risorse_anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`risorse_anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`risorse`.`nome`,`ruoli_anagrafica_path`(`risorse_anagrafica`.`id_ruolo`),coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from ((`risorse_anagrafica` left join `risorse` on((`risorse`.`id` = `risorse_anagrafica`.`id_risorsa`))) left join `anagrafica` `a1` on((`a1`.`id` = `risorse_anagrafica`.`id_anagrafica`)));

DROP TABLE IF EXISTS `risorse_categorie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `risorse_categorie_view` AS select `risorse_categorie`.`id` AS `id`,`risorse_categorie`.`id_risorsa` AS `id_risorsa`,`risorse`.`nome` AS `risorsa`,`risorse_categorie`.`id_categoria` AS `id_categoria`,`categorie_risorse_path`(`risorse_categorie`.`id_categoria`) AS `categorie_risorse_path( risorse_categorie.id_categoria )`,`risorse_categorie`.`id_account_inserimento` AS `id_account_inserimento`,`risorse_categorie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`risorse`.`nome`,`categorie_risorse_path`(`risorse_categorie`.`id_categoria`)) AS `__label__` from (`risorse_categorie` left join `risorse` on((`risorse`.`id` = `risorse_categorie`.`id_risorsa`)));

DROP TABLE IF EXISTS `risorse_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `risorse_view` AS select `risorse`.`id` AS `id`,`risorse`.`id_tipologia` AS `id_tipologia`,`tipologie_risorse`.`nome` AS `tipologia`,`risorse`.`codice` AS `codice`,`risorse`.`nome` AS `nome`,`risorse`.`id_testata` AS `id_testata`,`testate`.`nome` AS `testata`,`risorse`.`giorno_pubblicazione` AS `giorno_pubblicazione`,`risorse`.`mese_pubblicazione` AS `mese_pubblicazione`,`risorse`.`anno_pubblicazione` AS `anno_pubblicazione`,`risorse`.`id_account_inserimento` AS `id_account_inserimento`,`risorse`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`risorse`.`codice`,`risorse`.`nome`) AS `__label__` from ((`risorse` left join `tipologie_risorse` on((`tipologie_risorse`.`id` = `risorse`.`id_tipologia`))) left join `testate` on((`testate`.`id` = `risorse`.`id_testata`)));

DROP TABLE IF EXISTS `ruoli_anagrafica_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_anagrafica_view` AS select `ruoli_anagrafica`.`id` AS `id`,`ruoli_anagrafica`.`id_genitore` AS `id_genitore`,`ruoli_anagrafica`.`nome` AS `nome`,`ruoli_anagrafica`.`se_organizzazioni` AS `se_organizzazioni`,`ruoli_anagrafica`.`se_risorse` AS `se_risorse`,`ruoli_anagrafica`.`se_progetti` AS `se_progetti`,`ruoli_anagrafica_path`(`ruoli_anagrafica`.`id`) AS `__label__` from `ruoli_anagrafica`;

DROP TABLE IF EXISTS `ruoli_audio_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_audio_view` AS select `ruoli_audio`.`id` AS `id`,`ruoli_audio`.`id_genitore` AS `id_genitore`,`ruoli_audio`.`nome` AS `nome`,`ruoli_audio`.`html_entity` AS `html_entity`,`ruoli_audio`.`font_awesome` AS `font_awesome`,`ruoli_audio`.`se_anagrafica` AS `se_anagrafica`,`ruoli_audio`.`se_pagine` AS `se_pagine`,`ruoli_audio`.`se_prodotti` AS `se_prodotti`,`ruoli_audio`.`se_articoli` AS `se_articoli`,`ruoli_audio`.`se_categorie_prodotti` AS `se_categorie_prodotti`,`ruoli_audio`.`se_notizie` AS `se_notizie`,`ruoli_audio`.`se_categorie_notizie` AS `se_categorie_notizie`,`ruoli_audio`.`se_risorse` AS `se_risorse`,`ruoli_audio`.`se_categorie_risorse` AS `se_categorie_risorse`,`ruoli_audio_path`(`ruoli_audio`.`id`) AS `__label__` from `ruoli_audio`;

DROP TABLE IF EXISTS `ruoli_file_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_file_view` AS select `ruoli_file`.`id` AS `id`,`ruoli_file`.`id_genitore` AS `id_genitore`,`ruoli_file`.`nome` AS `nome`,`ruoli_file`.`html_entity` AS `html_entity`,`ruoli_file`.`font_awesome` AS `font_awesome`,`ruoli_file`.`se_anagrafica` AS `se_anagrafica`,`ruoli_file`.`se_pagine` AS `se_pagine`,`ruoli_file`.`se_prodotti` AS `se_prodotti`,`ruoli_file`.`se_articoli` AS `se_articoli`,`ruoli_file`.`se_categorie_prodotti` AS `se_categorie_prodotti`,`ruoli_file`.`se_notizie` AS `se_notizie`,`ruoli_file`.`se_categorie_notizie` AS `se_categorie_notizie`,`ruoli_file`.`se_risorse` AS `se_risorse`,`ruoli_file`.`se_categorie_risorse` AS `se_categorie_risorse`,`ruoli_file`.`se_mail` AS `se_mail`,`ruoli_file_path`(`ruoli_file`.`id`) AS `__label__` from `ruoli_file`;

DROP TABLE IF EXISTS `ruoli_immagini_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_immagini_view` AS select `ruoli_immagini`.`id` AS `id`,`ruoli_immagini`.`id_genitore` AS `id_genitore`,`ruoli_immagini`.`ordine_scalamento` AS `ordine_scalamento`,`ruoli_immagini`.`nome` AS `nome`,`ruoli_immagini`.`html_entity` AS `html_entity`,`ruoli_immagini`.`font_awesome` AS `font_awesome`,`ruoli_immagini`.`se_anagrafica` AS `se_anagrafica`,`ruoli_immagini`.`se_pagine` AS `se_pagine`,`ruoli_immagini`.`se_prodotti` AS `se_prodotti`,`ruoli_immagini`.`se_articoli` AS `se_articoli`,`ruoli_immagini`.`se_categorie_prodotti` AS `se_categorie_prodotti`,`ruoli_immagini`.`se_notizie` AS `se_notizie`,`ruoli_immagini`.`se_categorie_notizie` AS `se_categorie_notizie`,`ruoli_immagini`.`se_risorse` AS `se_risorse`,`ruoli_immagini`.`se_categorie_risorse` AS `se_categorie_risorse`,`ruoli_immagini_path`(`ruoli_immagini`.`id`) AS `__label__` from `ruoli_immagini`;

DROP TABLE IF EXISTS `ruoli_indirizzi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_indirizzi_view` AS select `ruoli_indirizzi`.`id` AS `id`,`ruoli_indirizzi`.`id_genitore` AS `id_genitore`,`ruoli_indirizzi`.`nome` AS `nome`,`ruoli_indirizzi`.`html_entity` AS `html_entity`,`ruoli_indirizzi`.`font_awesome` AS `font_awesome`,`ruoli_indirizzi`.`se_sede_legale` AS `se_sede_legale`,`ruoli_indirizzi`.`se_sede_operativa` AS `se_sede_operativa`,`ruoli_indirizzi`.`se_residenza` AS `se_residenza`,`ruoli_indirizzi`.`se_domicilio` AS `se_domicilio`,`ruoli_indirizzi_path`(`ruoli_indirizzi`.`id`) AS `__label__` from `ruoli_indirizzi`;

DROP TABLE IF EXISTS `ruoli_prodotti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_prodotti_view` AS select `ruoli_prodotti`.`id` AS `id`,`ruoli_prodotti`.`id_genitore` AS `id_genitore`,`ruoli_prodotti`.`nome` AS `nome`,`ruoli_prodotti_path`(`ruoli_prodotti`.`id`) AS `__label__` from `ruoli_prodotti`;

DROP TABLE IF EXISTS `ruoli_video_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `ruoli_video_view` AS select `ruoli_video`.`id` AS `id`,`ruoli_video`.`id_genitore` AS `id_genitore`,`ruoli_video`.`nome` AS `nome`,`ruoli_video`.`html_entity` AS `html_entity`,`ruoli_video`.`font_awesome` AS `font_awesome`,`ruoli_video`.`se_anagrafica` AS `se_anagrafica`,`ruoli_video`.`se_pagine` AS `se_pagine`,`ruoli_video`.`se_prodotti` AS `se_prodotti`,`ruoli_video`.`se_articoli` AS `se_articoli`,`ruoli_video`.`se_categorie_prodotti` AS `se_categorie_prodotti`,`ruoli_video`.`se_notizie` AS `se_notizie`,`ruoli_video`.`se_categorie_notizie` AS `se_categorie_notizie`,`ruoli_video`.`se_risorse` AS `se_risorse`,`ruoli_video`.`se_categorie_risorse` AS `se_categorie_risorse`,`ruoli_video_path`(`ruoli_video`.`id`) AS `__label__` from `ruoli_video`;

DROP TABLE IF EXISTS `settori_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `settori_view` AS select `settori`.`id` AS `id`,`settori`.`id_genitore` AS `id_genitore`,`settori`.`nome` AS `nome`,`settori`.`soprannome` AS `soprannome`,`settori`.`ateco` AS `ateco`,`settori_path`(`settori`.`id`) AS `__label__` from `settori`;

DROP TABLE IF EXISTS `sms_out_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `sms_out_view` AS select `sms_out`.`id` AS `id`,`sms_out`.`id_telefono` AS `id_telefono`,`sms_out`.`ordine` AS `ordine`,`sms_out`.`timestamp_composizione` AS `timestamp_composizione`,`sms_out`.`mittente` AS `mittente`,`sms_out`.`destinatari` AS `destinatari`,`sms_out`.`corpo` AS `corpo`,`sms_out`.`server` AS `server`,`sms_out`.`host` AS `host`,`sms_out`.`port` AS `port`,`sms_out`.`user` AS `user`,`sms_out`.`password` AS `password`,`sms_out`.`token` AS `token`,`sms_out`.`tentativi` AS `tentativi`,`sms_out`.`timestamp_invio` AS `timestamp_invio`,`sms_out`.`id_account_inserimento` AS `id_account_inserimento`,`sms_out`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`sms_out`.`destinatari`,`sms_out`.`corpo`) AS `__label__` from `sms_out`;

DROP TABLE IF EXISTS `sms_sent_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `sms_sent_view` AS select `sms_sent`.`id` AS `id`,`sms_sent`.`id_telefono` AS `id_telefono`,`sms_sent`.`ordine` AS `ordine`,`sms_sent`.`timestamp_composizione` AS `timestamp_composizione`,`sms_sent`.`mittente` AS `mittente`,`sms_sent`.`destinatari` AS `destinatari`,`sms_sent`.`corpo` AS `corpo`,`sms_sent`.`server` AS `server`,`sms_sent`.`host` AS `host`,`sms_sent`.`port` AS `port`,`sms_sent`.`user` AS `user`,`sms_sent`.`password` AS `password`,`sms_sent`.`token` AS `token`,`sms_sent`.`tentativi` AS `tentativi`,`sms_sent`.`timestamp_invio` AS `timestamp_invio`,`sms_sent`.`id_account_inserimento` AS `id_account_inserimento`,`sms_sent`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`sms_sent`.`destinatari`,`sms_sent`.`corpo`) AS `__label__` from `sms_sent`;

DROP TABLE IF EXISTS `software_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `software_view` AS select `software`.`id` AS `id`,`software`.`id_genitore` AS `id_genitore`,`software`.`id_articolo` AS `id_articolo`,concat(`prodotti`.`nome`,' - ',`articoli`.`nome`) AS `articolo`,`software`.`json` AS `json`,`software`.`nome` AS `nome`,`software`.`note` AS `note`,`software`.`id_account_inserimento` AS `id_account_inserimento`,`software`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`software_path`(`software`.`id`) AS `__label__` from ((`software` left join `articoli` on((`software`.`id_articolo` = `articoli`.`id`))) left join `prodotti` on((`prodotti`.`id` = `articoli`.`id_prodotto`)));

DROP TABLE IF EXISTS `stati_lingue_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `stati_lingue_view` AS select `stati_lingue`.`id` AS `id`,`stati_lingue`.`id_stato` AS `id_stato`,`stati`.`nome` AS `stato`,`stati_lingue`.`id_lingua` AS `id_lingua`,`lingue`.`nome` AS `lingua`,`stati_lingue`.`ordine` AS `ordine`,concat_ws(' ',`stati`.`nome`,`lingue`.`nome`) AS `__label__` from ((`stati_lingue` left join `stati` on((`stati`.`id` = `stati_lingue`.`id_stato`))) left join `lingue` on((`lingue`.`id` = `stati_lingue`.`id_lingua`)));

DROP TABLE IF EXISTS `stati_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `stati_view` AS select `stati`.`id` AS `id`,`stati`.`id_continente` AS `id_continente`,`continenti`.`nome` AS `continente`,`stati`.`nome` AS `nome`,`stati`.`iso31661alpha2` AS `iso31661alpha2`,`stati`.`iso31661alpha3` AS `iso31661alpha3`,`stati`.`codice_istat` AS `codice_istat`,`stati`.`data_archiviazione` AS `data_archiviazione`,concat_ws(' ',`continenti`.`nome`,`stati`.`nome`) AS `__label__` from (`stati` left join `continenti` on((`continenti`.`id` = `stati`.`id_continente`)));

DROP TABLE IF EXISTS `task_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `task_view` AS select `task`.`id` AS `id`,`task`.`minuto` AS `minuto`,`task`.`ora` AS `ora`,`task`.`giorno_del_mese` AS `giorno_del_mese`,`task`.`mese` AS `mese`,`task`.`giorno_della_settimana` AS `giorno_della_settimana`,`task`.`settimana` AS `settimana`,`task`.`task` AS `task`,`task`.`iterazioni` AS `iterazioni`,`task`.`delay` AS `delay`,`task`.`token` AS `token`,`task`.`timestamp_esecuzione` AS `timestamp_esecuzione`,`task`.`id_account_inserimento` AS `id_account_inserimento`,`task`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(' / ',coalesce(`task`.`minuto`,'*'),' / ',coalesce(`task`.`ora`,'*'),' / ',coalesce(`task`.`giorno_del_mese`,'*'),' / ',coalesce(`task`.`mese`,'*'),' / ',coalesce(`task`.`giorno_della_settimana`,'*'),' / ',coalesce(`task`.`settimana`,'*'),' / ',`task`.`task`) AS `__label__` from `task`;

DROP TABLE IF EXISTS `telefoni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `telefoni_view` AS select `telefoni`.`id` AS `id`,`telefoni`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`telefoni`.`id_tipologia` AS `id_tipologia`,`tipologie_telefoni`.`nome` AS `tipologia`,`telefoni`.`numero` AS `numero`,`telefoni`.`se_notifiche` AS `se_notifiche`,`telefoni`.`id_account_inserimento` AS `id_account_inserimento`,`telefoni`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),''),`tipologie_telefoni`.`nome`,`telefoni`.`numero`) AS `__label__` from ((`telefoni` left join `anagrafica` `a1` on((`a1`.`id` = `telefoni`.`id_anagrafica`))) left join `tipologie_telefoni` on((`tipologie_telefoni`.`id` = `telefoni`.`id_tipologia`)));

DROP TABLE IF EXISTS `template_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `template_view` AS select `template`.`id` AS `id`,`template`.`ruolo` AS `ruolo`,`template`.`nome` AS `nome`,`template`.`tipo` AS `tipo`,`template`.`note` AS `note`,`template`.`se_mail` AS `se_mail`,`template`.`se_sms` AS `se_sms`,`template`.`id_account_inserimento` AS `id_account_inserimento`,`template`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`template`.`ruolo` AS `__label__` from `template`;

DROP TABLE IF EXISTS `testate_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `testate_view` AS select `testate`.`id` AS `id`,`testate`.`nome` AS `nome`,`testate`.`nome` AS `__label__` from `testate`;

DROP TABLE IF EXISTS `tipologie_anagrafica_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_anagrafica_view` AS select `tipologie_anagrafica`.`id` AS `id`,`tipologie_anagrafica`.`id_genitore` AS `id_genitore`,`tipologie_anagrafica`.`ordine` AS `ordine`,`tipologie_anagrafica`.`nome` AS `nome`,`tipologie_anagrafica`.`html_entity` AS `html_entity`,`tipologie_anagrafica`.`font_awesome` AS `font_awesome`,`tipologie_anagrafica`.`se_persona_fisica` AS `se_persona_fisica`,`tipologie_anagrafica`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_anagrafica`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_anagrafica_path`(`tipologie_anagrafica`.`id`) AS `__label__` from `tipologie_anagrafica`;

DROP TABLE IF EXISTS `tipologie_attivita_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_attivita_view` AS select `tipologie_attivita`.`id` AS `id`,`tipologie_attivita`.`id_genitore` AS `id_genitore`,`tipologie_attivita`.`ordine` AS `ordine`,`tipologie_attivita`.`nome` AS `nome`,`tipologie_attivita`.`html_entity` AS `html_entity`,`tipologie_attivita`.`font_awesome` AS `font_awesome`,`tipologie_attivita`.`se_anagrafica` AS `se_anagrafica`,`tipologie_attivita`.`se_agenda` AS `se_agenda`,`tipologie_attivita`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_attivita`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_attivita_path`(`tipologie_attivita`.`id`) AS `__label__` from `tipologie_attivita`;

DROP TABLE IF EXISTS `tipologie_chiavi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_chiavi_view` AS select `tipologie_chiavi`.`id` AS `id`,`tipologie_chiavi`.`id_genitore` AS `id_genitore`,`tipologie_chiavi`.`ordine` AS `ordine`,`tipologie_chiavi`.`nome` AS `nome`,`tipologie_chiavi`.`html_entity` AS `html_entity`,`tipologie_chiavi`.`font_awesome` AS `font_awesome`,`tipologie_chiavi`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_chiavi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_chiavi_path`(`tipologie_chiavi`.`id`) AS `__label__` from `tipologie_chiavi`;

DROP TABLE IF EXISTS `tipologie_contatti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_contatti_view` AS select `tipologie_contatti`.`id` AS `id`,`tipologie_contatti`.`id_genitore` AS `id_genitore`,`tipologie_contatti`.`ordine` AS `ordine`,`tipologie_contatti`.`nome` AS `nome`,`tipologie_contatti`.`html_entity` AS `html_entity`,`tipologie_contatti`.`font_awesome` AS `font_awesome`,`tipologie_contatti`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_contatti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_contatti_path`(`tipologie_contatti`.`id`) AS `__label__` from `tipologie_contatti`;

DROP TABLE IF EXISTS `tipologie_documenti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_documenti_view` AS select `tipologie_documenti`.`id` AS `id`,`tipologie_documenti`.`id_genitore` AS `id_genitore`,`tipologie_documenti`.`ordine` AS `ordine`,`tipologie_documenti`.`nome` AS `nome`,`tipologie_documenti`.`html_entity` AS `html_entity`,`tipologie_documenti`.`font_awesome` AS `font_awesome`,`tipologie_documenti`.`se_fattura` AS `se_fattura`,`tipologie_documenti`.`se_nota_credito` AS `se_nota_credito`,`tipologie_documenti`.`se_trasporto` AS `se_trasporto`,`tipologie_documenti`.`se_pro_forma` AS `se_pro_forma`,`tipologie_documenti`.`se_offerta` AS `se_offerta`,`tipologie_documenti`.`se_ordine` AS `se_ordine`,`tipologie_documenti`.`se_ricevuta` AS `se_ricevuta`,`tipologie_documenti`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_documenti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_documenti_path`(`tipologie_documenti`.`id`) AS `__label__` from `tipologie_documenti`;

DROP TABLE IF EXISTS `tipologie_indirizzi_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_indirizzi_view` AS select `tipologie_indirizzi`.`id` AS `id`,`tipologie_indirizzi`.`id_genitore` AS `id_genitore`,`tipologie_indirizzi`.`ordine` AS `ordine`,`tipologie_indirizzi`.`nome` AS `nome`,`tipologie_indirizzi`.`html_entity` AS `html_entity`,`tipologie_indirizzi`.`font_awesome` AS `font_awesome`,`tipologie_indirizzi`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_indirizzi`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_indirizzi_path`(`tipologie_indirizzi`.`id`) AS `__label__` from `tipologie_indirizzi`;

DROP TABLE IF EXISTS `tipologie_licenze_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_licenze_view` AS select `tipologie_licenze`.`id` AS `id`,`tipologie_licenze`.`id_genitore` AS `id_genitore`,`tipologie_licenze`.`ordine` AS `ordine`,`tipologie_licenze`.`nome` AS `nome`,`tipologie_licenze`.`html_entity` AS `html_entity`,`tipologie_licenze`.`font_awesome` AS `font_awesome`,`tipologie_licenze`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_licenze`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_licenze_path`(`tipologie_licenze`.`id`) AS `__label__` from `tipologie_licenze`;

DROP TABLE IF EXISTS `tipologie_mastri_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_mastri_view` AS select `tipologie_mastri`.`id` AS `id`,`tipologie_mastri`.`id_genitore` AS `id_genitore`,`tipologie_mastri`.`ordine` AS `ordine`,`tipologie_mastri`.`nome` AS `nome`,`tipologie_mastri`.`html_entity` AS `html_entity`,`tipologie_mastri`.`font_awesome` AS `font_awesome`,`tipologie_mastri`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_mastri`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_mastri_path`(`tipologie_mastri`.`id`) AS `__label__` from `tipologie_mastri`;

DROP TABLE IF EXISTS `tipologie_notizie_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_notizie_view` AS select `tipologie_notizie`.`id` AS `id`,`tipologie_notizie`.`id_genitore` AS `id_genitore`,`tipologie_notizie`.`ordine` AS `ordine`,`tipologie_notizie`.`nome` AS `nome`,`tipologie_notizie`.`html_entity` AS `html_entity`,`tipologie_notizie`.`font_awesome` AS `font_awesome`,`tipologie_notizie`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_notizie`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_notizie_path`(`tipologie_notizie`.`id`) AS `__label__` from `tipologie_notizie`;

DROP TABLE IF EXISTS `tipologie_pagamenti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_pagamenti_view` AS select `tipologie_pagamenti`.`id` AS `id`,`tipologie_pagamenti`.`id_genitore` AS `id_genitore`,`tipologie_pagamenti`.`ordine` AS `ordine`,`tipologie_pagamenti`.`nome` AS `nome`,`tipologie_pagamenti`.`html_entity` AS `html_entity`,`tipologie_pagamenti`.`font_awesome` AS `font_awesome`,`tipologie_pagamenti`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_pagamenti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_pagamenti_path`(`tipologie_pagamenti`.`id`) AS `__label__` from `tipologie_pagamenti`;

DROP TABLE IF EXISTS `tipologie_popup_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_popup_view` AS select `tipologie_popup`.`id` AS `id`,`tipologie_popup`.`id_genitore` AS `id_genitore`,`tipologie_popup`.`ordine` AS `ordine`,`tipologie_popup`.`nome` AS `nome`,`tipologie_popup`.`html_entity` AS `html_entity`,`tipologie_popup`.`font_awesome` AS `font_awesome`,`tipologie_popup`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_popup`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_popup_path`(`tipologie_popup`.`id`) AS `__label__` from `tipologie_popup`;

DROP TABLE IF EXISTS `tipologie_prodotti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_prodotti_view` AS select `tipologie_prodotti`.`id` AS `id`,`tipologie_prodotti`.`id_genitore` AS `id_genitore`,`tipologie_prodotti`.`ordine` AS `ordine`,`tipologie_prodotti`.`nome` AS `nome`,`tipologie_prodotti`.`html_entity` AS `html_entity`,`tipologie_prodotti`.`font_awesome` AS `font_awesome`,`tipologie_prodotti`.`se_colori` AS `se_colori`,`tipologie_prodotti`.`se_taglie` AS `se_taglie`,`tipologie_prodotti`.`se_dimensioni` AS `se_dimensioni`,`tipologie_prodotti`.`se_imballo` AS `se_imballo`,`tipologie_prodotti`.`se_spedizione` AS `se_spedizione`,`tipologie_prodotti`.`se_trasporto` AS `se_trasporto`,`tipologie_prodotti`.`se_prodotto` AS `se_prodotto`,`tipologie_prodotti`.`se_servizio` AS `se_servizio`,`tipologie_prodotti`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_prodotti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_prodotti_path`(`tipologie_prodotti`.`id`) AS `__label__` from `tipologie_prodotti`;

DROP TABLE IF EXISTS `tipologie_progetti_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_progetti_view` AS select `tipologie_progetti`.`id` AS `id`,`tipologie_progetti`.`id_genitore` AS `id_genitore`,`tipologie_progetti`.`ordine` AS `ordine`,`tipologie_progetti`.`nome` AS `nome`,`tipologie_progetti`.`html_entity` AS `html_entity`,`tipologie_progetti`.`font_awesome` AS `font_awesome`,`tipologie_progetti`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_progetti`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_progetti_path`(`tipologie_progetti`.`id`) AS `__label__` from `tipologie_progetti`;

DROP TABLE IF EXISTS `tipologie_pubblicazioni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_pubblicazioni_view` AS select `tipologie_pubblicazioni`.`id` AS `id`,`tipologie_pubblicazioni`.`id_genitore` AS `id_genitore`,`tipologie_pubblicazioni`.`ordine` AS `ordine`,`tipologie_pubblicazioni`.`nome` AS `nome`,`tipologie_pubblicazioni`.`html_entity` AS `html_entity`,`tipologie_pubblicazioni`.`font_awesome` AS `font_awesome`,`tipologie_pubblicazioni`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_pubblicazioni`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_pubblicazioni_path`(`tipologie_pubblicazioni`.`id`) AS `__label__` from `tipologie_pubblicazioni`;

DROP TABLE IF EXISTS `tipologie_risorse_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_risorse_view` AS select `tipologie_risorse`.`id` AS `id`,`tipologie_risorse`.`id_genitore` AS `id_genitore`,`tipologie_risorse`.`ordine` AS `ordine`,`tipologie_risorse`.`nome` AS `nome`,`tipologie_risorse`.`html_entity` AS `html_entity`,`tipologie_risorse`.`font_awesome` AS `font_awesome`,`tipologie_risorse`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_risorse`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_risorse_path`(`tipologie_risorse`.`id`) AS `__label__` from `tipologie_risorse`;

DROP TABLE IF EXISTS `tipologie_telefoni_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_telefoni_view` AS select `tipologie_telefoni`.`id` AS `id`,`tipologie_telefoni`.`id_genitore` AS `id_genitore`,`tipologie_telefoni`.`ordine` AS `ordine`,`tipologie_telefoni`.`nome` AS `nome`,`tipologie_telefoni`.`html_entity` AS `html_entity`,`tipologie_telefoni`.`font_awesome` AS `font_awesome`,`tipologie_telefoni`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_telefoni`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_telefoni_path`(`tipologie_telefoni`.`id`) AS `__label__` from `tipologie_telefoni`;

DROP TABLE IF EXISTS `tipologie_todo_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_todo_view` AS select `tipologie_todo`.`id` AS `id`,`tipologie_todo`.`id_genitore` AS `id_genitore`,`tipologie_todo`.`ordine` AS `ordine`,`tipologie_todo`.`nome` AS `nome`,`tipologie_todo`.`html_entity` AS `html_entity`,`tipologie_todo`.`font_awesome` AS `font_awesome`,`tipologie_todo`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_todo`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_todo_path`(`tipologie_todo`.`id`) AS `__label__` from `tipologie_todo`;

DROP TABLE IF EXISTS `tipologie_url_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `tipologie_url_view` AS select `tipologie_url`.`id` AS `id`,`tipologie_url`.`id_genitore` AS `id_genitore`,`tipologie_url`.`ordine` AS `ordine`,`tipologie_url`.`nome` AS `nome`,`tipologie_url`.`html_entity` AS `html_entity`,`tipologie_url`.`font_awesome` AS `font_awesome`,`tipologie_url`.`id_account_inserimento` AS `id_account_inserimento`,`tipologie_url`.`id_account_aggiornamento` AS `id_account_aggiornamento`,`tipologie_url_path`(`tipologie_url`.`id`) AS `__label__` from `tipologie_url`;

DROP TABLE IF EXISTS `todo_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `todo_view` AS select `todo`.`id` AS `id`,`todo`.`id_tipologia` AS `id_tipologia`,`tipologie_todo`.`nome` AS `tipologia`,`todo`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`todo`.`id_cliente` AS `id_cliente`,coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`),'') AS `cliente`,`todo`.`id_indirizzo` AS `id_indirizzo`,concat_ws(' ',`indirizzi`.`indirizzo`,`indirizzi`.`civico`,`indirizzi`.`cap`,`indirizzi`.`localita`,`comuni`.`nome`,`provincie`.`sigla`) AS `indirizzo`,`todo`.`id_luogo` AS `id_luogo`,`luoghi_path`(`todo`.`id_luogo`) AS `luogo`,`todo`.`data_scadenza` AS `data_scadenza`,`todo`.`ora_scadenza` AS `ora_scadenza`,`todo`.`data_programmazione` AS `data_programmazione`,`todo`.`ora_inizio_programmazione` AS `ora_inizio_programmazione`,`todo`.`ora_fine_programmazione` AS `ora_fine_programmazione`,`todo`.`anno_programmazione` AS `anno_programmazione`,`todo`.`settimana_programmazione` AS `settimana_programmazione`,`todo`.`ore_programmazione` AS `ore_programmazione`,`todo`.`data_chiusura` AS `data_chiusura`,`todo`.`nome` AS `nome`,`todo`.`id_contatto` AS `id_contatto`,`todo`.`id_progetto` AS `id_progetto`,`todo`.`id_pianificazione` AS `id_pianificazione`,`todo`.`data_archiviazione` AS `data_archiviazione`,`todo`.`id_account_inserimento` AS `id_account_inserimento`,`todo`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`todo`.`nome`,' per ',coalesce(`a2`.`denominazione`,concat(`a2`.`cognome`,' ',`a2`.`nome`),''),' su ',`todo`.`id_progetto`) AS `__label__` from ((((((`todo` left join `anagrafica` `a1` on((`a1`.`id` = `todo`.`id_anagrafica`))) left join `anagrafica` `a2` on((`a2`.`id` = `todo`.`id_cliente`))) left join `indirizzi` on((`indirizzi`.`id` = `todo`.`id_indirizzo`))) left join `comuni` on((`comuni`.`id` = `indirizzi`.`id_comune`))) left join `provincie` on((`provincie`.`id` = `comuni`.`id_provincia`))) left join `tipologie_todo` on((`tipologie_todo`.`id` = `todo`.`id_tipologia`)));

DROP TABLE IF EXISTS `udm_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `udm_view` AS select `udm`.`id` AS `id`,coalesce(`udm`.`id_genitore`,`udm`.`id`) AS `id_genitore`,coalesce(`udm`.`conversione`,1) AS `conversione`,`udm`.`nome` AS `nome`,`udm`.`sigla` AS `sigla`,`udm`.`se_lunghezza` AS `se_lunghezza`,`udm`.`se_peso` AS `se_peso`,`udm`.`se_quantita` AS `se_quantita`,`udm`.`sigla` AS `__label__` from `udm`;

DROP TABLE IF EXISTS `url_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `url_view` AS select `url`.`id` AS `id`,`url`.`id_tipologia` AS `id_tipologia`,`tipologie_url`.`nome` AS `tipologia`,`url`.`id_anagrafica` AS `id_anagrafica`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'') AS `anagrafica`,`url`.`url` AS `url`,`url`.`nome` AS `nome`,`url`.`id_account_inserimento` AS `id_account_inserimento`,`url`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat_ws(' ',`url`.`url`,`tipologie_url`.`nome`,coalesce(`a1`.`denominazione`,concat(`a1`.`cognome`,' ',`a1`.`nome`),'')) AS `__label__` from ((`url` left join `anagrafica` `a1` on((`a1`.`id` = `url`.`id_anagrafica`))) left join `tipologie_url` on((`tipologie_url`.`id` = `url`.`id_tipologia`)));

DROP TABLE IF EXISTS `valute_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `valute_view` AS select `valute`.`id` AS `id`,`valute`.`iso4217` AS `iso4217`,`valute`.`html_entity` AS `html_entity`,`valute`.`utf8` AS `utf8`,`valute`.`iso4217` AS `__label__` from `valute`;

DROP TABLE IF EXISTS `video_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `video_view` AS select `video`.`id` AS `id`,`video`.`id_anagrafica` AS `id_anagrafica`,`video`.`id_pagina` AS `id_pagina`,`video`.`id_file` AS `id_file`,`video`.`id_prodotto` AS `id_prodotto`,`video`.`id_articolo` AS `id_articolo`,`video`.`id_categoria_prodotti` AS `id_categoria_prodotti`,`video`.`id_risorsa` AS `id_risorsa`,`video`.`id_categoria_risorse` AS `id_categoria_risorse`,`video`.`id_notizia` AS `id_notizia`,`video`.`id_categoria_notizie` AS `id_categoria_notizie`,`video`.`id_lingua` AS `id_lingua`,`lingue`.`nome` AS `lingua`,`video`.`id_ruolo` AS `id_ruolo`,`ruoli_video`.`nome` AS `ruolo`,`video`.`ordine` AS `ordine`,`video`.`nome` AS `nome`,`video`.`path` AS `path`,`video`.`id_embed` AS `id_embed`,`video`.`codice_embed` AS `codice_embed`,`video`.`embed_custom` AS `embed_custom`,`video`.`target` AS `target`,`video`.`orientamento` AS `orientamento`,`video`.`ratio` AS `ratio`,`video`.`id_account_inserimento` AS `id_account_inserimento`,`video`.`id_account_aggiornamento` AS `id_account_aggiornamento`,concat(`ruoli_video`.`nome`,' # ',`video`.`ordine`,' / ',`video`.`nome`,' / ',`video`.`path`) AS `__label__` from ((`video` left join `lingue` on((`lingue`.`id` = `video`.`id_lingua`))) left join `ruoli_video` on((`ruoli_video`.`id` = `video`.`id_ruolo`)));

-- 2026-10-02 — ogni tabella InnoDB, utf8, utf8_general_ci
--
-- Contesto: i file di base dichiarano ogni tabella ENGINE=InnoDB DEFAULT CHARSET=utf8, senza COLLATE, quindi con la
-- collation predefinita di utf8, utf8_general_ci; è quella di quasi tutte le tabelle dei deploy, e quella che le
-- funzioni di _070000999999.procedures.sql dichiarano sul valore che restituiscono. Misurato il 02/10/2026:
--
-- -# le viste statiche ( anagrafica_view_static, attivita_view_static, todo_view_static, iscrizioni_, corsi_, ... )
--    sono MyISAM su tutti i deploy, mentre i file di base le dichiarano InnoDB;
-- -# ruoli_categorie_progetti, relazioni_articoli e relazioni_prodotti, che nei file di base non avevano ENGINE e
--    CHARSET ( corretto nello stesso giro ), sono uscite utf8mb4_unicode_ci o utf8_unicode_ci, prendendo il
--    default del server o del database; su gimbe anche taglie, tipologie_taglie, tipologie_pubblicazione e __patch__.
--
-- Una colonna utf8_unicode_ci confrontata con una utf8_general_ci in una JOIN o in una vista dà "Illegal mix of
-- collations", e una tabella MyISAM non ha né transazioni né chiavi esterne.
--
-- COSA FA. Per ogni tabella vera del database che non sia InnoDB o non sia utf8_general_ci, una ALTER sola:
-- ENGINE=InnoDB e CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci. Da utf8mb4 la conversione fallisce se ci
-- sono caratteri fuori da utf8 ( emoji ): in quel caso la tabella resta com'è e lo si scrive nella nota. Ricopia le
-- tabelle che tocca: fuori orario.
--
-- La procedura riceve un filtro LIKE sui nomi delle tabelle ( '%' per tutte ). L'esito è in @motore_tabelle e
-- @motore_note.
--
-- IDEMPOTENTE: una seconda esecuzione non trova tabelle da convertire.

-- | 202610021800

CREATE OR REPLACE PROCEDURE `__patch_motore_collation__`( IN filtro VARCHAR(64) CHARACTER SET utf8 COLLATE utf8_general_ci )
BEGIN

    DECLARE fine INT DEFAULT 0;
    DECLARE errore INT DEFAULT 0;
    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE v_tabella CHAR(64) CHARACTER SET utf8;

    DECLARE lista CURSOR FOR
        SELECT TABLE_NAME FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = database() AND TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME LIKE filtro
          AND ( ENGINE <> 'InnoDB' OR TABLE_COLLATION <> 'utf8_general_ci' )
        ORDER BY TABLE_NAME;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fine = 1;

    SET @motore_tabelle = 0, @motore_note = NULL;

    OPEN lista;

    ciclo: LOOP

        FETCH lista INTO v_tabella;
        IF fine = 1 THEN
            LEAVE ciclo;
        END IF;

        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
                BEGIN
                    GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
                    SET errore = 1;
                END;
            SET errore = 0;
            SET @motore_sql = CONCAT( 'ALTER TABLE `', v_tabella, '` ENGINE=InnoDB, CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci' );
            PREPARE modifica FROM @motore_sql;
            EXECUTE modifica;
            DEALLOCATE PREPARE modifica;
            IF errore = 1 THEN
                SET @motore_note = CONCAT_WS( '\n', @motore_note, LEFT( CONCAT( v_tabella, ': ', messaggio ), 255 ) );
            ELSE
                SET @motore_tabelle = @motore_tabelle + 1;
            END IF;
        END;

    END LOOP;

    CLOSE lista;

END;

-- | 202610021801

-- si esegue su tutte le tabelle
CALL `__patch_motore_collation__`( '%' );

-- | 202610021802

-- quante tabelle sono state convertite, e quali no: lo legge chi applica la patch a mano
SELECT @motore_tabelle AS tabelle, @motore_note AS nota;

-- | 202610021803

-- si libera la procedura
DROP PROCEDURE IF EXISTS `__patch_motore_collation__`;

-- | FINE

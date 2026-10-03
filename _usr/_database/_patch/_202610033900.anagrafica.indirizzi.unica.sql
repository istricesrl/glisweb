-- 2026-10-03 — la UNIQUE `id_anagrafica_indirizzo` di anagrafica_indirizzi passa da ( id_anagrafica, indirizzo ) a
-- ( id_anagrafica, indirizzo, civico, cap, id_comune ), decisione di Fabio.
--
-- Il civico sta nella sua colonna: con la chiave vecchia la stessa anagrafica non poteva avere "Via Isonzo 5" e
-- "Via Isonzo 73", e con la collation _ci "Via X" e "VIA X" collidevano ( polmasi prod: 34 gruppi, 72 righe; la
-- 1510 documenta lo stesso 1062 ). Nessun upsert si appoggia a questa chiave: l'importazione usa `unica`
-- ( id_anagrafica, id_indirizzo ). Attenzione: con civico, cap o id_comune NULL le righe non collidono.
--
-- Le liste del canone in 1400, 3400 e 3700 e la tabella base sono gia' corrette; questa patch allinea i deploy che le
-- avevano gia' passate. Se manca una delle cinque colonne non tocca niente ( lo dira' canone-vivo ).
-- Un'istruzione per blocco, va anche su MySQL. IDEMPOTENTE.

-- | 202610033900

SET @unica_indirizzi = ( SELECT GROUP_CONCAT( COLUMN_NAME ORDER BY SEQ_IN_INDEX SEPARATOR ',' ) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'anagrafica_indirizzi' AND INDEX_NAME = 'id_anagrafica_indirizzo' );

-- | 202610033901

SET @unica_indirizzi_sql = IF(
    ( SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'anagrafica_indirizzi'
        AND COLUMN_NAME IN ( 'id_anagrafica', 'indirizzo', 'civico', 'cap', 'id_comune' ) ) < 5
    OR @unica_indirizzi <=> 'id_anagrafica,indirizzo,civico,cap,id_comune',
    'SELECT 1',
    CONCAT( 'ALTER TABLE `anagrafica_indirizzi` ', IF( @unica_indirizzi IS NULL, '', 'DROP INDEX `id_anagrafica_indirizzo`, ' ),
        'ADD UNIQUE KEY `id_anagrafica_indirizzo` (`id_anagrafica`,`indirizzo`,`civico`,`cap`,`id_comune`)' )
);

-- | 202610033902

PREPARE unica_indirizzi FROM @unica_indirizzi_sql;

-- | 202610033903

EXECUTE unica_indirizzi;

-- | 202610033904

DEALLOCATE PREPARE unica_indirizzi;

-- | FINE

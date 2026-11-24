-- 2026-11-04 — articoli_view_static.categorie da char(255) a text
--
-- categorie nella vista e' l'elenco delle categorie dell'articolo, mediumtext, e con molte categorie supera i 255
-- caratteri: sul dev di utensilerialughese il ripopolamento della statica e' fallito con 1406 su 24 articoli
-- ( mysql.err 2026-11-04 12:00, 88 articoli oltre i 255, il piu' lungo 521 ). Stesso caso di nome il 2026-10-04
-- ( _202610041203 ): si allarga la colonna come in prodotti_view_static, poi si ripopolano le righe troncate.
--
-- Dal 24/11/2026 la ALTER e il ripopolamento passano da __patch_statiche_forma__, come le altre istruzioni sulle statiche
-- ( 202610041000, 202610041203, 202611121300, 202611121400 ): su un DB senza articoli_view_static si saltano invece di
-- fermarsi in 1146. La procedura si crea qui, nel 1300, perche' i database nati dai file base non l'hanno ( come nella
-- 202611121286 ); per un deploy che aveva gia' applicato il vecchio 1300 i blocchi 1301 e 1302 non cambiano niente.

-- | 202611041300

-- la procedura che, se la statica c'e', prova un'istruzione e, se fallisce, lo annota invece di fermare la coda
CREATE OR REPLACE PROCEDURE `__patch_statiche_forma__`( IN tabella VARCHAR(64), IN istruzione LONGTEXT )
BEGIN

    DECLARE messaggio TEXT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 messaggio = MESSAGE_TEXT;
        END;

    IF EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = tabella ) THEN

        SET @statiche_forma_sql = istruzione;
        PREPARE prova FROM @statiche_forma_sql;
        IF messaggio IS NULL THEN
            EXECUTE prova;
            DEALLOCATE PREPARE prova;
        END IF;

        IF messaggio IS NOT NULL THEN
            SET @statiche_forma_note = CONCAT_WS( '\n', @statiche_forma_note, CONCAT( tabella, ': ', messaggio ) );
        END IF;

    END IF;

END;


-- | 202611041301

-- articoli_view_static: categorie da char(255) a text
CALL `__patch_statiche_forma__`( 'articoli_view_static', 'ALTER TABLE `articoli_view_static` MODIFY `categorie` text DEFAULT NULL' );

-- | 202611041302

-- articoli_view_static: il ripopolamento delle righe troncate
CALL `__patch_statiche_forma__`( 'articoli_view_static', 'REPLACE INTO `articoli_view_static` ( `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` )
	SELECT `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` FROM `articoli_view` WHERE char_length( `categorie` ) > 255' );

-- | FINE

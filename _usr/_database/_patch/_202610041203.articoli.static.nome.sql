-- 2026-10-04 — articoli_view_static.nome da char(128) a varchar(512)
--
-- nome nella vista e' prodotto + articolo e supera i 128 caratteri: su polmasi prod il ripopolamento della
-- statica ( _202610041200, blocco 1202 ) e' fallito con 1406 su 8 articoli. Si allarga la colonna e si ripopola.
--
-- Dal 17/11/2026 qui stanno anche le colonne di _202610041200, e tutto passa dalla procedura di _202611121300: su un
-- DB legacy senza la statica i blocchi si fermavano in 1146, adesso si saltano. La procedura si crea nel 1205, piu'
-- in alto di tutti i blocchi vecchi, perche' la trovi anche un deploy fermo a meta'.

-- | 202610041203

-- vuota dal 17/11/2026: si fermava in 1146 su un DB legacy senza articoli_view_static; sta nel 202610041206

-- | 202610041204

-- vuota dal 17/11/2026: si fermava in 1146 su un DB legacy senza articoli_view_static; sta nel 202610041207

-- | 202610041205

-- la procedura che, se la tabella c'e', prova un'istruzione e, se fallisce, lo annota invece di fermare la coda: e'
-- quella di _202611121300, creata in un blocco piu' alto di tutti quelli vecchi del file perche' la trovi anche un
-- deploy fermo a meta' ( 17/11/2026 )
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

-- | 202610041206

-- articoli_view_static: le tre colonne con cui comincia la vista e nome a varchar(512) ( erano 1201, 1202 e 1203 )
CALL `__patch_statiche_forma__`( 'articoli_view_static', 'ALTER TABLE `articoli_view_static`
	ADD COLUMN IF NOT EXISTS `tipologia_listino` char(64) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `pubblicazione` char(32) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `id_tipologia_pubblicazione` bigint(20) DEFAULT NULL FIRST,
	MODIFY `nome` varchar(512) DEFAULT NULL' );

-- | 202610041207

-- articoli_view_static: il ripopolamento ( era il 1204 )
CALL `__patch_statiche_forma__`( 'articoli_view_static', 'REPLACE INTO `articoli_view_static` ( `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` )
	SELECT `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` FROM `articoli_view`' );

-- | FINE

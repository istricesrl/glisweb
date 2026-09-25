-- 2026-09-25 — la chiave esterna id_genitore -> pianificazioni sui deploy che hanno avuto la tabella dalla patch
--
-- Contesto: la patch _202609251400.pianificazioni.sql rimette la tabella pianificazioni sui deploy esistenti senza
-- le chiavi esterne, che stanno solo nei file di base ( blocco 060000023600 ). Una di quelle chiavi non e' un
-- dettaglio di integrita': pianificazioni_ibfk_00, id_genitore -> pianificazioni.id, e' la strada per cui controller()
-- trova le righe figlie di una tabella ( segue le chiavi esterne che puntano a lei, tranne le _nofollow, vedi
-- _src/_lib/_controller.tools.php ). Senza, il form di una pianificazione di documenti caricato in GET non porta con
-- se' le pianificazioni figlie, e il sub form delle righe e dei pagamenti del modello resta vuoto anche quando le
-- figlie ci sono. Sui database installati dai file di base la chiave c'e' gia'.
--
-- COSA FA. Aggiunge la stessa chiave dei file di base, con lo stesso nome e le stesse regole ( ON DELETE NO ACTION ON
-- UPDATE CASCADE ), solo se:
--
-- -# su pianificazioni.id_genitore non c'e' gia' una chiave esterna, con qualunque nome ( un deploy installato dai
--    file di base, o uno che l'aveva da prima di marzo );
-- -# id_genitore e id hanno lo stesso tipo e id e' la chiave primaria: sulla tabella della fase per duplicazione
--    id e' int( 11 ) e id_genitore arriva bigint( 20 ) dalla patch del 1400, e la ALTER fallirebbe;
-- -# nessuna riga ha un id_genitore che non esiste, perche' la ALTER verificherebbe i dati e fallirebbe: le righe
--    orfane sono un problema del dato, e questa patch non e' il posto per decidere cosa farne.
--
-- Negli altri casi la patch non fa niente e lo dice. Le condizioni sono dentro un PREPARE guardato da
-- information_schema, come in _202609151510.sedi.inline.backfill.sql e _202609251300.embed.sql, perche' il task si
-- ferma al primo errore e lascerebbe indietro tutte le patch successive. Le altre chiavi esterne di pianificazioni
-- restano solo nei file di base, per i motivi scritti nella patch del 1400.

-- | 202609251500

-- la chiave, se manca e se si puo' aggiungere
SET @genitore = IF(
    EXISTS (
        SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = database()
          AND TABLE_NAME   = 'pianificazioni'
          AND COLUMN_NAME  = 'id_genitore'
          AND REFERENCED_TABLE_NAME IS NOT NULL
    ),
    "SELECT 'pianificazioni ha gia'' una chiave esterna su id_genitore' AS nota",
    IF(
        (
            SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'pianificazioni' AND COLUMN_NAME = 'id_genitore'
        ) <=> (
            SELECT COLUMN_TYPE FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = database() AND TABLE_NAME = 'pianificazioni' AND COLUMN_NAME = 'id'
        )
        AND EXISTS (
            SELECT 1 FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA    = database()
              AND TABLE_NAME      = 'pianificazioni'
              AND COLUMN_NAME     = 'id'
              AND CONSTRAINT_NAME = 'PRIMARY'
        ),
        IF(
            EXISTS (
                SELECT 1 FROM pianificazioni AS figlie
                LEFT JOIN pianificazioni AS genitori ON genitori.id = figlie.id_genitore
                WHERE figlie.id_genitore IS NOT NULL AND genitori.id IS NULL
            ),
            "SELECT 'pianificazioni ha righe con un id_genitore che non esiste: chiave non aggiunta' AS nota",
            "ALTER TABLE `pianificazioni`
    ADD CONSTRAINT `pianificazioni_ibfk_00` FOREIGN KEY (`id_genitore`) REFERENCES `pianificazioni` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE"
        ),
        "SELECT 'pianificazioni.id_genitore e pianificazioni.id hanno tipi diversi, o id non e'' la chiave primaria: chiave non aggiunta' AS nota"
    )
);

-- | 202609251501

-- si prepara
PREPARE genitore FROM @genitore;

-- | 202609251502

-- si esegue
EXECUTE genitore;

-- | 202609251503

-- e si libera
DEALLOCATE PREPARE genitore;

-- | FINE FILE

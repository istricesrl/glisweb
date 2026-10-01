-- 2026-09-30 — l'indice unico dei documenti comprende l'emittente
--
-- COSA SI VEDEVA. documenti.unica era ( id_tipologia, numero, sezionale ), mentre la numerazione si calcola per emittente
-- ( generaInfoNumeroDocumento() ): due emittenti con lo stesso sezionale, o due fornitori che mandano la fattura numero 1
-- senza sezionale, producevano la stessa chiave, e mysqlInsertRow(), che fa INSERT ... ON DUPLICATE KEY UPDATE, invece di
-- inserire il secondo documento sovrascriveva il primo.
--
-- COSA FA. Ricrea unica come ( id_emittente, id_tipologia, numero, sezionale ). Dove unica c'era, aggiungere una colonna
-- rende l'indice meno stretto e non puo' fallire per doppioni gia' presenti. Ma ci sono deploy dove unica non c'e' mai
-- stata ( utensilerialughese il 01/10/2026: 12.713 preventivi storici importati, numerati per anno ): li' i doppioni
-- possono esserci, e la ADD UNIQUE fermava tutta la catena con 1062. Se ci sono doppioni la patch non tocca l'indice e
-- lo scrive in @unica_emittente_note, che il blocco in fondo restituisce: i doppioni sono dati del cliente, e decidere
-- come distinguerli tocca a chi li conosce. Risolti, l'indice si mette a mano con l'ALTER che la nota riporta.
--
-- IDEMPOTENTE. L'indice si toglie con DROP INDEX IF EXISTS e si ricrea uguale; con doppioni non si tocca niente.

-- | 202609302340

CREATE OR REPLACE PROCEDURE `__patch_unica_emittente__`()
BEGIN

    DECLARE gruppi INT DEFAULT 0;

    SET @unica_emittente_note = NULL;

    -- gruppi di documenti che il nuovo indice rifiuterebbe ( NULL non collide in un indice unico )
    SELECT count(*) INTO gruppi FROM (
        SELECT 1 FROM documenti
        WHERE id_emittente IS NOT NULL AND id_tipologia IS NOT NULL AND numero IS NOT NULL AND sezionale IS NOT NULL
        GROUP BY id_emittente, id_tipologia, numero, sezionale
        HAVING count(*) > 1
    ) AS doppioni;

    IF gruppi = 0 THEN
        ALTER TABLE `documenti`
            DROP INDEX IF EXISTS `unica`,
            ADD UNIQUE KEY `unica` (`id_emittente`,`id_tipologia`,`numero`,`sezionale`);
    ELSE
        SET @unica_emittente_note = concat(
            'documenti.unica non creato: ', gruppi, ' gruppi di documenti con stessi id_emittente, id_tipologia, numero e ',
            'sezionale. Risolti i doppioni: ALTER TABLE documenti DROP INDEX IF EXISTS unica, ADD UNIQUE KEY unica ',
            '( id_emittente, id_tipologia, numero, sezionale )'
        );
    END IF;

END;

-- | 202609302341

CALL `__patch_unica_emittente__`();

-- | 202609302342

DROP PROCEDURE IF EXISTS `__patch_unica_emittente__`;

-- | 202609302343

-- quello che non si e' potuto fare, per chi applica la patch a mano
SELECT @unica_emittente_note AS nota;

-- | FINE FILE

-- 2026-11-20 — prodotti: codice a 64 caratteri
--
-- Il codice di un prodotto non è sempre scelto a mano: su bernispa i prodotti dei panieri nascono dal codice di
-- assortimento di SAM ( ext_assort_paniere ), che può superare i 32 caratteri ( CARTA_WHITEBACK_WATERBASED_MATT_120_GR
-- ne ha 38 ). Con char(32) l'insert fallisce con "Data too long for column 'codice'". Si porta a 64.
--
-- Cosa fa: allarga la colonna; l'indice UNIQUE `codice` resta quello che è.
--
-- IDEMPOTENTE.

-- | 202611201500

-- prodotti
ALTER TABLE `prodotti`
	MODIFY `codice` char(64) DEFAULT NULL;

-- | FINE FILE

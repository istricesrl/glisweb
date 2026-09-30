-- 2026-09-30 — l'indice unico dei documenti comprende l'emittente
--
-- COSA SI VEDEVA. documenti.unica era ( id_tipologia, numero, sezionale ), mentre la numerazione si calcola per emittente
-- ( generaInfoNumeroDocumento() ): due emittenti con lo stesso sezionale, o due fornitori che mandano la fattura numero 1
-- senza sezionale, producevano la stessa chiave, e mysqlInsertRow(), che fa INSERT ... ON DUPLICATE KEY UPDATE, invece di
-- inserire il secondo documento sovrascriveva il primo.
--
-- COSA FA. Ricrea unica come ( id_emittente, id_tipologia, numero, sezionale ). Aggiungere una colonna rende l'indice meno
-- stretto, quindi non puo' fallire per doppioni gia' presenti.
--
-- IDEMPOTENTE. L'indice si toglie con DROP INDEX IF EXISTS e si ricrea uguale.

-- | 202609302340

ALTER TABLE `documenti`
	DROP INDEX IF EXISTS `unica`,
	ADD UNIQUE KEY `unica` (`id_emittente`,`id_tipologia`,`numero`,`sezionale`);

-- | FINE FILE

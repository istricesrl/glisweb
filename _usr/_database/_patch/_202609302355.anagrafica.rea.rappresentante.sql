-- 2026-09-30 — iscrizione al REA e rappresentante fiscale nell'anagrafica
--
-- COSA SI VEDEVA. La fattura elettronica non poteva scrivere IscrizioneREA ( obbligatoria per le società iscritte al
-- registro delle imprese ) ne' RappresentanteFiscale ( per il cedente non residente che opera tramite un rappresentante in
-- Italia ): l'anagrafica non aveva dove tenere quei dati.
--
-- COSA FA. Aggiunge ad anagrafica l'ufficio e il numero REA, il capitale sociale, socio unico e stato di liquidazione, e
-- la chiave esterna verso l'anagrafica del rappresentante fiscale, con indice e vincolo ( _nofollow, SET NULL ).
--
-- IDEMPOTENTE. ADD COLUMN IF NOT EXISTS e ADD KEY IF NOT EXISTS; il vincolo si toglie con DROP FOREIGN KEY IF EXISTS e si
-- rimette uguale.

-- | 202609302355

ALTER TABLE `anagrafica`
	ADD COLUMN IF NOT EXISTS `rea_ufficio` char(2) DEFAULT NULL AFTER `id_regime`,
	ADD COLUMN IF NOT EXISTS `rea_numero` char(20) DEFAULT NULL AFTER `rea_ufficio`,
	ADD COLUMN IF NOT EXISTS `capitale_sociale` decimal(16,2) DEFAULT NULL AFTER `rea_numero`,
	ADD COLUMN IF NOT EXISTS `socio_unico` enum('SU','SM') DEFAULT NULL AFTER `capitale_sociale`,
	ADD COLUMN IF NOT EXISTS `stato_liquidazione` enum('LS','LN') DEFAULT NULL AFTER `socio_unico`,
	ADD COLUMN IF NOT EXISTS `id_rappresentante_fiscale` bigint(20) DEFAULT NULL AFTER `stato_liquidazione`,
	ADD KEY IF NOT EXISTS `id_rappresentante_fiscale` (`id_rappresentante_fiscale`);

-- | 202609302356

ALTER TABLE `anagrafica` DROP FOREIGN KEY IF EXISTS `anagrafica_ibfk_10_nofollow`;

-- | 202609302357

ALTER TABLE `anagrafica`
	ADD CONSTRAINT `anagrafica_ibfk_10_nofollow` FOREIGN KEY (`id_rappresentante_fiscale`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE FILE

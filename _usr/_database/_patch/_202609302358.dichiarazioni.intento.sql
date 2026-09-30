-- 2026-09-30 — dichiarazioni d'intento degli esportatori abituali
--
-- COSA SI VEDEVA. Le righe con natura N3.5 ( non imponibili a seguito di dichiarazione d'intento ) vanno accompagnate, nella
-- fattura elettronica, dal protocollo e dalla data della dichiarazione ( AltriDatiGestionali con TipoDato INTENTO ): il
-- framework non aveva dove registrarle.
--
-- COSA FA. Crea la tabella dichiarazioni_intento, figlia dell'anagrafica del cliente ( il vincolo verso anagrafica si
-- segue, cosi' le dichiarazioni compaiono nella scheda ), con indici, vincoli e vista.
--
-- IDEMPOTENTE. CREATE TABLE IF NOT EXISTS, indici con IF NOT EXISTS, vincoli tolti con DROP FOREIGN KEY IF EXISTS e rimessi,
-- vista con CREATE OR REPLACE.

-- | 202609302358

CREATE TABLE IF NOT EXISTS `dichiarazioni_intento` (             --
  `id` bigint(20) NOT NULL,                                      -- chiave primaria
  `id_anagrafica` bigint(20) DEFAULT NULL,                       -- chiave esterna per l'esportatore abituale che ha emesso la dichiarazione
  `protocollo` char(32) DEFAULT NULL,                         -- protocollo di ricezione telematica ( 17 cifre, trattino, 6 cifre )
  `data_protocollo` date DEFAULT NULL,                        -- data della ricevuta telematica
  `anno` int(4) DEFAULT NULL,                                 -- anno a cui si riferisce la dichiarazione
  `data_inizio` date DEFAULT NULL,                            -- inizio del periodo di validita', se la dichiarazione ne indica uno
  `data_fine` date DEFAULT NULL,                              -- fine del periodo di validita'
  `importo` decimal(16,2) DEFAULT NULL,                       -- importo fino a concorrenza del quale vale la dichiarazione
  `note` text DEFAULT NULL,                                   -- note
  `id_account_inserimento` bigint(20) DEFAULT NULL,              -- chiave esterna per l'account che ha inserito la dichiarazione
  `timestamp_inserimento` int(11) DEFAULT NULL,               -- timestamp di inserimento
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,            -- chiave esterna per l'account che ha aggiornato la dichiarazione
  `timestamp_aggiornamento` int(11) DEFAULT NULL              -- timestamp di aggiornamento
) ENGINE=InnoDB DEFAULT CHARSET=utf8;                         --

-- | 202609302359

ALTER TABLE `dichiarazioni_intento`
	ADD PRIMARY KEY IF NOT EXISTS (`id`),
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_anagrafica`,`protocollo`),
	ADD KEY IF NOT EXISTS `id_anagrafica` (`id_anagrafica`),
	ADD KEY IF NOT EXISTS `data_protocollo` (`data_protocollo`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`);

-- | 202610010000

ALTER TABLE `dichiarazioni_intento` MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

-- | 202610010001

ALTER TABLE `dichiarazioni_intento`
	DROP FOREIGN KEY IF EXISTS `dichiarazioni_intento_ibfk_01`,
	DROP FOREIGN KEY IF EXISTS `dichiarazioni_intento_ibfk_98_nofollow`,
	DROP FOREIGN KEY IF EXISTS `dichiarazioni_intento_ibfk_99_nofollow`;

-- | 202610010002

ALTER TABLE `dichiarazioni_intento`
    ADD CONSTRAINT `dichiarazioni_intento_ibfk_01`            FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `dichiarazioni_intento_ibfk_98_nofollow`   FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `dichiarazioni_intento_ibfk_99_nofollow`   FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202610010003

CREATE OR REPLACE VIEW `dichiarazioni_intento_view` AS
	SELECT
		dichiarazioni_intento.id,
		dichiarazioni_intento.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		dichiarazioni_intento.protocollo,
		dichiarazioni_intento.data_protocollo,
		dichiarazioni_intento.anno,
		dichiarazioni_intento.data_inizio,
		dichiarazioni_intento.data_fine,
		dichiarazioni_intento.importo,
		dichiarazioni_intento.id_account_inserimento,
		dichiarazioni_intento.id_account_aggiornamento,
		concat_ws( ' ', dichiarazioni_intento.protocollo, 'del', dichiarazioni_intento.data_protocollo ) AS __label__
	FROM dichiarazioni_intento
		LEFT JOIN anagrafica AS a1 ON a1.id = dichiarazioni_intento.id_anagrafica
;

-- | FINE FILE

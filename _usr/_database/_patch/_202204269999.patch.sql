--
-- PATCH
--

--| 202204260010
CREATE TABLE IF NOT EXISTS `messaggi` (
  `id` int(11) NOT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `id_destinatario` int(11) DEFAULT NULL,
  `testo` text,
  `timestamp_invio` int DEFAULT NULL,
  `timestamp_lettura` int DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB;

--| 202204260020
ALTER TABLE `messaggi`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_emittente` (`id_emittente`), 
	ADD KEY `id_destinatario` (`id_destinatario`), 
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_emittente`,`id_destinatario`,`timestamp_invio`,`timestamp_lettura`);

--| 202204260030
ALTER TABLE `messaggi` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204260040
ALTER TABLE `messaggi` 
  ADD CONSTRAINT `messaggi_ibfk_01_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `messaggi_ibfk_02_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `messaggi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `messaggi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202204260050
CREATE OR REPLACE VIEW `messaggi_view` AS
	SELECT
		messaggi.id,
		messaggi.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		messaggi.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		messaggi.timestamp_invio,
		messaggi.timestamp_lettura,
		messaggi.id_account_inserimento,
		messaggi.id_account_aggiornamento,
		concat( 'messaggio #', messaggi.id ) AS __label__
	FROM messaggi
        LEFT JOIN anagrafica AS a1 ON a1.id = messaggi.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = messaggi.id_destinatario
;

-- FINE
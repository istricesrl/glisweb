--
-- PATCH
--

--| 202203080005
CREATE TABLE IF NOT EXISTS `rinnovi_documenti_articoli` (
`id` int(11) NOT NULL,
  `id_rinnovo` int(11) NOT NULL,
  `id_documenti_articolo` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202203080010
ALTER TABLE `rinnovi_documenti_articoli`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_rinnovo` (`id_rinnovo`),
	ADD KEY `id_documenti_articolo` (`id_documenti_articolo`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD UNIQUE KEY `unico` (`id_documenti_articolo`,`id_rinnovo`);

--| 202203080020
ALTER TABLE `rinnovi_documenti_articoli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202203080030
ALTER TABLE `rinnovi_documenti_articoli`
ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_01` FOREIGN KEY (`id_rinnovo`) REFERENCES `rinnovi` (`id`)  ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_02` FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`)  ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `rinnovi_documenti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202203080040
CREATE OR REPLACE VIEW rinnovi_documenti_articoli_view AS
	SELECT
	rinnovi_documenti_articoli.id_documenti_articolo,
	rinnovi_documenti_articoli.id_rinnovo,
	concat( rinnovi_documenti_articoli.id_rinnovo ,' - ', rinnovi_documenti_articoli.id_documenti_articolo) AS __label__
	FROM rinnovi_documenti_articoli
	ORDER BY __label__
;

--| FINE FILE
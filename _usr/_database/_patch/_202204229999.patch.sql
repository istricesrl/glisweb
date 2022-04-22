--
-- PATCH
--

--| 202204220010
CREATE TABLE IF NOT EXISTS `causali` (
  `id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_trasporto` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202204220020
ALTER TABLE `causali`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `se_trasporto` (`se_trasporto`), 
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`se_trasporto`);

--| 202204220030
ALTER TABLE `causali` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204220040
ALTER TABLE documenti 
ADD COLUMN `id_causale` int(11) DEFAULT NULL  AFTER `id_mastro_destinazione`,
ADD COLUMN `id_trasportatore` int(11) DEFAULT NULL  AFTER `id_causale`,
ADD COLUMN   `porto` enum('franco','assegnato','-') DEFAULT NULL AFTER `id_trasportatore`,
ADD KEY `id_causale` (`id_causale`),
ADD KEY `id_trasportatore` (`id_trasportatore`),
ADD KEY `porto` (`porto`),
ADD CONSTRAINT `documenti_ibfk_10_nofollow` FOREIGN KEY (`id_causale`) REFERENCES `causali` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_ibfk_11_nofollow` FOREIGN KEY (`id_trasportatore`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202204220050
CREATE TABLE `colli` (
  `id` int(11) NOT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `ordine` int DEFAULT NULL,
  `codice` char(32) DEFAULT NULL,
  `larghezza` decimal(7,2) DEFAULT NULL,
  `lunghezza` decimal(7,2) DEFAULT NULL,
  `altezza` decimal(7,2) DEFAULT NULL,
  `id_udm_dimensioni` int DEFAULT NULL,
  `peso` decimal(7,2) DEFAULT NULL,
  `id_udm_peso` int DEFAULT NULL,
  `volume` decimal(7,2) DEFAULT NULL,
  `id_udm_volume` int DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL
) ENGINE=InnoDB;

--| 202204220060
ALTER TABLE `colli`
 	ADD PRIMARY KEY (`id`), 
 	ADD KEY `id_documento` (`id_documento`), 
	ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
	ADD KEY `id_udm_peso` (`id_udm_peso`),
	ADD KEY `id_udm_volume` (`id_udm_volume`),
 	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
 	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`ordine`,`codice`,`id_documento`),
	ADD KEY `indice_dimensioni` (`id`,`ordine`,`codice`,`id_documento`,`larghezza`,`lunghezza`,`altezza`,`peso`,`volume`);

--| 202204220070
ALTER TABLE `colli` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202204220080
ALTER TABLE `colli`
    ADD CONSTRAINT `colli_ibfk_01_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `colli_ibfk_02_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `colli_ibfk_03_nofollow` FOREIGN KEY (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `colli_ibfk_04_nofollow` FOREIGN KEY (`id_udm_volume`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	ADD CONSTRAINT `colli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `colli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;


--| 202204220090
ALTER TABLE documenti_articoli 
ADD COLUMN `id_collo` int(11) DEFAULT NULL  AFTER `id_matricola`,
ADD KEY `id_collo` (`id_collo`),
ADD CONSTRAINT `documenti_articoli_ibfk_16_nofollow`    FOREIGN KEY (`id_collo`) REFERENCES `colli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202204220100
ALTER TABLE categorie_anagrafica 
ADD COLUMN `se_corriere` int(1) DEFAULT NULL  AFTER se_notizie,
ADD KEY `se_corriere` (`se_corriere`);

--| 202204220110
INSERT INTO `categorie_anagrafica` (`id_genitore`, `ordine`, `nome`, `note`, `se_lead`, `se_prospect`, `se_cliente`, `se_fornitore`, `se_produttore`, `se_collaboratore`, `se_interno`, `se_esterno`, `se_concorrente`, `se_gestita`, `se_amministrazione`, `se_produzione`, `se_commerciale`, `se_notizie`, `se_corriere`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`)
VALUES (NULL, NULL, 'corriere', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, NULL);

--| 202204220120
ALTER TABLE ranking DROP KEY indice;

--| 202204220130
ALTER TABLE ranking 
ADD COLUMN `se_cliente` int(1) DEFAULT NULL  AFTER ordine,
ADD KEY `se_cliente` (`se_cliente`),
ADD COLUMN `se_fornitore` int(1) DEFAULT NULL  AFTER se_cliente,
ADD KEY `se_fornitore` (`se_fornitore`),
ADD KEY `indice` (`id`,`nome`,`ordine`,  `se_cliente`, `se_fornitore`);



-- FINE
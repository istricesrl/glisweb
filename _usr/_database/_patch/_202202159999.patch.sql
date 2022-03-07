--
-- PATCH
--

--| 202202150010
ALTER TABLE `categorie_progetti` 
ADD `se_materia` INT(1) NULL DEFAULT NULL AFTER `se_straordinario`, 
ADD `se_classe` INT(1) NULL DEFAULT NULL AFTER `se_materia`,
ADD KEY `se_materia`(`se_materia`),
ADD KEY `se_classe`(`se_classe`);

--| 202202150020
CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.template,
		categorie_progetti.schema_html,
		categorie_progetti.tema_css,
		categorie_progetti.se_sitemap,
		categorie_progetti.se_cacheable,
		categorie_progetti.id_sito,
		categorie_progetti.id_pagina,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
		categorie_progetti.se_materia,
		categorie_progetti.se_classe,
		count( c1.id ) AS figli,
		count( progetti_categorie.id ) AS membri,
		categorie_progetti.id_account_inserimento,
		categorie_progetti.id_account_aggiornamento,
		categorie_progetti_path( categorie_progetti.id ) AS __label__
	FROM categorie_progetti
		LEFT JOIN categorie_progetti AS c1 ON c1.id_genitore = categorie_progetti.id
		LEFT JOIN progetti_categorie ON progetti_categorie.id_categoria = categorie_progetti.id
	GROUP BY categorie_progetti.id
;

--| 202202150030
CREATE TABLE `tipologie_contratti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ordine` int DEFAULT NULL,
  `nome` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `html_entity` char(8) DEFAULT NULL,
  `font_awesome` char(16) DEFAULT NULL,
  `se_tesseramento` INT(1) NULL DEFAULT NULL,
  `se_abbonamento` INT(1) NULL DEFAULT NULL,
  `se_iscrizione` INT(1) NULL DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`nome`),
  KEY `ordine` (`ordine`),
  KEY `nome` (`nome`),
  KEY `se_tesseramento`(`se_tesseramento`),
  KEY `se_abbonamento`(`se_abbonamento`),
  KEY `se_iscrizione`(`se_iscrizione`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`nome`,`html_entity`,`font_awesome`),
  CONSTRAINT `tipologie_contratti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `tipologie_contratti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB;

--| 202202150040
CREATE TABLE `contratti` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipologia` int DEFAULT NULL,
  `id_emittente` int DEFAULT NULL,
  `id_destinatario` int NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `nome` char(32) DEFAULT NULL,
  `note` text,
  `id_account_inserimento` int DEFAULT NULL,
  `timestamp_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `timestamp_aggiornamento` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_tipologia` (`id_tipologia`),
  KEY `id_emittente` (`id_emittente`),
  KEY `id_destinatario` (`id_destinatario`),
  KEY `id_progetto` (`id_progetto`),
  KEY `indice` ( `id_tipologia`, `id_emittente`, `id_destinatario`, `nome`, `id_progetto`),
  CONSTRAINT `contratti_ibfk_01_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_contratti` (`id`),
  CONSTRAINT `contratti_ibfk_02_nofollow` FOREIGN KEY (`id_emittente`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `contratti_ibfk_03_nofollow` FOREIGN KEY (`id_destinatario`) REFERENCES `anagrafica` (`id`),
  CONSTRAINT `contratti_ibfk_04_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`),
  CONSTRAINT `contratti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `contratti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB;

--| 202202150050
CREATE TABLE IF NOT EXISTS `rinnovi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_contratto` int(11) DEFAULT NULL,
  `id_licenza` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `codice` char(64) DEFAULT NULL,
  `note` text,
  `se_automatico` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
   PRIMARY KEY (`id`),
    KEY `id_account_inserimento` (`id_account_inserimento`),
    KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `id_contratto` (`id_contratto`),
  KEY `id_licenza` (`id_licenza`),
  KEY `id_progetto` (`id_progetto`),
  KEY `indice` ( `id_contratto`, `id_licenza`, `id_progetto`, `data_inizio`, `data_fine`, `codice`),
  UNIQUE KEY `unica_contratto` (`id_contratto`, `data_inizio`, `data_fine`),
  UNIQUE KEY `unica_progetto` (`id_progetto`, `data_inizio`, `data_fine`),
  CONSTRAINT `rinnovi_ibfk_01` FOREIGN KEY (`id_contratto`) REFERENCES `contratti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rinnovi_ibfk_02` FOREIGN KEY (`id_licenza`) REFERENCES `licenze` (`id`)ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rinnovi_ibfk_03` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`)ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `rinnovi_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `rinnovi_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| 2022021500150
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		pagamenti.id_tipologia,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		pagamenti.id_documento,
        concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		pagamenti.importo_netto_totale,
		pagamenti.id_iva,
		iva.nome AS iva,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.timestamp_scadenza,
		from_unixtime( pagamenti.timestamp_scadenza, '%Y-%m-%d' ) AS data_ora_scadenza,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN iva ON iva.id = pagamenti.id_iva
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN documenti ON documenti.id = pagamenti.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
	WHERE
		tipologie_documenti.se_fattura = 1
		OR
		tipologie_documenti.se_ricevuta = 1
;

--| 2022021500160
ALTER TABLE `macro` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_categoria_risorse`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `macro_ibfk_09` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `macro_ibfk_10` FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 2022021500170
ALTER TABLE `macro` CHANGE `id_pagina` `id_pagina` INT(11) NULL;

--| FINE
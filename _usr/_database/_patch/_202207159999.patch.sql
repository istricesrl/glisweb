--
-- PATCH
--

--| 202207150010
CREATE TABLE IF NOT EXISTS `crediti` (
  `id` int(11) NOT NULL,
  `id_documenti_articolo` int(11) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `id_account_destinatario` int(11) DEFAULT NULL,
  `id_account_emittente` int(11) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202207150020
ALTER TABLE `crediti`
	ADD PRIMARY KEY (`id`), 
	ADD KEY `id_documenti_articolo` (`id_documenti_articolo`), 
	ADD KEY `id_account_emittente` (`id_account_emittente`), 
	ADD KEY `id_account_destinatario` (`id_account_destinatario`), 
	ADD KEY `id_mastro_provenienza` (`id_mastro_provenienza`), 
	ADD KEY `id_mastro_destinazione` (`id_mastro_destinazione`), 
    ADD KEY `id_pianificazione` (`id_pianificazione`),
	ADD KEY `data` (`data`), 
	ADD KEY `quantita` (`quantita`), 
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`id_documenti_articolo`,`data`,`id_account_emittente`,`id_account_destinatario`,`id_mastro_provenienza`,`id_mastro_destinazione`,`id_pianificazione`,  `quantita`,  `nome`);

--| 202207150030
ALTER TABLE `crediti` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202207150040
ALTER TABLE `crediti`
    ADD CONSTRAINT `crediti_ibfk_03_nofollow`    FOREIGN KEY (`id_documenti_articolo`) REFERENCES `documenti_articoli` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `crediti_ibfk_04_nofollow`    FOREIGN KEY (`id_account_emittente`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `crediti_ibfk_05_nofollow`    FOREIGN KEY (`id_account_destinatario`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `crediti_ibfk_06_nofollow`    FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `crediti_ibfk_07_nofollow`    FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	ADD CONSTRAINT `crediti_ibfk_08_nofollow`    FOREIGN KEY (`id_pianificazione`) REFERENCES `pianificazioni` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_98_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `crediti_ibfk_99_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202207150050
CREATE OR REPLACE VIEW `crediti_view` AS
    SELECT
		crediti.id,
		crediti.id_documenti_articolo,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' ',
			documenti_articoli.id_articolo
		) AS riga_documento,
		crediti.data,
		crediti.id_account_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS account_emittente,
		crediti.id_account_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS account_destinatario,
		crediti.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		crediti.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		crediti.quantita,
		crediti.id_pianificazione,
		crediti.nome,
		crediti.id_account_inserimento,
		crediti.id_account_aggiornamento,
		concat(
			crediti.data,
			' / ',
			tipologie_documenti.sigla,
			' / ',
			crediti.quantita,
			' x ',
			documenti_articoli.id_articolo,
			' / ',
			crediti.nome
		) AS __label__
	FROM
		crediti
		LEFT JOIN documenti_articoli ON documenti_articoli.id = crediti.id_documenti_articolo
        	LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
        	LEFT JOIN account AS acc1 ON acc1.id = crediti.id_account_emittente
		LEFT JOIN anagrafica AS a1 ON a1.id = acc1.id_anagrafica
		LEFT JOIN account AS acc2 ON acc2.id = crediti.id_account_destinatario
		LEFT JOIN anagrafica AS a2 ON a2.id = acc2.id_anagrafica
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = crediti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = crediti.id_mastro_destinazione
;



--| 202207150060
ALTER TABLE `tipologie_mastri`
ADD `se_credito` int(1) NULL AFTER `se_registro`;

--| 202207150070
INSERT INTO `tipologie_mastri` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_magazzino`, `se_conto`, `se_registro`, `se_credito`,`id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(4,	NULL,	NULL,	'crediti',	NULL,	NULL,	NULL,	NULL,	NULL,	1, NULL,	NULL,	NULL,	NULL);

--| 202207150080
CREATE OR REPLACE VIEW `tipologie_mastri_view` AS
	SELECT
		tipologie_mastri.id,
		tipologie_mastri.id_genitore,
		tipologie_mastri.ordine,
		tipologie_mastri.nome,
		tipologie_mastri.html_entity,
		tipologie_mastri.font_awesome,
		tipologie_mastri.se_magazzino,
		tipologie_mastri.se_conto,
		tipologie_mastri.se_registro,
		tipologie_mastri.se_credito,
		tipologie_mastri.id_account_inserimento,
		tipologie_mastri.id_account_aggiornamento,
		tipologie_mastri_path( tipologie_mastri.id ) AS __label__
	FROM tipologie_mastri
;
--| FINE
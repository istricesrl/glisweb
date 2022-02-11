--
-- PATCH
--

--| 202202070005
ALTER TABLE `attivita`
DROP CONSTRAINT `attivita_ibfk_07_nofollow`,
DROP CONSTRAINT `attivita_ibfk_08_nofollow`,
DROP CONSTRAINT `attivita_ibfk_09_nofollow`,
DROP CONSTRAINT `attivita_ibfk_10_nofollow`;

--| 202202070006
ALTER TABLE `attivita`
DROP  FOREIGN KEY `attivita_ibfk_07_nofollow`,
DROP  FOREIGN KEY `attivita_ibfk_08_nofollow`,
DROP  FOREIGN KEY `attivita_ibfk_09_nofollow`,
DROP  FOREIGN KEY `attivita_ibfk_10_nofollow`;

--| 202202070010
ALTER TABLE `attivita`
ADD `id_documento` int NULL AFTER `note_cliente`,
ADD `codice_archivium` char(32) DEFAULT NULL AFTER `id_mastro_destinazione`,
ADD KEY `id_documento` (`id_documento`),
ADD KEY `codice_archivium` (`codice_archivium`),
ADD CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_10_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_11_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202202070020
ALTER TABLE `attivita_view_static`
ADD `id_documento` int NULL AFTER `anagrafica`,
ADD `documento` char(255) NULL AFTER `id_documento`,
ADD `codice_archivium` char(32) DEFAULT NULL AFTER `mastro_destinazione`;

--| 202202070030
CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
		attivita.id,
		attivita.id_tipologia,
		tipologie_attivita.nome AS tipologia,
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		attivita.id_indirizzo,
		indirizzi.indirizzo AS indirizzo,
		attivita.id_luogo,
		luoghi_path( attivita.id_luogo ) AS luogo,
		attivita.data_scadenza,
		attivita.ora_scadenza,
		attivita.data_programmazione,
		attivita.ora_inizio_programmazione,
		attivita.ora_fine_programmazione,
		attivita.id_anagrafica_programmazione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS anagrafica_programmazione,
		attivita.ore_programmazione,
		attivita.data_attivita,
		day( data_attivita ) as giorno_attivita,
		month( data_attivita ) as mese_attivita,
		year( data_attivita ) as anno_attivita,
		attivita.ora_inizio,
		attivita.latitudine_ora_inizio,
		attivita.longitudine_ora_inizio,
		attivita.ora_fine,
		attivita.latitudine_ora_fine,
		attivita.longitudine_ora_fine,
		attivita.id_anagrafica,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		attivita.ore,
		attivita.nome,
		attivita.id_documento,
		concat(
			tipologie_documenti.nome,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
        attivita.codice_archivium,
		attivita.token,
		attivita.id_account_inserimento,
		attivita.id_account_aggiornamento,
		concat(
			attivita.nome,
			' / ',
			attivita.ore,
			' / ',
			coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' )
		) AS __label__
	FROM attivita
		LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = attivita.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = attivita.id_cliente
		LEFT JOIN anagrafica AS a3 ON a3.id = attivita.id_anagrafica_programmazione
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = attivita.id_progetto
		LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria
		LEFT JOIN progetti ON progetti.id = attivita.id_progetto
		LEFT JOIN todo ON todo.id = attivita.id_todo
		LEFT JOIN indirizzi ON indirizzi.id = attivita.id_indirizzo
		LEFT JOIN mastri AS m1 ON m1.id = attivita.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = attivita.id_mastro_destinazione
		LEFT JOIN documenti ON documenti.id = attivita.id_documento
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
;

--| 202202070035
CREATE TABLE IF NOT EXISTS `attivita_view_static` (
  `id` int NOT NULL,
  `id_tipologia` int DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` int DEFAULT NULL,
  `indirizzo` text,
  `id_luogo` int DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_anagrafica_programmazione` int DEFAULT NULL,
  `anagrafica_programmazione` char(255) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `giorno_attivita` int DEFAULT NULL,
  `mese_attivita` int DEFAULT NULL,
  `anno_attivita` int DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `id_anagrafica` int DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_documento` int DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `todo` char(255) DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `mastro_provenienza` char(64) DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `mastro_destinazione` char(64) DEFAULT NULL,
  `codice_archivium` char(32) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `__label__` varchar(320) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


--| 202202070040
TRUNCATE attivita_view_static;

--| 202202070050
INSERT INTO attivita_view_static SELECT * FROM attivita_view;

--| 202202070060
CREATE TABLE `mailing` (
  `id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `note` text DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--| 202202070080
ALTER TABLE `mailing`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`);
	

--| 202202070090
ALTER TABLE `mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202070100
ALTER TABLE `mailing`
    ADD CONSTRAINT `mailing_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `mailing_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202070110
CREATE OR REPLACE VIEW `mailing_view` AS
	SELECT
	mailing.id,
	mailing.nome,
	mailing.nome AS __label__
	FROM mailing
;

--| 202202070120
CREATE TABLE `mailing_mail` (
  `id` int(11) NOT NULL,
  `id_mailing` int(11) NOT NULL,
  `id_mail` int(11) NOT NULL,
  `id_mail_out` int(11) DEFAULT NULL,
  `timestamp_generazione` int(11) DEFAULT NULL,
  `timestamp_invio` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202070130
ALTER TABLE `mailing_mail`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_mail`(`id_mail`),
	ADD KEY `id_mail_out` (`id_mail_out`),
	ADD KEY `indice` (`id`,`id_mailing`, `id_mail`, `id_mail_out` );

--| 202202070140
ALTER TABLE `mailing` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202070150
ALTER TABLE `mailing_mail`
    ADD CONSTRAINT `mailing_mail_ibfk_01_nofollow`     FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mailing_mail_ibfk_02_nofollow`     FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `mailing_mail_ibfk_03_nofollow`     FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202070160
CREATE OR REPLACE VIEW `mailing_mail_view` AS
	SELECT
	mailing_mail.id,
	mailing_mail.id_mailing,
	mailing_mail.id_mail,
	mailing_mail.id_mail_out,
	concat(mailing_mail.id_mailing  , " | ", mailing_mail.id_mail , " | ", mailing_mail.id_mail_out) AS __label__
	FROM mailing_mail
;

--| 202202070170
CREATE TABLE `liste` (
  `id` int(11) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202070180
ALTER TABLE `liste`
	ADD PRIMARY KEY (`id`),
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`), 
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`), 
	ADD KEY `indice` (`id`,`nome`);

--| 202202070190
ALTER TABLE `liste` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202070200
ALTER TABLE `liste`
    ADD CONSTRAINT `liste_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `liste_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202070210   
CREATE OR REPLACE VIEW `liste_view` AS
	SELECT
	liste.id,
	liste.nome,
	liste.nome AS __label__
	FROM liste
;

--| 202202070220  
CREATE TABLE `liste_mail` (
  `id` int(11) NOT NULL,
  `id_lista` int(11) NOT NULL,
  `id_mail` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202070230  
ALTER TABLE `liste_mail`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_lista` (`id_lista`),
	ADD KEY `id_mail` (`id_mail`),
	ADD UNIQUE KEY `unica` (`id_lista`,`id_mail`);

--| 202202070240  
ALTER TABLE `liste_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202070250  
ALTER TABLE `liste_mail`
ADD CONSTRAINT `liste_mail_ibfk_01_nofollow` FOREIGN KEY (`id_lista`) REFERENCES `liste` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `liste_mail_ibfk_02_nofollow` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202070260  
CREATE OR REPLACE VIEW `liste_mail_view` AS
	SELECT
	liste_mail.id,
	liste_mail.id_lista,
	liste_mail.id_mail,
	concat( liste_mail.id_lista, liste_mail.id_mail ) AS __label__
	FROM liste_mail
;

--| 202202070270  
CREATE TABLE `mailing_liste` (
  `id` int(11) NOT NULL,
  `id_mailing` int(11) NOT NULL,
  `id_lista` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--| 202202070280  
ALTER TABLE `mailing_liste`
	ADD PRIMARY KEY (`id`),
	ADD KEY `id_mailing` (`id_mailing`),
	ADD KEY `id_lista` (`id_lista`),
	ADD UNIQUE KEY `unica` (`id_lista`,`id_mailing`);

--| 202202070290  
ALTER TABLE `mailing_liste` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202070295  
ALTER TABLE `mailing_liste`
ADD CONSTRAINT `mailing_liste_ibfk_02_nofollow` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `mailing_liste_ibfk_01_nofollow` FOREIGN KEY (`id_lista`) REFERENCES `liste` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202070299
CREATE OR REPLACE VIEW `mailing_liste_view` AS
	SELECT
	mailing_liste.id,
	mailing_liste.id_lista,
	mailing_liste.id_mailing,
	concat( mailing_liste.id_lista, mailing_liste.id_mailing ) AS __label__
	FROM mailing_liste
;

--| FINE
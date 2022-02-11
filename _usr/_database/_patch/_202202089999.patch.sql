--
-- PATCH
--

--| 202202080005
ALTER TABLE `mailing_mail` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202202080010
ALTER TABLE `contenuti` DROP CONSTRAINT `contenuti_ibfk_21`;

--| 202202080011
ALTER TABLE `contenuti` DROP FOREIGN KEY `contenuti_ibfk_21`;

--| 202202080015
ALTER TABLE `contenuti` 
ADD `id_mailing` int(11) NULL AFTER `id_template`,
ADD KEY `id_mailing` (`id_mailing`),
ADD CONSTRAINT `contenuti_ibfk_21`          FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `contenuti_ibfk_22`          FOREIGN KEY (`id_colore`) REFERENCES `colori` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
;

--| 202202080020
ALTER TABLE `file`
DROP CONSTRAINT `file_ibfk_09`,
DROP CONSTRAINT `file_ibfk_10`,
DROP CONSTRAINT `file_ibfk_11`,
DROP CONSTRAINT `file_ibfk_12`, 
DROP CONSTRAINT `file_ibfk_13_nofollow`,
DROP CONSTRAINT `file_ibfk_14`,
DROP CONSTRAINT `file_ibfk_15`;

--| 202202080021
ALTER TABLE `file`
DROP FOREIGN KEY `file_ibfk_09`,
DROP FOREIGN KEY  `file_ibfk_10`,
DROP FOREIGN KEY  `file_ibfk_11`,
DROP FOREIGN KEY  `file_ibfk_12`, 
DROP FOREIGN KEY  `file_ibfk_13_nofollow`,
DROP FOREIGN KEY  `file_ibfk_14`,
DROP FOREIGN KEY  `file_ibfk_15`;

--| 202202080030
ALTER TABLE `file` ADD `id_mailing` int NULL AFTER `id_template`,
    ADD KEY `id_mailing` (`id_mailing`),
    ADD CONSTRAINT `file_ibfk_09`           FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_10`           FOREIGN KEY (`id_notizia`) REFERENCES `notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_11`           FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_12`           FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_13`           FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_14_nofollow`  FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ADD CONSTRAINT `file_ibfk_15`           FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `file_ibfk_16`           FOREIGN KEY (`id_mail_sent`) REFERENCES `mail_sent` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
;

--| 202202080040
ALTER TABLE `mailing`
CHANGE `nome` `nome` char(255) COLLATE 'utf8_general_ci' NULL AFTER `id`;

--| 202202080045
ALTER TABLE `mailing_mail` DROP INDEX `indice`;

--| 202202080050
ALTER TABLE `mailing_mail`
ADD `token` char(128) DEFAULT NULL AFTER id_mail_out,
ADD KEY `token` (`token`), 
ADD KEY `indice` (`id`,`id_mailing`, `id_mail`, `id_mail_out`, `token` );

--| 202202080060
CREATE OR REPLACE VIEW `mailing_mail_view` AS
	SELECT
	mailing_mail.id,
	mailing_mail.id_mailing,
	mailing_mail.id_mail,
	mailing_mail.id_mail_out,
	mailing_mail.token,
	concat(mailing_mail.id_mailing  , " | ", mailing_mail.id_mail , " | ", mailing_mail.id_mail_out) AS __label__
	FROM mailing_mail
;

--| 202202080070
ALTER TABLE `mailing_liste`
DROP CONSTRAINT  `mailing_liste_ibfk_02_nofollow` ,
ADD CONSTRAINT `mailing_liste_ibfk_02` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202080071
ALTER TABLE `mailing_liste`
DROP FOREIGN KEY   `mailing_liste_ibfk_02_nofollow` ,
ADD CONSTRAINT `mailing_liste_ibfk_02` FOREIGN KEY (`id_mailing`) REFERENCES `mailing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE

--| 202202080080
ALTER TABLE `mailing_mail`
ADD UNIQUE `unica_mail` (`id_mailing`, `id_mail`);

--| 202202080100
ALTER TABLE `mailing_liste` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_lista`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `mailing_liste_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `mailing_liste_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202080110
ALTER TABLE `liste_mail` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_mail`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `liste_mail_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `liste_mail_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202080120
ALTER TABLE `mailing_mail` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `timestamp_invio`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `mailing_mail_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `mailing_mail_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202080130
ALTER TABLE `mailing_mail`
DROP FOREIGN KEY `mailing_mail_ibfk_03_nofollow`;

--| 202202080140
ALTER TABLE `mailing_mail`
ADD CONSTRAINT `mailing_mail_ibfk_03_nofollow`  FOREIGN KEY (`id_mail_out`) REFERENCES `mail_out` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202080150
CREATE OR REPLACE VIEW `mailing_view` AS
	SELECT
	mailing.id,
	mailing.nome,
	mailing.timestamp_invio,
	mailing.id_account_inserimento,
	mailing.id_account_aggiornamento,
	mailing.nome AS __label__
	FROM mailing
;

--| 202202080160
CREATE OR REPLACE VIEW `mailing_mail_view` AS
	SELECT
		mailing_mail.id,
		mailing_mail.id_mailing,
		mailing.nome AS mailing,
		mailing_mail.id_mail,
		mail.indirizzo AS mail,
		mail.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		mailing_mail.id_mail_out,
		mailing_mail.timestamp_generazione,
		from_unixtime( mailing_mail.timestamp_generazione, '%Y-%m-%d' ) AS data_ora_generazione,
		mailing_mail.timestamp_invio,
		from_unixtime( mailing_mail.timestamp_invio, '%Y-%m-%d' ) AS data_ora_invio,
		concat(mailing_mail.id_mailing  , " | ", mailing_mail.id_mail , " | ", mailing_mail.id_mail_out) AS __label__
	FROM mailing_mail
		INNER JOIN mailing ON mailing.id = mailing_mail.id_mailing
		INNER JOIN mail ON mail.id = mailing_mail.id_mail
		INNER JOIN anagrafica AS a1 ON a1.id = mail.id_anagrafica
;

--| FINE
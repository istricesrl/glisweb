--
-- PATCH
--

--| 202201240010
CREATE OR REPLACE VIEW task_view AS
	SELECT
		task.id,
		task.minuto,
		task.ora,
		task.giorno_del_mese,
		task.mese,
		task.giorno_della_settimana,
		task.settimana,
		task.task,
		task.iterazioni,
		task.delay,
		task.token,
		task.timestamp_esecuzione,
		from_unixtime( task.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
		task.id_account_inserimento,
		task.id_account_aggiornamento,
		CONCAT(
			' / ',
			coalesce( task.minuto, '*' ),
			' / ',
			coalesce( task.ora, '*' ),
			' / ',
			coalesce( task.giorno_del_mese, '*' ),
			' / ',
			coalesce( task.mese, '*' ),
			' / ',
			coalesce( task.giorno_della_settimana, '*' ),
			' / ',
			coalesce( task.settimana, '*' ),
			' / ',
			task.task
		) AS __label__
	FROM task
;

--| 202201240020
ALTER TABLE progetti_anagrafica ADD `se_sostituto` int(1) DEFAULT NULL AFTER `ordine`, ADD KEY `se_sostituto` (`se_sostituto`); 

--| 202201240030
ALTER TABLE `progetti_anagrafica` DROP INDEX `indice`;

--| 202201240040
ALTER TABLE `progetti_anagrafica`
ADD INDEX `indice` (`id`, `id_progetto`, `id_anagrafica`, `id_ruolo`, `ordine`, `se_sostituto`);

--| 202201240050
CREATE OR REPLACE VIEW progetti_anagrafica_view AS
	SELECT
		progetti_anagrafica.id,
		progetti_anagrafica.id_progetto,
		progetti.nome AS progetto,
		progetti_anagrafica.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		progetti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome as ruolo,
		progetti_anagrafica.ordine,
		progetti_anagrafica.se_sostituto,
		progetti_anagrafica.id_account_inserimento,
		progetti_anagrafica.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ),
			ruoli_anagrafica.nome
		) AS __label__
	FROM progetti_anagrafica
		LEFT JOIN progetti ON progetti.id = progetti_anagrafica.id_progetto
		LEFT JOIN anagrafica AS a1 ON a1.id = progetti_anagrafica.id_anagrafica
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = progetti_anagrafica.id_ruolo
;

--| 202201240060
ALTER TABLE attivita ADD `id_anagrafica_programmazione` int(11) DEFAULT NULL AFTER `ora_fine_programmazione`;

--| 202201240070
ALTER TABLE `attivita`
ADD KEY `id_anagrafica_programmazione` (`id_anagrafica_programmazione`),
CHANGE `id_anagrafica` `id_anagrafica` int NULL AFTER `longitudine_ora_fine`;

--| 202201240080
ALTER TABLE `attivita`
DROP FOREIGN KEY `attivita_ibfk_02_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_03_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_04_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_05_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_06_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_07_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_08_nofollow`,
DROP FOREIGN KEY `attivita_ibfk_09_nofollow`;

--| 202201240085
ALTER TABLE `attivita`
ADD CONSTRAINT `attivita_ibfk_02_nofollow` FOREIGN KEY (`id_cliente`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_03_nofollow` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `attivita_ibfk_04_nofollow` FOREIGN KEY (`id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `attivita_ibfk_05_nofollow` FOREIGN KEY (`id_anagrafica_programmazione`) REFERENCES `anagrafica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_06_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `attivita_ibfk_07_nofollow` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_08_nofollow` FOREIGN KEY (`id_todo`) REFERENCES `todo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_09_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `attivita_ibfk_10_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202201240090
ALTER TABLE `attivita_view_static`
ADD `id_anagrafica_programmazione` int(11) DEFAULT NULL AFTER `ora_fine_programmazione`,
ADD `anagrafica_programmazione` char(255) DEFAULT NULL AFTER `id_anagrafica_programmazione`,
CHANGE `id_anagrafica` `id_anagrafica` int NULL AFTER `longitudine_ora_fine`,
CHANGE `anagrafica` `anagrafica` char(255) NULL AFTER `id_anagrafica`;

--| 202201240100
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
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_todo,
		todo.nome AS todo,
		attivita.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		attivita.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
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
;

--| 202201240100
TRUNCATE attivita_view_static;

--| 202201240110
INSERT INTO attivita_view_static select * from attivita_view; 

--| 202201240120
ALTER TABLE attivita CHANGE `testo` `note` text NULL AFTER `nome`;

--| 202201240130
ALTER TABLE attivita 
ADD `note_cliente` text NULL after `note`;

--| 202201240140
ALTER TABLE `categorie_risorse` 	ADD KEY `id_sito` (`id_sito`);

--| 202201240150
ALTER TABLE `categorie_progetti` 
ADD  `se_ordinario` int(1) DEFAULT NULL AFTER `note`,
ADD  `se_straordinario` int(1) DEFAULT NULL AFTER `se_ordinario`,
ADD KEY `se_ordinario` (`se_ordinario`),
ADD KEY `se_straordinario` (`se_straordinario`);

--| 202201240160
CREATE OR REPLACE VIEW categorie_progetti_view AS
	SELECT
		categorie_progetti.id,
		categorie_progetti.id_genitore,
		categorie_progetti.ordine,
		categorie_progetti.nome,
		categorie_progetti.se_straordinario,
		categorie_progetti.se_ordinario,
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

--| 202201240170
ALTER TABLE `tipologie_progetti` 
    ADD  `se_contratto` tinyint(1) DEFAULT NULL AFTER `font_awesome`,
    ADD  `se_pacchetto` tinyint(1) DEFAULT NULL AFTER `se_contratto`,
    ADD  `se_progetto` tinyint(1) DEFAULT NULL AFTER `se_pacchetto`,
    ADD  `se_consuntivo` tinyint(1) DEFAULT NULL AFTER `se_progetto`,
    ADD  `se_forfait` tinyint(1) DEFAULT NULL AFTER `se_consuntivo`,
	ADD KEY `se_contratto` (`se_contratto`),
  	ADD KEY `se_pacchetto` (`se_pacchetto`),
    ADD KEY `se_progetto` (`se_progetto`),
    ADD KEY `se_consuntivo` (`se_consuntivo`),
    ADD KEY `se_forfait` (`se_forfait`);

--| 202201240180
CREATE OR REPLACE VIEW `tipologie_progetti_view` AS
	SELECT
		tipologie_progetti.id,
		tipologie_progetti.id_genitore,
		tipologie_progetti.ordine,
		tipologie_progetti.nome,
		tipologie_progetti.html_entity,
		tipologie_progetti.font_awesome,
		tipologie_progetti.se_contratto,
		tipologie_progetti.se_pacchetto,
		tipologie_progetti.se_progetto,
		tipologie_progetti.se_consuntivo,
		tipologie_progetti.se_forfait,
		tipologie_progetti.id_account_inserimento,
		tipologie_progetti.id_account_aggiornamento,
		tipologie_progetti_path( tipologie_progetti.id ) AS __label__
	FROM tipologie_progetti
;

--| 202201240190
INSERT IGNORE INTO `tipologie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `html_entity`, `font_awesome`, `se_contratto`, `se_pacchetto`, `se_progetto`, `se_consuntivo`, `se_forfait`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'contratto',	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'pacchetto',	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(3,	NULL,	NULL,	'progetto',	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL),
(4,	NULL,	NULL,	'consuntivo',	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(5,	NULL,	NULL,	'forfait',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| 202201240195
INSERT IGNORE INTO `categorie_progetti` (`id`, `id_genitore`, `ordine`, `nome`, `se_ordinario`, `se_straordinario`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`) VALUES
(1,	NULL,	NULL,	'ordinario',	1,	NULL,	NULL,	NULL,	NULL,	NULL),
(2,	NULL,	NULL,	'straordinario',	NULL,	1,	NULL,	NULL,	NULL,	NULL);

--| FINE FILE

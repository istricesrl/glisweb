--
-- PATCH
--

--| 202209160010
ALTER TABLE `attivita` DROP KEY `indice`;

--| 202209160020
ALTER TABLE `attivita`
    ADD COLUMN `id_contatto` int(11) DEFAULT NULL AFTER `id_cliente`, 
    ADD KEY `id_contatto` (`id_contatto`),
	ADD KEY `indice` (`id`,`id_tipologia`,`id_anagrafica`,`id_cliente`,`id_contatto`,`id_progetto`,`id_todo`);

--| 202209160030
ALTER TABLE `attivita`
    ADD CONSTRAINT `attivita_ibfk_15_nofollow` FOREIGN KEY (`id_contatto`) REFERENCES `contatti` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202209160040
CREATE OR REPLACE VIEW `attivita_view` AS
	SELECT	
		attivita.id,
		attivita.id_tipologia,
		tipologie_attivita.nome AS tipologia,
		attivita.id_cliente,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		attivita.id_contatto,
		c1.nome AS contatto,
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
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		attivita.id_progetto,
		progetti.nome AS progetto,
		attivita.id_matricola,
        attivita.id_immobile,
		attivita.id_pianificazione,
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
		LEFT JOIN contatti AS c1 ON c1.id = attivita.id_contatto
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

--| 202209160050
DROP TABLE attivita_view_static;

--| 202209160060
CREATE TABLE `attivita_view_static` (
  `id` int NOT NULL,
  `id_tipologia` int DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `id_cliente` int DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_contatto` int DEFAULT NULL,
  `contatto` char(255) DEFAULT NULL,
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
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_documento` int DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `id_matricola` int DEFAULT NULL,
  `id_immobile` int DEFAULT NULL,
  `id_pianificazione` int DEFAULT NULL,
  `id_todo` int DEFAULT NULL,
  `todo` char(255) DEFAULT NULL,
  `id_mastro_provenienza` int DEFAULT NULL,
  `mastro_provenienza` char(64) DEFAULT NULL,
  `id_mastro_destinazione` int DEFAULT NULL,
  `mastro_destinazione` char(64) DEFAULT NULL,
  `codice_archivium` char(128) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` int DEFAULT NULL,
  `id_account_aggiornamento` int DEFAULT NULL,
  `__label__` varchar(320) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
--| FINE
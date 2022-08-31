--
-- PATCH
--

--| 202204129010
DROP TABLE attivita_view_static;

--| 202204129020
CREATE TABLE `attivita_view_static` (
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
  `ore` decimal(5,2) DEFAULT NULL,
  `nome` char(255) NOT NULL,
  `id_documento` int DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
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

--| 202204129030
INSERT INTO attivita_view_static select * from attivita_view


--| FINE FILE


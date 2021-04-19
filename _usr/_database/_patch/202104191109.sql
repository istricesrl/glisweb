CREATE TABLE IF NOT EXISTS `sostituzioni_progetti` (
  `id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_scopertura` date NOT NULL,
  `data_scarto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
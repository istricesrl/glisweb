CREATE TABLE IF NOT EXISTS `pause_progetti` (
`id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `data_inizio` date NOT NULL,
  `data_fine` date NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `turni` (
`id` int(11) NOT NULL,
  `turno` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_contratto` int(11) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
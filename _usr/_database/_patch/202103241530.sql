CREATE TABLE IF NOT EXISTS `variazioni_attivita` (
`id` int(11) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_tipologia_inps` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_richiesta` date NOT NULL,
  `data_approvazione` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
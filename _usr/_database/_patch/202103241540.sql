CREATE TABLE IF NOT EXISTS `periodi_variazioni_attivita` (
`id` int(11) NOT NULL,
  `id_variazione` int(11) NOT NULL,
  `data_inizio` date NOT NULL,
  `data_fine` date NOT NULL,
  `ora_inizio` time NOT NULL,
  `ora_fine` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
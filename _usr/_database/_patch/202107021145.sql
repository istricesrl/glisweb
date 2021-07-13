CREATE TABLE IF NOT EXISTS `cartellini` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_attivita` date NOT NULL,
  `id_tipologia_inps` int(11) NOT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

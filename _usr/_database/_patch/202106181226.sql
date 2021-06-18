CREATE TABLE IF NOT EXISTS `certificazioni` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_emittente` int(11) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

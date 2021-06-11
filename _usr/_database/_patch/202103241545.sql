CREATE TABLE IF NOT EXISTS `sostituzioni_attivita` (
`id` int(11) NOT NULL,
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_richiesta` date NOT NULL,
  `data_accettazione` date DEFAULT NULL,
  `data_rifiuto` date DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
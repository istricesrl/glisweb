CREATE TABLE IF NOT EXISTS `progetti_certificazioni` (
`id` int(11) NOT NULL,
  `id_certificazione` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

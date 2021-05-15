CREATE TABLE IF NOT EXISTS `progetti_categorie` (
`id` int(11) NOT NULL,
  `id_progetto` CHAR(32) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
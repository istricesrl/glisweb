CREATE TABLE IF NOT EXISTS `todo_articoli` (
`id` int(11) NOT NULL,
  `id_todo` int(11) NOT NULL,
  `id_articolo` char(32) NOT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
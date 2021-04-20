CREATE TABLE IF NOT EXISTS `strategie` (
`id` int(11) NOT NULL,
  `nome` char(128) NOT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `obiettivo` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
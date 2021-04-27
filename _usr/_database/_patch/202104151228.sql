CREATE TABLE IF NOT EXISTS `obiettivi` (
`id` int(11) NOT NULL,
  `id_genitore` int(11) DEFAULT NULL,
  `nome` int(11) NOT NULL,
  `data_inizio` int(11) DEFAULT NULL,
  `data_fine` int(11) DEFAULT NULL,
  `sorgente` int(11) NOT NULL,
  `obiettivo` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `id_fase_strategia` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

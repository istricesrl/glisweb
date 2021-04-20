CREATE TABLE IF NOT EXISTS `obiettivi_prodotti` (
`id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `nome_colonna` char(64) NOT NULL,
  `valore_colonna` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

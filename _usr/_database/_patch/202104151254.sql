CREATE TABLE IF NOT EXISTS `obiettivi_prodotti` (
`id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `id_prodotto` char(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
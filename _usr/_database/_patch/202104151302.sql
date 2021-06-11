CREATE TABLE IF NOT EXISTS `obiettivi_categorie_prodotti` (
`id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `id_categoria_prodotti` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
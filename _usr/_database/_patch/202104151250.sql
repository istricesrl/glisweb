CREATE TABLE IF NOT EXISTS `obiettivi_anagrafica` (
`id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `id_obiettivo` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
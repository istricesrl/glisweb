CREATE TABLE IF NOT EXISTS `menu` (
`id` int(11) NOT NULL,
  `id_pagina` int(11) NOT NULL,
  `id_lingua` int(11) NOT NULL,
  `menu` char(32) NOT NULL,
  `nome` char(128) NOT NULL,
  `target` char(16) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `sottopagine` char(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

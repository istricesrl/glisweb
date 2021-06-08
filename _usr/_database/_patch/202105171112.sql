CREATE TABLE IF NOT EXISTS `reparti` (
`id` int(11) NOT NULL,
  `id_iva` int(11) NOT NULL,
  `id_settore` int(11) DEFAULT NULL,
  `nome` char(64) NOT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

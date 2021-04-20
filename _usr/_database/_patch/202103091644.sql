 CREATE TABLE IF NOT EXISTS `mastri` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_commerciale` int(1) DEFAULT NULL,
  `se_produzione` int(1) DEFAULT NULL,
  `se_amministrazione` int(1) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS `pianificazioni` (
`id` int(11) NOT NULL,
  `entita` char(255) NOT NULL,
  `nome` char(255) DEFAULT NULL,
  `workspace` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

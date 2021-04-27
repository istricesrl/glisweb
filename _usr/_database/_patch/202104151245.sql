CREATE TABLE IF NOT EXISTS `obiettivi_tracking` (
`id` int(11) NOT NULL,
  `id_obiettivo` int(11) NOT NULL,
  `id_tracking` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
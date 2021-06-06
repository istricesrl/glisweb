CREATE TABLE IF NOT EXISTS `refresh_view_statiche` (
`id` int(11) NOT NULL,
  `entita` char(64) NOT NULL,
  `note` text,
  `timestamp_prenotazione` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

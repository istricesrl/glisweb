CREATE TABLE IF NOT EXISTS `progetti_anagrafica` (
`id` int(11) NOT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `id_ruolo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
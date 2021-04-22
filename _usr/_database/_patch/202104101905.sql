CREATE TABLE IF NOT EXISTS `__report_progetti_assenze__` (
  `id_progetto` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_assenza` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
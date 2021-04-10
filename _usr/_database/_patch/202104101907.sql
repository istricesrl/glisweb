CREATE TABLE IF NOT EXISTS `__report_attivita_assenze__` (
  `id_attivita` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `data_assenza` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
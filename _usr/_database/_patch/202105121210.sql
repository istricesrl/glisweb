CREATE TABLE IF NOT EXISTS `__report_progetti_sostituti__` (
`id` int(11) NOT NULL,
  `id_progetto` char(32) NOT NULL,
  `data_prima_scopertura` date NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `punti_totali` int(11) DEFAULT NULL,
  `punti_sostituto` int(11) DEFAULT NULL,
  `punti_progetto` int(11) DEFAULT NULL,
  `punti_copertura` int(11) DEFAULT NULL,
  `punti_distanza` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
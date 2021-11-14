CREATE TABLE IF NOT EXISTS `__report_ore_operatori_per_progetto__` (
`id` int(11) NOT NULL,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_progetto` int(11) NOT NULL,
  `ore_contratto` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

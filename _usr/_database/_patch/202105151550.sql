CREATE TABLE IF NOT EXISTS `__report_sostituzioni_attivita__` (
`id` int(11) NOT NULL,
  `id_attivita` char(32) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `punteggio` int(11) DEFAULT NULL,
  `punti_sostituto` int(11) DEFAULT NULL,
  `punti_progetto` int(11) DEFAULT NULL,
  `punti_disponibilita` int(11) DEFAULT NULL,
  `punti_distanza` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
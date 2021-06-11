-- __report_ore_progetti_tipologie_mastri__
-- NOTA: questa è una tabella, di seguito il resto del codice per crearla, valutare se separarlo come per le altre tabelle, pure essendo questo un report
CREATE TABLE IF NOT EXISTS `__report_ore_progetti_tipologie_mastri__` (
`id` int(11) NOT NULL,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_tipologia_attivita` int(11) DEFAULT NULL,
  `id_mastro` int(11) DEFAULT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

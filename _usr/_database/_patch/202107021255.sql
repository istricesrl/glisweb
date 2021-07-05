CREATE TABLE IF NOT EXISTS `fasce_orari_contratti` (
`id` int(11) NOT NULL,
  `id_contratto` int(11) NOT NULL,
  `turno` INT NULL DEFAULT '1',
  `id_giorno` int(11) NOT NULL,
  `ora_inizio` time NOT NULL,
  `ora_fine` time NOT NULL,
  `id_tipologia_inps` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

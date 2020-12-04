CREATE TABLE IF NOT EXISTS `anagrafica_servizi_contatto` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_servizio_contatto` int(11) NOT NULL,
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
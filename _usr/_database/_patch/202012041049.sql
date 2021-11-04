CREATE TABLE IF NOT EXISTS `anagrafica_provenienze` (
`id` int(11) NOT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `id_provenienza` int(11) NOT NULL,
  `testo` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

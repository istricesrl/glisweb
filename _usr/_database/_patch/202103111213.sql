CREATE TABLE IF NOT EXISTS `documenti` (
  `id` int(11) NOT NULL,
  `numero` int(11) NOT NULL,
  `id_tipologia` int(11) NOT NULL,
  `data` date NOT NULL,
  `id_destinatario` int(11) NOT NULL,
  `id_sede_destinatario` int(11) DEFAULT NULL,
  `id_emittente` int(11) NOT NULL,
  `id_sede_emittente` int(11) DEFAULT NULL,
  `note_interne` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
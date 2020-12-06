CREATE TABLE IF NOT EXISTS `condizioni_pagamento` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `descrizione` text,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
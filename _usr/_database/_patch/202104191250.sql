CREATE TABLE IF NOT EXISTS `tipologie_todo` (
`id` int(11) NOT NULL,
  `nome` char(64) NOT NULL,
  `se_pianificata` int(1) DEFAULT NULL,
  `se_richiesta` int(1) DEFAULT NULL,
  `se_imprevista` int(1) DEFAULT NULL,
  `se_ordinaria` int(1) DEFAULT NULL,
  `se_chiamata` int(1) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
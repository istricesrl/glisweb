CREATE TABLE IF NOT EXISTS `tipologie_documenti` (
`id` int(11) NOT NULL,
  `nome` char(255) NOT NULL,
  `codice` char(8) DEFAULT NULL,
  `se_fattura` int(1) DEFAULT NULL,
  `se_nota_credito` int(1) DEFAULT NULL,
  `se_trasporto` int(1) DEFAULT NULL,
  `se_pro_forma` int(1) DEFAULT NULL,
  `se_offerta` int(1) DEFAULT NULL,
  `se_ordine` int(1) DEFAULT NULL,
  `se_ricevuta` int(1) DEFAULT NULL,
  `stampa_xml` char(255) DEFAULT NULL,
  `stampa_pdf` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
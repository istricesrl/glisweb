INSERT INTO `tipologie_documenti` (`id`, `nome`, `codice`, `se_fattura`, `se_nota_credito`, `se_trasporto`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_ricevuta`) VALUES
(1, 'fattura', 'TD01', 1, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'fattura accompagnatoria', 'TD01', 1, NULL, 1, NULL, NULL, NULL, NULL),
(3, 'nota di credito', 'TD04', NULL, 1, NULL, NULL, NULL, NULL, NULL),
(4, 'documento di trasporto', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL),
(5, 'nota pro forma', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL),
(6, 'offerta', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL),
(7, 'ordine', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
(8, 'ricevuta', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1),
(9, 'scontrino', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE
    nome = VALUES( nome ),
    codice = VALUES( codice ),
    se_fattura = VALUES( se_fattura ),
    se_nota_credito = VALUES( se_nota_credito ),
    se_trasporto = VALUES( se_trasporto ),
    se_pro_forma = VALUES( se_pro_forma ),
    se_offerta = VALUES( se_offerta );
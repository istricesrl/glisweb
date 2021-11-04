INSERT INTO `tipologie_indirizzi` (`id`, `nome`, `se_sede`, `se_operativa`, `se_abitazione`, `se_domicilio`, `html`) VALUES
(4, 'residenza', NULL, NULL, 1, NULL, '&#xf015;'),
(5, 'domicilio', NULL, NULL, 1, 1, '&#xf015;')
ON DUPLICATE KEY UPDATE
	nome = VALUES( nome ),
	se_sede = VALUES( se_sede ),
	se_operativa = VALUES( se_operativa ),
	se_abitazione = VALUES( se_abitazione ),
	se_domicilio = VALUES( se_domicilio ),
	html = VALUES( html );
INSERT INTO `tipologie_variazioni_attivita` (`id`, `nome`) VALUES
(1, 'malattia'),
(2, 'ferie'),
(3, 'permessi')
ON DUPLICATE KEY UPDATE nome = VALUES( nome );
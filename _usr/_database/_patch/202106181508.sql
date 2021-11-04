INSERT INTO `tipologie_contatti` (`id`, `nome`, `se_segnalazione`) VALUES
(1, 'di persona', 1),
(2, 'telefonata', 1),
(3, 'mail', 1)
ON DUPLICATE KEY UPDATE
    nome = VALUES( nome ),
    se_segnalazione =  VALUES( se_segnalazione )
;
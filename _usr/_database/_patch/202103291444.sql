INSERT INTO `ruoli_file` (`id`, `nome`, `se_anagrafica`, `se_contenuti`, `se_categorie_prodotti`, `se_mail`, `se_prodotti`, `se_articoli`) VALUES
(1, 'allegato', 1, 1, 1, 1, 1, 1),
(2, 'brochure', NULL, NULL, NULL, NULL, 1, 1),
(3, 'documentazione', NULL, NULL, NULL, NULL, 1, 1),
(4, 'driver', NULL, NULL, NULL, NULL, 1, 1),
(5, 'manualistica', NULL, NULL, NULL, NULL, 1, 1),
(6, 'press kit', 1, NULL, NULL, NULL, 1, NULL),
(7, 'schede tecniche', NULL, NULL, NULL, NULL, 1, 1),
(8, 'software', NULL, NULL, NULL, NULL, 1, 1)
ON DUPLICATE KEY UPDATE
    nome = VALUES( nome ),
    se_anagrafica = VALUES( se_anagrafica ),
    se_contenuti = VALUES( se_contenuti ),
    se_categorie_prodotti = VALUES( se_categorie_prodotti ),
    se_mail = VALUES( se_mail ),
    se_prodotti = VALUES( se_prodotti ),
    se_articoli = VALUES( se_articoli )
;

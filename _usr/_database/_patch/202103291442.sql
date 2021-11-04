INSERT INTO `ruoli_video` (`id`, `nome`, `se_anagrafica`, `se_contenuti`, `se_categorie_prodotti`, `se_prodotti`, `se_articoli`) VALUES
(1, 'intestazione', NULL, NULL, NULL, NULL, NULL),
(2, 'sfondo', NULL, NULL, NULL, NULL, NULL),
(4, 'card', NULL, NULL, NULL, NULL, NULL),
(5, 'media', NULL, NULL, NULL, NULL, NULL),
(7, 'gallery', NULL, NULL, NULL, 1, 1),
(8, 'footer', NULL, NULL, NULL, NULL, NULL),
(9, 'contenuto', NULL, NULL, NULL, NULL, NULL),
(10, 'copertina', NULL, NULL, NULL, NULL, NULL),
(11, 'principale', NULL, 1, 1, 1, 1),
(12, 'carousel', NULL, NULL, NULL, NULL, NULL),
(13, 'video', 1, 1, 1, 1, 1),
(14, 'jumbotron', NULL, NULL, NULL, NULL, NULL),
(15, 'dettaglio', NULL, NULL, NULL, NULL, NULL),
(16, 'anteprima', NULL, NULL, NULL, NULL, NULL)
ON DUPLICATE KEY UPDATE
    nome = VALUES( nome ),
    se_anagrafica = VALUES( se_anagrafica ),
    se_contenuti = VALUES( se_contenuti ),
    se_categorie_prodotti = VALUES( se_categorie_prodotti ),
    se_prodotti = VALUES( se_prodotti ),
    se_articoli = VALUES( se_articoli );
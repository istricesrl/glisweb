INSERT INTO `ruoli_audio` (`id`, `nome`, `se_anagrafica`, `se_contenuti`, `se_categorie_prodotti`, `se_prodotti`, `se_articoli`) VALUES
(1, 'audio', 1, 1, 1, 1, 1),
(2, 'commento', NULL, 1, NULL, 1, 1)
ON DUPLICATE KEY UPDATE
    nome = VALUES( nome ),
    se_anagrafica = VALUES( se_anagrafica ),
    se_contenuti = VALUES( se_contenuti ),
    se_categorie_prodotti = VALUES( se_categorie_prodotti ),
    se_prodotti = VALUES( se_prodotti ),
    se_articoli = VALUES( se_articoli )
;
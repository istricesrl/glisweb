ALTER TABLE `pubblicazione` ADD FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

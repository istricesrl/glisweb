ALTER TABLE `menu` ADD CONSTRAINT `menu_ibfk_3` FOREIGN KEY (`id_categoria_prodotti`) REFERENCES `categorie_prodotti`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
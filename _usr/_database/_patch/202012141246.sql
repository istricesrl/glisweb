ALTER TABLE `audio` ADD FOREIGN KEY (`id_categoria_notizie`) REFERENCES `categorie_notizie`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;
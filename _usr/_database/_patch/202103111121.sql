ALTER TABLE `immagini` ADD CONSTRAINT `immagini_ibfk_17` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

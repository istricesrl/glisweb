ALTER TABLE `metadati` ADD CONSTRAINT `metadati_ibfk_14` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

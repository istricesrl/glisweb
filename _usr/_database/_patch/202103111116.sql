ALTER TABLE `file` ADD CONSTRAINT `file_ibfk_16` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

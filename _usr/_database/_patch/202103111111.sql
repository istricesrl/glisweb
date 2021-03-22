ALTER TABLE `contenuti` ADD CONSTRAINT `contenuti_ibfk_27` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

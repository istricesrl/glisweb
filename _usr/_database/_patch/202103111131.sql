ALTER TABLE `video` ADD CONSTRAINT `video_ibfk_13` FOREIGN KEY (`id_categoria_risorse`) REFERENCES `categorie_risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

ALTER TABLE `file` ADD CONSTRAINT `file_ibfk_15` FOREIGN KEY (`id_risorsa`) REFERENCES `risorse` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
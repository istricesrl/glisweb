ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_4_nofollow` FOREIGN KEY (`id_genitore`) REFERENCES `mastri`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;
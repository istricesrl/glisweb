ALTER TABLE `progetti` ADD CONSTRAINT `progetti_ibfk_35_nofollow` FOREIGN KEY (`id_mastro_magazzino_lavoro_default`) REFERENCES `mastri`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `mastri` ADD CONSTRAINT `mastri_ibfk_3_nofollow` FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_mastri`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `contratti` ADD FOREIGN KEY (`id_tipologia_orario`) REFERENCES `tipologie_orari_inps`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
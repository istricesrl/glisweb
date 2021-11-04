ALTER TABLE `contratti` ADD FOREIGN KEY (`id_tipologia_durata`) REFERENCES `tipologie_durate_inps`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION; 

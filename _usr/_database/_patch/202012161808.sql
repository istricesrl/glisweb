ALTER TABLE `anagrafica_indirizzi` ADD FOREIGN KEY (`id_tipologia`) REFERENCES `tipologie_indirizzi`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
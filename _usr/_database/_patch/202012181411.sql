ALTER TABLE `contratti` ADD FOREIGN KEY (`id_agenzia`) REFERENCES `anagrafica`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `ruoli_anagrafica` ADD FOREIGN KEY (`id_genitore`) REFERENCES `anagrafica_ruoli`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;

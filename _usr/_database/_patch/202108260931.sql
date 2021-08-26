ALTER TABLE `file` ADD CONSTRAINT `file_ibfk_18` FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `__test__`.`anagrafica_certificazioni`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;

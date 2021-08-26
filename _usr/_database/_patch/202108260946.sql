ALTER TABLE `immagini` ADD CONSTRAINT `immagini_ibfk_19` FOREIGN KEY (`id_anagrafica_certificazioni`) REFERENCES `anagrafica_certificazioni`(`id`) ON DELETE SET NULL ON UPDATE SET NULL;

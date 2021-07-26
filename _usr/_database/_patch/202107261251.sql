ALTER TABLE `anagrafica_certificazioni` ADD CONSTRAINT `anagrafica_certificazioni_ibfk_2` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

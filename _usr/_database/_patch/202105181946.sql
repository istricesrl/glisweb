ALTER TABLE `attivita` 
ADD CONSTRAINT `attivita_ibfk_18_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `attivita` ADD CONSTRAINT `attivita_ibfk_21_nofollow` FOREIGN KEY (`id_contratto`) REFERENCES `contratti`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

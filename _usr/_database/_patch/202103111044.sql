ALTER TABLE `attivita`
ADD CONSTRAINT `attivita_ibfk_8` FOREIGN KEY (`id_indirizzo`) REFERENCES `indirizzi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
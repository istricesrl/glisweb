ALTER TABLE `sostituzioni_attivita` ADD CONSTRAINT `sostituzioni_attivita_ibfk_2_nofollow` FOREIGN KEY (`id_attivita`) REFERENCES `attivita`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
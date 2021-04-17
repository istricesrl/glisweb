ALTER TABLE `sostituzioni_attivita`
ADD CONSTRAINT `sostituzioni_attivita_ibfk_1_nofollow` FOREIGN KEY (`id_anagrafica`) REFERENCES `anagrafica` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `sostituzioni_attivita_ibfk_1` FOREIGN KEY (`id_attivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
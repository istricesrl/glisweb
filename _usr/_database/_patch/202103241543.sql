ALTER TABLE `periodi_variazioni_attivita`
ADD CONSTRAINT `periodi_variazioni_attivita_ibfk_1` FOREIGN KEY (`id_variazione`) REFERENCES `variazioni_attivita` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
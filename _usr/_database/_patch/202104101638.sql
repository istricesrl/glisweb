ALTER TABLE `pause_progetti`
ADD CONSTRAINT `pause_progetti_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
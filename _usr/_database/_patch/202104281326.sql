ALTER TABLE `pianificazioni` ADD CONSTRAINT `pianificazioni_ibfk_5` FOREIGN KEY (`id_progetto`) REFERENCES `progetti`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
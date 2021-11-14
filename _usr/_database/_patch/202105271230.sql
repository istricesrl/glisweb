ALTER TABLE `scadenze` ADD CONSTRAINT `scadenze_ibfk_1` FOREIGN KEY (`id_documento`) REFERENCES `documenti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

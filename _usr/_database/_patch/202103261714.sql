ALTER TABLE `articoli_caratteristiche`
ADD CONSTRAINT `articoli_caratteristiche_ibfk_1` FOREIGN KEY (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `articoli_caratteristiche_ibfk_2` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche_articoli` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `pubblicazione`
ADD CONSTRAINT `pubblicazione_ibfk_5` FOREIGN KEY (`id_prodotto`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
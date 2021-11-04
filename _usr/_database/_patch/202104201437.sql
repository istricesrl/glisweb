ALTER TABLE `documenti_articoli`
ADD CONSTRAINT `documenti_articoli_ibfk_26_nofollow` FOREIGN KEY (`id_mastro_destinazione`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `documenti_articoli_ibfk_25_nofollow` FOREIGN KEY (`id_mastro_provenienza`) REFERENCES `mastri` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
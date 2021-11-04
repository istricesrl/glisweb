ALTER TABLE `progetti_certificazioni`
ADD CONSTRAINT `progetti_certificazioni_ibfk_1_nofollow` FOREIGN KEY (`id_certificazione`) REFERENCES `certificazioni` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `progetti_certificazioni_ibfk_1` FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

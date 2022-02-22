--
-- PATCH
--

--| 202202221500
ALTER TABLE `articoli`
ADD  `id_udm_dimensioni` int DEFAULT NULL AFTER `altezza`,
ADD `id_udm_peso` int DEFAULT NULL AFTER `peso`,
ADD `id_udm_volume` int DEFAULT NULL AFTER `volume`,
ADD `id_udm_capacita` int DEFAULT NULL AFTER `capacita`,
ADD `id_udm_durata` int DEFAULT NULL AFTER `durata`,
ADD KEY `id_udm_dimensioni` (`id_udm_dimensioni`),
ADD KEY `id_udm_peso` (`id_udm_peso`),
ADD KEY `id_udm_volume` (`id_udm_volume`),
ADD KEY `id_udm_capacita`(`id_udm_capacita`),
ADD KEY  `id_udm_durata`(`id_udm_durata`),
ADD CONSTRAINT `articoli_ibfk_04_nofollow` FOREIGN KEY (`id_udm_dimensioni`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `articoli_ibfk_05_nofollow` FOREIGN KEY (`id_udm_peso`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `articoli_ibfk_06_nofollow` FOREIGN KEY (`id_udm_volume`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `articoli_ibfk_07_nofollow` FOREIGN KEY (`id_udm_capacita`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `articoli_ibfk_08_nofollow` FOREIGN KEY (`id_udm_durata`) REFERENCES `udm` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--| 202202221510
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		articoli.id,
		articoli.id_prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
		articoli.id_reparto,
		articoli.id_taglia,
		articoli.id_colore,
		articoli.larghezza,
		articoli.lunghezza,
		articoli.altezza,
        articoli.id_udm_dimensioni,
		articoli.peso,
        articoli.id_udm_peso,
		articoli.volume,
        articoli.id_udm_volume,
		articoli.capacita,
        articoli.id_udm_capacita,
        articoli.durata,
        articoli.id_udm_durata,
		articoli.nome,
		concat(
			articoli.id_prodotto,
			' / ',
			articoli.id,
			' / ',
			articoli.nome
		) AS __label__
	FROM articoli
;



--| FINE
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

--| 202202221520
ALTER TABLE `pianificazioni` 
ADD `entita`	enum('todo','attivita','rinnovi','documenti','documenti_articoli','pagamenti') NULL DEFAULT NULL AFTER `data_fine`,
ADD `model_id_luogo` int(11) DEFAULT NULL,
ADD  `model_ora_inizio_programmazione` time DEFAULT NULL,
ADD  `model_ora_fine_programmazione` time DEFAULT NULL,
ADD KEY `entita` (`entita`),
ADD KEY  `model_id_luogo` (`model_id_luogo`),
ADD CONSTRAINT `pianificazioni_ibfk_05_nofollow` FOREIGN KEY (`model_id_luogo`) REFERENCES `luoghi` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `pianificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `pianificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
 
--| 202202221530
CREATE OR REPLACE VIEW `pianificazioni_view` AS
	SELECT
		pianificazioni.id,
		pianificazioni.id_progetto,
		pianificazioni.id_todo,
		pianificazioni.id_attivita,
		pianificazioni.nome,
		pianificazioni.id_periodicita,
		periodicita.nome AS periodicita,
		pianificazioni.cadenza,
		pianificazioni.se_lunedi,
		pianificazioni.se_martedi,
		pianificazioni.se_mercoledi,
		pianificazioni.se_giovedi,
		pianificazioni.se_venerdi,
		pianificazioni.se_sabato,
		pianificazioni.se_domenica,
		pianificazioni.schema_ripetizione,
		pianificazioni.data_elaborazione,
		pianificazioni.giorni_estensione,
		pianificazioni.data_fine,
		pianificazioni.entita,
		pianificazioni.model_id_luogo,
		pianificazioni.model_ora_inizio_programmazione,
		pianificazioni.model_ora_fine_programmazione,
		pianificazioni.workspace,
		pianificazioni.token,
		pianificazioni.id_account_inserimento,
		pianificazioni.id_account_aggiornamento,
		concat_ws(
			' ',
			pianificazioni.nome,
			periodicita.nome,
			pianificazioni.cadenza
		) as __label__
	FROM pianificazioni
		LEFT JOIN periodicita ON periodicita.id = pianificazioni.id_periodicita
;

--| FINE
--
-- PATCH
--

--| 202205030010
ALTER TABLE `progetti_certificazioni` 
    ADD COLUMN `ordine` int(11) DEFAULT NULL AFTER  `id_certificazione`,
	ADD PRIMARY KEY (`id`), 
	ADD UNIQUE KEY `unica` (`id_progetto`,`id_certificazione`), 
	ADD KEY `id_progetto` (`id_progetto`), 
	ADD KEY `id_certificazione` (`id_certificazione`), 
	ADD KEY `ordine` (`ordine`),
	ADD KEY `nome` (`nome`),
	ADD KEY `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_progetto`,`id_certificazione`,`ordine`,`nome`);

--| 202205030020
ALTER TABLE `progetti_certificazioni` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--| 202205030030
ALTER TABLE `progetti_certificazioni`
    ADD CONSTRAINT `progetti_certificazioni_ibfk_01`             FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_02_nofollow`    FOREIGN KEY (`id_certificazionE`) REFERENCES `certificazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_98_nofollow`    FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
    ADD CONSTRAINT `progetti_certificazioni_ibfk_99_nofollow`    FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202205030040
CREATE OR REPLACE VIEW progetti_certificazioni_view AS
	SELECT
		progetti_certificazioni.id,
		progetti_certificazioni.id_progetto,
		progetti.nome AS progetto,
		progetti_certificazioni.id_certificazione,
		certificazioni.nome AS certificazione,
		progetti_certificazioni.ordine,
		progetti_certificazioni.nome,
		progetti_certificazioni.se_richiesta,
		progetti_certificazioni.id_account_inserimento,
		progetti_certificazioni.id_account_aggiornamento,
 		concat_ws(
			' ',
			progetti.nome,
			certificazioni.nome
		) AS __label__
	FROM progetti_certificazioni
		LEFT JOIN progetti ON progetti.id = progetti_certificazioni.id_progetto
		LEFT JOIN certificazioni ON certificazioni.id = progetti_certificazioni.id_certificazione
;

--| FINE FILE

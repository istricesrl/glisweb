--
-- PATCH
--

--| 202202110010
ALTER TABLE `relazioni_anagrafica` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_anagrafica_collegata`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `relazioni_anagrafica_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `relazioni_anagrafica_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202110020
ALTER TABLE `relazioni_documenti` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_documento_collegato`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `relazioni_documenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `relazioni_documenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202110030
ALTER TABLE `relazioni_documenti_articoli` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_documenti_articolo_collegato`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `relazioni_documenti_articoli_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202110040
ALTER TABLE `relazioni_pagamenti` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_pagamento_collegato`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `relazioni_pagamenti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `relazioni_pagamenti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202110050
ALTER TABLE `relazioni_progetti` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_progetto_collegato`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `relazioni_progetti_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `relazioni_progetti_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202110050
ALTER TABLE `relazioni_software` 
ADD  `id_account_inserimento` int(11) DEFAULT NULL AFTER `id_software_collegato`,
ADD  `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
ADD  `id_account_aggiornamento` int(11) DEFAULT NULL AFTER `timestamp_inserimento`,
ADD  `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`,
ADD KEY `id_account_inserimento` (`id_account_inserimento`),
ADD KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
ADD CONSTRAINT `relazioni_software_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
ADD CONSTRAINT `relazioni_software_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--| 202202110060
ALTER TABLE `pubblicazioni` 
ADD `id_progetto` char(32) DEFAULT NULL AFTER `id_categoria_risorse`,
ADD `id_categoria_progetti` INT(11) DEFAULT NULL AFTER `id_progetto`,
ADD KEY `id_progetto` (`id_progetto`),
ADD KEY `id_categoria_progetti` (`id_categoria_progetti`),
ADD CONSTRAINT `pubblicazioni_ibfk_11`                  FOREIGN KEY (`id_progetto`) REFERENCES `progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `pubblicazioni_ibfk_12`                  FOREIGN KEY (`id_categoria_progetti`) REFERENCES `categorie_progetti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--| 202202110070
CREATE OR REPLACE VIEW `pubblicazioni_view` AS
    SELECT
		pubblicazioni.id,
		pubblicazioni.id_tipologia,
		tipologie_pubblicazioni.nome AS tipologia,
		pubblicazioni.ordine,
		pubblicazioni.id_prodotto,
		pubblicazioni.id_articolo,
		pubblicazioni.id_categoria_prodotti,
		pubblicazioni.id_notizia,
		pubblicazioni.id_categoria_notizie,
		pubblicazioni.id_pagina,
		pubblicazioni.id_popup,
		pubblicazioni.id_risorsa,
		pubblicazioni.id_categoria_risorse,
		pubblicazioni.id_progetto,
		pubblicazioni.id_categoria_progetti,
		pubblicazioni.timestamp_inizio,
		pubblicazioni.timestamp_fine,
		concat_ws(
			' ',
			tipologie_pubblicazioni.nome,
			pubblicazioni.timestamp_inizio,
			pubblicazioni.timestamp_fine
		) AS __label__
    FROM pubblicazioni
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia
;

--| FINE
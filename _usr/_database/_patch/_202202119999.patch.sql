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


--| FINE
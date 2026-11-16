-- 2026-11-16 — rinnovi: id_articolo, id_periodo e data_ritiro entrano nel canone
--
-- Schema canonico, punto 7b, caso C6, decisione di Fabio del 16/11/2026: le tre colonne vengono da polmasi.
-- id_articolo e' l'articolo venduto che ha generato il rinnovo ( per le iscrizioni da backend, senza carrello ne'
-- documento, e' l'unica traccia ); id_periodo lega il rinnovo a un periodo ( p.es. l'anno sportivo ), "per consentire
-- ad esempio la reiscrizione a un corso frequentato l'anno precedente"; data_ritiro e' l'ultimo giorno di
-- partecipazione quando il rinnovo viene interrotto, NULL vuol dire non interrotto.
--
-- Cosa fa: aggiunge colonne, chiavi e vincoli dove mancano.
--
-- Cosa NON fa ( punti 11 e 12 ): su polmasi le colonne ci sono gia', senza chiavi ne' vincoli e in un'altra posizione;
-- il riordino resta al punto 12. Se su un deploy ci sono valori orfani il vincolo non entra: vanno messi a NULL prima.
--
-- IDEMPOTENTE.

-- | 202611161400

-- rinnovi
ALTER TABLE `rinnovi`
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL AFTER `id_licenza`,
	ADD COLUMN IF NOT EXISTS `id_periodo` bigint(20) DEFAULT NULL AFTER `id_articolo`,
	ADD COLUMN IF NOT EXISTS `data_ritiro` date DEFAULT NULL AFTER `data_fine`,
	ADD KEY IF NOT EXISTS `id_articolo` (`id_articolo`),
	ADD KEY IF NOT EXISTS `id_periodo` (`id_periodo`);

-- | 202611161401

-- rinnovi
ALTER TABLE `rinnovi` ADD CONSTRAINT `rinnovi_ibfk_08_nofollow` FOREIGN KEY IF NOT EXISTS (`id_articolo`) REFERENCES `articoli` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611161402

-- rinnovi
ALTER TABLE `rinnovi` ADD CONSTRAINT `rinnovi_ibfk_09_nofollow` FOREIGN KEY IF NOT EXISTS (`id_periodo`) REFERENCES `periodi` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE FILE

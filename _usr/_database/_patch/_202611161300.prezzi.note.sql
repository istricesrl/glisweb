-- 2026-11-16 — prezzi: note entra nel canone
--
-- Schema canonico, punto 7b, caso C5, decisione di Fabio del 16/11/2026: la nota sta sulla voce di listino
-- ( vincoli o condizioni dell'opzione nel modello di macchina, utensilerialughese ), non sull'articolo.
--
-- Cosa fa: aggiunge la colonna dove manca, dopo id_reparto.
--
-- Cosa NON fa ( punti 11 e 12 ): non sposta la colonna dove c'è già in un'altra posizione ( bernispa,
-- utensilerialughese ), e non svuota le note di provenienza scritte dal sincronizzatore di bernispa
-- ( "prezzo inserito dall'importazione automatica il …" ), che sono audit e non note.
--
-- IDEMPOTENTE.

-- | 202611161300

-- prezzi
ALTER TABLE `prezzi`
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL AFTER `id_reparto`;

-- | FINE FILE

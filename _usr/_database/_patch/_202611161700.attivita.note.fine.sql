-- 2026-11-16 — attivita: note_fine entra nel canone
--
-- Schema canonico, punto 7b, caso C7, decisione di Fabio del 16/11/2026: "e' importante tenere distinte le note
-- generiche da quelle specifiche di fine attivita'". La colonna viene da trbitaly ( src/api/tempi.php, che la scrive
-- quando l'API delle macchine chiude un'attivita' ) e chiude il blocco della fine dell'esecuzione, come note_scadenza,
-- note_programmazione e note_archiviazione chiudono i loro.
--
-- Cosa fa: aggiunge la colonna dove manca.
--
-- Cosa NON fa ( punti 11 e 12 ): su trbitaly la colonna c'e' gia' in un'altra posizione; il riordino resta al punto 12.
--
-- IDEMPOTENTE.

-- | 202611161700

-- attivita
ALTER TABLE `attivita`
	ADD COLUMN IF NOT EXISTS `note_fine` text DEFAULT NULL AFTER `longitudine_ora_fine`;

-- | FINE FILE

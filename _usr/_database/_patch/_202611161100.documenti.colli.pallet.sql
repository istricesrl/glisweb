-- 2026-11-16 — documenti: numero_colli e numero_pallet entrano nel canone
--
-- Schema canonico, punto 7b, caso C3, decisione di Fabio del 16/11/2026: documenti.numero_colli e
-- documenti.numero_pallet sono i totali dichiarati sul documento di trasporto ( la casella "numero colli" del DDT ),
-- della stessa famiglia di porto, id_causale e id_trasportatore; sono indipendenti dai colli censiti in colli, che
-- esistono solo dove la spedizione si censisce collo per collo. Le colonne vengono da bernispa ( migrazione di
-- progetto 2026082701 del 27/08/2026, maschera "chiusura LP" ).
--
-- Cosa fa: aggiunge le due colonne dove mancano, dopo porto.
--
-- Cosa NON fa ( punti 11 e 12 ): su bernispa le colonne ci sono gia' dopo note_spedizione e non si spostano qui; il
-- riordino delle colonne resta al punto 12.
--
-- IDEMPOTENTE.

-- | 202611161100

-- documenti
ALTER TABLE `documenti`
	ADD COLUMN IF NOT EXISTS `numero_colli` int(11) DEFAULT NULL AFTER `porto`,
	ADD COLUMN IF NOT EXISTS `numero_pallet` int(11) DEFAULT NULL AFTER `numero_colli`;

-- | FINE FILE

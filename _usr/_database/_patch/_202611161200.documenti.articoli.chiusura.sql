-- 2026-11-16 — documenti_articoli: timestamp_chiusura e note_chiusura entrano nel canone
--
-- Schema canonico, punto 7b, caso C4, decisione di Fabio del 16/11/2026: la coppia di chiusura di documenti e colli
-- vale anche per la riga. La chiusura non è l'evasione: dice che dalla riga non ci si aspetta altro, anche se è
-- arrivato meno dell'ordinato o se lo decide un sistema esterno, e toglie dalle liste di lavoro le righe chiuse di un
-- documento ancora aperto, che non si possono cancellare perché hanno righe figlie. Le colonne vengono da bernispa
-- ( migrazione di progetto 2026091002 del 10/09/2026, chiusura degli ordini di acquisto evasi in SAM ).
--
-- Cosa fa: aggiunge le due colonne dove mancano, dopo note_consegna.
--
-- Cosa NON fa ( punti 11 e 12 ): su bernispa le colonne ci sono gia' in coda alla tabella e non si spostano qui; il
-- riordino delle colonne resta al punto 12.
--
-- IDEMPOTENTE.

-- | 202611161200

-- documenti_articoli
ALTER TABLE `documenti_articoli`
	ADD COLUMN IF NOT EXISTS `timestamp_chiusura` int(11) DEFAULT NULL AFTER `note_consegna`,
	ADD COLUMN IF NOT EXISTS `note_chiusura` text DEFAULT NULL AFTER `timestamp_chiusura`;

-- | FINE FILE

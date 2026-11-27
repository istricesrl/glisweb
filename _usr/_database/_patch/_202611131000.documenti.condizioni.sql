-- 2026-11-13 — documenti: le condizioni d'offerta entrano nel canone
--
-- Schema canonico, punto 7b, caso C1, decisione di Fabio del 13/11/2026: le condizioni d'offerta di lughese si
-- canonizzano su documenti, nel gruppo "condizioni" dopo note_cliente:
-- - validita_offerta diventa data_fine_validita + note_fine_validita ( la forma di data/note_fine_validita gia' nel canone );
-- - note_pagamento resta note_pagamento;
-- - messa_in_funzione diventa note_installazione;
-- - garanzia diventa note_garanzia;
-- - oneri_fiscali diventa note_fiscali.
--
-- Cosa fa: aggiunge le sei colonne dove mancano.
--
-- Cosa NON fa ( punti 11 e 12 ): il travaso dei dati di lughese dalle colonne vecchie alle nuove ( "30 giorni" va
-- convertito in data_fine_validita a partire da data, il resto in note_fine_validita ) e la rimozione delle colonne
-- vecchie. Il riordino delle colonne resta al punto 12.
--
-- IDEMPOTENTE.

-- | 202611131000

-- documenti
ALTER TABLE `documenti`
	ADD COLUMN IF NOT EXISTS `data_fine_validita` date DEFAULT NULL AFTER `note_cliente`,
	ADD COLUMN IF NOT EXISTS `note_fine_validita` text DEFAULT NULL AFTER `data_fine_validita`,
	ADD COLUMN IF NOT EXISTS `note_pagamento` text DEFAULT NULL AFTER `note_fine_validita`,
	ADD COLUMN IF NOT EXISTS `note_installazione` text DEFAULT NULL AFTER `note_pagamento`,
	ADD COLUMN IF NOT EXISTS `note_garanzia` text DEFAULT NULL AFTER `note_installazione`,
	ADD COLUMN IF NOT EXISTS `note_fiscali` text DEFAULT NULL AFTER `note_garanzia`;

-- | FINE FILE

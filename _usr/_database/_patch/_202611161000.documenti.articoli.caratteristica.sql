-- 2026-11-16 — documenti_articoli: id_caratteristica entra nel canone
--
-- Schema canonico, punto 7b, caso C2, decisione di Fabio del 16/11/2026: documenti_articoli.id_caratteristica e' un
-- secondo livello di raggruppamento sotto id_genitore; vale per le righe figlie di una riga di raggruppamento, e dice
-- per quale caratteristica sono alternative fra loro ( "all'interno di questo gruppo le alternative PER QUESTA
-- CARATTERISTICA sono..." ). La colonna viene da utensilerialughese ( patch di progetto del 05/10/2026 ).
--
-- Cosa fa: aggiunge la colonna, la chiave e il vincolo dove mancano.
--
-- Cosa NON fa ( punti 11 e 12 ): su lughese la colonna c'e' gia' col vincolo documenti_articoli_ibfk_gruppo_nofollow,
-- da rinominare in documenti_articoli_ibfk_27_nofollow; le righe raggruppate di lughese, oggi quasi tutte senza riga
-- padre, vanno messe sotto un raggruppamento. Il riordino delle colonne resta al punto 12.
--
-- IDEMPOTENTE.

-- | 202611161000

-- documenti_articoli
ALTER TABLE `documenti_articoli`
	ADD COLUMN IF NOT EXISTS `id_caratteristica` bigint(20) DEFAULT NULL AFTER `id_tipologia_documento`,
	ADD KEY IF NOT EXISTS `id_caratteristica` (`id_caratteristica`);

-- | 202611161001

-- documenti_articoli
ALTER TABLE `documenti_articoli` ADD CONSTRAINT `documenti_articoli_ibfk_27_nofollow` FOREIGN KEY IF NOT EXISTS (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE FILE

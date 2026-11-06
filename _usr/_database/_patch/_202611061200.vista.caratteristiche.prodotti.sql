-- 2026-11-06 — caratteristiche_prodotti torna inseribile
--
-- Ordine di WEB03 del 06/11/2026 ( dalla correzione d582b71 di utensilerialughese ). La vista di compatibilita'
-- caratteristiche_prodotti aveva la colonna derivata NULL AS se_categoria, e una sola colonna derivata basta perche'
-- MySQL la dichiari non inseribile: ogni INSERT prendeva l'errore 1471, contro quello che prometteva il suo commento.
-- Su utensilerialughese l'import delle macchine ci scriveva sopra ( 11.481 errori dal 05/11 ) e, con gli id vuoti, la
-- pulizia NOT IN ( 0, 0, ... ) ha svuotato le caratteristiche di 135 schede.
--
-- se_categoria non la legge nessuno: cercata il 06/11 in standard e custom di tutti i deploy di web03, e l'unico
-- codice di progetto che scrive sulla vista e' quello di utensilerialughese, gia' passato alla tabella caratteristiche.
-- Il blocco e' quello del file base, copiato com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611061200

-- caratteristiche_prodotti
CREATE OR REPLACE VIEW `caratteristiche_prodotti` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.font_awesome,
		caratteristiche.html_entity,
		caratteristiche.se_prodotti AS se_prodotto,
		caratteristiche.se_articoli AS se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.timestamp_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche.timestamp_aggiornamento
	FROM caratteristiche
;

-- | FINE

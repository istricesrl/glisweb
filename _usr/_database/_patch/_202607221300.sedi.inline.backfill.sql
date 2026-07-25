-- 2026-07-22 — Backfill inline delle sedi (anagrafica_indirizzi) dal record `indirizzi` collegato.
--
-- Contesto: la migrazione del 2026-07-10 ha reso `anagrafica_indirizzi` la fonte inline
-- dell'indirizzo (documenti.id_sede_* hanno FK su anagrafica_indirizzi; le query di stampa
-- leggono anagrafica_indirizzi.indirizzo/civico/cap e fanno INNER JOIN comuni su
-- anagrafica_indirizzi.id_comune). Alcune righe legacy hanno l'indirizzo SOLO nel record
-- `indirizzi` collegato (inline NULL). Quando `id_comune` inline e' NULL l'INNER JOIN sui
-- comuni non torna righe e la ricevuta muore con "richiesto indirizzo sede destinatario".
--
-- Questo UPDATE completa la migrazione: copia dal collegato SOLO i campi inline vuoti
-- (COALESCE + NULLIF), quindi e' idempotente e non sovrascrive mai un dato inline reale.

UPDATE anagrafica_indirizzi ai
JOIN indirizzi i ON i.id = ai.id_indirizzo
SET ai.id_comune = COALESCE( ai.id_comune, i.id_comune ),
    ai.indirizzo = COALESCE( NULLIF( ai.indirizzo, '' ), i.indirizzo ),
    ai.civico    = COALESCE( NULLIF( ai.civico, '' ), i.civico ),
    ai.cap       = COALESCE( NULLIF( ai.cap, '' ), i.cap ),
    ai.localita  = COALESCE( NULLIF( ai.localita, '' ), i.localita )
WHERE ai.id_indirizzo IS NOT NULL
  AND ( ai.id_comune IS NULL OR ai.indirizzo IS NULL OR ai.indirizzo = '' );

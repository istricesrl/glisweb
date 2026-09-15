-- RINUMERATA IL 15/09/2026, E NON E' UN DETTAGLIO AMMINISTRATIVO.
--
-- Questo file e' stato scritto il 22/07/2026 come _202607221300 e non e' MAI stato eseguito su
-- nessun deploy: non aveva un solo marcatore `-- |`. Il task accumula le righe di una patch e la
-- esegue quando incontra il marcatore SUCCESSIVO; senza marcatori non ne incontra nessuno, e a
-- fine file non fa niente. Il file veniva letto e buttato via, senza un errore e senza una riga
-- di log. Verificato il 15/09/2026: la tabella __patch__ dei cinque deploy non ha nessuna patch
-- del 2026.
--
-- Il nome e' cambiato perche' il task salta un intero file quando il livello ricavato dal NOME e'
-- minore o uguale al patch level del database, e tutti i deploy sono ormai a 202609151411:
-- 202607221300 non sarebbe stato letto nemmeno con i marcatori a posto.
--
-- Il contenuto dell'UPDATE non e' stato toccato.

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
--
-- Guardia sulle collisioni (aggiunta 2026-07-28, applicando su TEST)
-- -----------------------------------------------------------------
-- anagrafica_indirizzi ha UNIQUE( id_anagrafica, indirizzo ) (_030000999999.indexes.sql).
-- Riempire `indirizzo` dal collegato puo' quindi far collidere una riga legacy con una riga
-- gia' popolata della stessa anagrafica, e l'UPDATE fallisce:
--   ERROR 1062: Duplicate entry '86009-VIA FELICE CAVALLOTTI 9/9A' for key 'id_anagrafica_indirizzo'
-- Siccome e' un UPDATE unico, l'errore fa fallire l'INTERA migrazione: su TEST bastavano
-- 4 righe duplicate su 2.210 candidate per non backfillarne nessuna. Senza guardia il patch
-- e' quindi "tutto o niente" e non passa su nessun DB che abbia anche un solo duplicato.
--
-- Il NOT EXISTS esclude le sole righe che collidono, lasciando passare tutte le altre. Le
-- righe escluse sono un problema di qualita' del dato (due sedi con lo stesso indirizzo
-- sotto la stessa anagrafica) e vanno riconciliate a mano: questo patch non e' il posto per
-- decidere quale delle due tenere. Per elencarle, invertire il NOT EXISTS in EXISTS.
-- | 202609151500

-- il backfill vero e proprio
UPDATE anagrafica_indirizzi ai
JOIN indirizzi i ON i.id = ai.id_indirizzo
SET ai.id_comune = COALESCE( ai.id_comune, i.id_comune ),
    ai.indirizzo = COALESCE( NULLIF( ai.indirizzo, '' ), i.indirizzo ),
    ai.civico    = COALESCE( NULLIF( ai.civico, '' ), i.civico ),
    ai.cap       = COALESCE( NULLIF( ai.cap, '' ), i.cap ),
    ai.localita  = COALESCE( NULLIF( ai.localita, '' ), i.localita )
WHERE ai.id_indirizzo IS NOT NULL
  AND ( ai.id_comune IS NULL OR ai.indirizzo IS NULL OR ai.indirizzo = '' )
  AND NOT EXISTS (
      SELECT 1 FROM ( SELECT id, id_anagrafica, indirizzo FROM anagrafica_indirizzi ) x
      WHERE x.id_anagrafica = ai.id_anagrafica
        AND x.id <> ai.id
        AND x.indirizzo = COALESCE( NULLIF( ai.indirizzo, '' ), i.indirizzo )
  );

-- | FINE FILE

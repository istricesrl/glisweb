-- 2026-10-04 — articoli_view senza righe doppie, e articoli_view_static con le colonne della vista
--
-- articoli_view prendeva la pubblicazione con due LEFT JOIN su pubblicazioni ( dell'articolo e del prodotto ):
-- un articolo con piu' pubblicazioni usciva una volta per pubblicazione ( su glisweb 7.920 righe per 132
-- articoli ). Adesso sono sottoquery scalari, come gia' tipologia_listino, categorie e prezzi.
--
-- articoli_view_static nel file di base non aveva le tre colonne con cui la vista comincia
-- ( id_tipologia_pubblicazione, pubblicazione, tipologia_listino ): gli inserimenti che le nominano
-- fallivano con 1054 e dal 03/10 la statica era vuota su tutti i deploy del canone. Si aggiungono, nella stessa
-- posizione della vista, e la statica si ripopola per intero.
--
-- nome nella statica era char(128), ma nella vista e' prodotto + articolo e supera i 128 caratteri
-- ( polmasi prod: 8 articoli, errore 1406 sul ripopolamento ): diventa varchar(512). Per i deploy
-- gia' arrivati al 1202 lo fa _202610041203.
--
-- il ripopolamento della statica non sta qui ma nel blocco 1204 di _202610041203: un blocco e' una
-- query sola, e ALTER + REPLACE nello stesso blocco davano 1064 ( eurosnodi crm dev, 20/10/2026 ).
--
-- ⚠ I deploy con una articoli_view di progetto ( utensilerialughese: usr/database/patch/202609281100 ) dopo
-- questa patch hanno la vista dello standard: va seguita da una patch di progetto che rimetta la loro.

-- | 202610041200

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041201

ALTER TABLE `articoli_view_static`
	ADD COLUMN IF NOT EXISTS `tipologia_listino` char(64) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `pubblicazione` char(32) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `id_tipologia_pubblicazione` bigint(20) DEFAULT NULL FIRST;

-- | 202610041202

ALTER TABLE `articoli_view_static` MODIFY `nome` varchar(512) DEFAULT NULL;

-- | FINE

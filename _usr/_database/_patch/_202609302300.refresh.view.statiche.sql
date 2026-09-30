-- 2026-09-30 — dismessa la coda refresh_view_statiche
--
-- COSA SI VEDEVA. Sei task legacy ( pulizia e popolazione delle pianificazioni, eliminazione di eventi, progetti e
-- todo ) prenotavano l'aggiornamento delle viste statiche scrivendo in refresh_view_statiche, e
-- /_src/_api/_task/_static.view.refresh.php le evadeva chiamando le procedure <entita>_view_static(). Nessuna patch
-- crea quella tabella dal 2022 e le procedure sono state tolte a marzo 2026: sulle installazioni nuove la catena era
-- rotta due volte, e le statiche restavano con le righe cancellate.
--
-- COSA FA. I task aggiornano ora le statiche da soli, con cleanStaticView() e refreshStaticView() di
-- _src/_lib/_mysql.tools.php, e il task che evadeva la coda non c'e' piu'. Questa patch toglie la sua pianificazione
-- dalla tabella task, la tabella della coda e le procedure rimaste sui deploy vecchi.
--
-- IDEMPOTENTE. Tutto e' DELETE su righe che alla seconda esecuzione non ci sono piu', o DROP ... IF EXISTS.

-- | 202609302300

-- la pianificazione del task che evadeva la coda
DELETE FROM `task` WHERE `task` LIKE '%_static.view.refresh.php';

-- | 202609302310

-- la coda
DROP TABLE IF EXISTS `refresh_view_statiche`;

-- | 202609302320

-- le procedure che la coda chiamava, sui deploy che le hanno ancora ( una per blocco: il task esegue una query per blocco )
DROP PROCEDURE IF EXISTS `anagrafica_view_static`;

-- | 202609302321

DROP PROCEDURE IF EXISTS `articoli_view_static`;

-- | 202609302322

DROP PROCEDURE IF EXISTS `attivita_view_static`;

-- | 202609302323

DROP PROCEDURE IF EXISTS `offerte_attive_view_static`;

-- | 202609302324

DROP PROCEDURE IF EXISTS `todo_view_static`;

-- | FINE FILE

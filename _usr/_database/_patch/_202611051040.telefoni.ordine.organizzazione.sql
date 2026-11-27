-- 2026-11-05 — telefoni: ordine e secondo proprietario ( nodo organizzativo )
--
-- Schema canonico, punto 6, riga 188, decisione di Fabio del 05/11/2026 ( opzione A ): telefoni prende la forma di
-- mail. Il numero di default e' il primo nell'ordine ( trasversale recapiti del 19/10/2026 ); un numero ha un solo
-- proprietario, un'anagrafica oppure un nodo di organizzazioni ( punto 6d, 21/10/2026 ), e per questo le chiavi uniche
-- sono due, una per proprietario: il NULL dell'altro svuoterebbe una chiave unica sola.
--
-- Cosa fa: aggiunge ordine e id_organizzazione, sostituisce la chiave unica unica con unica_anagrafica e
-- unica_organizzazione, aggiunge le KEY ordine e id_organizzazione e ricrea indice. La vista telefoni_view sta nel
-- file base.
--
-- Cosa NON fa: non riordina le colonne e non tocca le chiavi esterne ( la verso l'anagrafica da SET NULL a CASCADE,
-- quella nuova verso organizzazioni, la rinumerazione ): si fanno al punto 12 dello schema canonico, come per mail,
-- perche' su eurosnodi crm gli id sono ancora int(11) e una chiave esterna bigint verso organizzazioni fallirebbe.
-- Non tocca i dati: le righe senza anagrafica ( residui del SET NULL, 568 sui database letti il 05/11/2026 ) sono
-- decise al punto 10.
--
-- IDEMPOTENTE.

-- | 202611051040

-- telefoni: colonne nuove
ALTER TABLE `telefoni`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id`,
	ADD COLUMN IF NOT EXISTS `id_organizzazione` bigint(20) DEFAULT NULL AFTER `id_anagrafica`;

-- | 202611051041

-- telefoni: indici nella forma del canone
ALTER TABLE `telefoni`
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unica_anagrafica`,
	DROP INDEX IF EXISTS `unica_organizzazione`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `id_organizzazione`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`numero`),
	ADD UNIQUE KEY `unica_organizzazione` (`id_organizzazione`,`numero`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_organizzazione` (`id_organizzazione`),
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`id_anagrafica`,`id_organizzazione`,`numero`,`se_notifiche`);

-- | FINE

-- 2026-11-10 — url: ordine e secondo proprietario ( nodo organizzativo )
--
-- Schema canonico, punto 6, riga 231, decisione di Fabio del 10/11/2026 ( opzione A ): url prende la forma di
-- telefoni. L'URL di default e' il primo nell'ordine ( trasversale recapiti del 19/10/2026, estesa a url ); un URL ha
-- un solo proprietario, un'anagrafica oppure un nodo di organizzazioni ( punto 6d, 21/10/2026 ), e per questo le
-- chiavi uniche sono due, una per proprietario: il NULL dell'altro svuoterebbe una chiave unica sola.
--
-- Cosa fa: aggiunge ordine e id_organizzazione, porta nome a char(255), aggiunge unica_organizzazione, le KEY ordine
-- e id_organizzazione e ricrea indice. La vista url_view sta nel file base.
--
-- Cosa NON fa: non sostituisce la vecchia unica ( id_tipologia, id_anagrafica, url ) con unica_anagrafica
-- ( id_anagrafica, url ), perche' su eurosnodi crm e crmtrb ci sono 85 gruppi di URL ripetuti sulla stessa anagrafica
-- e l'indice fallirebbe: lo scambio si fa al punto 12, dopo la pulizia del punto 10. Non toglie username e password
-- ( le rimozioni sono del punto 12 ), non riordina le colonne e non tocca le chiavi esterne ( la nuova verso
-- organizzazioni ): su eurosnodi crm gli id sono ancora int(11). Non tocca i dati.
--
-- IDEMPOTENTE.

-- | 202611101700

-- url: colonne nuove
ALTER TABLE `url`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id_tipologia`,
	ADD COLUMN IF NOT EXISTS `id_organizzazione` bigint(20) DEFAULT NULL AFTER `id_anagrafica`;

-- | 202611101701

-- url: nome a char(255)
ALTER TABLE `url` MODIFY `nome` char(255) DEFAULT NULL;

-- | 202611101702

-- url: indici nella forma del canone, salvo lo scambio di unica
ALTER TABLE `url`
	DROP INDEX IF EXISTS `unica_organizzazione`,
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `id_organizzazione`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `unica_organizzazione` (`id_organizzazione`,`url`),
	ADD KEY `ordine` (`ordine`),
	ADD KEY `id_organizzazione` (`id_organizzazione`),
	ADD KEY `indice` (`id`,`id_tipologia`,`ordine`,`nome`,`id_anagrafica`,`id_organizzazione`,`url`);

-- | FINE

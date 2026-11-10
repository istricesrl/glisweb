-- 2026-11-10 — anagrafica_certificazioni e valutazioni_certificazioni: ordine
--
-- Schema canonico, punto 6, riga 233, decisione di Fabio del 10/11/2026 ( opzione B ): valutazioni_certificazioni e
-- anagrafica_certificazioni sono gemelle, tabelle di relazione fra un proprietario ( la valutazione, l'anagrafica ) e le
-- certificazioni che lo accompagnano. Come ogni tabella di relazione hanno ordine, con la sua chiave e dentro indice.
--
-- Cosa fa: aggiunge ordine dopo id alle due tabelle, aggiunge la KEY ordine e ricrea indice con ordine. Le viste stanno
-- nel file base.
--
-- Cosa NON fa: non cambia anagrafica_certificazioni_ibfk_03_nofollow ( id_emittente ) da CASCADE a SET NULL, ne' allinea
-- le FK di eurosnodi crm: lo fa il punto 12 del canone. Non sposta dati.
--
-- IDEMPOTENTE.

-- | 202611101900

-- anagrafica_certificazioni: ordine
ALTER TABLE `anagrafica_certificazioni`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id`;

-- | 202611101901

-- anagrafica_certificazioni: indice di ordine e indice composto
ALTER TABLE `anagrafica_certificazioni`
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `ordine` (`ordine`),
	ADD KEY `indice` (`id`,`ordine`,`id_anagrafica`,`id_certificazione`,`codice`,`id_emittente`,`nome`,`data_emissione`,`data_scadenza`);

-- | 202611101902

-- valutazioni_certificazioni: ordine
ALTER TABLE `valutazioni_certificazioni`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id`;

-- | 202611101903

-- valutazioni_certificazioni: indice di ordine e indice composto
ALTER TABLE `valutazioni_certificazioni`
	DROP INDEX IF EXISTS `ordine`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `ordine` (`ordine`),
	ADD KEY `indice` (`id`,`ordine`,`id_valutazione`,`id_certificazione`,`codice`,`id_emittente`,`nome`,`data_emissione`,`data_scadenza`);

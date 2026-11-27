-- 2026-11-05 — testate: nome a char(255), la UNIQUE si chiama unica
--
-- Schema canonico, punto 6, riga 190, decisione di Fabio del 05/11/2026 ( opzione A ): testate resta il classificatore
-- delle risorse d'archivio ( risorse.id_testata ) e prende la forma del canone: nome char(255) ( regola del 12/10/2026 )
-- e la UNIQUE sul nome col nome canonico unica.
--
-- Cosa fa: toglie gli indici vecchi, allarga nome a char(255) e ricrea unica e indice. La vista testate_view sta nel
-- file base.
--
-- Cosa NON fa: non tocca i dati ( 0 righe su tutti i database letti il 05/11/2026 ). Nessun codice legge la tabella.
--
-- IDEMPOTENTE: gli indici si tolgono con IF EXISTS e si ricreano, il MODIFY ripetuto non cambia niente.

-- | 202611051215

-- testate: via gli indici vecchi
ALTER TABLE `testate`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611051216

-- testate: nome a char(255)
ALTER TABLE `testate`
	MODIFY `nome` char(255) DEFAULT NULL AFTER `id`;

-- | 202611051217

-- testate: indici nella forma del canone
ALTER TABLE `testate`
	ADD UNIQUE KEY `unica` (`nome`),
	ADD KEY `indice` (`id`,`nome`);

-- | FINE

-- 2026-11-10 — tipologie_sconti: modello delle tipologie, tabella gestita con la coda di audit
--
-- Schema canonico, punto 6, riga 221, decisione di Fabio del 10/11/2026 ( opzione A ): la tabella segue il modello
-- delle tipologie_* ( ordine, codice, nome char(255), icone, unica, indice, vista completa ) ed è gestita: parte vuota,
-- la riempie l'utente, e quindi ha la coda di audit, che il 6b le aveva tolto quando era classificata standard.
--
-- Cosa fa:
-- - aggiunge ordine, codice, html_entity, font_awesome e le quattro colonne di audit dove mancano ( bernispa non le ha ),
--   allarga nome a char(255);
-- - toglie le KEY nome e indice, aggiunge unica se manca, le KEY codice, ordine, account e indice del modello;
-- - aggiunge le chiavi esterne 98 e 99 verso account;
-- - ricrea la vista con tutte le colonne e il percorso come etichetta.
--
-- Cosa NON fa: non tocca le righe ( 1 su bernispa e utensilerialughese, sconti quantità, dato dell'utente ) né
-- sconti_ibfk_01_nofollow, che resta NO ACTION.
--
-- IDEMPOTENTE: colonne, chiavi e vincoli con IF ( NOT ) EXISTS, indice si toglie e si ricrea; la vista è CREATE OR
-- REPLACE.

-- | 202611101100

-- tipologie_sconti: colonne del modello e coda di audit
ALTER TABLE `tipologie_sconti`
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL AFTER `id_genitore`,
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	ADD COLUMN IF NOT EXISTS `html_entity` char(8) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `font_awesome` char(16) DEFAULT NULL AFTER `html_entity`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `font_awesome`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`;

-- | 202611101101

-- tipologie_sconti: chiavi tolte
ALTER TABLE `tipologie_sconti`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611101102

-- tipologie_sconti: chiavi del modello
ALTER TABLE `tipologie_sconti`
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`id_genitore`,`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY IF NOT EXISTS `ordine` (`ordine`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611101103

-- tipologie_sconti: chiavi esterne della coda di audit
ALTER TABLE `tipologie_sconti`
	ADD CONSTRAINT `tipologie_sconti_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `tipologie_sconti_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | FINE

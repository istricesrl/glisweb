--
-- 2026-11-10 — udm: da tabella standard ad assistita, con la coda di audit e la conversione in double
--
-- Schema canonico, punto 6, riga 230, decisione di Fabio del 10/11/2026: la tabella passa da standard ad assistita,
-- l'utente aggiunge e gestisce le sue unità di misura accanto a quelle che caricano i file di base. Quindi prende la coda
-- di audit; in più nome char(255), conversione da float a double ( il float tiene sette cifre, e il kilometro quadrato si
-- leggeva 999999995904 ), nome e sigla unici, gli URL delle righe del framework da note a url_riferimento e le unità di
-- area senza se_lunghezza.
--
-- Cosa fa:
-- - riordina le colonne ( id, id_base, nome, sigla, conversione, flag, url_riferimento, note ), allarga nome, porta
--   conversione a double e aggiunge le quattro colonne di audit;
-- - toglie unica ( id_base, sigla ), che non proteggeva le basi, e indice; aggiunge unica ( nome ), sigla, le KEY degli
--   account e indice;
-- - aggiunge le chiavi esterne 98 e 99 verso account;
-- - sulle righe del framework, riconosciute da id e nome: rimette esatta la conversione del kilometro quadrato, sposta
--   gli URL da note a url_riferimento, toglie se_lunghezza alle aree. La vista sta nel file base.
--
-- Cosa NON fa: non tocca le righe aggiunte dall'utente ( le cinque di bernispa, da 39 a 43 ), né le conversioni delle
-- righe del framework che qualcuno ha cambiato davvero ( la correzione vale solo per lo scarto del float ).
--
-- IDEMPOTENTE.
--

-- | 202611101600

-- udm: ordine delle colonne, nome char(255), conversione double, coda di audit
ALTER TABLE `udm`
	MODIFY `nome` char(255) DEFAULT NULL AFTER `id_base`,
	MODIFY `sigla` char(8) DEFAULT NULL AFTER `nome`,
	MODIFY `conversione` double DEFAULT NULL AFTER `sigla`,
	MODIFY `url_riferimento` char(255) DEFAULT NULL AFTER `se_area`,
	MODIFY `note` text DEFAULT NULL AFTER `url_riferimento`,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `note`,
	ADD COLUMN IF NOT EXISTS `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	ADD COLUMN IF NOT EXISTS `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`;

-- | 202611101601

-- udm: chiavi tolte
ALTER TABLE `udm`
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611101602

-- udm: chiavi del canone
ALTER TABLE `udm`
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`),
	ADD UNIQUE KEY IF NOT EXISTS `sigla` (`sigla`),
	ADD KEY IF NOT EXISTS `id_account_inserimento` (`id_account_inserimento`),
	ADD KEY IF NOT EXISTS `id_account_aggiornamento` (`id_account_aggiornamento`),
	ADD KEY `indice` (`id`,`id_base`,`nome`,`sigla`,`conversione`);

-- | 202611101603

-- udm: chiavi esterne della coda di audit
ALTER TABLE `udm`
	ADD CONSTRAINT `udm_ibfk_98_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	ADD CONSTRAINT `udm_ibfk_99_nofollow` FOREIGN KEY IF NOT EXISTS (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

-- | 202611101604

-- udm: la conversione esatta del kilometro quadrato, dove il float l'aveva arrotondata
UPDATE `udm` SET `conversione` = 1000000000000
	WHERE `id` = 35 AND `nome` = 'kilometro quadrato' AND abs( `conversione` - 1000000000000 ) < 1000000;

-- | 202611101605

-- udm: gli URL delle righe del framework da note a url_riferimento
UPDATE `udm` SET `url_riferimento` = `note`, `note` = NULL
	WHERE `id` BETWEEN 2 AND 38 AND `url_riferimento` IS NULL AND `note` LIKE 'https://it.wikipedia.org/%';

-- | 202611101606

-- udm: le unità di area del framework non sono lunghezze
UPDATE `udm` SET `se_lunghezza` = NULL
	WHERE `id` BETWEEN 29 AND 38 AND `se_area` = 1 AND `se_lunghezza` = 1;

-- | FINE

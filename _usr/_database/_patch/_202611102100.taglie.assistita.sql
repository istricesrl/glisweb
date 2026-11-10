--
-- 2026-11-10 — taglie: tabella assistita, con le sigle dei paesi e la misura del corpo in millimetri
--
-- Schema canonico, punto 6, riga 235, decisione di Fabio del 10/11/2026: la tabella resta nel canone, passa da gestita
-- ad assistita ( il 050 aveva già le sue righe ) e si precompila con le taglie più comuni. Una tabella di conversione
-- normativa fra i paesi non esiste ( EN 13402 designa la taglia con le misure del corpo, ISO 19407 converte le calzature
-- dalla lunghezza del piede ): le sigle sono le convenzioni più diffuse, la misura è il dato stabile.
--
-- Cosa fa:
-- - riordina le colonne ( id, nome, id_tipologia_prodotti, sesso, sigle, misure ), allarga nome, aggiunge taglia_it,
--   taglia_eu, taglia_fr, taglia_uk, taglia_us e rinomina circonferenza_testa_min/max in misura_min/max, che valgono per
--   la dimensione primaria della tipologia ( nessun codice leggeva le due colonne vecchie );
-- - aggiunge unica ( nome ) e indice;
-- - sulle righe 1-26 del framework, riconosciute da id e nome, scrive sigle e misure ( le otto da donna avevano la sigla
--   internazionale sfasata di una taglia );
-- - aggiunge le righe 27-45 ( calzature e intimo ) solo dove le righe del framework ci sono già: un deploy con la tabella
--   vuota resta vuoto. La vista sta nel file base.
--
-- Cosa NON fa: non toglie le nove colonne della forma di prima del 02/03/2026 che gimbe ha ancora ( it, eu, us, uk, fr,
-- international, jeans, id_tipologia, cm ): il DROP è del punto 12. Non tocca le righe aggiunte dall'utente.
--
-- IDEMPOTENTE.
--

-- | 202611102100

-- taglie: le colonne nuove
ALTER TABLE `taglie`
	ADD COLUMN IF NOT EXISTS `taglia_it` char(8) DEFAULT NULL AFTER `taglia_internazionale`,
	ADD COLUMN IF NOT EXISTS `taglia_eu` char(8) DEFAULT NULL AFTER `taglia_it`,
	ADD COLUMN IF NOT EXISTS `taglia_fr` char(8) DEFAULT NULL AFTER `taglia_eu`,
	ADD COLUMN IF NOT EXISTS `taglia_uk` char(8) DEFAULT NULL AFTER `taglia_fr`,
	ADD COLUMN IF NOT EXISTS `taglia_us` char(8) DEFAULT NULL AFTER `taglia_uk`;

-- | 202611102101

-- taglie: la circonferenza della testa diventa la misura della dimensione primaria
ALTER TABLE `taglie`
	CHANGE COLUMN IF EXISTS `circonferenza_testa_min` `misura_min` int(11) DEFAULT NULL,
	CHANGE COLUMN IF EXISTS `circonferenza_testa_max` `misura_max` int(11) DEFAULT NULL;

-- | 202611102102

-- taglie: ordine delle colonne e nome char(255)
ALTER TABLE `taglie`
	MODIFY `nome` char(255) DEFAULT NULL AFTER `id`,
	MODIFY `id_tipologia_prodotti` bigint(20) DEFAULT NULL AFTER `nome`,
	MODIFY `sesso` enum('M','F','-') DEFAULT NULL AFTER `id_tipologia_prodotti`,
	MODIFY `taglia_internazionale` char(8) DEFAULT NULL AFTER `sesso`,
	MODIFY `taglia_it` char(8) DEFAULT NULL AFTER `taglia_internazionale`,
	MODIFY `taglia_eu` char(8) DEFAULT NULL AFTER `taglia_it`,
	MODIFY `taglia_fr` char(8) DEFAULT NULL AFTER `taglia_eu`,
	MODIFY `taglia_uk` char(8) DEFAULT NULL AFTER `taglia_fr`,
	MODIFY `taglia_us` char(8) DEFAULT NULL AFTER `taglia_uk`,
	MODIFY `misura_min` int(11) DEFAULT NULL AFTER `taglia_us`,
	MODIFY `misura_max` int(11) DEFAULT NULL AFTER `misura_min`,
	MODIFY `id_account_inserimento` bigint(20) DEFAULT NULL AFTER `misura_max`,
	MODIFY `timestamp_inserimento` int(11) DEFAULT NULL AFTER `id_account_inserimento`,
	MODIFY `id_account_aggiornamento` bigint(20) DEFAULT NULL AFTER `timestamp_inserimento`,
	MODIFY `timestamp_aggiornamento` int(11) DEFAULT NULL AFTER `id_account_aggiornamento`;

-- | 202611102103

-- taglie: indice tolto, si ricrea col nuovo ordine
ALTER TABLE `taglie`
	DROP INDEX IF EXISTS `indice`;

-- | 202611102104

-- taglie: chiavi del canone
ALTER TABLE `taglie`
	ADD UNIQUE KEY IF NOT EXISTS `unica` (`nome`),
	ADD KEY `indice` (`id`,`nome`,`id_tipologia_prodotti`,`sesso`,`taglia_internazionale`);

-- | 202611102105

-- taglie: sigle e misure delle righe 1-26 del framework
UPDATE `taglie` t
	INNER JOIN (
		SELECT 1 AS id, 'abbigliamento XXXS uomo' AS nome, 'XXXS' AS i, '40' AS it, '40' AS eu, '40' AS fr, '30' AS uk, '30' AS us, 800 AS mn, 839 AS mx
		UNION ALL SELECT 2, 'abbigliamento XXS uomo', 'XXS', '42', '42', '42', '32', '32', 840, 879
		UNION ALL SELECT 3, 'abbigliamento XS uomo', 'XS', '44', '44', '44', '34', '34', 880, 919
		UNION ALL SELECT 4, 'abbigliamento S uomo', 'S', '46', '46', '46', '36', '36', 920, 959
		UNION ALL SELECT 5, 'abbigliamento M uomo', 'M', '48', '48', '48', '38', '38', 960, 999
		UNION ALL SELECT 6, 'abbigliamento L uomo', 'L', '50', '50', '50', '40', '40', 1000, 1039
		UNION ALL SELECT 7, 'abbigliamento XL uomo', 'XL', '52', '52', '52', '42', '42', 1040, 1079
		UNION ALL SELECT 8, 'abbigliamento XXL uomo', 'XXL', '54', '54', '54', '44', '44', 1080, 1119
		UNION ALL SELECT 9, 'abbigliamento XXXL uomo', 'XXXL', '56', '56', '56', '46', '46', 1120, 1159
		UNION ALL SELECT 10, 'abbigliamento 4XL uomo', '4XL', '58', '58', '58', '48', '48', 1160, 1199
		UNION ALL SELECT 11, 'abbigliamento XXS donna', 'XXS', '38', '32', '34', '6', '2', 760, 799
		UNION ALL SELECT 12, 'abbigliamento XS donna', 'XS', '40', '34', '36', '8', '4', 800, 839
		UNION ALL SELECT 13, 'abbigliamento S donna', 'S', '42', '36', '38', '10', '6', 840, 879
		UNION ALL SELECT 14, 'abbigliamento M donna', 'M', '44', '38', '40', '12', '8', 880, 919
		UNION ALL SELECT 15, 'abbigliamento L donna', 'L', '46', '40', '42', '14', '10', 920, 959
		UNION ALL SELECT 16, 'abbigliamento XL donna', 'XL', '48', '42', '44', '16', '12', 960, 999
		UNION ALL SELECT 17, 'abbigliamento XXL donna', 'XXL', '50', '44', '46', '18', '14', 1000, 1039
		UNION ALL SELECT 18, 'abbigliamento XXXL donna', 'XXXL', '52', '46', '48', '20', '16', 1040, 1079
		UNION ALL SELECT 19, 'caschi XXS', 'XXS', NULL, NULL, NULL, NULL, NULL, 510, 529
		UNION ALL SELECT 20, 'caschi XS', 'XS', NULL, NULL, NULL, NULL, NULL, 530, 549
		UNION ALL SELECT 21, 'caschi S', 'S', NULL, NULL, NULL, NULL, NULL, 550, 569
		UNION ALL SELECT 22, 'caschi M', 'M', NULL, NULL, NULL, NULL, NULL, 570, 589
		UNION ALL SELECT 23, 'caschi L', 'L', NULL, NULL, NULL, NULL, NULL, 590, 609
		UNION ALL SELECT 24, 'caschi XL', 'XL', NULL, NULL, NULL, NULL, NULL, 610, 629
		UNION ALL SELECT 25, 'caschi XXL', 'XXL', NULL, NULL, NULL, NULL, NULL, 630, 649
		UNION ALL SELECT 26, 'caschi taglia unica', 'UNICA', NULL, NULL, NULL, NULL, NULL, NULL, NULL
	) s ON s.id = t.id AND s.nome = t.nome
	SET t.taglia_internazionale = s.i, t.taglia_it = s.it, t.taglia_eu = s.eu, t.taglia_fr = s.fr,
		t.taglia_uk = s.uk, t.taglia_us = s.us, t.misura_min = s.mn, t.misura_max = s.mx;

-- | 202611102106

-- taglie: calzature e intimo, dove ci sono già le righe del framework
INSERT IGNORE INTO `taglie` ( `id`, `nome`, `id_tipologia_prodotti`, `sesso`, `taglia_internazionale`, `taglia_it`, `taglia_eu`, `taglia_fr`, `taglia_uk`, `taglia_us`, `misura_min`, `misura_max` )
	SELECT s.* FROM (
		SELECT 27 AS id, 'calzature EU 35' AS nome, 15 AS t, NULL AS sesso, NULL AS i, NULL AS it, '35' AS eu, '35' AS fr, '2.5' AS uk, '3.5' AS us, 215 AS mn, 221 AS mx
		UNION ALL SELECT 28, 'calzature EU 36', 15, NULL, NULL, NULL, '36', '36', '3.5', '4.5', 222, 227
		UNION ALL SELECT 29, 'calzature EU 37', 15, NULL, NULL, NULL, '37', '37', '4', '5', 228, 234
		UNION ALL SELECT 30, 'calzature EU 38', 15, NULL, NULL, NULL, '38', '38', '5', '6', 235, 241
		UNION ALL SELECT 31, 'calzature EU 39', 15, NULL, NULL, NULL, '39', '39', '5.5', '6.5', 242, 247
		UNION ALL SELECT 32, 'calzature EU 40', 15, NULL, NULL, NULL, '40', '40', '6.5', '7.5', 248, 254
		UNION ALL SELECT 33, 'calzature EU 41', 15, NULL, NULL, NULL, '41', '41', '7.5', '8.5', 255, 261
		UNION ALL SELECT 34, 'calzature EU 42', 15, NULL, NULL, NULL, '42', '42', '8', '9', 262, 267
		UNION ALL SELECT 35, 'calzature EU 43', 15, NULL, NULL, NULL, '43', '43', '9', '10', 268, 274
		UNION ALL SELECT 36, 'calzature EU 44', 15, NULL, NULL, NULL, '44', '44', '9.5', '10.5', 275, 281
		UNION ALL SELECT 37, 'calzature EU 45', 15, NULL, NULL, NULL, '45', '45', '10.5', '11.5', 282, 287
		UNION ALL SELECT 38, 'calzature EU 46', 15, NULL, NULL, NULL, '46', '46', '11', '12', 288, 294
		UNION ALL SELECT 39, 'calzature EU 47', 15, NULL, NULL, NULL, '47', '47', '12', '13', 295, 301
		UNION ALL SELECT 40, 'intimo XS uomo', 14, 'M', 'XS', '2', NULL, NULL, NULL, NULL, NULL, NULL
		UNION ALL SELECT 41, 'intimo S uomo', 14, 'M', 'S', '3', NULL, NULL, NULL, NULL, NULL, NULL
		UNION ALL SELECT 42, 'intimo M uomo', 14, 'M', 'M', '4', NULL, NULL, NULL, NULL, NULL, NULL
		UNION ALL SELECT 43, 'intimo L uomo', 14, 'M', 'L', '5', NULL, NULL, NULL, NULL, NULL, NULL
		UNION ALL SELECT 44, 'intimo XL uomo', 14, 'M', 'XL', '6', NULL, NULL, NULL, NULL, NULL, NULL
		UNION ALL SELECT 45, 'intimo XXL uomo', 14, 'M', 'XXL', '7', NULL, NULL, NULL, NULL, NULL, NULL
	) s
	WHERE EXISTS ( SELECT 1 FROM `taglie` f WHERE f.id = 1 AND f.nome = 'abbigliamento XXXS uomo' )
		AND EXISTS ( SELECT 1 FROM `tipologie_prodotti` p WHERE p.id = s.t );

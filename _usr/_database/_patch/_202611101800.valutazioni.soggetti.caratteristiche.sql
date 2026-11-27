-- 2026-11-10 — valutazioni: tre soggetti, il valutatore, l'importo, e le caratteristiche
--
-- Schema canonico, punto 6, riga 232, decisione di Fabio del 10/11/2026: valutazioni fissa nel tempo l'associazione fra
-- un soggetto e determinati valori; il soggetto e' un immobile, una matricola ( p.es. un pezzo d'antiquariato ) o una
-- persona ( p.es. un candidato ), uno solo per riga. id_anagrafica e' la persona valutata, come vuole il canone per le
-- colonne id_<oggetto>, e chi valuta passa a id_valutatore. La valutazione economica e' importo con la sua valuta; i
-- valori senza una colonna stanno nella nuova valutazioni_caratteristiche, gemella di immobili_caratteristiche, con le
-- caratteristiche che hanno se_valutazioni.
--
-- Cosa fa: aggiunge valutazioni.id_valutatore, id_valuta e importo; sostituisce la vecchia unica ( id_anagrafica,
-- id_immobile, timestamp_valutazione ) con una chiave unica per soggetto e ricrea indice; crea valutazioni_caratteristiche
-- con indici e chiavi esterne; aggiunge caratteristiche.se_valutazioni e ricrea il suo indice. Le viste stanno nel file
-- base. La tabella valutazioni e' vuota su tutti i database letti, quindi lo scambio delle chiavi uniche non puo' fallire.
--
-- Cosa NON fa: non cambia le chiavi esterne di valutazioni ( id_immobile, id_matricola e id_anagrafica da SET NULL a
-- CASCADE, la nuova verso il valutatore e quella verso la valuta ): lo fa il punto 12 del canone. Non sposta dati.
--
-- IDEMPOTENTE.

-- | 202611101800

-- valutazioni: il valutatore, la valuta e l'importo
ALTER TABLE `valutazioni`
	ADD COLUMN IF NOT EXISTS `id_valutatore` bigint(20) DEFAULT NULL AFTER `id_anagrafica`,
	ADD COLUMN IF NOT EXISTS `id_valuta` bigint(20) DEFAULT NULL AFTER `id_classe_energetica`,
	ADD COLUMN IF NOT EXISTS `importo` decimal(16,2) DEFAULT NULL AFTER `id_valuta`;

-- | 202611101801

-- valutazioni: una chiave unica per soggetto, indici delle colonne nuove, indice composto
ALTER TABLE `valutazioni`
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `unica_immobile`,
	DROP INDEX IF EXISTS `unica_matricola`,
	DROP INDEX IF EXISTS `unica_anagrafica`,
	DROP INDEX IF EXISTS `id_valutatore`,
	DROP INDEX IF EXISTS `id_valuta`,
	DROP INDEX IF EXISTS `timestamp_valutazione`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `unica_immobile` (`id_immobile`,`timestamp_valutazione`),
	ADD UNIQUE KEY `unica_matricola` (`id_matricola`,`timestamp_valutazione`),
	ADD UNIQUE KEY `unica_anagrafica` (`id_anagrafica`,`timestamp_valutazione`),
	ADD KEY `id_valutatore` (`id_valutatore`),
	ADD KEY `id_valuta` (`id_valuta`),
	ADD KEY `timestamp_valutazione` (`timestamp_valutazione`),
	ADD KEY `indice` (`id`,`id_immobile`,`id_matricola`,`id_anagrafica`,`id_valutatore`,`id_condizione`,`id_disponibilita`,`id_classe_energetica`,`timestamp_valutazione`);

-- | 202611101802

-- caratteristiche: il flag delle caratteristiche proponibili nelle valutazioni
ALTER TABLE `caratteristiche`
	ADD COLUMN IF NOT EXISTS `se_valutazioni` tinyint(1) DEFAULT NULL AFTER `se_vani`;

-- | 202611101803

-- caratteristiche: indice composto col flag nuovo
ALTER TABLE `caratteristiche`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`codice`,`nome`,`se_prodotti`,`se_articoli`,`se_immobili`,`se_edifici`,`se_indirizzi`,`se_vani`,`se_valutazioni`);

-- | 202611101804

-- valutazioni_caratteristiche: i valori di una valutazione che non hanno una colonna
CREATE TABLE IF NOT EXISTS `valutazioni_caratteristiche` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ordine` int(11) DEFAULT NULL,
  `id_valutazione` bigint(20) DEFAULT NULL,
  `id_caratteristica` bigint(20) DEFAULT NULL,
  `id_lingua` bigint(20) DEFAULT NULL,
  `valore` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `se_assente` tinyint(1) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unica` (`id_valutazione`,`id_caratteristica`,`id_lingua`),
  KEY `id_valutazione` (`id_valutazione`),
  KEY `id_caratteristica` (`id_caratteristica`),
  KEY `id_lingua` (`id_lingua`),
  KEY `ordine` (`ordine`),
  KEY `id_account_inserimento` (`id_account_inserimento`),
  KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
  KEY `indice` (`id`,`ordine`,`id_valutazione`,`id_caratteristica`,`id_lingua`,`se_assente`),
  CONSTRAINT `valutazioni_caratteristiche_ibfk_01` FOREIGN KEY (`id_valutazione`) REFERENCES `valutazioni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `valutazioni_caratteristiche_ibfk_02_nofollow` FOREIGN KEY (`id_caratteristica`) REFERENCES `caratteristiche` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `valutazioni_caratteristiche_ibfk_03_nofollow` FOREIGN KEY (`id_lingua`) REFERENCES `lingue` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `valutazioni_caratteristiche_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `valutazioni_caratteristiche_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE

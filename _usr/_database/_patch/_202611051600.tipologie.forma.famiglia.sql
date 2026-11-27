-- 2026-11-05 — tipologie_*: le venti tipologie senza colonne proprie prendono la forma della famiglia
--
-- Schema canonico, punto 6, righe 191-227, decisione di Fabio del 05/11/2026: la famiglia tipologie_* si allinea in
-- blocco a un modello solo, e queste venti ( lotto 2, le "pure": nessuna colonna oltre id, id_genitore, ordine, nome,
-- html_entity, font_awesome e la coda di audit ) ne sono la parte meccanica.
--
-- Cosa fa: allarga nome a char(255) ( regola del 12/10/2026 ), toglie la KEY nome ( doppia di unica ) e ricrea indice
-- nella forma del modello ( id, id_genitore, ordine, nome, html_entity, font_awesome ); carica le quattro tipologie di
-- popup a id fissi, che _3400.popup/_420.pages.php traduce nelle classi popup-open/close/delay/scroll.
--
-- Cosa NON fa: non tocca unica, gia' ( id_genitore, nome ) nel canone; non cambia dati esistenti ( INSERT IGNORE ).
-- Le viste stanno nel file base.
--
-- IDEMPOTENTE: gli indici si tolgono con IF EXISTS e si ricreano, il MODIFY ripetuto non cambia niente.

-- | 202611051600

-- tipologie_asset: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_asset`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051601

-- tipologie_badge: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_badge`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051602

-- tipologie_banner: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_banner`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051603

-- tipologie_campagne: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_campagne`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051604

-- tipologie_chiavi: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_chiavi`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051605

-- tipologie_contatti: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_contatti`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051606

-- tipologie_edifici: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_edifici`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051607

-- tipologie_indirizzi: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_indirizzi`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051608

-- tipologie_licenze: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_licenze`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051609

-- tipologie_listini: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_listini`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051610

-- tipologie_luoghi: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_luoghi`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051611

-- tipologie_notizie: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_notizie`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051612

-- tipologie_pagamenti: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_pagamenti`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051613

-- tipologie_popup: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_popup`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051614

-- tipologie_risorse: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_risorse`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051615

-- tipologie_spedizioni: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_spedizioni`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051616

-- tipologie_telefoni: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_telefoni`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051617

-- tipologie_url: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_url`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051618

-- tipologie_vani: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_vani`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051619

-- tipologie_veicoli: nome a char(255), indice nella forma della famiglia
ALTER TABLE `tipologie_veicoli`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `indice`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `ordine`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611051620

-- tipologie_popup: le quattro tipologie a id fissi
INSERT IGNORE INTO `tipologie_popup` (`id`, `id_genitore`, `ordine`, `nome`) VALUES
(1,	NULL,	10,	'all''apertura della pagina'),
(2,	NULL,	20,	'alla chiusura della pagina'),
(3,	NULL,	30,	'dopo secondi'),
(4,	NULL,	40,	'dopo scroll');

-- | FINE

--
-- 2026-11-10 — tipologie_contratti, tipologie_documenti, tipologie_prodotti: indice a 16 colonne, il massimo di MySQL
--
-- Le patch 202611051806, 202611091132 e 202611091501 creavano indice con 17 colonne: MariaDB ne ammette 32 e le ha
-- applicate, MySQL 8.4 ( la PROD di gimbe, su Azure ) si ferma con 1070 ( too many key parts, max 16 ). Trovato da
-- gimbe sul banco /opt/mysql84 il 10/11/2026. Le tre patch e il file base ora tolgono font_awesome dall'indice: è una
-- colonna di sola visualizzazione, mentre i flag sono quelli su cui si filtra.
--
-- Cosa fa: sui database dove quelle patch sono già passate con 17 colonne, ricrea indice a 16, senza font_awesome.
--
-- IDEMPOTENTE: indice si toglie e si ricrea.
--

-- | 202611102300

-- tipologie_contratti: indice senza font_awesome
ALTER TABLE `tipologie_contratti`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_tesseramento`,`se_abbonamento`,`se_iscrizione`,`se_affiliazione`,`se_acquisto`,`se_locazione`,`se_libero`,`se_prenotazione`,`se_scalare`,`se_immobili`,`se_online`);

-- | 202611102301

-- tipologie_documenti: indice senza font_awesome
ALTER TABLE `tipologie_documenti`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`html_entity`,`se_fattura`,`se_nota_credito`,`se_nota_debito`,`se_pro_forma`,`se_offerta`,`se_ordine`,`se_missione`,`se_ricevuta`,`se_trasporto`,`se_ecommerce`);

-- | 202611102302

-- tipologie_prodotti: indice senza font_awesome
ALTER TABLE `tipologie_prodotti`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`se_colori`,`se_taglie`,`se_periodicita`,`se_tipologia_rinnovo`,`se_dimensioni`,`se_volume`,`se_capacita`,`se_peso`,`se_imballo`,`se_prodotto`,`se_servizio`);

-- | FINE

-- 2026-10-13 — tipologie di riga dettaglio ed evasione, e i loro flag
--
-- Decisione di Fabio del 13/10/2026: una riga di documento figlia di un'altra ( id_genitore ) puo' avere tre ruoli,
-- e la tipologia della riga deve dirlo con un flag, come fanno i flag di tipologie_documenti, perche' il codice
-- legga il comportamento e non un id:
-- - raggruppamento ( se_raggruppamento, con se_somma o se_alternativa ), le tipologie 1 e 2 che c'erano gia';
-- - dettaglio ( se_dettaglio ): la figlia ripartisce la madre, p.es. una riga di lista di prelievo divisa per
--   ubicazione o fra magazzino automatico e manuale;
-- - evasione ( se_evasione ): la figlia evade la madre in tutto o in parte, p.es. il prelievo fatto in missione.
--
-- Le tipologie hanno gli id fissi 5 e 6, come nel _050: gli id del canone sono gli stessi su tutti i deploy
-- ( database unico ). INSERT IGNORE non sovrascrive niente; un deploy che avesse gia' un 5 o un 6 suo resta com'e'
-- e va sistemato a mano.
-- Il char(255) di nome, voluto dal canone, non sta qui: va col punto 12 insieme alle altre tabelle.
--
-- IDEMPOTENTE.

-- | 202610131800

ALTER TABLE `tipologie_documenti_articoli`
	ADD COLUMN IF NOT EXISTS `se_dettaglio` tinyint(1) DEFAULT NULL AFTER `se_alternativa`,
	ADD COLUMN IF NOT EXISTS `se_evasione` tinyint(1) DEFAULT NULL AFTER `se_dettaglio`;

-- | 202610131801

ALTER TABLE `tipologie_documenti_articoli`
	ADD KEY IF NOT EXISTS `se_dettaglio` (`se_dettaglio`),
	ADD KEY IF NOT EXISTS `se_evasione` (`se_evasione`),
	DROP KEY IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`sigla`,`se_raggruppamento`,`se_somma`,`se_alternativa`,`se_dettaglio`,`se_evasione`);

-- | 202610131802

INSERT IGNORE INTO `tipologie_documenti_articoli` ( `id`, `ordine`, `nome`, `sigla`, `se_dettaglio` )
	VALUES ( 5, 5, 'dettaglio', 'dett.', 1 );

-- | 202610131803

INSERT IGNORE INTO `tipologie_documenti_articoli` ( `id`, `ordine`, `nome`, `sigla`, `se_evasione` )
	VALUES ( 6, 6, 'evasione', 'evas.', 1 );

-- | 202610131804

CREATE OR REPLACE VIEW `tipologie_documenti_articoli_view` AS
	SELECT
		tipologie_documenti_articoli.id,
		tipologie_documenti_articoli.id_genitore,
		tipologie_documenti_articoli.ordine,
		tipologie_documenti_articoli.nome,
		tipologie_documenti_articoli.sigla,
		tipologie_documenti_articoli.html_entity,
		tipologie_documenti_articoli.font_awesome,
		tipologie_documenti_articoli.se_raggruppamento,
		tipologie_documenti_articoli.se_somma,
		tipologie_documenti_articoli.se_alternativa,
		tipologie_documenti_articoli.se_dettaglio,
		tipologie_documenti_articoli.se_evasione,
		tipologie_documenti_articoli.id_account_inserimento,
		tipologie_documenti_articoli.id_account_aggiornamento,
		tipologie_documenti_articoli_path( tipologie_documenti_articoli.id ) AS __label__
	FROM tipologie_documenti_articoli
;

-- | FINE

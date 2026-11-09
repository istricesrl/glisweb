-- 2026-11-09 — tipologie_colli: codice, nome a char(255), indici del modello, vista con le misure
--
-- Schema canonico, punto 6, riga 198, decisione di Fabio del 09/11/2026 ( opzione A ): la tabella segue il modello
-- delle tipologie_* e tiene il suo blocco misure ( larghezza, lunghezza, altezza, peso e le loro udm ), che dice che
-- ingombro e che peso ha quel tipo di collo e vale da default per le misure del collo. È una tabella assistita: il 050
-- carica container, pallet e scatola, e l'utente fa crescere sotto i suoi formati.
--
-- Cosa fa:
-- - aggiunge codice, dopo ordine, con la UNIQUE KEY codice, e lo valorizza sulle tre righe del 050 riconoscendole da id
--   E nome, solo dove è ancora vuoto ( su crm eurosnodi la 3 è 'mezzo pallet' e la scatola è la 12: lì restano senza );
-- - allarga nome a char(255);
-- - toglie le KEY nome e sigla e ricrea indice coi campi del modello;
-- - ricrea la vista con codice e il blocco misure, con le sigle delle due udm.
--
-- Cosa NON fa: non toglie sigla ( vuota su tutti i database, nessun lettore ), che esce dal canone ma resta sui database
-- fino al punto 12; non tocca le misure né le chiavi esterne. Su crm eurosnodi le colonne sono ancora int(11): la patch
-- funziona lo stesso, il passaggio a bigint(20) è del punto 12.
--
-- IDEMPOTENTE: colonne e chiavi con IF ( NOT ) EXISTS, indice si toglie e si ricrea, l'UPDATE tocca solo righe con codice
-- ancora vuoto; UPDATE IGNORE salta la riga il cui codice è già usato da un'altra; la vista è CREATE OR REPLACE.

-- | 202611091700

-- tipologie_colli: codice, nome a char(255), chiavi tolte
ALTER TABLE `tipologie_colli`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `ordine`,
	MODIFY `nome` char(255) DEFAULT NULL AFTER `codice`,
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `sigla`,
	DROP INDEX IF EXISTS `indice`;

-- | 202611091701

-- tipologie_colli: chiavi del modello
ALTER TABLE `tipologie_colli`
	ADD UNIQUE KEY IF NOT EXISTS `codice` (`codice`),
	ADD KEY `indice` (`id`,`id_genitore`,`ordine`,`nome`,`html_entity`,`font_awesome`);

-- | 202611091702

-- tipologie_colli: codice sulle righe del 050
UPDATE IGNORE `tipologie_colli` JOIN (
		SELECT 1 AS id, 'container' AS nome, 'CONTAINER' AS codice
		UNION ALL SELECT 2 AS id, 'pallet' AS nome, 'PALLET' AS codice
		UNION ALL SELECT 3 AS id, 'scatola' AS nome, 'SCATOLA' AS codice
	) AS c050 ON c050.id = `tipologie_colli`.id AND c050.nome = `tipologie_colli`.nome
	SET `tipologie_colli`.codice = c050.codice
	WHERE `tipologie_colli`.codice IS NULL;

-- | 202611091703

-- tipologie_colli_view
CREATE OR REPLACE VIEW `tipologie_colli_view` AS
	SELECT
		tipologie_colli.id,
		tipologie_colli.id_genitore,
		tipologie_colli.ordine,
		tipologie_colli.codice,
		tipologie_colli.nome,
		tipologie_colli.larghezza,
		tipologie_colli.lunghezza,
		tipologie_colli.altezza,
		tipologie_colli.id_udm_dimensioni,
		udm_dimensioni.sigla AS udm_dimensioni,
		tipologie_colli.peso,
		tipologie_colli.id_udm_peso,
		udm_peso.sigla AS udm_peso,
		tipologie_colli.html_entity,
		tipologie_colli.font_awesome,
		tipologie_colli.id_account_inserimento,
		tipologie_colli.id_account_aggiornamento,
		tipologie_colli_path( tipologie_colli.id ) AS __label__
	FROM tipologie_colli
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = tipologie_colli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = tipologie_colli.id_udm_peso
;

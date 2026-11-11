-- 2026-11-11 — contratti_anagrafica: la forma canonica, note e ruoli proponibili
--
-- Schema canonico, punto 6, riga 245, decisione di Fabio del 11/11/2026 ( opzione B ): contratti_anagrafica prende la
-- colonna note come ogni relazione con un ruolo ( trasversale del 20/10/2026 ), e i ruoli che i deploy usano davvero nei
-- contratti diventano proponibili per flag.
--
-- Cosa fa: aggiunge note, rifa' la KEY indice con ordine in testa, ricrea la vista ( ordine, note, etichetta col codice
-- del contratto; le date dei rinnovi e la tipologia restano, le leggono le liste di _0600 e _0640 ), accende
-- se_contratti su iscritto, istituto, tesserato e abbonato e se_contraente su iscritto ( id e nome insieme, una riga
-- rinominata su un deploy non si tocca ).
--
-- Cosa NON fa ( punto 12 ): il riordino delle colonne ( ordine prima delle chiavi ).
--
-- IDEMPOTENTE.

-- | 202611112000

-- contratti_anagrafica: note
ALTER TABLE `contratti_anagrafica`
	ADD COLUMN IF NOT EXISTS `note` text DEFAULT NULL AFTER `id_ruolo`;

-- | 202611112001

-- contratti_anagrafica: indici
ALTER TABLE `contratti_anagrafica`
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`ordine`,`id_contratto`,`id_anagrafica`,`id_ruolo`);

-- | 202611112002

-- contratti_anagrafica_view
-- tipologia: tabella gestita
-- verifica: 2026-11-11 punto 6, riga 245
CREATE OR REPLACE VIEW `contratti_anagrafica_view` AS
	SELECT
		contratti_anagrafica.id,
		contratti_anagrafica.ordine,
		contratti_anagrafica.id_contratto,
		contratti.codice,
		contratti.nome,
		contratti_anagrafica.id_anagrafica,
		coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ) AS anagrafica,
		contratti_anagrafica.id_ruolo,
		ruoli_anagrafica.nome AS ruolo,
		ruoli_anagrafica.se_proponente,
		ruoli_anagrafica.se_contraente,
		contratti_anagrafica.note,
		tipologie_contratti.id AS id_tipologia,
		tipologie_contratti.nome AS tipologia,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		contratti.id_progetto,
		progetti.nome AS progetto,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		contratti_anagrafica.id_account_inserimento,
		contratti_anagrafica.id_account_aggiornamento,
		concat_ws(
			' ',
			'contratto',
			coalesce( nullif( contratti.codice, '' ), nullif( contratti.nome, '' ), contratti.id ),
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			ruoli_anagrafica.nome
		) AS __label__
	FROM contratti_anagrafica
		LEFT JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN ruoli_anagrafica ON ruoli_anagrafica.id = contratti_anagrafica.id_ruolo
		LEFT JOIN anagrafica ON anagrafica.id = contratti_anagrafica.id_anagrafica
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
		LEFT JOIN progetti ON progetti.id = contratti.id_progetto
	GROUP BY contratti_anagrafica.id
;

-- | 202611112003

-- ruoli_anagrafica: i ruoli usati nei contratti
UPDATE `ruoli_anagrafica` SET `se_contratti` = 1, `se_contraente` = 1 WHERE `id` = 29 AND `nome` = 'iscritto';
UPDATE `ruoli_anagrafica` SET `se_contratti` = 1 WHERE `id` = 30 AND `nome` = 'istituto';
UPDATE `ruoli_anagrafica` SET `se_contratti` = 1 WHERE `id` IN ( 33, 34 ) AND `nome` IN ( 'tesserato', 'abbonato' );

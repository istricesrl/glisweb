-- 2026-11-11 — licenze: la forma canonica, la durata passa alla tipologia
--
-- Schema canonico, punto 6, riga 246, decisione di Fabio del 11/11/2026 ( opzione B, con la durata sulla tipologia ): la
-- validita' di una licenza sono i suoi rinnovi ( rinnovi.id_licenza ), e la regola di durata con cui si creano il primo
-- rinnovo e i successivi sta sulla tipologia ( tipologie_licenze.giorni_validita, giorni_rinnovo ), che vale anche per chi
-- gestisce le proprie licenze senza venderle.
--
-- Cosa fa: aggiunge giorni_validita e giorni_rinnovo a tipologie_licenze e ricrea la sua vista; su licenze porta nome a
-- char(255) e note a text, toglie le KEY nome, giorni_validita, giorni_rinnovo, timestamp_distribuzione, timestamp_inizio,
-- timestamp_fine, rifa' indice e ricrea licenze_view ( intestatario dal contraente per flag del ruolo, non piu' il ruolo
-- 32 cablato; date dai rinnovi; etichetta col codice ).
--
-- Cosa NON fa ( punto 12 ): il DROP di licenze.giorni_validita, giorni_rinnovo, timestamp_inizio, timestamp_fine ( vuote
-- ovunque ) e il riordino delle colonne.
--
-- IDEMPOTENTE.

-- | 202611112100

-- tipologie_licenze: la regola di durata
ALTER TABLE `tipologie_licenze`
	ADD COLUMN IF NOT EXISTS `giorni_validita` int(11) DEFAULT NULL AFTER `nome`,
	ADD COLUMN IF NOT EXISTS `giorni_rinnovo` int(11) DEFAULT NULL AFTER `giorni_validita`;

-- | 202611112101

-- tipologie_licenze_view
CREATE OR REPLACE VIEW `tipologie_licenze_view` AS
	SELECT
		tipologie_licenze.id,
		tipologie_licenze.id_genitore,
		tipologie_licenze.ordine,
		tipologie_licenze.codice,
		tipologie_licenze.nome,
		tipologie_licenze.giorni_validita,
		tipologie_licenze.giorni_rinnovo,
		tipologie_licenze.html_entity,
		tipologie_licenze.font_awesome,
		tipologie_licenze.id_account_inserimento,
		tipologie_licenze.id_account_aggiornamento,
		tipologie_licenze_path( tipologie_licenze.id ) AS __label__
	FROM tipologie_licenze
;

-- | 202611112102

-- licenze: tipi
ALTER TABLE `licenze`
	MODIFY `nome` char(255) DEFAULT NULL,
	MODIFY `note` text DEFAULT NULL;

-- | 202611112103

-- licenze: indici
ALTER TABLE `licenze`
	DROP INDEX IF EXISTS `nome`,
	DROP INDEX IF EXISTS `giorni_validita`,
	DROP INDEX IF EXISTS `giorni_rinnovo`,
	DROP INDEX IF EXISTS `timestamp_distribuzione`,
	DROP INDEX IF EXISTS `timestamp_inizio`,
	DROP INDEX IF EXISTS `timestamp_fine`,
	DROP INDEX IF EXISTS `indice`,
	ADD KEY `indice` (`id`,`id_tipologia`,`codice`,`nome`,`id_anagrafica`,`id_rivenditore`);

-- | 202611112104

-- licenze_view
-- tipologia: tabella gestita
-- verifica: 2026-11-11 punto 6, riga 246
CREATE OR REPLACE VIEW `licenze_view` AS
	SELECT
		licenze.id,
		licenze.id_tipologia,
		tipologie_licenze.nome AS tipologia,
		tipologie_licenze.giorni_validita,
		tipologie_licenze.giorni_rinnovo,
		licenze.codice,
		licenze.nome,
		coalesce( licenze.id_anagrafica, min( contratti_anagrafica.id_anagrafica ) ) AS id_anagrafica,
		group_concat( DISTINCT coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) SEPARATOR ', ' ) AS anagrafica,
		licenze.id_rivenditore,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS rivenditore,
		licenze.postazioni,
		licenze.testo,
		licenze.note,
		licenze.timestamp_distribuzione,
		min( rinnovi.data_inizio ) AS data_inizio,
		max( rinnovi.data_fine ) AS data_fine,
		max( rinnovi.id_contratto ) AS id_contratto,
		group_concat( DISTINCT tipologie_contratti.nome SEPARATOR ', ' ) AS tipologia_contratto,
		group_concat( DISTINCT concat_ws( '§', software.codice, software.nome ) SEPARATOR ' | ' ) AS software,
		licenze.id_account_inserimento,
		licenze.timestamp_inserimento,
		licenze.id_account_aggiornamento,
		licenze.timestamp_aggiornamento,
		concat_ws( ' ', coalesce( nullif( licenze.codice, '' ), nullif( licenze.nome, '' ), licenze.id ), tipologie_licenze.nome ) AS __label__
	FROM licenze
		LEFT JOIN tipologie_licenze ON tipologie_licenze.id = licenze.id_tipologia
		LEFT JOIN rinnovi ON rinnovi.id_licenza = licenze.id
		LEFT JOIN licenze_software ON licenze_software.id_licenza = licenze.id
		LEFT JOIN software ON software.id = licenze_software.id_software
		LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto
		LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
			AND contratti_anagrafica.id_ruolo IN ( SELECT id FROM ruoli_anagrafica WHERE se_contraente = 1 )
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( licenze.id_anagrafica, contratti_anagrafica.id_anagrafica )
		LEFT JOIN anagrafica AS a2 ON a2.id = licenze.id_rivenditore
	GROUP BY licenze.id
;

-- | FINE

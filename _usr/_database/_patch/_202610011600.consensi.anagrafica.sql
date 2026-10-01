-- 2026-10-01 — un solo posto per i consensi di un'anagrafica: anagrafica_consensi
--
-- COSA SI VEDEVA. I consensi di un'anagrafica stavano in due tabelle gemelle: anagrafica_consensi, che scrivono la
-- registrazione ( _mod/_0350.registrazione ) e la newsletter ( _mod/_ML000.mailing ), e consensi_anagrafica, che
-- scriveva associazioneConsensiContatto() per l'utente collegato e che mostrava la linguetta privacy della scheda
-- anagrafica. Un consenso tolto da quella linguetta non arrivava a chi legge anagrafica_consensi: la newsletter
-- continuava a partire.
--
-- COSA FA. Resta anagrafica_consensi, che ha il nome del canone del database ( tabella principale, poi tabella
-- secondaria ). Le righe di consensi_anagrafica ci vengono copiate, una per anagrafica e consenso: vince la piu'
-- recente fra quella gia' presente e quella copiata, e nelle note finisce la storia per modulo che
-- consensi_anagrafica teneva su piu' righe. Poi consensi_anagrafica e la sua vista si tolgono.
--
-- IDEMPOTENTE. La tabella si ricrea vuota se manca, cosi' la copia non fallisce su un deploy che l'ha gia' tolta; la
-- copia aggiorna una riga solo se quella copiata e' piu' recente; le DROP sono IF EXISTS.

-- | 202610011600

CREATE TABLE IF NOT EXISTS `consensi_anagrafica` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_consenso` bigint(20) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `modulo` char(32) DEFAULT NULL,
  `valore` int(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610011601

INSERT INTO `anagrafica_consensi` ( id_anagrafica, id_consenso, se_prestato, note, timestamp_consenso, id_account_inserimento, timestamp_inserimento )
	SELECT
		ca.id_anagrafica,
		ca.id_consenso,
		ca.valore,
		concat( 'da consensi_anagrafica: ', (
			SELECT group_concat(
				concat( 'modulo ', coalesce( storia.modulo, '-' ), ' ', if( storia.valore, 'prestato', 'non prestato' ),
					coalesce( concat( ' il ', from_unixtime( coalesce( storia.timestamp_aggiornamento, storia.timestamp_inserimento ), '%d/%m/%Y %H:%i' ) ), '' ) )
				ORDER BY coalesce( storia.timestamp_aggiornamento, storia.timestamp_inserimento, 0 ), storia.id SEPARATOR '; ' )
			FROM consensi_anagrafica AS storia
			WHERE storia.id_anagrafica = ca.id_anagrafica AND storia.id_consenso = ca.id_consenso
		) ),
		coalesce( ca.timestamp_aggiornamento, ca.timestamp_inserimento ),
		ca.id_account_inserimento,
		coalesce( ca.timestamp_inserimento, unix_timestamp() )
	FROM consensi_anagrafica AS ca
		INNER JOIN anagrafica ON anagrafica.id = ca.id_anagrafica
		INNER JOIN consensi ON consensi.id = ca.id_consenso
	WHERE NOT EXISTS (
		SELECT piu_recente.id FROM consensi_anagrafica AS piu_recente
		WHERE piu_recente.id_anagrafica = ca.id_anagrafica AND piu_recente.id_consenso = ca.id_consenso
		AND (
			coalesce( piu_recente.timestamp_aggiornamento, piu_recente.timestamp_inserimento, 0 ) > coalesce( ca.timestamp_aggiornamento, ca.timestamp_inserimento, 0 )
			OR ( coalesce( piu_recente.timestamp_aggiornamento, piu_recente.timestamp_inserimento, 0 ) = coalesce( ca.timestamp_aggiornamento, ca.timestamp_inserimento, 0 ) AND piu_recente.id > ca.id )
		)
	)
ON DUPLICATE KEY UPDATE
	-- timestamp_consenso si aggiorna per ultimo: le assegnazioni prima vedono ancora quello della riga presente
	se_prestato = if( coalesce( VALUES( timestamp_consenso ), 0 ) > coalesce( anagrafica_consensi.timestamp_consenso, anagrafica_consensi.timestamp_aggiornamento, anagrafica_consensi.timestamp_inserimento, 0 ), VALUES( se_prestato ), anagrafica_consensi.se_prestato ),
	note = concat_ws( ' / ', anagrafica_consensi.note, VALUES( note ) ),
	timestamp_consenso = if( coalesce( VALUES( timestamp_consenso ), 0 ) > coalesce( anagrafica_consensi.timestamp_consenso, anagrafica_consensi.timestamp_aggiornamento, anagrafica_consensi.timestamp_inserimento, 0 ), VALUES( timestamp_consenso ), anagrafica_consensi.timestamp_consenso );

-- | 202610011602

DROP VIEW IF EXISTS `consensi_anagrafica_view`;

-- | 202610011603

DROP TABLE IF EXISTS `consensi_anagrafica`;

-- | FINE FILE

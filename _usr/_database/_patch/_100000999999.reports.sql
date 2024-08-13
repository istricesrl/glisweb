--
-- REPORT
-- questo file contiene le query per la creazione dei report
--



-- | 100000000014
-- __report_abbonamenti_attivi__
-- tipologia: report
DROP TABLE IF EXISTS `__report_abbonamenti_attivi__`;

-- | 100000000015
-- __report_abbonamenti_attivi__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_abbonamenti_attivi__` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        tipologie_contratti.nome AS tipologia,
		group_concat( DISTINCT coalesce( istituto.denominazione , concat( istituto.cognome, ' ', istituto.nome ), '' )  SEPARATOR ', ' ) AS istituti,
		group_concat( DISTINCT coalesce( iscritto.id, '' )  SEPARATOR ', ' ) AS id_iscritti,
		group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ) AS iscritti,
		contratti.id_progetto,
		progetti.nome AS progetto,
		contratti.codice,
		contratti.nome,
        max(rinnovi.data_inizio) AS data_inizio,
        max(rinnovi.data_fine) AS data_fine,
		contratti.id_account_inserimento,
		contratti.id_account_aggiornamento,
		concat(
			group_concat( DISTINCT coalesce( iscritto.denominazione , concat( iscritto.cognome, ' ', iscritto.nome ), '' )  SEPARATOR ', ' ), ' ',
			coalesce( contratti.nome, '' ), ' ', tipologie_contratti.nome, ' dal ',
			max(rinnovi.data_inizio), ' al ', max(rinnovi.data_fine) ) AS __label__
	FROM contratti
        INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
		LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id AND contratti_anagrafica.id_ruolo = 30
		LEFT JOIN anagrafica AS istituto ON istituto.id = contratti_anagrafica.id_anagrafica 
		LEFT JOIN contratti_anagrafica AS c_a ON c_a.id_contratto = contratti.id AND c_a.id_ruolo IN ( 29, 34 )
		LEFT JOIN anagrafica AS iscritto ON iscritto.id = c_a.id_anagrafica
        LEFT JOIN progetti ON progetti.id = contratti.id_progetto
    WHERE tipologie_contratti.se_abbonamento = 1
    AND rinnovi.data_inizio <= now()
    AND rinnovi.data_fine >= now()
    GROUP BY contratti.id
;

-- | 100000001860
-- __report_ore_operatori__
-- tipologia: report
DROP TABLE IF EXISTS `__report_ore_operatori__`;

-- | 100000001861

CREATE TABLE `__report_ore_operatori__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_anagrafica` int(11) NOT NULL,
  `ore_contratto` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_anagrafica` (`id_anagrafica`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 100000001862
-- __report_ore_progetti_tipologie_mastri__
-- tipologia: report
DROP TABLE IF EXISTS `__report_ore_progetti_tipologie_mastri__`;

-- | 100000001863

CREATE TABLE `__report_ore_progetti_tipologie_mastri__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mese` int(11) NOT NULL,
  `anno` int(11) NOT NULL,
  `id_job` int(11) DEFAULT NULL,
  `id_progetto` char(32) NOT NULL,
  `id_tipologia_attivita` int(11) DEFAULT NULL,
  `id_mastro` int(11) DEFAULT NULL,
  `ore_previste` decimal(5,2) DEFAULT NULL,
  `ore_fatte` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mese` (`mese`),
  KEY `anno` (`anno`),
  KEY `id_progetto` (`id_progetto`),
  KEY `id_job` (`id_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 100000003100

-- __report_documenti_carrelli__

CREATE OR REPLACE VIEW `__report_documenti_carrelli__` AS
SELECT
carrelli_articoli.id,
carrelli_articoli.id_carrello,
articoli.id_prodotto,
carrelli_articoli.id_articolo,
carrelli_articoli.id_rinnovo,
tipologie_contratti.nome AS tipologia_contratto,
carrelli_articoli.destinatario_id_anagrafica,
concat_ws( ' ', a1.nome, a1.cognome ) AS anagrafica,
carrelli_articoli.prezzo_lordo_finale,
coalesce( sum( p1.importo_lordo_finale ), 0.0 ) AS pagato,
coalesce( sum( p2.importo_lordo_finale ), 0.0 ) AS rateizzato,
coalesce( sum( p3.importo_lordo_finale ), 0.0 ) AS scaduto,
(
    carrelli_articoli.prezzo_lordo_finale
    -
    (
        coalesce( sum( p1.importo_lordo_finale ), 0.0 )
        +
        coalesce( sum( p2.importo_lordo_finale ), 0.0 )
    )
) AS sospeso,
from_unixtime( carrelli.timestamp_checkout, "%Y-%m-%d" ) AS data_acquisto
FROM carrelli_articoli
INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello
INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
INNER JOIN anagrafica AS a1 ON a1.id = carrelli_articoli.destinatario_id_anagrafica
LEFT JOIN pagamenti AS p1 ON p1.id_carrelli_articoli = carrelli_articoli.id AND p1.timestamp_pagamento IS NOT NULL
LEFT JOIN pagamenti AS p2 ON p2.id_carrelli_articoli = carrelli_articoli.id AND p2.timestamp_pagamento IS NULL AND p2.data_scadenza >= date_format( now(), '%Y-%m-%d' )
LEFT JOIN pagamenti AS p3 ON p3.id_carrelli_articoli = carrelli_articoli.id AND p3.timestamp_pagamento IS NULL AND p3.data_scadenza < date_format( now(), '%Y-%m-%d' )
LEFT JOIN rinnovi ON rinnovi.id = carrelli_articoli.id_rinnovo
LEFT JOIN contratti ON contratti.id = rinnovi.id_contratto
LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
WHERE carrelli.timestamp_checkout IS NOT NULL
GROUP BY carrelli_articoli.id
ORDER BY carrelli_articoli.id ASC, carrelli_articoli.id_carrello ASC
;

-- NOTA la colonna scaduto è sbagliata, trasformare questo report in una tabella e fare i calcoli nel task di popolazione
-- occhio che le cose che possono innescare il ricalcolo sono parecchie, vedi quello che abbiamo dovuto fare per l'anagrafica con le categorie

-- | 100000007200
-- __report_status_contratti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_status_contratti__`;

-- | 100000007201
CREATE OR REPLACE VIEW `__report_status_contratti__` AS
  SELECT
    progetti.id,
    progetti.nome,
    tipologie_progetti_path( progetti.id_tipologia ) AS tipologia,
    coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    count( DISTINCT td1.id ) AS backlog,
    count( DISTINCT td2.id ) AS sprint,
    count( DISTINCT td3.id ) AS fatto,
    coalesce( sum( at1.ore ), 0 ) AS ore_fatte,
    coalesce( m1.testo, '-' ) AS ore_mese,
    coalesce( ( m1.testo - sum( at1.ore ) ), m1.testo, '-' ) AS ore_residue
  FROM progetti
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = progetti.id AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = progetti.id AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND td2.data_chiusura IS NULL )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = progetti.id AND td3.data_chiusura IS NOT NULL )
    LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
    LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
    LEFT JOIN attivita AS at1 ON (
      at1.id_progetto = progetti.id
      AND
      at1.data_attivita BETWEEN
        DATE_SUB( LAST_DAY( NOW() ), INTERVAL DAY( LAST_DAY( NOW() ) ) - 1 DAY )
        AND
        last_day( now() )
    )
    LEFT JOIN metadati AS m1 ON ( m1.id_progetto = progetti.id AND m1.nome = 'contratto|monte_ore' )
  WHERE
    ( tipologie_progetti.se_contratto IS NOT NULL )
    AND
    progetti.data_accettazione IS NOT NULL
    AND
    ( progetti.data_chiusura IS NULL
    AND
    progetti.data_archiviazione IS NULL )
  GROUP BY progetti.id
;

-- | 100000007800
-- __report_corsi__
-- tipologia: report
DROP TABLE IF EXISTS `__report_corsi__`;

-- | 100000007801

CREATE TABLE `__report_corsi__` (
  `id` char(255) NOT NULL,
  `id_periodo` int(11) DEFAULT NULL,
  `tipologia` char(255) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `fasce` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `livelli` char(255) DEFAULT NULL,
  `giorni_orari_luoghi` text DEFAULT NULL,
  `posti_disponibili` char(255) DEFAULT NULL,
  `lista_attesa` char(255) DEFAULT NULL,
  `stato` char(255) DEFAULT NULL,
  `data_accettazione` date DEFAULT NULL,
  `data_chiusura` date DEFAULT NULL,
  `prezzi` char(255) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `timestamp_inserimento` (`timestamp_inserimento`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 100000008005

-- __report_utilizzi_coupon__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_utilizzi_coupon__` AS
    SELECT
        coupon.id,
        'carrelli' AS tipo,
        concat ( 'carrello #', carrelli.id ) AS riferimento,
        from_unixtime( carrelli.timestamp_pagamento, "%Y-%m-%d" ) AS data_pagamento,
        carrelli_articoli.id AS id_carrelli_articoli,
        NULL AS id_pagamento,
        coalesce( carrelli_articoli.prezzo_lordo_totale, 0 ) AS importo_lordo_totale,
        coalesce( carrelli_articoli.coupon_valore, 0 ) AS coupon_valore,
        coalesce( carrelli_articoli.prezzo_lordo_finale, 0 ) AS importo_lordo_finale
    FROM coupon
        INNER JOIN carrelli_articoli ON carrelli_articoli.id_coupon = coupon.id
        INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello

    UNION

    SELECT
        coupon.id,
        'pagamenti' AS tipo,
        concat ( 'documento n. ', documenti.numero, '/', documenti.sezionale, ' del ', documenti.data ) AS riferimento,
        from_unixtime( pagamenti.timestamp_pagamento, "%Y-%m-%d" ) AS data_pagamento,
        NULL AS id_carrelli_articoli,
        pagamenti.id AS id_pagamento,
        coalesce( pagamenti.importo_lordo_totale, 0 ) AS importo_lordo_totale,
        coalesce( pagamenti.coupon_valore, 0 ) AS coupon_valore,
        coalesce( pagamenti.importo_lordo_finale, 0 ) AS importo_lordo_finale
    FROM coupon
        INNER JOIN pagamenti ON pagamenti.id_coupon = coupon.id
        INNER JOIN documenti ON documenti.id = pagamenti.id_documento 
;

-- | 100000009870
-- __report_evasione_ordini__
-- tipologia: report
DROP TABLE IF EXISTS `__report_evasione_ordini__`;

-- | 100000009871


CREATE OR REPLACE VIEW `__report_evasione_ordini__` AS

WITH a AS (
   SELECT id_documento, id_tipologia,
          row_number() OVER (PARTITION BY id_documento
                           ORDER BY data_attivita DESC
                      ) AS `rank`
     FROM attivita
)

SELECT documenti.data, anagrafica.codice, concat_ws( ' ', anagrafica.nome, anagrafica.cognome, anagrafica.denominazione ) AS cliente, coalesce( tipologie_attivita.nome, 'ancora da iniziare' ) AS stato FROM documenti
INNER JOIN anagrafica ON anagrafica.id = documenti.id_destinatario
LEFT JOIN a ON a.id_documento = documenti.id AND a.rank = 1
LEFT JOIN tipologie_attivita ON tipologie_attivita.id = a.id_tipologia
WHERE documenti.id_tipologia = 4
GROUP BY documenti.id
;

-- | 100000009872
-- __report_dettaglio_evasione_ordini__
-- tipologia: report
DROP TABLE IF EXISTS `__report_dettaglio_evasione_ordini__`;

-- | 100000009873


CREATE OR REPLACE VIEW `__report_dettaglio_evasione_ordini__` AS
SELECT
  ordine.id_documento,
  ordine.id_ordine,
  ordine.codice_prodotto,
  ordine.prodotto,
  sum( ( ordine.quantita_ordinata / udm.conversione ) ) AS quantita_ordinata,
  sum( ( ordine.quantita_evasa / udm.conversione ) ) AS quantita_evasa,
  (
    sum( ( ordine.quantita_ordinata / udm.conversione ) )
    -
    sum( ( ordine.quantita_evasa / udm.conversione ) )
  ) AS quantita_da_evadere,
  udm.sigla AS udm
FROM (
  SELECT
    relazioni_documenti.id_documento,
    documenti.id AS id_ordine,
    coalesce(
      documenti_articoli.id_prodotto,
      articoli.id_prodotto
    ) AS codice_prodotto,
    prodotti.nome AS prodotto,
    documenti_articoli.id_articolo AS codice_articolo,
    coalesce( ( documenti_articoli.quantita * udm.conversione ), 0 ) AS quantita_ordinata,
    0 AS quantita_evasa,
    udm_base.sigla AS udm_base,
    udm.id AS id_udm
  FROM documenti
  LEFT JOIN relazioni_documenti ON relazioni_documenti.id_documento_collegato = documenti.id
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = coalesce( documenti_articoli.id_prodotto, articoli.id_prodotto )
  LEFT JOIN udm ON udm.id = documenti_articoli.id_udm
  LEFT JOIN udm AS udm_base ON udm_base.id = udm.id_base
  WHERE tipologie_documenti.se_ordine IS NOT NULL
  HAVING codice_prodotto IS NOT NULL
  UNION
  SELECT
    relazioni_documenti.id_documento,
    relazioni_documenti.id_documento_collegato AS id_ordine,
    coalesce(
      documenti_articoli.id_prodotto,
      articoli.id_prodotto
    ) AS codice_prodotto,
    prodotti.nome AS prodotto,
    documenti_articoli.id_articolo AS codice_articolo,
    0 AS quantita_ordinata,
    coalesce( ( articoli.peso * udm.conversione * documenti_articoli.quantita ), 0 ) AS quantita_evasa,
    udm_base.sigla AS udm_base,
    udm.id AS id_udm
  FROM documenti
  INNER JOIN relazioni_documenti ON id_documento = documenti.id
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = coalesce( documenti_articoli.id_prodotto, articoli.id_prodotto )
  LEFT JOIN udm ON udm.id = articoli.id_udm_peso
  LEFT JOIN udm AS udm_base ON udm_base.id = udm.id_base
  WHERE tipologie_documenti.se_trasporto IS NOT NULL
  HAVING codice_prodotto IS NOT NULL
) AS ordine
LEFT JOIN udm ON udm.id = (
  SELECT coalesce( max( documenti_articoli.id_udm ), max( articoli.id_udm_peso ) )
  FROM documenti_articoli LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  WHERE documenti_articoli.id_documento IN ( ordine.id_documento, ordine.id_ordine )
  AND ( documenti_articoli.id_prodotto = ordine.codice_prodotto OR articoli.id = ordine.codice_articolo )
)
GROUP BY id_documento, id_ordine, codice_prodotto, prodotto, conversione, udm;




-- | 100000015000
-- __report_giacenza_crediti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_crediti__`;

-- | 100000015001
CREATE OR REPLACE VIEW `__report_giacenza_crediti__` AS
SELECT
  movimenti.id,
  movimenti.id_account,
  movimenti.account,
  movimenti.nome,
  sum( movimenti.carico ) AS carico,
  sum( movimenti.scarico ) AS scarico,
  coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ) AS totale_float,
  format( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ) AS totale,
  concat_ws(
      ' ',
      movimenti.nome ,
      'giacenza',
      FORMAT( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ),
      'pz'
		) AS __label__
FROM (
SELECT
  mastri.id,
  mastri.id_account,
  account.username AS account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN account ON account.id = mastri.id_account
WHERE crediti.quantita IS NOT NULL
UNION ALL
SELECT
  mastri.id,
  mastri.id_account,
  account.username AS account,
  mastri_path( mastri.id ) AS nome,
  crediti.data,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN account ON account.id = mastri.id_account
WHERE crediti.quantita IS NOT NULL
) AS movimenti
GROUP BY movimenti.id, movimenti.id_account, movimenti.account, movimenti.nome;

-- | 100000015010
-- __report_giacenza_ore__
-- tipologia: report
DROP VIEW IF EXISTS `__report_giacenza_ore__`;

-- | 100000015011
CREATE OR REPLACE VIEW `__report_giacenza_ore__` AS
  SELECT report.*,
      count( DISTINCT td1.id ) AS backlog,
      count( DISTINCT td2.id ) AS sprint,
      count( DISTINCT td3.id ) AS fatto
  FROM (
    SELECT
      movimenti.id,
      movimenti.id_progetto,
      movimenti.progetto,
      movimenti.nome,
      sum( movimenti.carico ) AS carico,
      sum( movimenti.scarico ) AS scarico,
      coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ) AS totale_float,
      format( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ) AS totale,
      concat_ws(
          ' ',
          movimenti.nome ,
          'giacenza',
          FORMAT( coalesce( ( sum( movimenti.carico ) - sum( movimenti.scarico ) ), 0 ), 2, 'es_ES' ),
          'h'
        ) AS __label__
    FROM (
      SELECT
        mastri.id,
        mastri.id_progetto,
        progetti.nome AS progetto,
        mastri_path( mastri.id ) AS nome,
        attivita.data_attivita AS data,
        coalesce( attivita.ore, 0 ) AS carico,
        0 AS scarico
      FROM mastri
        LEFT JOIN attivita ON attivita.id_mastro_destinazione = mastri.id OR mastri_path_check( attivita.id_mastro_destinazione, mastri.id ) = 1
        LEFT JOIN progetti ON progetti.id = mastri.id_progetto
      WHERE attivita.ore IS NOT NULL
      UNION ALL
      SELECT
        mastri.id,
        mastri.id_progetto,
        progetti.nome AS progetto,
        mastri_path( mastri.id ) AS nome,
        attivita.data_attivita AS data,
        0 AS carico,
        coalesce( attivita.ore, 0 ) AS scarico
      FROM mastri
        LEFT JOIN attivita ON attivita.id_mastro_provenienza = mastri.id OR mastri_path_check( attivita.id_mastro_provenienza, mastri.id ) = 1
        LEFT JOIN progetti ON progetti.id = mastri.id_progetto
      WHERE attivita.ore IS NOT NULL
    ) AS movimenti
    GROUP BY movimenti.id, movimenti.id_progetto, movimenti.progetto, movimenti.nome
  ) AS report
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = report.id_progetto AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL AND td1.data_archiviazione IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = report.id_progetto AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND ( td2.data_chiusura IS NULL AND td2.data_archiviazione IS NULL ) )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = report.id_progetto AND td3.data_chiusura IS NOT NULL )
  GROUP BY report.id, report.id_progetto, report.progetto, report.nome
;
-- | 100000020000
-- __report_giacenza_magazzini__
-- tipologia: report
DROP TABLE IF EXISTS `__report_giacenza_magazzini__`;

-- | 100000020001
-- __report_giacenza_magazzini__
-- tipologia: report
CREATE TABLE `__report_giacenza_magazzini__` (
  `id` varchar(56) NOT NULL,
  `id_mastro` int(11) DEFAULT NULL,
  `nome` text DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `articolo` varchar(331) DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `prodotto` char(128) DEFAULT NULL,
  `codice_produttore` char(64) DEFAULT NULL,
  `categorie` text DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `matricola` char(128) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `carico` decimal(21,2) DEFAULT NULL,
  `scarico` decimal(21,2) DEFAULT NULL,
  `totale_proprio` decimal(21,2) DEFAULT NULL,
  `totale_figli` decimal(21,2) DEFAULT NULL,
  `totale` decimal(21,2) DEFAULT NULL,
  `peso` decimal(21,2) DEFAULT NULL,
  `sigla_udm_peso` char(8) DEFAULT NULL,
  `se_foglia` int(1) DEFAULT NULL,
  `note_aggiornamento` text NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`(1024)),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_prodotto` (`id_prodotto`),
  KEY `id_matricola` (`id_matricola`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 100000020500

-- __report_immagini_da_scalare__
-- tipologia: report
DROP TABLE IF EXISTS `__report_immagini_da_scalare__`;

-- | 100000020501
-- __report_immagini_da_scalare__
-- tipologia: report
CREATE OR REPLACE VIEW __report_immagini_da_scalare__ AS
	SELECT immagini.* FROM immagini
	INNER JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo
	WHERE ( immagini.timestamp_scalamento IS NULL OR immagini.timestamp_scalamento < immagini.timestamp_aggiornamento OR immagini.timestamp_aggiornamento IS NULL )
	ORDER BY immagini.timestamp_scalamento ASC, ruoli_immagini.ordine_scalamento ASC, immagini.ordine ASC
;

-- | 100000020550

-- __report_immagini_scalate__
-- tipologia: report
DROP TABLE IF EXISTS `__report_immagini_scalate__`;

-- | 100000020551

-- __report_immagini_scalate__
-- tipologia: report
CREATE OR REPLACE VIEW __report_immagini_scalate__ AS
SELECT
	sum(
	if( 
		( timestamp_scalamento IS NOT NULL OR timestamp_scalamento >= timestamp_aggiornamento )
		AND timestamp_aggiornamento IS NOT NULL, 1, 0) 
	) AS scalate,
	sum(
	if(
		timestamp_scalamento IS NULL OR timestamp_scalamento < timestamp_aggiornamento OR timestamp_aggiornamento IS NULL, 1, 0)
	) AS da_scalare,
	count(
		immagini.id
	) AS totali
FROM
	immagini
;

-- | 100000020700

-- __report_iscritti_corsi__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_iscritti_corsi__` AS
  SELECT
    anagrafica.id AS id_anagrafica,
    coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
    contratti.id_progetto,
    rinnovi.data_inizio,
    rinnovi.data_fine,
    rinnovi.id_contratto
  FROM anagrafica
  INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_anagrafica = anagrafica.id	
  INNER JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto 
  INNER JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
  INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
  INNER JOIN progetti ON progetti.id = contratti.id_progetto
  LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
  LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
  WHERE tipologie_contratti.se_iscrizione = 1
  AND categorie_anagrafica.se_gestita IS NULL
  UNION
  SELECT
    anagrafica.id AS id_anagrafica,
    coalesce(anagrafica.soprannome,anagrafica.denominazione, concat_ws(' ', coalesce(anagrafica.cognome, ''),coalesce(anagrafica.nome, '') ),'') AS anagrafica,
    relazioni_progetti.id_progetto_collegato AS id_progetto,
    rinnovi.data_inizio,
    rinnovi.data_fine,
    rinnovi.id_contratto
  FROM anagrafica
  INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_anagrafica = anagrafica.id	
  INNER JOIN contratti ON contratti.id = contratti_anagrafica.id_contratto 
  INNER JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
  INNER JOIN rinnovi ON rinnovi.id_contratto = contratti.id
  INNER JOIN relazioni_progetti ON relazioni_progetti.id_progetto = contratti.id_progetto
  INNER JOIN ruoli_progetti ON ruoli_progetti.id = relazioni_progetti.id_ruolo
  LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
  LEFT JOIN categorie_anagrafica ON categorie_anagrafica.id = anagrafica_categorie.id_categoria
  WHERE tipologie_contratti.se_iscrizione = 1
  AND ruoli_progetti.se_sottoprogetto = 1
  AND categorie_anagrafica.se_gestita IS NULL
;

-- | 100000020900
-- __report_movimenti_crediti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_movimenti_crediti__`;

-- | 100000020901
-- __report_movimenti_crediti__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_movimenti_crediti__` AS
SELECT
  id,
  nome,
  id_account,
  data,
  id_crediti,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_account,
  crediti.data,
  crediti.id AS id_crediti,
  coalesce( crediti.quantita, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_destinazione = mastri.id OR mastri_path_check( crediti.id_mastro_destinazione, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_account,
  crediti.data,
  crediti.id AS id_crediti,
  0 AS carico,
  coalesce( crediti.quantita, 0 ) AS scarico
FROM mastri
  LEFT JOIN crediti ON crediti.id_mastro_provenienza = mastri.id OR mastri_path_check( crediti.id_mastro_provenienza, mastri.id ) = 1
  WHERE crediti.quantita IS NOT NULL
) AS movimenti;

-- | 100000020910
-- __report_movimenti_ore__
-- tipologia: report
DROP VIEW IF EXISTS `__report_movimenti_ore__`;

-- | 100000020911
-- __report_movimenti_ore__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_movimenti_ore__` AS
SELECT
  id,
  nome,
  id_progetto,
  progetto,
  data,
  id_attivita,
  attivita,
  id_todo,
  todo,
  carico,
  scarico
FROM (
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_progetto,
  progetti.nome AS progetto,
  attivita.data_attivita AS data,
  attivita.id AS id_attivita,
  attivita.nome AS attivita,
  attivita.id_todo,
  todo.nome AS todo,
  coalesce( attivita.ore, 0 ) AS carico,
  0 AS scarico
FROM mastri
  LEFT JOIN attivita ON attivita.id_mastro_destinazione = mastri.id OR mastri_path_check( attivita.id_mastro_destinazione, mastri.id ) = 1
  LEFT JOIN todo ON todo.id = attivita.id_todo
  LEFT JOIN progetti ON progetti.id = mastri.id_progetto
  WHERE attivita.ore IS NOT NULL
UNION
SELECT
  mastri.id,
  mastri.nome,
  mastri.id_progetto,
  progetti.nome AS progetto,
  attivita.data_attivita AS data,
  attivita.id AS id_attivita,
  attivita.nome AS attivita,
  attivita.id_todo,
  todo.nome AS todo,
  0 AS carico,
  coalesce( attivita.ore, 0 ) AS scarico
FROM mastri
  LEFT JOIN attivita ON attivita.id_mastro_provenienza = mastri.id OR mastri_path_check( attivita.id_mastro_provenienza, mastri.id ) = 1
  LEFT JOIN todo ON todo.id = attivita.id_todo
  LEFT JOIN progetti ON progetti.id = mastri.id_progetto
  WHERE attivita.ore IS NOT NULL
) AS movimenti;

-- | 100000021000
-- __report_movimenti_magazzini__
-- tipologia: report
DROP TABLE IF EXISTS `__report_movimenti_magazzini__`;

-- | 100000021001
-- __report_movimenti_magazzini__
-- tipologia: report
CREATE TABLE `__report_movimenti_magazzini__` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` mediumint(9) DEFAULT NULL,
  `categorie` mediumtext DEFAULT NULL,
  `id_prodotto` char(32) DEFAULT NULL,
  `prodotto` char(255) DEFAULT NULL,
  `codice_produttore` char(128) DEFAULT NULL,
  `id_articolo` char(32) DEFAULT NULL,
  `articolo` char(255) DEFAULT NULL,
  `id_matricola` int(11) DEFAULT NULL,
  `matricola` char(128) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(128) DEFAULT NULL,
  `id_documento` int(11) DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `numero` char(32) DEFAULT NULL,
  `sezionale` char(32) DEFAULT NULL,
  `emittente` char(255) DEFAULT NULL,
  `destinatario` char(255) DEFAULT NULL,
  `id_mastro_provenienza` int(11) DEFAULT NULL,
  `mastro_provenienza` char(255) DEFAULT NULL,
  `id_mastro_destinazione` int(11) DEFAULT NULL,
  `mastro_destinazione` char(255) DEFAULT NULL,
  `quantita` decimal(9,2) DEFAULT NULL,
  `quantita_movimento` decimal(16,2) DEFAULT NULL,
  `udm_movimento` char(32) DEFAULT NULL,
  `note_aggiornamento` text DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- | 100000022700
-- __report_evasione_ordini__
-- tipologia: report
DROP VIEW IF EXISTS `__report_evasione_ordini__`;

-- | 100000022701
-- __report_evasione_ordini__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_evasione_ordini__` AS
SELECT
  ordine.id_documento,
  ordine.id_ordine,
  ordine.codice_prodotto,
  ordine.prodotto,
  sum( ( ordine.quantita_ordinata / udm.conversione ) ) AS quantita_ordinata,
  sum( ( ordine.quantita_evasa / udm.conversione ) ) AS quantita_evasa,
  (
    sum( ( ordine.quantita_ordinata / udm.conversione ) )
    -
    sum( ( ordine.quantita_evasa / udm.conversione ) )
  ) AS quantita_da_evadere,
  udm.sigla AS udm
FROM (
  SELECT
    relazioni_documenti.id_documento,
    documenti.id AS id_ordine,
    coalesce(
      documenti_articoli.id_prodotto,
      articoli.id_prodotto
    ) AS codice_prodotto,
    prodotti.nome AS prodotto,
    documenti_articoli.id_articolo AS codice_articolo,
    coalesce( ( documenti_articoli.quantita * udm.conversione ), 0 ) AS quantita_ordinata,
    0 AS quantita_evasa,
    udm_base.sigla AS udm_base,
    udm.id AS id_udm
  FROM documenti
  LEFT JOIN relazioni_documenti ON relazioni_documenti.id_documento_collegato = documenti.id
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = coalesce( documenti_articoli.id_prodotto, articoli.id_prodotto )
  LEFT JOIN udm ON udm.id = documenti_articoli.id_udm
  LEFT JOIN udm AS udm_base ON udm_base.id = udm.id_base
  WHERE tipologie_documenti.se_ordine IS NOT NULL
  HAVING codice_prodotto IS NOT NULL
  UNION
  SELECT
    relazioni_documenti.id_documento,
    relazioni_documenti.id_documento_collegato AS id_ordine,
    coalesce(
      documenti_articoli.id_prodotto,
      articoli.id_prodotto
    ) AS codice_prodotto,
    prodotti.nome AS prodotto,
    documenti_articoli.id_articolo AS codice_articolo,
    0 AS quantita_ordinata,
    coalesce( ( articoli.peso * udm.conversione * documenti_articoli.quantita ), 0 ) AS quantita_evasa,
    udm_base.sigla AS udm_base,
    udm.id AS id_udm
  FROM documenti
  INNER JOIN relazioni_documenti ON id_documento = documenti.id
  LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
  LEFT JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id
  LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
  LEFT JOIN prodotti ON prodotti.id = coalesce( documenti_articoli.id_prodotto, articoli.id_prodotto )
  LEFT JOIN udm ON udm.id = articoli.id_udm_peso
  LEFT JOIN udm AS udm_base ON udm_base.id = udm.id_base
  WHERE tipologie_documenti.se_trasporto IS NOT NULL
  HAVING codice_prodotto IS NOT NULL
) AS ordine
LEFT JOIN udm ON udm.id = (
  SELECT coalesce( max( documenti_articoli.id_udm ), max( articoli.id_udm_peso ) )
  FROM documenti_articoli LEFT JOIN articoli ON articoli.id = ordine.codice_articolo
  WHERE documenti_articoli.id_documento IN ( ordine.id_documento, ordine.id_ordine )
  AND ( documenti_articoli.id_prodotto = ordine.codice_prodotto OR articoli.id = ordine.codice_articolo )
)
GROUP BY id_documento, id_ordine, codice_prodotto, prodotto, conversione, udm;

-- | 100000027000
-- __report_avanzamento_progetti__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_progetti__`;

-- | 100000027001
-- __report_avanzamento_progetti__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_progetti__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    count( DISTINCT td1.id ) AS backlog,
    count( DISTINCT td2.id ) AS sprint,
    count( DISTINCT td3.id ) AS fatto,
    coalesce( concat( round( ( count( DISTINCT td3.id ) ) / ( count( DISTINCT td1.id ) + count( DISTINCT td2.id ) + count( DISTINCT td3.id ) ), 2 ) * 100, '%' ), '-' ) AS completed,
    round( datediff( now(), progetti.data_accettazione ) / 7, 0 ) AS elapsed,
    coalesce( ( count( DISTINCT td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) AS speed,
    coalesce( date_add( now(), interval ( ( count( DISTINCT td1.id ) + count( DISTINCT td2.id ) ) / ( coalesce( ( count( DISTINCT td3.id ) ) / round( datediff( now(), progetti.data_accettazione ) / 7, 0 ), 0 ) ) ) week ), '-' ) AS eta
  FROM progetti
    LEFT JOIN todo AS td1 ON ( td1.id_progetto = progetti.id AND td1.data_programmazione IS NULL AND td1.settimana_programmazione IS NULL AND td1.data_chiusura IS NULL )
    LEFT JOIN todo AS td2 ON ( td2.id_progetto = progetti.id AND ( td2.data_programmazione IS NOT NULL OR td2.settimana_programmazione IS NOT NULL ) AND td2.data_chiusura IS NULL )
    LEFT JOIN todo AS td3 ON ( td3.id_progetto = progetti.id AND td3.data_chiusura IS NOT NULL )
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  WHERE
  	( tipologie_progetti.se_progetto IS NOT NULL OR tipologie_progetti.se_forfait IS NOT NULL )
    AND
    progetti.data_accettazione IS NOT NULL
    AND
    progetti.data_chiusura IS NULL
  GROUP BY progetti.id
;

-- | 100000027010
-- __report_avanzamento_trattative__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_trattative__`;

-- | 100000027011
-- __report_avanzamento_trattative__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_trattative__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( coalesce( progetti.entrate_previste, 0 ) - coalesce( progetti.costi_previsti, 0 ) ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id
;

-- | 100000027012
-- __report_avanzamento_trattative_attive__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_trattative_attive__`;

-- | 100000027013
-- __report_avanzamento_trattative_attive__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_trattative_attive__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( coalesce( progetti.entrate_previste, 0 ) - coalesce( progetti.costi_previsti, 0 ) ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id
	HAVING ( min( at2.data_programmazione ) IS NULL OR min( at2.data_programmazione ) <= CURRENT_DATE() )
;

-- | 100000027014
-- __report_avanzamento_trattative_gestite__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_trattative_gestite__`;

-- | 100000027015
-- __report_avanzamento_trattative_gestite__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_trattative_gestite__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( coalesce( progetti.entrate_previste, 0 ) - coalesce( progetti.costi_previsti, 0 ) ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NULL
		AND progetti.data_chiusura IS NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id
	HAVING ( min( at2.data_programmazione ) IS NOT NULL AND min( at2.data_programmazione ) > CURRENT_DATE() )
;

-- | 100000027016
-- __report_avanzamento_amministrazione__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_amministrazione__`;

-- | 100000027017
-- __report_avanzamento_amministrazione__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_amministrazione__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( coalesce( progetti.entrate_previste, 0 ) - coalesce( progetti.costi_previsti, 0 ) ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id
;

-- | 100000027018
-- __report_avanzamento_amministrazione_attiva__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_amministrazione_attiva__`;

-- | 100000027019
-- __report_avanzamento_amministrazione_attiva__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_amministrazione_attiva__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( coalesce( progetti.entrate_previste, 0 ) - coalesce( progetti.costi_previsti, 0 ) ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id
	HAVING ( min( at2.data_programmazione ) IS NULL OR min( at2.data_programmazione ) <= CURRENT_DATE() )
;

-- | 100000027020
-- __report_avanzamento_amministrazione_gestita__
-- tipologia: report
DROP VIEW IF EXISTS `__report_avanzamento_amministrazione_gestita__`;

-- | 100000027021
-- __report_avanzamento_amministrazione_gestita__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_avanzamento_amministrazione_gestita__` AS
  SELECT
    progetti.id,
    progetti.nome,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS account,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
    progetti.entrate_previste,
    progetti.costi_previsti,
    progetti.ore_previste,
    ( coalesce( progetti.entrate_previste, 0 ) - coalesce( progetti.costi_previsti, 0 ) ) AS margine_previsto,
    coalesce( max( at1.data_attivita ), '-' ) AS data_ultima_attivita,
    coalesce( min( at2.data_programmazione ), '-' ) AS data_prossima_attivita
  FROM progetti
	LEFT JOIN anagrafica AS a2 ON a2.id = progetti.id_cliente
	LEFT JOIN anagrafica AS a1 ON a1.id = a2.id_agente
	LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  LEFT JOIN attivita AS at1 ON ( at1.id_progetto = progetti.id AND at1.data_attivita IS NOT NULL )
  LEFT JOIN attivita AS at2 ON ( at2.id_progetto = progetti.id AND at2.data_attivita IS NULL AND at2.data_programmazione IS NOT NULL )
	WHERE progetti.data_accettazione IS NOT NULL
		AND progetti.data_chiusura IS NOT NULL
		AND progetti.data_archiviazione IS NULL
  GROUP BY progetti.id
	HAVING ( min( at2.data_programmazione ) IS NOT NULL AND min( at2.data_programmazione ) > CURRENT_DATE() )
;

-- | 100000031510
-- __report_tesseramenti_anagrafica__
-- tipologia: report
DROP VIEW IF EXISTS `__report_tesseramenti_anagrafica__`;

-- | 100000031511
-- __report_tesseramenti_anagrafica__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_tesseramenti_anagrafica__` AS
	SELECT
		contratti.id,
		contratti.id_tipologia,
        contratti_anagrafica.id_anagrafica,
		tipologie_contratti.nome AS tipologia,
		tipologie_contratti.se_abbonamento,
		tipologie_contratti.se_iscrizione,
		tipologie_contratti.se_tesseramento,
		tipologie_contratti.se_immobili,
		tipologie_contratti.se_acquisto,
		tipologie_contratti.se_locazione,
		rinnovi.id AS id_rinnovo,
		rinnovi.id_tipologia AS id_tipologia_rinnovo,
		tipologie_rinnovi.nome AS tipologia_rinnovo,
		contratti.id AS id_contratto,
		contratti.nome AS contratto,
		contratti.codice AS tessera,
		rinnovi.id_licenza,
		licenze.nome AS licenza,
		rinnovi.id_progetto,
		progetti.nome AS progetto,
		rinnovi.data_inizio,
		rinnovi.data_fine,
		rinnovi.codice,
		rinnovi.id_pianificazione,
		rinnovi.id_account_inserimento,
		rinnovi.id_account_aggiornamento,
		concat('rinnovo ', rinnovi.id, ' dal ',CONCAT_WS('-',rinnovi.data_inizio),' al ',CONCAT_WS('-',rinnovi.data_fine)) AS __label__
	FROM contratti
		LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id 
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
    LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
    LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
		LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza 
		LEFT JOIN progetti ON progetti.id = rinnovi.id_progetto
  WHERE tipologie_contratti.se_tesseramento IS NOT NULL
;

-- | 100000056610
-- __report_backlog_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_backlog_todo__`;

-- | 100000056611
-- __report_backlog_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_backlog_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		progetti.nome AS progetto,    
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
  WHERE ( todo.data_chiusura IS NULL AND todo.data_archiviazione IS NULL )
    AND coalesce( todo.data_programmazione, todo.settimana_programmazione ) IS NULL
    AND tipologie_todo.se_produzione IS NOT NULL
;

-- | 100000056612
-- __report_sprint_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_sprint_todo__`;

-- | 100000056613
-- __report_sprint_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_sprint_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		progetti.nome AS progetto,
    tipologie_progetti.id AS id_tipologia_progetto,
    tipologie_progetti.nome AS tipologia_progetto,
    tipologie_progetti.se_pacchetto,
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
    LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia
  WHERE ( todo.data_chiusura IS NULL AND todo.data_archiviazione IS NULL )
    AND (
      (
        date_format( todo.data_programmazione, '%Y' ) = date_format( now(), '%Y' )
        AND
        date_format( todo.data_programmazione, '%u' ) <= date_format( now(), '%u' )
      )
      OR
      (
        date_format( todo.data_programmazione, '%Y' ) < date_format( now(), '%Y' )
      )
      OR
      (
        todo.anno_programmazione = date_format( now(), '%Y' )
        AND
        todo.settimana_programmazione <= date_format( now(), '%u' )
      )
      OR
      (
        todo.anno_programmazione < date_format( now(), '%Y' )
      )
    )
    AND tipologie_todo.se_produzione IS NOT NULL
;

-- | 100000056614
-- __report_planned_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_planned_todo__`;

-- | 100000056615
-- __report_planned_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_planned_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		progetti.nome AS progetto,    
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
  WHERE ( todo.data_chiusura IS NULL AND todo.data_archiviazione IS NULL )
    AND (
      (
        date_format( todo.data_programmazione, '%Y' ) = date_format( now(), '%Y' )
        AND
        date_format( todo.data_programmazione, '%u' ) > date_format( now(), '%u' )
      )
      OR
      (
        date_format( todo.data_programmazione, '%Y' ) > date_format( now(), '%Y' )
      )
      OR
      (
        todo.anno_programmazione = date_format( now(), '%Y' )
        AND
        todo.settimana_programmazione > date_format( now(), '%u' )
      )
      OR
      (
        todo.anno_programmazione > date_format( now(), '%Y' )
      )
    )
    AND tipologie_todo.se_produzione IS NOT NULL
;

-- | 100000056618
-- __report_done_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_done_todo__`;

-- | 100000056619
-- __report_done_todo__
-- tipologia: report
-- NOTA: questo report è ancora da documentare
CREATE OR REPLACE VIEW `__report_done_todo__` AS
	SELECT
		todo.id,
		todo.id_tipologia,
		tipologie_todo.nome AS tipologia,
		tipologie_todo.se_agenda,
		todo.id_anagrafica,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS anagrafica,
		todo.id_cliente,
		coalesce( a2.denominazione, concat( a2.cognome, ' ', a2.nome ), '' ) AS cliente,
		todo.id_indirizzo,
		concat_ws(
			' ',
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS indirizzo,
		todo.id_luogo,
		luoghi_path( todo.id_luogo ) AS luogo,
		todo.data_scadenza,
		todo.ora_scadenza,
		todo.data_programmazione,
		todo.ora_inizio_programmazione,
		todo.ora_fine_programmazione,
		todo.anno_programmazione,
		todo.settimana_programmazione,
		todo.ore_programmazione,
		todo.data_chiusura,
		todo.nome,
		todo.id_contatto,
		todo.id_progetto,
		progetti.nome AS progetto,    
		todo.id_pianificazione,
		todo.id_immobile,
		todo.data_archiviazione,
		todo.id_account_inserimento,
		todo.id_account_aggiornamento,
		concat(
			todo.nome,
			coalesce( concat( ' per ', a2.denominazione, concat( a2.cognome, ' ', a2.nome ) ), '' ),
			coalesce( concat( ' su ', todo.id_progetto, ' ', progetti.nome ), '' )
		) AS __label__
	FROM todo
		LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
		LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
		LEFT JOIN indirizzi ON indirizzi.id = todo.id_indirizzo
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
		LEFT JOIN progetti ON progetti.id = todo.id_progetto
  WHERE ( todo.data_chiusura IS NOT NULL AND todo.data_archiviazione IS NULL )
    AND tipologie_todo.se_produzione IS NOT NULL
;

-- | 100000056620
-- __report_coda_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_coda_todo__`;

-- | 100000056621
-- __report_coda_todo__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_coda_todo__` AS
SELECT
andamento.anno,
andamento.settimana,
count( andamento.id_aperta ) AS aperte,
count( andamento.id_chiusa ) AS chiuse,

sum( count( andamento.id_aperta ) ) over( ORDER BY anno, settimana ) AS saldo_aperte,
sum( count( andamento.id_chiusa ) ) over( ORDER BY anno, settimana ) AS saldo_chiuse,

(
count( andamento.id_aperta )
-
count( andamento.id_chiusa )
) AS saldo_settimana,

(
sum( count( andamento.id_aperta ) ) over( ORDER BY anno, settimana )
-
sum( count( andamento.id_chiusa ) ) over( ORDER BY anno, settimana )
) AS saldo_totale

FROM (

SELECT 
todo.id AS id_aperta,
NULL AS id_chiusa,
date_format( from_unixtime( todo.timestamp_inserimento ), "%Y" ) AS anno,
date_format( from_unixtime( todo.timestamp_inserimento ), "%u" ) AS settimana
FROM todo 
WHERE timestamp_inserimento IS NOT NULL

UNION 

SELECT 
NULL AS id_aperta,
todo.id AS id_chiusa,
date_format( todo.data_chiusura, "%Y" ) AS anno,
date_format( todo.data_chiusura, "%u" ) AS settimana
FROM todo
WHERE data_chiusura IS NOT NULL

) AS andamento
GROUP BY andamento.anno, andamento.settimana
ORDER BY andamento.anno, andamento.settimana

;

-- | 100000056622
-- __report_pianificazione_todo__
-- tipologia: report
DROP VIEW IF EXISTS `__report_pianificazione_todo__`;

-- | 100000056623

-- __report_pianificazione_todo__
-- tipologia: report
CREATE OR REPLACE VIEW `__report_pianificazione_todo__` AS

SELECT

todo.id,
todo.nome,
todo.ore_programmazione AS previsione_todo,
sum( attivita.ore_programmazione ) AS previsione_attivita,
sum( attivita.ore ) AS consuntivo_attivita,

coalesce( sum( attivita.ore_programmazione ), todo.ore_programmazione, 0 ) - sum( attivita.ore ) AS errore_pianificazione

FROM todo
INNER JOIN attivita ON attivita.id_todo = todo.id

GROUP BY todo.id
ORDER BY todo.id

;
-- NOTA per avere le medie usare
-- SELECT
--  avg( previsione_todo ) AS previsione_media_todo,
--  avg( previsione_attivita ) AS previsione_media_todo_attivita,
--  avg( consuntivo_attivita ) AS consuntivo_attivita,
--  avg( errore_pianificazione ) AS errore_pianificazione
-- FROM __report_pianificazione_todo__

-- | 100000060300

-- __report_lezioni_corsi__
-- tipologia: report

CREATE TABLE `__report_lezioni_corsi__` (
  `id` char(255) NOT NULL,
  `id_tipologia` int(11) DEFAULT NULL,
  `tipologia` char(255) DEFAULT NULL,
  `codice` char(255) DEFAULT NULL,
  `se_agenda` int(1) DEFAULT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_indirizzo` int(11) DEFAULT NULL,
  `indirizzo` char(255) DEFAULT NULL,
  `id_luogo` int(11) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `docenti` char(255) DEFAULT NULL,
  `numero_alunni` int(11) DEFAULT NULL,
  `numero_posti` int(11) DEFAULT NULL,
  `numero_alunni_in_attesa` int(11) DEFAULT NULL,
  `timestamp_apertura` int(11) DEFAULT NULL,
  `data_scadenza` char(255) DEFAULT NULL,
  `ora_scadenza` char(255) DEFAULT NULL,
  `data_programmazione` char(255) DEFAULT NULL,
  `ora_inizio_programmazione` char(255) DEFAULT NULL,
  `ora_fine_programmazione` char(255) DEFAULT NULL,
  `anno_programmazione` char(255) DEFAULT NULL,
  `settimana_programmazione` char(255) DEFAULT NULL,
  `ore_programmazione` char(255) DEFAULT NULL,
  `note_programmazione` text DEFAULT NULL,
  `data_chiusura` char(255) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `posti_disponibili` char(32) DEFAULT NULL,
  `se_prova` int(1) DEFAULT NULL,
  `se_prenotabile_online` int(1) DEFAULT NULL,
  `posti_prova` int(11) DEFAULT NULL,
  `id_contatto` int(11) DEFAULT NULL,
  `id_progetto` char(32) DEFAULT NULL,
  `corso` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_pianificazione` int(11) DEFAULT NULL,
  `id_immobile` int(11) DEFAULT NULL,
  `data_archiviazione` char(255) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 100000060400

-- __report_variazioni_anagrafica__
CREATE TABLE `__report_variazioni_anagrafica__` (
  `id` int(11) NOT NULL,
  `id_anagrafica` int(11) DEFAULT NULL,
  `nome` char(128) DEFAULT NULL,
  `cognome` char(128) DEFAULT NULL,
  `telefono` char(128) DEFAULT NULL,
  `mobile` char(128) DEFAULT NULL,
  `mail` char(128) DEFAULT NULL,
  `residenza_indirizzo` char(128) DEFAULT NULL,
  `residenza_civico` char(128) DEFAULT NULL,
  `residenza_cap` char(128) DEFAULT NULL,
  `residenza_localita` char(128) DEFAULT NULL,
  `residenza_id_comune` int(11) DEFAULT NULL,
  `id_account_evasione` int(11) DEFAULT NULL,
  `timestamp_evasione` int(11) DEFAULT NULL,
  `id_account_inserimento` int(11) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` int(11) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nome` (`nome`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE FILE

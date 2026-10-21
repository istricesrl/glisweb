--
-- REPORT
-- questo file contiene le query per la creazione dei report
--

-- | 100000008005

-- __report_utilizzi_coupon__
-- ripristinato il 2026-09-30 dalla versione di prima del 02/03/2026: gli utilizzi di un coupon nei carrelli e nei
-- pagamenti, letto dalla scheda utilizzi e dal rimborso del modulo 4140.coupon
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

-- | 100000020550

-- __report_immagini_scalate__
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

-- __report_iscrizioni_anagrafica__
-- NOTA: il JOIN su categorie_progetti filtra `se_disciplina = 1` (NON `IS NOT NULL`):
-- se_disciplina e' un tinyint 0/1/NULL, quindi `IS NOT NULL` non filtra le sole
-- discipline e fa risolvere il corso a una categoria "non disciplina" arbitraria.
-- id_disciplina_progetto / disciplina_progetto usano max() perche' il LEFT JOIN su
-- progetti_categorie produce comunque una riga per ogni categoria del progetto
-- (anche non-disciplina): max() scarta i NULL e tiene la sola foglia-disciplina.
-- | 100000020551

-- __report_iscrizioni_anagrafica__
CREATE OR REPLACE VIEW __report_iscrizioni_anagrafica__ AS
    SELECT
        contratti.id AS id,
        contratti.id_tipologia AS id_tipologia,
        contratti_anagrafica.id_anagrafica AS id_anagrafica,
        tipologie_contratti.nome AS tipologia,
        tipologie_contratti.se_abbonamento AS se_abbonamento,
        tipologie_contratti.se_iscrizione AS se_iscrizione,
        tipologie_contratti.se_tesseramento AS se_tesseramento,
        tipologie_contratti.se_immobili AS se_immobili,
        tipologie_contratti.se_acquisto AS se_acquisto,
        tipologie_contratti.se_locazione AS se_locazione,
        rinnovi.id AS id_rinnovo,
        rinnovi.id_tipologia AS id_tipologia_rinnovo,
        tipologie_rinnovi.nome AS tipologia_rinnovo,
        contratti.id AS id_contratto,
        contratti.nome AS contratto,
        contratti.codice AS tessera,
        rinnovi.id_licenza AS id_licenza,
        licenze.nome AS licenza,
        coalesce( rinnovi.id_progetto, contratti.id_progetto ) AS id_progetto,
        progetti.nome AS progetto,
        max( categorie_progetti.id ) AS id_disciplina_progetto,
        max( categorie_progetti.nome ) AS disciplina_progetto,
        m1.testo AS non_applicare_sconti,
        rinnovi.data_inizio AS data_inizio,
        rinnovi.data_fine AS data_fine,
        rinnovi.codice AS codice,
        rinnovi.id_pianificazione AS id_pianificazione,
        rinnovi.id_account_inserimento AS id_account_inserimento,
        rinnovi.id_account_aggiornamento AS id_account_aggiornamento,
        concat( 'rinnovo ', rinnovi.id, ' dal ', concat_ws( '-', rinnovi.data_inizio ), ' al ', concat_ws( '-', rinnovi.data_fine ) ) AS __label__
    FROM
        contratti
        LEFT JOIN rinnovi ON rinnovi.id_contratto = contratti.id
        LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
        LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia
        LEFT JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id
        LEFT JOIN licenze ON licenze.id = rinnovi.id_licenza
        LEFT JOIN progetti ON progetti.id = coalesce( rinnovi.id_progetto, contratti.id_progetto )
        LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
        LEFT JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1
        LEFT JOIN metadati m1 ON m1.id_progetto = progetti.id AND m1.nome = 'non_applicare_sconti'
    WHERE
        tipologie_contratti.se_iscrizione IS NOT NULL
    GROUP BY
        contratti.id, contratti_anagrafica.id_anagrafica, rinnovi.id, progetti.id
;

-- | 100000020605

-- __report_sottoscorta__
-- tabella, non vista: la riscrive per intero il task _mod/_0500.mastri/_src/_api/_task/_rifornimenti.da.sottoscorta.php
-- e la legge la scheda del sottoscorta del modulo _5000.logistica; dove il progetto non dichiara l'automazione
-- ( $cf['automazioni']['profile']['sottoscorta'] ) resta vuota. id e' la chiave sintetica <id_mastro>|<id_articolo>,
-- come __report_giacenza_magazzini__; le colonne id_* sono copie, senza chiave esterna
CREATE TABLE IF NOT EXISTS `__report_sottoscorta__` (
  `id` varchar(56) NOT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `articolo` varchar(331) DEFAULT NULL,
  `id_mastro` bigint(20) DEFAULT NULL,
  `collocazione` char(64) DEFAULT NULL,
  `giacenza` decimal(21,2) DEFAULT NULL,
  `scorta_minima` decimal(21,2) DEFAULT NULL,
  `scorta_minima_dichiarata` decimal(21,2) DEFAULT NULL COMMENT 'la soglia come l''ha scritta il magazzino, nell''unita'' di udm',
  `scorta_massima` decimal(21,2) DEFAULT NULL,
  `scorta_massima_dichiarata` decimal(21,2) DEFAULT NULL,
  `udm` char(32) DEFAULT NULL COMMENT 'nome dell''unita'' in cui e'' dichiarata la soglia; NULL = unita'' inventariale',
  `mancante` decimal(21,2) DEFAULT NULL COMMENT 'quanto serve per tornare a scorta massima',
  `id_mastro_bulk` bigint(20) DEFAULT NULL,
  `bulk` char(64) DEFAULT NULL,
  `giacenza_bulk` decimal(21,2) DEFAULT NULL,
  `quantita_richiesta` decimal(21,2) DEFAULT NULL COMMENT 'il mancante, limitato a quello che il bulk ha davvero',
  `id_missione` bigint(20) DEFAULT NULL,
  `missione` char(32) DEFAULT NULL,
  `esito` char(32) DEFAULT NULL COMMENT 'rifornita | non rifornibile',
  `se_allarme` tinyint(1) DEFAULT NULL COMMENT '1 = giacenza sotto la soglia adesso; 0 = ubicazione sorvegliata e a posto',
  `motivo` text DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_mastro` (`id_mastro`),
  KEY `esito` (`esito`),
  KEY `se_allarme` (`se_allarme`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 100000020606

-- __report_scorte_non_valutabili__
-- tabella, non vista: la riscrive lo stesso task di __report_sottoscorta__ con le ubicazioni la cui soglia non si puo'
-- confrontare con la giacenza; motivo dice perche'
CREATE TABLE IF NOT EXISTS `__report_scorte_non_valutabili__` (
  `id` varchar(56) NOT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `articolo` varchar(331) DEFAULT NULL,
  `id_mastro` bigint(20) DEFAULT NULL,
  `collocazione` char(64) DEFAULT NULL,
  `scorta_minima` decimal(21,2) DEFAULT NULL COMMENT 'come dichiarata: qui non c''e'' niente da convertire',
  `scorta_massima` decimal(21,2) DEFAULT NULL,
  `udm` char(32) DEFAULT NULL,
  `motivo` text DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_articolo` (`id_articolo`),
  KEY `id_mastro` (`id_mastro`),
  KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | FINE FILE

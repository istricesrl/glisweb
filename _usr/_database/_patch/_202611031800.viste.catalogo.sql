-- 2026-11-03 — viste del catalogo al canone: articoli, prodotti, categorie, listini, sconti, coupon, colli
--
-- Ordine di WEB03 del 03/11/2026, via Fabio; terzo gruppo dopo geografia ( 202611031600 ) e anagrafica
-- ( 202611031700 ), stesso criterio. Le viste vive sono rimaste indietro rispetto al file base _090000999999.views.sql
-- perche' i loro blocchi stanno sotto il livello di patch dei database esistenti: mancano p.es. valore e id_lingua di
-- prodotti_caratteristiche_view ( la
-- UNION dei cartellini grandi di _4100.prodotti la legge ), data_archiviazione delle categorie, mezza listini_view e
-- sconti_view, mittente e destinatario di colli_view. Su ognuno dei dieci database dei deploy letti da web03 la vista
-- viva ha solo colonne del canone e il SELECT del canone gira con LIMIT 0 ( viste-esatte.py, var/20261103-viste-ritardo/
-- di glisweb ): la patch aggiunge colonne e non ne toglie. Nessuna query, standard o dei progetti, mette queste viste in
-- JOIN con le colonne nuove non qualificate ( join.py; i casi trovati su listini_view sono falsi positivi ).
--
-- Fuori da questo gruppo, anche se in ritardo: articoli_view, prodotti_view e caratteristiche_prodotti_view. bernispa e
-- utensilerialughese le ridefiniscono di proposito con patch loro ( label, pubblicazioni, caratteristiche ), con le
-- stesse colonne del canone: rifarle dal file base con un id piu' alto gli toglierebbe la personalizzazione. Vanno
-- portate al canone deploy per deploy, o promuovendo prima a monte quello che i progetti hanno fatto meglio. I loro
-- blocchi, 202611031800, 202611031801 e 202611031803, sono stati tolti il 03/11 prima che la patch fosse applicata
-- fuori da glisweb.
--
-- Un blocco per vista, con la definizione del file base copiata com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611031802

-- prodotti_caratteristiche_view
CREATE OR REPLACE VIEW `prodotti_caratteristiche_view` AS
	SELECT
		prodotti_caratteristiche.id,
		prodotti_caratteristiche.ordine,
		prodotti_caratteristiche.id_prodotto,
		prodotti_caratteristiche.id_caratteristica,
		prodotti_caratteristiche.id_lingua,
		caratteristiche.nome AS caratteristica,
		prodotti_caratteristiche.valore,
		prodotti_caratteristiche.note,
		prodotti_caratteristiche.id_account_inserimento,
		prodotti_caratteristiche.id_account_aggiornamento,
		concat(
			prodotti_caratteristiche.id_prodotto,
			' / ',
			caratteristiche.nome
		) AS __label__
	FROM prodotti_caratteristiche
		LEFT JOIN caratteristiche ON caratteristiche.id = prodotti_caratteristiche.id_caratteristica
;

-- | 202611031804

-- categorie_prodotti_view
CREATE OR REPLACE VIEW categorie_prodotti_view AS
	SELECT
		categorie_prodotti.id,
		categorie_prodotti.id_genitore,
		categorie_prodotti.ordine,
		categorie_prodotti.codice,
		categorie_prodotti.nome,
		categorie_prodotti.template,
		categorie_prodotti.schema_html,
		categorie_prodotti.tema_css,
		categorie_prodotti.se_sitemap,
		categorie_prodotti.se_cacheable,
		categorie_prodotti.id_sito,
		categorie_prodotti.id_pagina,
		categorie_prodotti.data_archiviazione,
		count( c1.id ) AS figli,
		count( prodotti_categorie.id ) AS membri,
		categorie_prodotti.id_account_inserimento,
		categorie_prodotti.id_account_aggiornamento,
		categorie_prodotti_path( categorie_prodotti.id ) AS __label__
	FROM categorie_prodotti
		LEFT JOIN categorie_prodotti AS c1 ON c1.id_genitore = categorie_prodotti.id
		LEFT JOIN prodotti_categorie ON prodotti_categorie.id_categoria = categorie_prodotti.id
	GROUP BY categorie_prodotti.id
;

-- | 202611031805

-- categorie_notizie_view
CREATE OR REPLACE VIEW categorie_notizie_view AS
	SELECT
		categorie_notizie.id,
		categorie_notizie.id_genitore,
		categorie_notizie.ordine,
		categorie_notizie.codice,
		categorie_notizie.nome,
		categorie_notizie.template,
		categorie_notizie.schema_html,
		categorie_notizie.tema_css,
		categorie_notizie.se_sitemap,
		categorie_notizie.se_cacheable,
		categorie_notizie.id_sito,
		categorie_notizie.id_pagina,
		categorie_notizie.data_archiviazione,
		count( c1.id ) AS figli,
		count( notizie_categorie.id ) AS membri,
		categorie_notizie.id_account_inserimento,
		categorie_notizie.id_account_aggiornamento,
		categorie_notizie_path( categorie_notizie.id ) AS __label__
	FROM categorie_notizie
		LEFT JOIN categorie_notizie AS c1 ON c1.id_genitore = categorie_notizie.id
		LEFT JOIN notizie_categorie ON notizie_categorie.id_categoria = categorie_notizie.id
	GROUP BY categorie_notizie.id
;

-- | 202611031806

-- colori_view
CREATE OR REPLACE VIEW colori_view AS
	SELECT
		colori.id,
		colori.id_genitore,
		colori.nome,
		colori.hex,
		colori.r,
		colori.g,
		colori.b,
		colori.ral,
		colori.pantone,
		colori.c,
		colori.m,
		colori.y,
		colori.k,
		colori.css,
		colori_path( colori.id ) AS __label__
	FROM colori
;

-- | 202611031807

-- coupon_articoli_view
CREATE OR REPLACE VIEW `coupon_articoli_view` AS
	SELECT
		coupon_articoli.id,
		coupon_articoli.ordine,
		coupon_articoli.id_coupon,
		coupon_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		coupon_articoli.gruppo_alternative,
		coupon_articoli.id_account_inserimento,
		coupon_articoli.id_account_aggiornamento,
		CONCAT(
			coupon.nome,
			' / ',
			concat_ws( ' ', prodotti.nome, articoli.nome )
		) AS __label__
	FROM coupon_articoli
		LEFT JOIN coupon ON coupon.id = coupon_articoli.id_coupon
		LEFT JOIN articoli ON articoli.id = coupon_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
;

-- | 202611031808

-- sconti_view
CREATE OR REPLACE VIEW `sconti_view` AS
	SELECT
		sconti.id,
		sconti.id_tipologia,
		tipologie_sconti.nome AS tipologia,
		sconti.nome,
		sconti.id_valuta,
		valute.iso4217 AS valuta,
		sconti.sconto_percentuale,
		sconti.sconto_fisso,
		sconti.qta_min,
		sconti.note,
		sconti.timestamp_inizio,
		from_unixtime( sconti.timestamp_inizio, '%Y-%m-%d' ) AS data_ora_inizio,
		sconti.timestamp_fine,
		from_unixtime( sconti.timestamp_fine, '%Y-%m-%d' ) AS data_ora_fine,
		sconti.id_account_inserimento,
		sconti.timestamp_inserimento,
		sconti.id_account_aggiornamento,
		sconti.timestamp_aggiornamento,
		concat_ws( ' ', sconti.id, sconti.nome ) AS __label__
	FROM sconti
		LEFT JOIN tipologie_sconti ON tipologie_sconti.id = sconti.id_tipologia
		LEFT JOIN valute ON valute.id = sconti.id_valuta
;

-- | 202611031809

-- listini_view
CREATE OR REPLACE VIEW listini_view AS                                                   --
  SELECT                                                                                 --
    listini.id,                                                                          --
    listini.id_genitore,                                                                 --
    listini.id_tipologia,                                                                --
    tipologie_listini_path( listini.id_tipologia ) AS tipologia,                         --
    listini.codice,                                                                      --
    listini.nome,                                                                        --
    listini.id_emittente,                                                                --
    coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,   --
    listini.id_valuta,                                                                   --
    valute.iso4217 AS valuta,                                                            --
    listini.sconto_su_genitore,                                                          --
    listini.note,                                                                        --
    listini.se_default_su_genitore,                                                      --
    listini.data_archiviazione,                                                          --
    listini.id_account_inserimento,                                                      --
    listini.id_account_aggiornamento,                                                    --
    concat_ws(                                                                           --
      ' ',                                                                               --
      listini.codice,                                                                    --
      listini_path( listini.id ),                                                        --
      valute.iso4217                                                                     --
    ) AS __label__                                                                       -- etichetta per le tendine e le liste
  FROM listini                                                                           --
    LEFT JOIN valute ON valute.id = listini.id_valuta                                    --
    LEFT JOIN anagrafica AS a1 ON a1.id = listini.id_emittente                           --
  ;

-- | 202611031810

-- listini_clienti_view
CREATE OR REPLACE VIEW listini_clienti_view AS                                           --
  SELECT                                                                                 --
    listini_clienti.id,                                                                  --
    listini_clienti.ordine,                                                              --
    listini_clienti.id_listino,                                                          --
    listini.codice AS listino_codice,                                                    --
    concat( listini.nome, ' ', valute.iso4217 ) AS listino,                              --
    listini_clienti.id_cliente,                                                          --
    coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS cliente,     --
    a1.nome AS cliente_nome,                                                             --
    a1.cognome AS cliente_cognome,                                                       --
    a1.denominazione AS cliente_denominazione,                                           --
    a1.codice_fiscale AS cliente_codice_fiscale,                                         --
    a1.codice AS cliente_codice,                                                         --
    listini_clienti.id_account_inserimento,                                              --
    listini_clienti.id_account_aggiornamento,                                            --
    concat(                                                                              --
      listini.nome,                                                                      --
      ' ',                                                                               --
      valute.iso4217,                                                                    --
      ' / ',                                                                             --
      coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' )               --
    ) AS __label__                                                                       -- etichetta per le tendine e le liste
  FROM listini_clienti                                                                   --
    LEFT JOIN listini ON listini.id = listini_clienti.id_listino                         --
    LEFT JOIN valute ON valute.id = listini.id_valuta                                    --
    LEFT JOIN anagrafica AS a1 ON a1.id = listini_clienti.id_cliente                     --
  ;

-- | 202611031811

-- listini_zone_view
CREATE OR REPLACE VIEW listini_zone_view AS                                              --
  SELECT                                                                                 --
    listini_zone.id,                                                                     --
    listini_zone.ordine,                                                                 --
    listini_zone.id_listino,                                                             --
    listini.codice AS listino_codice,                                                    --
    concat( listini.nome, ' ', valute.iso4217 ) AS listino,                              --
    listini_zone.id_zona,                                                                --
    zone.nome AS zona,                                                                   --
    listini_zone.id_account_inserimento,                                                 --
    listini_zone.id_account_aggiornamento,                                               --
    concat(                                                                              --
      listini.nome,                                                                      --
      ' ',                                                                               --
      valute.iso4217,                                                                    --
      ' / ',                                                                             --
      zone.nome                                                                          --
    ) AS __label__                                                                       -- etichetta per le tendine e le liste
  FROM listini_zone                                                                      --
    LEFT JOIN listini ON listini.id = listini_zone.id_listino                            --
    LEFT JOIN valute ON valute.id = listini.id_valuta                                    --
    LEFT JOIN zone ON zone.id = listini_zone.id_zona                                     --
  ;

-- | 202611031812

-- mastri_articoli_view
CREATE OR REPLACE VIEW `mastri_articoli_view` AS
	SELECT
		mastri_articoli.id,
		mastri_articoli.ordine,
		mastri_articoli.codice,
		mastri_articoli.id_mastro,
		mastri_path( mastri_articoli.id_mastro ) AS mastro,
		mastri_articoli.id_articolo,
		concat_ws( ' ', prodotti.nome, articoli.nome ) AS articolo,
		mastri_articoli.id_ruolo,
		ruoli_mastri.nome AS ruolo,
		mastri_articoli.scorta_minima,
		mastri_articoli.scorta_massima,
		mastri_articoli.id_udm,
		udm.sigla AS udm,
		mastri_articoli.note,
		mastri_articoli.id_account_inserimento,
		mastri_articoli.id_account_aggiornamento,
		concat_ws(
			' / ',
			mastri_path( mastri_articoli.id_mastro ),
			concat_ws( ' ', prodotti.nome, articoli.nome )
		) AS __label__
	FROM mastri_articoli
		LEFT JOIN articoli ON articoli.id = mastri_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN ruoli_mastri ON ruoli_mastri.id = mastri_articoli.id_ruolo
		LEFT JOIN udm ON udm.id = mastri_articoli.id_udm
;

-- | 202611031813

-- colli_view
CREATE OR REPLACE VIEW `colli_view` AS
	SELECT
		colli.id,
		colli.id_genitore,
		colli.id_tipologia,
		tipologie_colli_path( colli.id_tipologia ) AS tipologia,
		colli.ordine,
		colli.codice,
		colli.nome,
		colli.id_anagrafica,
		a2.denominazione AS anagrafica,
		colli.id_documento,
		colli.id_mittente,
		a3.denominazione AS mittente,
		colli.id_destinatario,
		a4.denominazione AS destinatario,
		colli.id_mastro,
		mastri_path( colli.id_mastro ) AS mastro,
		colli.raggruppamento,
		colli.larghezza,
		colli.lunghezza,
		colli.altezza,
		colli.id_udm_dimensioni,
		colli.peso,
		colli.id_udm_peso,
		colli.volume,
		colli.id_udm_volume,
		colli.pezzi,
		colli.note,
		GROUP_CONCAT( DISTINCT anagrafica.denominazione SEPARATOR '|' ) AS destinatari,
		colli.timestamp_chiusura,
		colli.note_chiusura,
		IF( colli.timestamp_chiusura IS NOT NULL AND colli.timestamp_chiusura > 0,
			'<i class="fa fa-check text-success"></i>', '' ) AS chiuso,    -- indicatore collo chiuso
		colli.timestamp_spedizione,
		colli.note_spedizione,
		colli.id_account_inserimento,
		colli.id_account_aggiornamento,
		CONCAT_WS( ' ', colli.codice, tipologie_colli_path( colli.id_tipologia ), colli.nome ) AS __label__
	FROM colli
		LEFT JOIN documenti_articoli ON documenti_articoli.id_collo = colli.id
		LEFT JOIN documenti ON documenti.id = documenti_articoli.id_packing_list
		LEFT JOIN anagrafica ON anagrafica.id = documenti.id_destinatario
		LEFT JOIN anagrafica a2 ON a2.id = colli.id_anagrafica
		LEFT JOIN anagrafica a3 ON a3.id = colli.id_mittente
		LEFT JOIN anagrafica a4 ON a4.id = colli.id_destinatario
	GROUP BY colli.id
;

-- | FINE

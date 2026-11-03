-- 2026-11-03 — viste del catalogo al canone: articoli, prodotti, categorie, listini, sconti, coupon, colli
--
-- Ordine di WEB03 del 03/11/2026, via Fabio; terzo gruppo dopo geografia ( 202611031600 ) e anagrafica
-- ( 202611031700 ), stesso criterio. Le viste vive sono rimaste indietro rispetto al file base _090000999999.views.sql
-- perche' i loro blocchi stanno sotto il livello di patch dei database esistenti: mancano p.es. codice_produttore e le
-- note di articoli_view, note e id_pagina di prodotti_view, valore e id_lingua di prodotti_caratteristiche_view ( la
-- UNION dei cartellini grandi di _4100.prodotti la legge ), data_archiviazione delle categorie, mezza listini_view e
-- sconti_view, mittente e destinatario di colli_view. Su ognuno dei dieci database dei deploy letti da web03 la vista
-- viva ha solo colonne del canone e il SELECT del canone gira con LIMIT 0 ( viste-esatte.py, var/20261103-viste-ritardo/
-- di glisweb ): la patch aggiunge colonne e non ne toglie. Nessuna query, standard o dei progetti, mette queste viste in
-- JOIN con le colonne nuove non qualificate ( join.py; i casi trovati su listini_view sono falsi positivi ). Le statiche
-- ( articoli_view_static ) reggono: refreshStaticView() copia solo le colonne comuni.
--
-- Un blocco per vista, con la definizione del file base copiata com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611031800

-- articoli_view
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		-- PUBBLICAZIONE: SOTTOQUERY, NON JOIN ( 2026-10-04 )
		--
		-- prima erano due LEFT JOIN su pubblicazioni ( dell'articolo e del prodotto ): un articolo con
		-- piu' pubblicazioni usciva una volta per pubblicazione, e su glisweb la vista dava 7.920 righe
		-- per 132 articoli. La statica, che ha id come chiave primaria, non si riusciva piu' a
		-- riempire. Si prende la prima pubblicazione dell'articolo, se no la prima del prodotto; la prima e' quella
		-- che viene prima nell'ordine ( punto 6e ), su qualunque sito.
		coalesce(
			( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.ordine IS NULL, pa.ordine, pa.id LIMIT 1 ),
			( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1 )
		) AS id_tipologia_pubblicazione,
		( SELECT tp.nome FROM tipologie_pubblicazioni AS tp WHERE tp.id = coalesce(
				( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.ordine IS NULL, pa.ordine, pa.id LIMIT 1 ),
				( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1 )
			) ) AS pubblicazione,
		-- TIPOLOGIA DI VOCE A LISTINO: SOTTOQUERY, NON JOIN
		--
		-- prima erano tre LEFT JOIN su articoli_caratteristiche piu' un max( CASE ... ) sotto il
		-- GROUP BY. Funziona, ma moltiplica le righe per le caratteristiche di ogni articolo, e
		-- quando quella tabella si riempie la vista non si regge piu': l'08/09/2026, con le 7.580
		-- righe arrivate dalla migrazione del catalogo, la vista e' passata da meno di un secondo
		-- a cinque. La sottoquery scalare da' lo stesso valore e non tocca la cardinalita'
		( SELECT tipo_voce.nome
			FROM articoli_caratteristiche AS ac_tipo
			INNER JOIN caratteristiche_prodotti AS tipo_voce ON tipo_voce.id = ac_tipo.id_caratteristica
			INNER JOIN caratteristiche_prodotti AS radice_tipo ON radice_tipo.id = tipo_voce.id_genitore
			WHERE ac_tipo.id_articolo = articoli.id
			AND radice_tipo.nome = 'TIPO DI VOCE A LISTINO'
			LIMIT 1
		) AS tipologia_listino,
		articoli.id,
		articoli.codice,
		articoli.id_prodotto,
		prodotti.nome AS prodotto,
		articoli.ordine,
		articoli.ean,
		articoli.isbn,
		articoli.codice_produttore,
		articoli.id_reparto,
		articoli.id_taglia,
		articoli.id_colore,
		articoli.id_periodicita,
		periodicita.nome AS periodicita,
		articoli.id_tipologia_rinnovo,
		tipologie_rinnovi.nome AS tipologia_rinnovo,
		articoli.larghezza,
		articoli.lunghezza,
		articoli.altezza,
		articoli.id_udm_dimensioni,
		udm_dimensioni.sigla AS udm_dimensioni,
		articoli.peso,
		articoli.id_udm_peso,
		udm_peso.sigla AS udm_peso,
		articoli.volume,
		articoli.id_udm_volume,
		udm_volume.sigla AS udm_volume,
		articoli.capacita,
		articoli.id_udm_capacita,
		udm_capacita.sigla AS udm_capacita,
		articoli.durata,
		articoli.id_udm_durata,
		udm_durata.sigla AS udm_durata,
		concat_ws(
			' ',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					concat_ws( 'x', articoli.larghezza, articoli.lunghezza, articoli.altezza ),
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS nome,
		articoli.note,
		articoli.note_codifica,
		-- CATEGORIE E PREZZI: SOTTOQUERY, NON JOIN PIU' GROUP BY
		--
		-- stessa ragione della sottoquery di tipologia_listino qui sopra, ma il guasto era peggiore:
		-- il GROUP BY impedisce all'ottimizzatore di spingere dentro la vista una condizione
		-- espressa con un SEGNAPOSTO, e il framework interroga sempre con statement preparati.
		-- Misurato l'08/09/2026: SELECT * ... WHERE id = ? passava da 2,36 secondi a 0,032, e un
		-- elenco di venti righe da 2,76 a 0,26 - perche' categorie_prodotti_path(), che e' una
		-- funzione ricorsiva, adesso viene chiamata solo per le righe che si mostrano davvero e
		-- non per tutte quelle della vista.
		--
		-- il coalesce a stringa vuota NON e' pignoleria: con la LEFT JOIN un articolo senza
		-- categorie dava '' e non NULL, perche' categorie_prodotti_path( NULL ) torna '' e il
		-- group_concat trovava comunque una riga. id_categorie invece resta NULL come prima.
		( SELECT group_concat( DISTINCT pc.id_categoria SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
			WHERE pc.id_prodotto = articoli.id_prodotto
		) AS id_categorie,
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
			WHERE pc.id_prodotto = articoli.id_prodotto
		), '' ) AS categorie,
		coalesce( ( SELECT group_concat( DISTINCT concat_ws( ' ', l.nome, v.iso4217, format( p.prezzo, 2, 'it_IT' ) ) SEPARATOR ' | ' )
			FROM prezzi AS p
			LEFT JOIN listini AS l ON l.id = p.id_listino
			LEFT JOIN valute AS v ON v.id = l.id_valuta
			WHERE p.id_articolo = articoli.id
		), '' ) AS prezzi,
		coalesce( articoli.data_archiviazione, prodotti.data_archiviazione ) AS data_archiviazione,
		articoli.note_archiviazione,
		articoli.id_account_inserimento,                      --
		articoli.timestamp_inserimento,                       --
		articoli.id_account_aggiornamento,                    --
		articoli.timestamp_aggiornamento,                     --
		concat_ws(
			' ',
			articoli.ean,
			articoli.codice,
			'/',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					udm_durata.sigla
				),
				''
			)
		) AS __label__
	FROM articoli
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN periodicita ON periodicita.id = articoli.id_periodicita
		LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = articoli.id_tipologia_rinnovo
;

-- | 202611031801

-- prodotti_view
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		-- PUBBLICAZIONE: SOTTOQUERY, NON JOIN ( 22/10/2026 )
		--
		-- prima era una LEFT JOIN su pubblicazioni: un prodotto con piu' pubblicazioni usciva una volta per
		-- pubblicazione ( su utensilerialughese cinque righe doppie ). Si prende la prima pubblicazione del
		-- prodotto, come in articoli_view, la prima nell'ordine.
		( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = prodotti.id ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1 ) AS id_tipologia_pubblicazione,
		( SELECT tp.nome FROM tipologie_pubblicazioni AS tp WHERE tp.id = (
				SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = prodotti.id ORDER BY pp.ordine IS NULL, pp.ordine, pp.id LIMIT 1
			) ) AS pubblicazione,
		prodotti.id,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.codice,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		prodotti.note,
		prodotti.note_codifica,
		-- SOTTOQUERY E NON JOIN PIU' GROUP BY: vedi la nota in articoli_view. Misurato
		-- l'08/09/2026: SELECT * ... WHERE id = ? da 0,81 secondi a 0,011, un elenco di venti
		-- righe da 0,74 a 0,017.
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
		   WHERE pc.id_prodotto = prodotti.id
		), '' ) AS categorie,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
		prodotti.id_sito,
		prodotti.id_pagina,
		prodotti.data_archiviazione,
		prodotti.id_account_inserimento,
		prodotti.id_account_aggiornamento,
		concat_ws(
			' ',
			prodotti.codice,
			prodotti.nome
		) AS __label__
	FROM prodotti
		LEFT JOIN tipologie_prodotti ON tipologie_prodotti.id = prodotti.id_tipologia
		LEFT JOIN marchi ON marchi.id = prodotti.id_marchio
		LEFT JOIN anagrafica AS a1 ON a1.id = prodotti.id_produttore
;

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

-- | 202611031803

-- caratteristiche_prodotti_view
CREATE OR REPLACE VIEW `caratteristiche_prodotti_view` AS
	SELECT
		caratteristiche.id,
		caratteristiche.id_genitore,
		caratteristiche.nome,
		caratteristiche.html_entity,
		caratteristiche.font_awesome,
		NULL AS se_categoria,
		caratteristiche.se_prodotti AS se_prodotto,
		caratteristiche.se_articoli AS se_articolo,
		caratteristiche.id_account_inserimento,
		caratteristiche.id_account_aggiornamento,
		caratteristiche_path(
            caratteristiche.id
        ) AS __label__
	FROM caratteristiche
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

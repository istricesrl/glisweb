-- 2026-09-28 — la descrizione degli articoli non esce piu' scritta due volte
--
-- COSA SI VEDEVA. Le due viste compongono l'etichetta dell'articolo come prodotti.nome piu'
-- articoli.nome, ed e' giusto: il prodotto e' il contenitore ( "GOODWAY GS3300" ) e il nome
-- dell'articolo e' cio' che distingue la variante ( "con FANUC" ). Quando pero' l'articolo porta lo
-- stesso nome del suo prodotto - il caso tipico e' l'import, dove prodotto e articolo nascono dalla
-- stessa riga - la somma scrive due volte la stessa cosa: "CUSCINETTO SKF 47.30.9 CUSCINETTO SKF
-- 47.30.9". Su utensilerialughese, il 20/09/2026, era il 77% degli articoli.
--
-- COSA FA. nullif( articoli.nome, prodotti.nome ) al posto di articoli.nome nelle tre composizioni
-- che li sommano: articoli_view.nome, articoli_view.__label__ e documenti_articoli_view.articolo.
-- concat_ws salta i NULL, quindi dove i due nomi coincidono ne esce uno solo e dove sono diversi non
-- cambia niente. Il file di base e' stato corretto nello stesso giro.
--
-- PERCHE' PRIMA LA COLONNA articoli.codice. La articoli_view di base la legge dal 02/03/2026 ( commit
-- d975b4a15 ), e _010000999999.tables.sql la crea, ma nessuna patch datata l'ha mai aggiunta ai
-- deploy installati prima: li' ricreare la vista dal file di base muore con 1054 Unknown column
-- 'articoli.codice'. La si aggiunge qui, come nel file di base ( char( 32 ), dopo id, nessun indice ).
--
-- ⚠ VISTE PERSONALIZZATE. Questa patch rifa' le due viste come sono nel file di base: un deploy che
-- le ha cambiate con una patch di progetto le perde, e deve riapplicarle con una patch di progetto
-- datata dopo questa ( su utensilerialughese e' la 202609281100 ).
--
-- IDEMPOTENZA. ADD COLUMN IF NOT EXISTS e' di MariaDB, come in _202609251000.audio.sql; le viste si
-- ricreano.

-- | 202609281000

-- articoli
ALTER TABLE `articoli`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL AFTER `id`;

-- | 202609281010

-- articoli_view
CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		coalesce( pubblicazioni.id_tipologia, pubblicazioni_prodotto.id_tipologia ) AS id_tipologia_pubblicazione,
		tipologie_pubblicazioni.nome AS pubblicazione,
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
		LEFT JOIN pubblicazioni ON pubblicazioni.id_articolo = articoli.id
		LEFT JOIN pubblicazioni AS pubblicazioni_prodotto ON pubblicazioni_prodotto.id_prodotto = articoli.id_prodotto
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = coalesce( pubblicazioni.id_tipologia, pubblicazioni_prodotto.id_tipologia )
;

-- | 202609281011

-- documenti_articoli_view
CREATE OR REPLACE VIEW `documenti_articoli_view` AS
    SELECT
		documenti_articoli.id,
		documenti_articoli.id_genitore,
        documenti_articoli.codice,
		coalesce( documenti_articoli.id_tipologia_documento, documenti.id_tipologia ) AS id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti_articoli.id_tipologia AS id_tipologia_riga,
		tipologie_documenti_articoli.nome AS tipologia_riga,
		documenti_articoli.ordine,
		documenti_articoli.id_documento,
		documenti.codice AS codice_documento,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			documenti.sezionale,
			' del ',
			documenti.data
		) AS documento,
		coalesce( documenti_articoli.data, documenti.data ) AS data,
		documenti_articoli.id_packing_list,
		documenti_articoli.id_missione,
		coalesce( documenti_articoli.id_emittente, documenti.id_emittente ) AS id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		coalesce( documenti_articoli.id_destinatario, documenti.id_destinatario ) AS id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti_articoli.id_reparto,
		documenti_articoli.id_progetto,
		documenti_articoli.id_todo,
		documenti_articoli.id_attivita,
		documenti_articoli.id_articolo,
		udm_riga.sigla AS udm,
				concat_ws(
			' ',
			articoli.id,
			'/',
			prodotti.nome,
			nullif( articoli.nome, prodotti.nome ),
			coalesce(
				concat(
					articoli.larghezza, 'x', articoli.lunghezza, 'x', articoli.altezza,
					' ',
					udm_dimensioni.sigla
				),
				concat(
					articoli.peso,
					' ',
					udm_peso.sigla
				),
				concat(
					articoli.volume,
					' ',
					udm_volume.sigla
				),
				concat(
					articoli.capacita,
					' ',
					udm_capacita.sigla
				),
				concat(
					articoli.durata,
					' ',
					udm_durata.sigla
				),
				''
			)
		) AS articolo,
		documenti_articoli.id_prodotto,
		IF( documenti_articoli.id_articolo IS NOT NULL ,prodotti.nome, p.nome ) AS prodotto,
		documenti_articoli.id_mastro_provenienza,
		mastri_path( m1.id ) AS mastro_provenienza,
		documenti_articoli.id_mastro_destinazione,
		mastri_path( m2.id ) AS mastro_destinazione,
		documenti_articoli.id_udm,
		documenti_articoli.quantita,
        -- LA QUANTITA' DELLE SOTTO RIGHE: SOTTOQUERY, NON JOIN PIU' GROUP BY
        --
        -- era una LEFT JOIN su se stessa piu' un sum() sotto GROUP BY, ed e' l'unica ragione per
        -- cui questa vista aveva un GROUP BY. Costava carissimo, ma solo dove non si vedeva: con
        -- un valore letterale nel WHERE l'ottimizzatore spinge la condizione dentro la vista e
        -- legge una riga sola, con un SEGNAPOSTO non ci riesce e materializza tutte le righe
        -- passando per venti join. Il framework interroga SEMPRE con statement preparati, quindi
        -- pagava sempre il prezzo pieno.
        --
        -- Misurato l'08/09/2026 su 50.213 righe: SELECT * ... WHERE id = ? passa da 11,1 secondi a
        -- 0,012, e la tendina delle righe genitore da 9,0 a 0,17. Le due versioni danno righe
        -- identiche, verificate una per una.
        ( SELECT coalesce( sum( sotto_righe.quantita ), 0 )
            FROM documenti_articoli AS sotto_righe
           WHERE sotto_righe.id_genitore = documenti_articoli.id
        ) AS sotto_righe_quantita,
		documenti_articoli.id_listino,		
		documenti_articoli.id_pianificazione,
		listini.id_valuta,
		valute.utf8 AS valuta,
		documenti_articoli.importo_netto_totale,
		documenti_articoli.sconto_percentuale,
		documenti_articoli.sconto_valore,
		documenti_articoli.id_matricola,
		matricole.matricola AS matricola,
		documenti_articoli.id_rinnovo,
		documenti_articoli.id_collo,
		colli.codice AS codice_collo,
		colli.nome AS nome_collo,
        colli.ordine AS ordine_collo,
		matricole.data_scadenza,
		documenti_articoli.nome,
		documenti_articoli.data_consegna,
        documenti.data_archiviazione,
		documenti_articoli.id_account_inserimento,
		documenti_articoli.id_account_aggiornamento,
		concat_ws(
            ' / ',
			coalesce( documenti_articoli.data, documenti.data, NULL ),
			coalesce( tipologie_documenti.sigla, NULL ),
            concat(
			    coalesce( documenti.numero, NULL ),
                '/',
                coalesce( documenti.sezionale, NULL )
            ),
            concat(
                coalesce( documenti_articoli.quantita, 0 ),
                ' x ',
                coalesce( documenti_articoli.id_articolo, '' )
            ),
			coalesce( documenti_articoli.nome, NULL ),
            concat(
                coalesce( documenti_articoli.importo_netto_totale, NULL ),
                ' ',
                coalesce( valute.utf8, '' )
            )
		) AS __label__
	FROM
		documenti_articoli
        LEFT JOIN documenti ON documenti.id = documenti_articoli.id_documento
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( documenti_articoli.id_emittente, documenti.id_emittente )
		LEFT JOIN anagrafica AS a2 ON a2.id = coalesce( documenti_articoli.id_destinatario, documenti.id_destinatario )
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = coalesce( documenti_articoli.id_tipologia_documento, documenti.id_tipologia )
		LEFT JOIN listini ON listini.id = documenti_articoli.id_listino
		LEFT JOIN valute ON valute.id = listini.id_valuta
		LEFT JOIN mastri AS m1 ON m1.id = documenti_articoli.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti_articoli.id_mastro_destinazione
		LEFT JOIN matricole ON matricole.id = documenti_articoli.id_matricola
		LEFT JOIN articoli ON articoli.id = documenti_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN prodotti AS p ON p.id = documenti_articoli.id_prodotto
		LEFT JOIN colli ON colli.id = documenti_articoli.id_collo
		LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
		LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
		LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
		LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
		LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
		LEFT JOIN udm AS udm_riga ON udm_riga.id = documenti_articoli.id_udm
		LEFT JOIN tipologie_documenti_articoli ON tipologie_documenti_articoli.id = documenti_articoli.id_tipologia
;

-- | FINE FILE

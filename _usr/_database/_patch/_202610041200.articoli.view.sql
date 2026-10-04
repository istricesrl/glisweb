-- 2026-10-04 — articoli_view senza righe doppie, e articoli_view_static con le colonne della vista
--
-- articoli_view prendeva la pubblicazione con due LEFT JOIN su pubblicazioni ( dell'articolo e del prodotto ):
-- un articolo con piu' pubblicazioni usciva una volta per pubblicazione ( su glisweb 7.920 righe per 132
-- articoli ). Adesso sono sottoquery scalari, come gia' tipologia_listino, categorie e prezzi.
--
-- articoli_view_static nel file di base non aveva le tre colonne con cui la vista comincia
-- ( id_tipologia_pubblicazione, pubblicazione, tipologia_listino ): gli inserimenti che le nominano
-- fallivano con 1054 e dal 03/10 la statica era vuota su tutti i deploy del canone. Si aggiungono, nella stessa
-- posizione della vista, e la statica si ripopola per intero.
--
-- ⚠ I deploy con una articoli_view di progetto ( utensilerialughese: usr/database/patch/202609281100 ) dopo
-- questa patch hanno la vista dello standard: va seguita da una patch di progetto che rimetta la loro.

-- | 202610041200

CREATE OR REPLACE VIEW `articoli_view` AS
	SELECT
		-- PUBBLICAZIONE: SOTTOQUERY, NON JOIN ( 2026-10-04 )
		--
		-- prima erano due LEFT JOIN su pubblicazioni ( dell'articolo e del prodotto ): un articolo con
		-- piu' pubblicazioni usciva una volta per pubblicazione, e su glisweb la vista dava 7.920 righe
		-- per 132 articoli. La statica, che ha id come chiave primaria, non si riusciva piu' a
		-- riempire. Si prende la prima pubblicazione dell'articolo, se no la prima del prodotto.
		coalesce(
			( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.id LIMIT 1 ),
			( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.id LIMIT 1 )
		) AS id_tipologia_pubblicazione,
		( SELECT tp.nome FROM tipologie_pubblicazioni AS tp WHERE tp.id = coalesce(
				( SELECT pa.id_tipologia FROM pubblicazioni AS pa WHERE pa.id_articolo = articoli.id ORDER BY pa.id LIMIT 1 ),
				( SELECT pp.id_tipologia FROM pubblicazioni AS pp WHERE pp.id_prodotto = articoli.id_prodotto ORDER BY pp.id LIMIT 1 )
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
;

-- | 202610041201

ALTER TABLE `articoli_view_static`
	ADD COLUMN IF NOT EXISTS `tipologia_listino` char(64) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `pubblicazione` char(32) DEFAULT NULL FIRST,
	ADD COLUMN IF NOT EXISTS `id_tipologia_pubblicazione` bigint(20) DEFAULT NULL FIRST;

-- | 202610041202

REPLACE INTO `articoli_view_static` ( `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` )
	SELECT `id_tipologia_pubblicazione`, `pubblicazione`, `tipologia_listino`, `id`, `codice`, `id_prodotto`, `prodotto`, `ordine`, `ean`, `isbn`, `id_reparto`, `id_taglia`, `id_colore`, `id_periodicita`, `periodicita`, `id_tipologia_rinnovo`, `tipologia_rinnovo`, `larghezza`, `lunghezza`, `altezza`, `id_udm_dimensioni`, `udm_dimensioni`, `peso`, `id_udm_peso`, `udm_peso`, `volume`, `id_udm_volume`, `udm_volume`, `capacita`, `id_udm_capacita`, `udm_capacita`, `durata`, `id_udm_durata`, `udm_durata`, `nome`, `id_categorie`, `categorie`, `prezzi`, `data_archiviazione`, `id_account_inserimento`, `timestamp_inserimento`, `id_account_aggiornamento`, `timestamp_aggiornamento`, `__label__` FROM `articoli_view`;

-- | FINE

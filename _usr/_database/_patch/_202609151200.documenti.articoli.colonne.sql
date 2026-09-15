-- 2026-09-15 — allineamento delle colonne di documenti_articoli, e le due cose che ci si appoggiano
--
-- PERCHE' ESISTE QUESTA PATCH. documenti_articoli_view legge 34 colonne di documenti_articoli, e
-- i deploy non le hanno tutte: misurato il 15/09/2026, a crmfia ne mancano 3 ( data_consegna,
-- id_missione, id_packing_list ), a gimbe 4 ( le stesse piu' `codice` ), a polmasi 1
-- ( id_packing_list ). Non e' un effetto della migrazione delle tipologie: e' un disallineamento
-- fra i file di base e i deploy che c'era gia' e che nessuno aveva mai misurato, perche' finche'
-- nessuno ricrea le viste da quei file non si vede.
--
-- Si e' visto il 15/09/2026, quando la migrazione _202609151100 ha provato a ricreare la vista su
-- crmfia ed e' morta con "Unknown column 'documenti_articoli.id_packing_list'", lasciando il
-- deploy con lo schema migrato e la vista vecchia: tipologia vuota a video su 6.106 righe.
--
-- COSA FA. Aggiunge con ADD COLUMN IF NOT EXISTS tutte e trentuno le colonne che la vista usa e
-- che la migrazione non tocca, poi rifa' l'unicita' sul codice e la vista. Sono tutte nullable e
-- tutte prese pari pari dai file di base, quindi su un deploy che le ha gia' non succede niente.
--
-- PERCHE' IL NUMERO E' PIU' ALTO DELLA MIGRAZIONE. Il task salta un intero file quando il livello
-- ricavato dal NOME e' minore o uguale al patch level del database. crmfia, fermandosi a meta',
-- e' rimasto a 202609151140: un file numerato piu' in basso non lo leggerebbe nemmeno. Con
-- 202609151200 il file passa su tutti e cinque, e dove non c'e' niente da fare non fa niente.

-- | 202609151200

-- le colonne che la vista usa e che su qualche deploy non ci sono
ALTER TABLE `documenti_articoli`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_consegna` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_aggiornamento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_account_inserimento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_articolo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_attivita` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_collo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_destinatario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_documento` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_emittente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_listino` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_mastro_destinazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_mastro_provenienza` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_matricola` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_missione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_packing_list` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_pianificazione` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_prodotto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_progetto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_reparto` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_rinnovo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_todo` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_udm` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `importo_netto_totale` decimal(16,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `nome` char(255) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `ordine` int(11) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `quantita` decimal(9,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `sconto_percentuale` decimal(9,2) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `sconto_valore` decimal(9,2) DEFAULT NULL;

-- | 202609151201

-- l'unicita' sul codice, che vuole la colonna `codice` appena allineata
ALTER TABLE `documenti_articoli`
	ADD UNIQUE KEY IF NOT EXISTS `unico_codice` (`codice`,`id_tipologia_documento`);

-- | 202609151202

-- la vista non legge solo documenti_articoli: di `documenti` usa nove colonne, e anche li' i
-- deploy non le hanno tutte. A crmfia manca data_archiviazione, a gimbe anche codice; verificato
-- il 15/09/2026, e scoperto nel modo peggiore: la prima versione di questa patch guardava solo
-- documenti_articoli ed e' morta su crmfia con "Unknown column 'documenti.data_archiviazione'".
ALTER TABLE `documenti`
	ADD COLUMN IF NOT EXISTS `codice` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `data_archiviazione` date DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_destinatario` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_emittente` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `id_tipologia` bigint(20) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `numero` char(32) DEFAULT NULL,
	ADD COLUMN IF NOT EXISTS `sezionale` char(32) DEFAULT NULL;

-- | 202609151203

-- e finalmente la vista, identica a quella dei file di base
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
			articoli.nome,
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
-- | FINE

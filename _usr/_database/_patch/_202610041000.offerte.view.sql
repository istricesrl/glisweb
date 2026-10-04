-- 2026-10-04 — offerte_view e offerte_view_static al posto di offerte_attive_view e offerte_attive_view_static
--
-- Decisione di Fabio del 03/10/2026: la statica delle offerte comprende TUTTE le offerte, emesse e ricevute, e
-- nasce dalla sua vista offerte_view, che torna nel canone ( _090000999999.views.sql ). offerte_attive_view, tolta
-- dal canone in d975b4a15, restava solo su qualche deploy ( fra i dev, utensilerialughese ); il filtro "attive"
-- ( emittente gestito ) adesso lo applica l'elenco, _mod/_0400.documenti/_src/_inc/_macro/_offerte.commerciale.view.php.
--
-- La statica si popola qui UNA volta, per intero: e' un'installazione, e offerte_view non ha piu' nel WHERE la
-- anagrafica_check_gestita() che rendeva cara la vecchia vista. I timestamp si prendono da documenti ( o dall'ora
-- corrente se li' sono NULL ), cosi' la prima syncStaticView() trova la statica gia' in pari. Dopo, a tenerla
-- allineata sono il controller _documenti.finally.php e il task _offerte.view.static.popolazione.
--
-- Nella stessa patch ( richiesta del coordinamento, 04/10/2026, dalla verifica dei file base ):
-- - sette viste che sui DB avevano una definizione diversa dal base ( contenuti, documenti, immagini, prodotti,
--   ruoli_file, ruoli_immagini, pagamenti ): si ricreano copiate da _090000999999.views.sql, che e' il canone;
-- - la chiave unica unica_mail ( id_mailing, id_mail ) di mailing_mail, dichiarata nel base 030 ma tolta dai DB
--   dalla patch 202610023571 perche' canone-db.py non riconosceva la forma senza KEY: si rimette se manca.
--
-- IDEMPOTENTE.

-- | 202610041000

CREATE OR REPLACE VIEW `offerte_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.codice,
		documenti.numero,
		documenti.sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		documenti.id_causale,
		documenti.porto,
		documenti.id_trasportatore,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			documenti.nome,
			' ',
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
   	WHERE tipologie_documenti.se_offerta IS NOT NULL
;

-- | 202610041001

CREATE TABLE IF NOT EXISTS `offerte_view_static` (            --
  `id` bigint(20) PRIMARY KEY NOT NULL,                       --
  `id_tipologia` bigint(20) DEFAULT NULL,                     --
  `tipologia` char(255) DEFAULT NULL,                         --
  `codice` char(64) DEFAULT NULL,                             --
  `numero` char(32) DEFAULT NULL,                             --
  `sezionale` char(32) DEFAULT NULL,                          --
  `data` date DEFAULT NULL,                                   --
  `nome` char(255) DEFAULT NULL,                              --
  `id_emittente` bigint(20) DEFAULT NULL,                     --
  `emittente` varchar(320) DEFAULT NULL,                      --
  `id_destinatario` bigint(20) DEFAULT NULL,                  --
  `destinatario` varchar(320) DEFAULT NULL,                   --
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,            --
  `mastro_provenienza` char(64) DEFAULT NULL,                 --
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,           --
  `mastro_destinazione` char(64) DEFAULT NULL,                --
  `id_causale` bigint(20) DEFAULT NULL,                       --
  `porto` enum('franco','assegnato','-') DEFAULT NULL,        --
  `id_trasportatore` bigint(20) DEFAULT NULL,                 --
  `id_account_inserimento` bigint(20) DEFAULT NULL,           --
  `timestamp_inserimento` int(11) DEFAULT NULL,               --
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,         --
  `timestamp_aggiornamento` int(11) DEFAULT NULL,             --
  `__label__` text,                                           --
  UNIQUE KEY `codice` (`codice`),                             --
  KEY `data` (`data`)                                         --
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610041002

REPLACE INTO `offerte_view_static` ( `id`, `id_tipologia`, `tipologia`, `codice`, `numero`, `sezionale`, `data`, `nome`, `id_emittente`, `emittente`, `id_destinatario`, `destinatario`, `id_mastro_provenienza`, `mastro_provenienza`, `id_mastro_destinazione`, `mastro_destinazione`, `id_causale`, `porto`, `id_trasportatore`, `id_account_inserimento`, `id_account_aggiornamento`, `__label__`, `timestamp_inserimento`, `timestamp_aggiornamento` )
    SELECT offerte_view.`id`, offerte_view.`id_tipologia`, offerte_view.`tipologia`, offerte_view.`codice`, offerte_view.`numero`, offerte_view.`sezionale`, offerte_view.`data`, offerte_view.`nome`, offerte_view.`id_emittente`, offerte_view.`emittente`, offerte_view.`id_destinatario`, offerte_view.`destinatario`, offerte_view.`id_mastro_provenienza`, offerte_view.`mastro_provenienza`, offerte_view.`id_mastro_destinazione`, offerte_view.`mastro_destinazione`, offerte_view.`id_causale`, offerte_view.`porto`, offerte_view.`id_trasportatore`, offerte_view.`id_account_inserimento`, offerte_view.`id_account_aggiornamento`, offerte_view.`__label__`,
        coalesce( documenti.timestamp_inserimento, unix_timestamp() ),
        coalesce( documenti.timestamp_aggiornamento, unix_timestamp() )
    FROM offerte_view
        INNER JOIN documenti ON documenti.id = offerte_view.id;

-- | 202610041003

DROP TABLE IF EXISTS `offerte_attive_view_static`;

-- | 202610041004

DROP VIEW IF EXISTS `offerte_attive_view`;

-- | 202610041010

-- contenuti_view, copiata dal base
CREATE OR REPLACE VIEW contenuti_view AS                        --
	SELECT                                                      --
		contenuti.id,                                           --
		contenuti.id_lingua,                                    --
		contenuti.id_anagrafica,                                --
		contenuti.id_prodotto,                                  --
		contenuti.id_articolo,                                  --
		contenuti.id_categoria_prodotti,                        --
		contenuti.id_caratteristica,                            --
		contenuti.id_marchio,                                   --
		contenuti.id_file,                                      --
		contenuti.id_immagine,                                  --
		contenuti.id_video,                                     --
		contenuti.id_audio,                                     --
		contenuti.id_risorsa,                                   --
		contenuti.id_categoria_risorse,                         --
		contenuti.id_pagina,                                    --
		contenuti.id_popup,                                     --
		contenuti.id_indirizzo,                                 --
		contenuti.id_edificio,                                  --
		contenuti.id_immobile,                                  --
		contenuti.id_notizia,                                   --
		contenuti.id_annuncio,                                  --
		contenuti.id_categoria_notizie,                         --
		contenuti.id_categoria_annunci,                         --
		contenuti.id_template,                                  --
		contenuti.id_colore,                                    --
		contenuti.id_progetto,                                  --
		contenuti.id_categoria_progetti,                        --
		contenuti.id_banner,                                    --
		contenuti.title,                                        --
		contenuti.h1,                                           --
		contenuti.robots,                                       --
		contenuti.id_account_inserimento,                       --
		contenuti.id_account_aggiornamento,                     --
		concat(                                                 --
			contenuti.h1,                                       --
			' / ',                                              --
			lingue.nome                                         --
		) AS __label__                                          -- etichetta per le tendine e le liste
	FROM contenuti                                              --
		INNER JOIN lingue                                       --
            ON lingue.id = contenuti.id_lingua                  --
;

-- | 202610041011

-- documenti_view, copiata dal base
CREATE OR REPLACE VIEW `documenti_view` AS
    SELECT
		documenti.id,
		documenti.id_tipologia,
		tipologie_documenti.nome AS tipologia,
		documenti.codice,
		documenti.numero,
		documenti.sezionale,
        concat_ws(
            '/',
            documenti.numero,
            documenti.sezionale
        ) AS numero_sezionale,
		documenti.data,
		documenti.nome,
		documenti.id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		documenti.id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		documenti.id_destinatario_spedizione,
		coalesce( a3.denominazione , concat( a3.cognome, ' ', a3.nome ), '' ) AS destinatario_spedizione,
		documenti.id_condizione_pagamento,
		condizioni_pagamento.codice AS condizione_pagamento,
		documenti.esigibilita, 
		-- Il totale di un documento e' quello che vale la prestazione, non i soli contanti.
		--
		-- Fix 2026-09-08. `importo_lordo_finale` e' la sola parte pagata in denaro: una ricevuta
		-- saldata per intero con un coupon ci metteva dentro ZERO. E non in modo coerente, perche'
		-- il ripiego su `importo_lordo_totale` scattava solo con NULL e mai con `0.00`, che i vari
		-- flussi di checkout scrivono uno per uno: due ricevute della stessa tornata finivano cosi'
		-- a dichiarare l'importo in due modi diversi ( segreteria Polisportiva Masi, 08/09/2026 ).
		--
		-- Il coupon e' un modo di pagare, non uno sconto sul dovuto: va sommato al contante. E'
		-- la stessa somma che la stampa della ricevuta usa da sempre come totale pagato
		-- ( coupon_valore + importo_lordo_finale ). Il ripiego sul nominale resta per il solo caso
		-- in cui non si sa ne' quanto e' stato incassato ne' quanto coperto dal buono: la rata
		-- pianificata e non ancora saldata.
		--
		-- NOTA per chi tocchera' questa vista: la `sum()` sta dentro un GROUP BY che ha in JOIN
		-- anche `relazioni_documenti` ( r1/r2 ), quindi su un documento con N pagamenti e M
		-- documenti collegati il totale risulta moltiplicato per M. Difetto reale ma indipendente
		-- da questo, e non verificabile qui: su questo deploy `relazioni_documenti` e' vuota.
		sum(
			CASE WHEN pagamenti.importo_lordo_finale IS NULL AND pagamenti.coupon_valore IS NULL
			     THEN coalesce( pagamenti.importo_lordo_totale, 0 )
			     ELSE coalesce( pagamenti.importo_lordo_finale, 0 ) + coalesce( pagamenti.coupon_valore, 0 )
			END
		) AS totale_lordo_finale,
		sum( coalesce( pagamenti.coupon_valore, 0 ) ) AS totale_coupon,
		documenti.codice_archivium,
    	documenti.codice_sdi,
		documenti.cig,
		documenti.cup,
		documenti.riferimento,
    	documenti.timestamp_invio,
    	documenti.progressivo_invio,
		documenti.id_coupon,
		documenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		documenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
        group_concat( DISTINCT d1.codice SEPARATOR ' | ' ) AS documenti_antecedenti,
        group_concat( DISTINCT d2.codice SEPARATOR ' | ' ) AS documenti_successivi,
		documenti.porto,
		documenti.id_causale,
		documenti.id_trasportatore,
		documenti.id_immobile,
		documenti.id_pianificazione,
		documenti.data_consegna,
		documenti.timestamp_chiusura,
		documenti.data_archiviazione,
		from_unixtime( documenti.timestamp_chiusura, '%Y-%m-%d %H:%i' ) AS data_ora_chiusura,
		documenti.id_account_inserimento,
		documenti.id_account_aggiornamento,
		concat(
			tipologie_documenti.sigla,
			' ',
            concat_ws(
                '/',
                documenti.numero,
                documenti.sezionale
            ),
			' del ',
			documenti.data,
			' per ',
			coalesce(
				a2.denominazione,
				concat(
					a2.cognome,
					' ',
					a2.nome
				),
				''
			)
		) AS __label__
    FROM
		documenti
		LEFT JOIN anagrafica AS a1 ON a1.id = documenti.id_emittente
		LEFT JOIN anagrafica AS a2 ON a2.id = documenti.id_destinatario
        LEFT JOIN anagrafica AS a3 ON a3.id = documenti.id_destinatario_spedizione
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN condizioni_pagamento ON condizioni_pagamento.id = documenti.id_condizione_pagamento
		LEFT JOIN mastri AS m1 ON m1.id = documenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = documenti.id_mastro_destinazione
		LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id
        LEFT JOIN relazioni_documenti AS r1 ON r1.id_documento = documenti.id
        LEFT JOIN documenti AS d1 ON d1.id = r1.id_documento_collegato
        LEFT JOIN relazioni_documenti AS r2 ON r2.id_documento_collegato = documenti.id
        LEFT JOIN documenti AS d2 ON d2.id = r2.id_documento
	GROUP BY
		documenti.id
;

-- | 202610041012

-- immagini_view, copiata dal base
CREATE OR REPLACE VIEW `immagini_view` AS                       --
	SELECT                                                      --
		immagini.id,                                            --
		immagini.id_anagrafica,                                 --
		immagini.id_pagina,                                     --
		immagini.id_file,                                       --
		immagini.id_prodotto,                                   --
		immagini.id_articolo,                                   --
		immagini.id_categoria_prodotti,                         --
		immagini.id_marchio,                         --
		immagini.id_risorsa,                                    --
		immagini.id_categoria_risorse,                          --
		immagini.id_notizia,                                    --
		immagini.id_annuncio,                                   --
		immagini.id_categoria_notizie,                          --
		immagini.id_categoria_annunci,                          --
		immagini.id_progetto,                                   --
		immagini.id_categoria_progetti,                         --
		immagini.id_indirizzo,                                  --
		immagini.id_edificio,                                   --
		immagini.id_immobile,                                   --
		immagini.id_contratto,                                  --
        immagini.id_valutazione,                                --
		immagini.id_banner,                                     --
        immagini.id_rinnovo,                                    --
        immagini.id_video,                                    --
		immagini.id_lingua,                                     --
		lingue.nome AS lingua,                                  --
		immagini.id_ruolo,                                      --
		ruoli_immagini.nome AS ruolo,                           --
		immagini.ordine,                                        --
		immagini.orientamento,                                  --
		immagini.taglio,                                        --
		immagini.nome,                                          --
		immagini.path,                                          --
		immagini.path_alternativo,                              --
		immagini.token,                                         --
		immagini.timestamp_scalamento,                          --
		immagini.id_account_inserimento,                        --
		immagini.id_account_aggiornamento,                      --
		concat(                                                 --
			ruoli_immagini.nome,                                --
			' # ',                                              --
			immagini.ordine,                                    --
			' / ',                                              --
			immagini.nome,                                      --
			' / ',                                              --
			immagini.path                                       --
		) AS __label__                                          -- etichetta per le tendine e le liste
	FROM immagini                                               --
		LEFT JOIN lingue                                        --
            ON lingue.id = immagini.id_lingua                   --
		LEFT JOIN ruoli_immagini                                --
            ON ruoli_immagini.id = immagini.id_ruolo            --
;

-- | 202610041013

-- prodotti_view, copiata dal base
CREATE OR REPLACE VIEW `prodotti_view` AS
	SELECT
		pubblicazioni.id_tipologia AS id_tipologia_pubblicazione,
		tipologie_pubblicazioni.nome AS pubblicazione,
		prodotti.id,
		prodotti.codice,
		prodotti.id_tipologia,
		tipologie_prodotti.nome AS tipologia,
		tipologie_prodotti.se_prodotto,
		tipologie_prodotti.se_servizio,
		prodotti.nome,
		prodotti.id_marchio,
		marchi.nome AS marchio,
		prodotti.id_produttore,
		coalesce( a1.denominazione, concat( a1.cognome, ' ', a1.nome ), '' ) AS produttore,
		prodotti.codice_produttore,
		-- SOTTOQUERY E NON JOIN PIU' GROUP BY: vedi la nota in articoli_view. Misurato
		-- l'08/09/2026: SELECT * ... WHERE id = ? da 0,81 secondi a 0,011, un elenco di venti
		-- righe da 0,74 a 0,017.
		coalesce( ( SELECT group_concat( DISTINCT categorie_prodotti_path( pc.id_categoria ) SEPARATOR ' | ' )
			FROM prodotti_categorie AS pc
		   WHERE pc.id_prodotto = prodotti.id
		), '' ) AS categorie,
		prodotti.id_sito,
		prodotti.template,
		prodotti.schema_html,
		prodotti.tema_css,
		prodotti.se_sitemap,
		prodotti.se_cacheable,
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
		LEFT JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id
		LEFT JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia

;

-- | 202610041014

-- ruoli_file_view, copiata dal base
CREATE OR REPLACE VIEW ruoli_file_view AS
	SELECT
		ruoli_file.id,
		ruoli_file.id_genitore,
		ruoli_file.nome,
		ruoli_file.html_entity,
		ruoli_file.font_awesome,
		ruoli_file.se_anagrafica,
		ruoli_file.se_pagine,
		ruoli_file.se_prodotti,
		ruoli_file.se_articoli,
		ruoli_file.se_categorie_prodotti,
		ruoli_file.se_marchi,
		ruoli_file.se_notizie,
		ruoli_file.se_categorie_notizie,
		ruoli_file.se_risorse,
		ruoli_file.se_categorie_risorse,
		ruoli_file.se_mail,
		ruoli_file.se_immobili,
		ruoli_file.se_documenti,
	 	ruoli_file_path( ruoli_file.id ) AS __label__
	FROM ruoli_file
;

-- | 202610041015

-- ruoli_immagini_view, copiata dal base
CREATE OR REPLACE VIEW ruoli_immagini_view AS                   --
	SELECT                                                      --
		ruoli_immagini.id,                                      --
		ruoli_immagini.id_genitore,                             --
		ruoli_immagini.ordine_scalamento,                       --
		ruoli_immagini.nome,                                    --
		ruoli_immagini.html_entity,                             --
		ruoli_immagini.font_awesome,                            --
		ruoli_immagini.se_anagrafica,                           --
		ruoli_immagini.se_pagine,                               --
		ruoli_immagini.se_prodotti,                             --
		ruoli_immagini.se_articoli,                             --
		ruoli_immagini.se_categorie_prodotti,                   --
		ruoli_immagini.se_marchi,                   --
		ruoli_immagini.se_notizie,                              --
		ruoli_immagini.se_categorie_notizie,                    --
		ruoli_immagini.se_risorse,                              --
		ruoli_immagini.se_categorie_risorse,                    --
		ruoli_immagini.se_immobili,                             --
		ruoli_immagini.se_file,                             --
		ruoli_immagini.se_video,                             --
	 	ruoli_immagini_path(                                    --
            ruoli_immagini.id ) AS __label__                    -- etichetta per le tendine e le liste
	FROM ruoli_immagini                                         --
;

-- | 202610041016

-- pagamenti_view, copiata dal base
CREATE OR REPLACE VIEW `pagamenti_view` AS
	SELECT
		pagamenti.id,
		coalesce( pagamenti.id_tipologia, documenti.id_tipologia ) AS id_tipologia,
		pagamenti.codice,
		pagamenti.id_modalita_pagamento,
		concat(modalita_pagamento.codice, ' - ' ,modalita_pagamento.nome) AS modalita_pagamento,
		tipologie_pagamenti.nome AS tipologia,
		pagamenti.ordine,
		pagamenti.nome,
		pagamenti.note,
		pagamenti.note_pagamento,
		coalesce( pagamenti.id_documento, carrelli.id_documento, documenti_articoli.id_documento ) AS id_documento,
		pagamenti.id_carrello,
		pagamenti.id_carrelli_articoli,
        concat(
			tipologie_documenti.sigla,
			' ',
			documenti.numero,
			'/',
			year( documenti.data ),
			' del ',
			documenti.data
		) AS documento,
		tipologie_documenti.id AS id_tipologia_documento,
		group_concat( DISTINCT carrelli_articoli.id_articolo SEPARATOR '|' ) AS id_articoli,
		group_concat( DISTINCT COALESCE( categorie_progetti.id, cp_disc.id ) SEPARATOR '|' ) AS id_categorie_progetti,
		group_concat( DISTINCT COALESCE( categorie_progetti.nome, cp_disc.nome ) SEPARATOR '|' ) AS categorie_progetti,
		group_concat( DISTINCT COALESCE( categorie_progetti_path_find_ancestor( categorie_progetti.id ), categorie_progetti_path_find_ancestor( cp_disc.id ) ) ) AS id_aree,
		group_concat( DISTINCT COALESCE( aree.nome, aree_abb.nome ) ) AS aree,
		group_concat( DISTINCT concat( pagamenti.id_coupon, ':', pagamenti.coupon_valore ) SEPARATOR '|' ) AS dettagli_coupon,
		pagamenti.id_mastro_provenienza,
		m1.nome AS mastro_provenienza,
		pagamenti.id_mastro_destinazione,
		m2.nome AS mastro_destinazione,
		coalesce( documenti.id_emittente, pagamenti.id_creditore ) AS id_emittente,
		coalesce( a1.denominazione , concat( a1.cognome, ' ', a1.nome ), '' ) AS emittente,
		coalesce( documenti.id_destinatario, pagamenti.id_debitore ) AS id_destinatario,
		coalesce( a2.denominazione , concat( a2.cognome, ' ', a2.nome ), '' ) AS destinatario,
		pagamenti.id_iban,
		iban.iban AS iban,
		pagamenti.importo_lordo_totale,
		pagamenti.id_coupon,
		pagamenti.coupon_valore,
		pagamenti.importo_lordo_finale,
		pagamenti.id_listino,
		listini.nome AS listino,
		pagamenti.id_pianificazione,
		pagamenti.data_scadenza,
		day( pagamenti.data_scadenza ) as giorno_scadenza,
		month( pagamenti.data_scadenza ) as mese_scadenza,
		year( pagamenti.data_scadenza ) as anno_scadenza,
        documenti.data_archiviazione,
		pagamenti.timestamp_pagamento,
		from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) AS data_ora_pagamento,
		day( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as giorno_pagamento,
		month( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as mese_pagamento,
		year( from_unixtime( pagamenti.timestamp_pagamento, '%Y-%m-%d' ) ) as anno_pagamento,
		pagamenti.id_account_inserimento,
		pagamenti.id_account_aggiornamento,
		pagamenti.nome AS __label__
	FROM pagamenti
		LEFT JOIN tipologie_pagamenti ON tipologie_pagamenti.id = pagamenti.id_tipologia
		LEFT JOIN mastri AS m1 ON m1.id = pagamenti.id_mastro_provenienza
		LEFT JOIN mastri AS m2 ON m2.id = pagamenti.id_mastro_destinazione
		LEFT JOIN listini ON listini.id = pagamenti.id_listino
		LEFT JOIN modalita_pagamento ON modalita_pagamento.id = pagamenti.id_modalita_pagamento
		LEFT JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli
		LEFT JOIN carrelli ON carrelli.id = pagamenti.id_carrello
		LEFT JOIN documenti_articoli ON documenti_articoli.id_carrelli_articoli = carrelli_articoli.id
		LEFT JOIN documenti ON documenti.id = coalesce( pagamenti.id_documento, carrelli.id_documento, documenti_articoli.id_documento )
		LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
		LEFT JOIN anagrafica AS a1 ON a1.id = coalesce( documenti.id_emittente, pagamenti.id_creditore )
		LEFT JOIN anagrafica AS a2 ON a2.id = coalesce( documenti.id_destinatario, pagamenti.id_debitore )
		LEFT JOIN iban ON iban.id = pagamenti.id_iban
		LEFT JOIN coupon ON coupon.id = pagamenti.id_coupon
		LEFT JOIN contratti ON contratti.id = coupon.causale_id_contratto
		-- LEFT JOIN progetti ON progetti.id = contratti.id_progetto
		LEFT JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
		LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
		LEFT JOIN progetti ON IF( prodotti.id IS NOT NULL, progetti.id_prodotto = prodotti.id, progetti.id = contratti.id_progetto )
		LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
		LEFT JOIN categorie_progetti ON ( categorie_progetti.id = progetti_categorie.id_categoria AND categorie_progetti.se_disciplina = 1 )
		LEFT JOIN categorie_progetti AS aree ON aree.id = categorie_progetti_path_find_ancestor( categorie_progetti.id )
		LEFT JOIN tipologie_contratti AS tc_abb ON tc_abb.id_prodotto = prodotti.id AND tc_abb.se_abbonamento = 1
		-- la disciplina dell'abbonamento è memorizzata come metadati 'abbonamento|discipline' (multi-valore), non su tipologie_contratti.id_categoria_progetti
		LEFT JOIN metadati AS m_abb_disc ON m_abb_disc.id_tipologia_contratti = tc_abb.id AND m_abb_disc.nome = 'abbonamento|discipline'
		LEFT JOIN categorie_progetti AS cp_disc ON cp_disc.id = CAST( m_abb_disc.testo AS UNSIGNED ) AND cp_disc.se_disciplina = 1
		LEFT JOIN categorie_progetti AS aree_abb ON aree_abb.id = categorie_progetti_path_find_ancestor( cp_disc.id )
--	WHERE
--		tipologie_documenti.se_fattura = 1
--		OR
--		tipologie_documenti.se_nota_credito = 1
--		OR
--		tipologie_documenti.se_ricevuta = 1
--		OR
--		tipologie_documenti.se_pro_forma = 1
	GROUP BY pagamenti.id
;

-- | 202610041020

ALTER TABLE `mailing_mail` ADD UNIQUE KEY IF NOT EXISTS `unica_mail` (`id_mailing`, `id_mail`);

-- | FINE

-- 2026-11-03 — viste della geografia al canone: comuni, provincie, regioni, stati, zone_stati, indirizzi
--
-- Ordine di WEB03 del 03/11/2026, via Fabio. I blocchi delle viste nel file base _090000999999.views.sql stanno sotto
-- il livello di patch dei database esistenti, quindi le viste vive sono rimaste a versioni vecchie, senza colonne
-- che il canone ha ( data_archiviazione e id_successore di comuni, provincie, regioni e stati, nome di regioni, stato e
-- zona di zone_stati, id_zona di indirizzi ). Gruppo scelto con viste-esatte.py ( var/20261103-viste-ritardo/ di
-- glisweb ): su ognuno dei dieci database dei deploy letti da web03 la vista viva ha solo colonne del canone, e il
-- SELECT del canone gira con LIMIT 0, quindi la patch aggiunge colonne e non ne toglie. Nessuna query del codice,
-- standard o dei progetti, mette queste viste in JOIN con le colonne nuove senza qualificarle ( join.py ).
--
-- Un blocco per vista, con la definizione del file base copiata com'e'.
--
-- IDEMPOTENTE: CREATE OR REPLACE VIEW.

-- | 202611031600

-- comuni_view
CREATE OR REPLACE VIEW comuni_view AS                         --
	SELECT                                                    --
		comuni.id,                                            --
		comuni.id_provincia,                                  --
		provincie.nome AS provincia,                          --
		provincie.sigla AS sigla_provincia,                   --
		provincie.id_regione,                                 --
		regioni.nome AS regione,                              --
		regioni.id_stato,                                     --
		stati.nome AS stato,                                  --
		comuni.nome,                                          --
		comuni.codice_istat,                                  --
		comuni.codice_catasto,                                --
		comuni.data_archiviazione,                            --
		comuni.id_successore,                                 --
		concat(                                               --
			comuni.nome, ' ',                                 --
			coalesce(                                         --
                concat( '(', provincie.sigla, ') '),          --
                ' '                                           --
            ),                                                --
			stati.nome                                        --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM comuni                                               --
		INNER JOIN provincie                                  --
            ON provincie.id = comuni.id_provincia             --
		INNER JOIN regioni                                    --
            ON regioni.id = provincie.id_regione              --
		INNER JOIN stati                                      --
            ON stati.id = regioni.id_stato                    --
;

-- | 202611031601

-- provincie_view
CREATE OR REPLACE VIEW provincie_view AS                      --
	SELECT                                                    --
		provincie.id,                                         --
		provincie.id_regione,                                 --
		regioni.nome AS regione,                              --
		regioni.id_stato,                                     --
		stati.nome AS stato,                                  --
		provincie.nome,                                       --
		provincie.sigla,                                      --
		provincie.codice_istat,                               --
		provincie.data_archiviazione,                         --
		provincie.id_successore,                              --
		concat_ws(                                            --
			' ',                                              --
			provincie.nome,                                   --
			concat( '(', provincie.sigla, ')' ),              --
			stati.nome                                        --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM provincie                                            --
		INNER JOIN regioni                                    --
            ON regioni.id = provincie.id_regione              --
		INNER JOIN stati                                      --
            ON stati.id = regioni.id_stato                    --
;

-- | 202611031602

-- regioni_view
CREATE OR REPLACE VIEW regioni_view AS
	SELECT
		regioni.id,
		regioni.id_stato,
		stati.nome AS stato,
		regioni.nome,
		regioni.codice_istat,
		regioni.data_archiviazione,
		regioni.id_successore,
		concat_ws(
			' ',
			regioni.nome,
			stati.nome
		) AS __label__
	FROM regioni
		INNER JOIN stati ON stati.id = regioni.id_stato
;

-- | 202611031603

-- stati_view
CREATE OR REPLACE VIEW stati_view AS                          --
    SELECT                                                    --
		stati.id,                                             --
		stati.id_continente,                                  --
		continenti.nome AS continente,                        -- nome del continente
		stati.nome,                                           --
		stati.iso31661alpha2,                                 --
		stati.iso31661alpha3,                                 --
		stati.codice_istat,                                   --
		stati.data_archiviazione,                             --
		stati.id_successore,                                  --
		concat_ws(                                            --
			' ',                                              --
			continenti.nome,                                  --
			stati.nome                                        --
		) AS __label__                                        -- etichetta per le tendine e le liste
    FROM stati                                                --
    	INNER JOIN continenti                                 --
            ON continenti.id = stati.id_continente            --
;

-- | 202611031604

-- zone_stati_view
CREATE OR REPLACE VIEW zone_stati_view AS
	SELECT
		zone_stati.id,
		zone_stati.id_stato,
		stati.nome AS stato,
		zone_stati.id_zona,
		zone.nome AS zona,
		zone_stati.ordine,
		zone_stati.id_account_inserimento,
		zone_stati.id_account_aggiornamento,
		concat(zone_stati.id_stato, ' - ', zone_stati.id_zona) AS __label__
	FROM zone_stati
		LEFT JOIN stati ON stati.id = zone_stati.id_stato
		LEFT JOIN zone ON zone.id = zone_stati.id_zona
;

-- | 202611031605

-- indirizzi_view
CREATE OR REPLACE VIEW indirizzi_view AS
	SELECT
		indirizzi.id,
		indirizzi.id_tipologia,
		tipologie_indirizzi.nome AS tipologia,
		indirizzi.id_comune,
		comuni.nome AS comune,
		comuni.id_provincia,
		provincie.nome AS provincia,
		provincie.id_regione,
		regioni.nome AS regione,
		regioni.id_stato,
		stati.nome AS stato,
		indirizzi.localita,
		indirizzi.indirizzo,
		indirizzi.civico,
		indirizzi.cap,
		indirizzi.latitudine,
		indirizzi.longitudine,
		indirizzi.token,
		indirizzi.timestamp_geolocalizzazione,
		indirizzi.id_zona,
		indirizzi.id_account_inserimento,
		indirizzi.id_account_aggiornamento,
		concat_ws(
			' ',
			tipologie_indirizzi.nome,
			indirizzo,
			indirizzi.civico,
			indirizzi.cap,
			indirizzi.localita,
			comuni.nome,
			provincie.sigla
		) AS __label__
	FROM indirizzi
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
		LEFT JOIN regioni ON regioni.id = provincie.id_regione
		LEFT JOIN stati ON stati.id = regioni.id_stato
;

-- | FINE

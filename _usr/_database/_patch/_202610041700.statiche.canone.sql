-- 2026-10-04 — attivita_view, attivita_view_static e articoli_view_static come il canone
--
-- il commit 622c1907a ha ridefinito le statiche nel _080 e attivita_view nel _090 senza una patch che ci
-- portasse i DB vivi: su DEV e PROD attivita_view dava colonne diverse dal canone e alla statica ne
-- mancavano fino a 26 ( piu' l'indice codice ). Le statiche sono dati derivati: si ricostruiscono dalla vista
-- in una tabella nuova e si scambiano con RENAME, cosi' non restano mai vuote. Dimensioni di articoli a
-- decimal(12,5) come in articoli ( decisione del 02/10; il _080 diceva decimal(7,2) e arrotondava ).
-- Provata il 04/10 su tabelle zz_ in bernispa, crmfia, gimbe, polmasi dev e prod, utensilerialughese.

-- | 202610041700

CREATE OR REPLACE VIEW `attivita_view` AS                     --
	SELECT	                                                  --
		attivita.id,                                          --
		attivita.id_tipologia,                                --
		tipologie_attivita.nome AS tipologia,                 -- nome della tipologia
		attivita.codice,                                      --
		attivita.id_cliente,                                  --
		a2.codice AS codice_cliente,                          -- codice del cliente
		coalesce(                                             --
            a2.denominazione,                                 --
            concat(                                           --
                a2.cognome, ' ', a2.nome                      --
            ), ''                                             --
        ) AS cliente,                                         -- denominazione o cognome e nome del cliente
		attivita.id_contatto,                                 --
		c1.nome AS contatto,                                  -- nome del contatto
		attivita.id_indirizzo,                                --
		indirizzi.indirizzo AS indirizzo,                     -- indirizzo
		attivita.id_luogo,                                    --
		luoghi_path(                                          --
            coalesce(                                         --
                attivita.id_luogo, todo.id_luogo              --
            )                                                 --
        ) AS luogo,                                           -- percorso del luogo
		attivita.id_messaggio,                                --
		attivita.id_oggetto,                                  --
		concat( asset1.id, ' ', asset1.nome ) AS oggetto,     -- id e nome dell'oggetto
        coalesce(                                             --
            attivita.data_attivita,                           --
            attivita.data_programmazione                      --
        ) AS data_riferimento,                                -- data di riferimento per ordinamento
		coalesce(                                             --
            attivita.ora_inizio,                              --
            attivita.ora_inizio_programmazione                --
        ) AS ora_inizio_riferimento,                          -- ora di inizio di riferimento
		coalesce(                                             --
            attivita.ora_fine,                                --
            attivita.ora_fine_programmazione                  --
        ) AS ora_fine_riferimento,                            -- ora di fine di riferimento
		coalesce(                                             --
            a1.denominazione,                                 --
            concat(                                           --
                a1.cognome, ' ', a1.nome                      --
            ),                                                --
            a3.denominazione,                                 --
            concat(                                           --
                a3.cognome, ' ', a3.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica_riferimento,                          -- denominazione o cognome e nome dell'anagrafica di programmazione o di esecuzione
		attivita.data_scadenza,                               --
		attivita.ora_scadenza,                                --
		attivita.data_programmazione,                         --
		attivita.ora_inizio_programmazione,                   --
		attivita.ora_fine_programmazione,                     --
		attivita.id_anagrafica_programmazione,                --
		coalesce(                                             --
            a3.denominazione,                                 --
            concat(                                           --
                a3.cognome, ' ', a3.nome                      --
            ),                                                --
            ''                                                --
        ) AS anagrafica_programmazione,                       -- denominazione o cognome e nome dell'anagrafica di programmazione
		attivita.ore_programmazione,                          --
		attivita.se_confermata,                               --
		attivita.data_attivita,                               --
		day( data_attivita ) as giorno_attivita,              -- giorno di attivita
		month( data_attivita ) as mese_attivita,              -- mese di attivita
		year( data_attivita ) as anno_attivita,               -- anno di attivita
		attivita.ora_inizio,                                  --
		attivita.latitudine_ora_inizio,                       --
		attivita.longitudine_ora_inizio,                      --
		attivita.data_fine,                                   --
		attivita.ora_fine,                                    --
		attivita.latitudine_ora_fine,                         --
		attivita.longitudine_ora_fine,                        --
		attivita.id_anagrafica,                               --
		coalesce(                                             --
            a1.denominazione,                                 --
            concat( a1.cognome, ' ', a1.nome ),               --
            ''                                                --
        ) AS anagrafica,                                      -- denominazione o cognome e nome dell'anagrafica
		attivita.id_account,                                  --
		attivita.id_asset,                                    --
		concat( asset2.id, ' ', asset2.nome ) AS asset,       -- id e nome dell'asset
		attivita.ore,                                         --
        da.id_articolo,                                       -- id dell'articolo previsto
        da.quantita AS quantita_prevista,                     -- quantità prevista
		attivita.nome,                                        --
		attivita.id_documento,                                --
		concat(                                               --
			td.sigla,                                         --
			' ',                                              --
			documenti.numero,                                 --
			'/',                                              --
			documenti.sezionale,                              --
			' del ',                                          --
			documenti.data                                    --
		) AS documento,                                       -- tipologia, numero, sezionale e data del documento
		attivita.id_corrispondenza,                           --
		concat_ws(                                            --
            ' ',                                              --
            'da',                                             --
            coalesce(                                         --
                a4.denominazione,                             --
                concat( a4.cognome, ' ', a4.nome ),           --
                ''                                            --
            ),                                                --
            concat(                                           --
                '(',                                          --
                organizzazioni_path(                          --
                    cr.id_organizzazione_mittente             --
                ),                                            --   
                ')'                                           --
            ),                                                --
            tipologie_corrispondenza_path(                    --
                cr.id_tipologia                               --
            ),                                                --
            'per',                                            --
            coalesce(                                         --
                cr.destinatario_denominazione,                --
                concat(                                       --
                    cr.destinatario_cognome,                  --
                    ' ',                                      --
                    cr.destinatario_nome                      --
                ),                                            --
                ''                                            --
            )                                                 --
        ) AS corrispondenza,                                  -- descrizione della corrispondenza
		attivita.id_progetto,                                 --
		progetti.nome AS progetto,                            -- nome del progetto
		attivita.id_contratto,                                --
		concat_ws(                                            --
            ' ',                                              --
            tc.nome,                                          --
            c.nome                                            --
        ) AS contratto,                                       -- tipologia e nome del contratto
		group_concat(                                         --
            DISTINCT                                          --
            if(                                               --
                d.id,                                         --
                categorie_progetti_path( d.id ),              --
                null                                          --
            )                                                 --
            SEPARATOR ' | '                                   --
        ) AS discipline,                                      -- elenco delle discipline del progetto separate da |
		attivita.id_matricola,                                --
        attivita.id_immobile,                                 --
        attivita.id_step,                                     --
        step.nome AS step,                                    -- nome dello step
		attivita.id_pianificazione,                           --
		attivita.id_todo,                                     --
		todo.nome AS todo,                                    -- nome del todo
		attivita.id_mastro_provenienza,                       --
		m1.nome AS mastro_provenienza,                        --
		attivita.id_mastro_destinazione,                      --
		m2.nome AS mastro_destinazione,                       --
		attivita.codice_archivium,                            --
		attivita.token,                                       --
		attivita.id_account_inserimento,                      --
		attivita.timestamp_inserimento,                       --
		attivita.id_account_aggiornamento,                    --
		attivita.timestamp_aggiornamento,                     --
		attivita.data_archiviazione,                          --
		concat(                                               --
			attivita.nome,                                    --
			' / ',                                            --
			attivita.ore,                                     --
			' / ',                                            --
			coalesce(                                         --
                a1.denominazione,                             --
                concat(                                       --
                    a1.cognome,                               --
                    ' ',                                      --
                    a1.nome                                   --
                ),                                            --
                ''                                            --
            )                                                 --
		) AS __label__                                        -- etichetta per le tendine e le liste
	FROM attivita                                             --
		LEFT JOIN tipologie_attivita                          --
            ON tipologie_attivita.id = attivita.id_tipologia  --
		LEFT JOIN anagrafica AS a1                            --
            ON a1.id = attivita.id_anagrafica                 --
		LEFT JOIN anagrafica AS a2                            --
            ON a2.id = attivita.id_cliente                    --
		LEFT JOIN anagrafica AS a3                            --
            ON a3.id = attivita.id_anagrafica_programmazione  --
		LEFT JOIN anagrafica AS a4                            --
            ON a4.id = attivita.id_corrispondenza             --
		LEFT JOIN contatti AS c1                              --
            ON c1.id = attivita.id_contatto                   --
		LEFT JOIN todo                                        --
            ON todo.id = attivita.id_todo                     --
		LEFT JOIN step                                        --
            ON step.id = attivita.id_step                     --
		LEFT JOIN progetti_categorie AS pc                    --
            ON pc.id_progetto = attivita.id_progetto          --
		LEFT JOIN progetti                                    --
            ON progetti.id = coalesce(                        --
                attivita.id_progetto,                         --
                todo.id_progetto                              --
            )                                                 --
		LEFT JOIN categorie_progetti                          --
            ON categorie_progetti.id = pc.id_categoria        --
		LEFT JOIN categorie_progetti AS d                     --
            ON d.id = pc.id_categoria                         --
                AND d.se_disciplina = 1                       --
		LEFT JOIN indirizzi                                   --
            ON indirizzi.id = attivita.id_indirizzo           --
		LEFT JOIN mastri AS m1                                --
            ON m1.id = attivita.id_mastro_provenienza         --
		LEFT JOIN mastri AS m2                                --
            ON m2.id = attivita.id_mastro_destinazione        --
		LEFT JOIN documenti                                   --
            ON documenti.id = attivita.id_documento           --
		LEFT JOIN tipologie_documenti AS td                   --
            ON td.id = documenti.id_tipologia                 --
		LEFT JOIN contratti AS c                              --
            ON c.id = attivita.id_contratto                   --
		LEFT JOIN tipologie_contratti AS tc                   --
            ON tc.id = c.id_tipologia                         --
		LEFT JOIN corrispondenza AS cr                        --
            ON cr.id = attivita.id_corrispondenza             --
		LEFT JOIN organizzazioni AS o                         --
            ON o.id = cr.id_organizzazione_mittente           --
		LEFT JOIN tipologie_corrispondenza AS tc2             --
            ON tc2.id = cr.id_tipologia                       --
		LEFT JOIN asset AS asset1                             --
            ON asset1.id = attivita.id_asset                  --
		LEFT JOIN asset AS asset2                             --
            ON asset2.id = attivita.id_asset                  --
        LEFT JOIN documenti_articoli AS da                    --
            ON da.id = todo.id_documenti_articoli             --
	GROUP BY attivita.id                                      --
;

-- | 202610041701

DROP TABLE IF EXISTS `attivita_view_static__nuova`;

-- | 202610041702

CREATE TABLE `attivita_view_static__nuova` (
  `id` bigint(20) PRIMARY KEY NOT NULL,
  `id_tipologia` bigint(20) DEFAULT NULL,
  `tipologia` char(64) DEFAULT NULL,
  `codice` char(64) DEFAULT NULL,
  `id_cliente` bigint(20) DEFAULT NULL,
  `codice_cliente` char(64) DEFAULT NULL,
  `cliente` char(255) DEFAULT NULL,
  `id_contatto`	bigint(20) DEFAULT NULL,
  `contatto`	char(255) DEFAULT NULL,
  `id_indirizzo` bigint(20) DEFAULT NULL,
  `indirizzo` text,
  `id_luogo` bigint(20) DEFAULT NULL,
  `luogo` char(255) DEFAULT NULL,
  `id_messaggio` bigint(20) DEFAULT NULL,
  `id_oggetto` bigint(20) DEFAULT NULL,
  `oggetto` char(255) DEFAULT NULL,
  `data_riferimento` date DEFAULT NULL,
  `ora_inizio_riferimento` time DEFAULT NULL,
  `ora_fine_riferimento` time DEFAULT NULL,
  `anagrafica_riferimento` char(255) DEFAULT NULL,
  `data_scadenza` date DEFAULT NULL,
  `ora_scadenza` time DEFAULT NULL,
  `data_programmazione` date DEFAULT NULL,
  `ora_inizio_programmazione` time DEFAULT NULL,
  `ora_fine_programmazione` time DEFAULT NULL,
  `id_anagrafica_programmazione` bigint(20) DEFAULT NULL,
  `anagrafica_programmazione` char(255) DEFAULT NULL,
  `ore_programmazione` decimal(5,2) DEFAULT NULL,
  `se_confermata` tinyint(1) DEFAULT NULL,
  `data_attivita` date DEFAULT NULL,
  `giorno_attivita` int(2) DEFAULT NULL,
  `mese_attivita` int(2) DEFAULT NULL,
  `anno_attivita` int(4) DEFAULT NULL,
  `ora_inizio` time DEFAULT NULL,
  `latitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_inizio` decimal(11,7) DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `ora_fine` time DEFAULT NULL,
  `latitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `longitudine_ora_fine` decimal(11,7) DEFAULT NULL,
  `id_anagrafica` bigint(20) DEFAULT NULL,
  `anagrafica` char(255) DEFAULT NULL,
  `id_account` bigint(20) DEFAULT NULL,
  `id_asset` bigint(20) DEFAULT NULL,
  `asset` char(255) DEFAULT NULL,
  `ore` decimal(5,2) DEFAULT NULL,
  `id_articolo` bigint(20) DEFAULT NULL,
  `quantita_prevista` decimal(9,2) DEFAULT NULL,
  `nome` char(255) DEFAULT NULL,
  `id_documento` bigint(20) DEFAULT NULL,
  `documento` char(255) DEFAULT NULL,
  `id_corrispondenza` bigint(20) DEFAULT NULL,
  `corrispondenza` char(255) DEFAULT NULL,
  `id_progetto` bigint(20) DEFAULT NULL,
  `progetto` char(255) DEFAULT NULL,
  `id_contratto` bigint(20) DEFAULT NULL,
  `contratto` char(255) DEFAULT NULL,
  `discipline` char(255) DEFAULT NULL,
  `id_matricola` bigint(20) DEFAULT NULL,
  `id_immobile` bigint(20) DEFAULT NULL,
  `id_step` bigint(20) DEFAULT NULL,
  `step` char(255) DEFAULT NULL,
  `id_pianificazione`	bigint(20) DEFAULT NULL,
  `id_todo` bigint(20) DEFAULT NULL,
  `todo` char(255) DEFAULT NULL,
  `id_mastro_provenienza` bigint(20) DEFAULT NULL,
  `mastro_provenienza` char(64) DEFAULT NULL,
  `id_mastro_destinazione` bigint(20) DEFAULT NULL,
  `mastro_destinazione` char(64) DEFAULT NULL,
  `codice_archivium` char(128) DEFAULT NULL,
  `token` char(128) DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `__label__` text,
  UNIQUE KEY `codice` (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610041703

INSERT INTO `attivita_view_static__nuova` SELECT * FROM `attivita_view`;

-- | 202610041704

RENAME TABLE `attivita_view_static` TO `attivita_view_static__vecchia`, `attivita_view_static__nuova` TO `attivita_view_static`;

-- | 202610041705

DROP TABLE `attivita_view_static__vecchia`;

-- | 202610041706

DROP TABLE IF EXISTS `articoli_view_static__nuova`;

-- | 202610041707

CREATE TABLE `articoli_view_static__nuova` (
  `id_tipologia_pubblicazione` bigint(20) DEFAULT NULL,       -- le prime tre come in articoli_view ( 2026-10-04 )
  `pubblicazione` char(32) DEFAULT NULL,
  `tipologia_listino` char(64) DEFAULT NULL,
  `id` bigint(20) PRIMARY KEY NOT NULL,
  `codice` char(32) DEFAULT NULL,
  `id_prodotto` bigint(20) DEFAULT NULL,
  `prodotto` char(255) DEFAULT NULL,
  `ordine` int(11) DEFAULT NULL,
  `ean` char(32) DEFAULT NULL,
  `isbn` char(32) DEFAULT NULL,
  `id_reparto` bigint(20) DEFAULT NULL,
  `id_taglia` bigint(20) DEFAULT NULL,
  `id_colore` bigint(20) DEFAULT NULL,
  `id_periodicita` bigint(20) DEFAULT NULL,
  `periodicita` char(32) DEFAULT NULL,
  `id_tipologia_rinnovo` bigint(20) DEFAULT NULL,
  `tipologia_rinnovo` char(32) DEFAULT NULL,
  `larghezza` decimal(12,5) DEFAULT NULL,
  `lunghezza` decimal(12,5) DEFAULT NULL,
  `altezza` decimal(12,5) DEFAULT NULL,
  `id_udm_dimensioni` bigint(20) DEFAULT NULL,
  `udm_dimensioni` char(32) DEFAULT NULL,
  `peso` decimal(12,5) DEFAULT NULL,
  `id_udm_peso` bigint(20) DEFAULT NULL,
  `udm_peso` char(32) DEFAULT NULL,
  `volume` decimal(12,5) DEFAULT NULL,
  `id_udm_volume` bigint(20) DEFAULT NULL,
  `udm_volume` char(32) DEFAULT NULL,
  `capacita` decimal(12,5) DEFAULT NULL,
  `id_udm_capacita` bigint(20) DEFAULT NULL,
  `udm_capacita` char(32) DEFAULT NULL,
  `durata` decimal(12,5) DEFAULT NULL,
  `id_udm_durata` bigint(20) DEFAULT NULL,
  `udm_durata` char(32) DEFAULT NULL,
  `nome` varchar(512) DEFAULT NULL,
  `id_categorie` char(255) DEFAULT NULL,
  `categorie` char(255) DEFAULT NULL,
  `prezzi` text DEFAULT NULL,
  `data_archiviazione` date DEFAULT NULL,
  `id_account_inserimento` bigint(20) DEFAULT NULL,
  `timestamp_inserimento` int(11) DEFAULT NULL,
  `id_account_aggiornamento` bigint(20) DEFAULT NULL,
  `timestamp_aggiornamento` int(11) DEFAULT NULL,
  `__label__` text,
  UNIQUE KEY `codice` (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202610041708

INSERT INTO `articoli_view_static__nuova` SELECT * FROM `articoli_view`;

-- | 202610041709

RENAME TABLE `articoli_view_static` TO `articoli_view_static__vecchia`, `articoli_view_static__nuova` TO `articoli_view_static`;

-- | 202610041710

DROP TABLE `articoli_view_static__vecchia`;

-- | FINE

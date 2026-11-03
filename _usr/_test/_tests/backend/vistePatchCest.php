<?php

    /**
     * test delle patch che portano al canone le viste rimaste indietro
     *
     * i blocchi delle viste nel file base _090000999999.views.sql stanno sotto il livello di patch dei database
     * esistenti, che quindi tengono le viste alla versione in cui sono nati; dal 2026-11-03 le viste rimaste indietro
     * si portano al canone con patch datate per gruppi ( ordine di WEB03 ), e questo test guarda, gruppo per gruppo, che
     * ogni vista esponga tutte le colonne del file base: e' rosso su un database dove la patch del gruppo non e' passata
     * e la vista e' vecchia, verde dopo
     *
     */

    class vistePatchCest {

        // patch 202611031600: viste della geografia
        public function visteGeografia( BackendTester $I ) {

            $this->vedoColonne( $I, array(
                'comuni_view' => 'id, id_provincia, provincia, sigla_provincia, id_regione, regione, id_stato, stato, nome, codice_istat, codice_catasto, data_archiviazione, id_successore, __label__',
                'provincie_view' => 'id, id_regione, regione, id_stato, stato, nome, sigla, codice_istat, data_archiviazione, id_successore, __label__',
                'regioni_view' => 'id, id_stato, stato, nome, codice_istat, data_archiviazione, id_successore, __label__',
                'stati_view' => 'id, id_continente, continente, nome, iso31661alpha2, iso31661alpha3, codice_istat, data_archiviazione, id_successore, __label__',
                'zone_stati_view' => 'id, id_stato, stato, id_zona, zona, ordine, id_account_inserimento, id_account_aggiornamento, __label__',
                'indirizzi_view' => 'id, id_tipologia, tipologia, id_comune, comune, id_provincia, provincia, id_regione, regione, id_stato, stato, localita, indirizzo, civico, cap, latitudine, longitudine, token, timestamp_geolocalizzazione, id_zona, id_account_inserimento, id_account_aggiornamento, __label__'
            ) );

        }

        // patch 202611031700: viste dell'anagrafica
        public function visteAnagrafica( BackendTester $I ) {

            $this->vedoColonne( $I, array(
                'anagrafica_categorie_view' => 'id, ordine, id_anagrafica, anagrafica, id_categoria, categoria, id_account_inserimento, id_account_aggiornamento, __label__',
                'anagrafica_certificazioni_view' => 'id, id_anagrafica, anagrafica, id_certificazione, certificazione, id_emittente, emittente, nome, codice, data_emissione, data_scadenza, data_ora_inserimento, __label__',
                'anagrafica_consensi_view' => 'id, id_account, id_anagrafica, anagrafica, id_mail, mail, id_consenso, se_prestato, timestamp_consenso, id_account_inserimento, id_account_aggiornamento, __label__',
                'anagrafica_settori_view' => 'id, id_anagrafica, id_settore, ateco, settore, ordine, id_account_inserimento, id_account_aggiornamento, __label__',
                'consensi_moduli_view' => 'id, ordine, nome, id_lingua, lingua, id_consenso, codice_consenso, consenso, modulo, azione, informativa, pagina, note, se_richiesto, id_account_inserimento, id_account_aggiornamento, __label__',
                'url_view' => 'id, id_tipologia, tipologia, id_anagrafica, anagrafica, url, nome, username, password, id_account_inserimento, id_account_aggiornamento, __label__',
                'immobili_anagrafica_view' => 'id, ordine, id_immobile, id_anagrafica, anagrafica, id_ruolo, ruolo, note, id_account_inserimento, id_account_aggiornamento, __label__',
                'progetti_anagrafica_view' => 'id, ordine, id_progetto, progetto, id_anagrafica, anagrafica, id_ruolo, ruolo, note, se_sostituto, id_account_inserimento, id_account_aggiornamento, __label__'
            ) );

        }

        // patch 202611031800: viste del catalogo
        public function visteCatalogo( BackendTester $I ) {

            $this->vedoColonne( $I, array(
                'prodotti_caratteristiche_view' => 'id, ordine, id_prodotto, id_caratteristica, id_lingua, caratteristica, valore, note, id_account_inserimento, id_account_aggiornamento, __label__',
                'categorie_prodotti_view' => 'id, id_genitore, ordine, codice, nome, template, schema_html, tema_css, se_sitemap, se_cacheable, id_sito, id_pagina, data_archiviazione, figli, membri, id_account_inserimento, id_account_aggiornamento, __label__',
                'categorie_notizie_view' => 'id, id_genitore, ordine, codice, nome, template, schema_html, tema_css, se_sitemap, se_cacheable, id_sito, id_pagina, data_archiviazione, figli, membri, id_account_inserimento, id_account_aggiornamento, __label__',
                'colori_view' => 'id, id_genitore, nome, hex, r, g, b, ral, pantone, c, m, y, k, css, __label__',
                'coupon_articoli_view' => 'id, ordine, id_coupon, id_articolo, articolo, gruppo_alternative, id_account_inserimento, id_account_aggiornamento, __label__',
                'sconti_view' => 'id, id_tipologia, tipologia, nome, id_valuta, valuta, sconto_percentuale, sconto_fisso, qta_min, note, timestamp_inizio, data_ora_inizio, timestamp_fine, data_ora_fine, id_account_inserimento, timestamp_inserimento, id_account_aggiornamento, timestamp_aggiornamento, __label__',
                'listini_view' => 'id, id_genitore, id_tipologia, tipologia, codice, nome, id_emittente, emittente, id_valuta, valuta, sconto_su_genitore, note, se_default_su_genitore, data_archiviazione, id_account_inserimento, id_account_aggiornamento, __label__',
                'listini_clienti_view' => 'id, ordine, id_listino, listino_codice, listino, id_cliente, cliente, cliente_nome, cliente_cognome, cliente_denominazione, cliente_codice_fiscale, cliente_codice, id_account_inserimento, id_account_aggiornamento, __label__',
                'listini_zone_view' => 'id, ordine, id_listino, listino_codice, listino, id_zona, zona, id_account_inserimento, id_account_aggiornamento, __label__',
                'mastri_articoli_view' => 'id, ordine, codice, id_mastro, mastro, id_articolo, articolo, id_ruolo, ruolo, scorta_minima, scorta_massima, id_udm, udm, note, id_account_inserimento, id_account_aggiornamento, __label__',
                'colli_view' => 'id, id_genitore, id_tipologia, tipologia, ordine, codice, nome, id_anagrafica, anagrafica, id_documento, id_mittente, mittente, id_destinatario, destinatario, id_mastro, mastro, raggruppamento, larghezza, lunghezza, altezza, id_udm_dimensioni, peso, id_udm_peso, volume, id_udm_volume, pezzi, note, destinatari, timestamp_chiusura, note_chiusura, chiuso, timestamp_spedizione, note_spedizione, id_account_inserimento, id_account_aggiornamento, __label__'
            ) );

        }

        /**
         * verifica che ogni vista abbia tutte le colonne attese
         *
         * @param       BackendTester   $I          il tester
         * @param       array           $viste      vista => colonne del file base, separate da virgola
         *
         */
        protected function vedoColonne( BackendTester $I, $viste ) {

            foreach( $viste as $vista => $attese ) {

                $vive = explode( ',', (string) $I->grabFromDatabase(
                    'SELECT group_concat( column_name ORDER BY ordinal_position ) FROM information_schema.columns WHERE table_schema = database() AND table_name = ?',
                    array( $vista )
                ) );

                $mancanti = array_values( array_diff( array_map( 'trim', explode( ',', $attese ) ), $vive ) );

                $I->assertEquals( array(), $mancanti, $vista . ' senza ' . implode( ', ', $mancanti ) );

            }

        }

    }

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

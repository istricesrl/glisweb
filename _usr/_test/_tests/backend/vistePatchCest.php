<?php

    /**
     * test delle patch che portano al canone le viste rimaste indietro
     *
     * i blocchi delle viste nel file base _090000999999.views.sql stanno sotto il livello di patch dei database
     * esistenti, che quindi tengono le viste alla versione in cui sono nati; dal 2026-11-03 le viste rimaste indietro
     * si portano al canone con patch datate ( ordine di WEB03 ), e questo test guarda, patch per patch, che ogni vista
     * esponga tutte le colonne del file base: e' rosso su un database dove la patch non e' passata e la vista e'
     * vecchia, verde dopo
     *
     */

    class vistePatchCest {

        // patch 202611031900: job_view, lingue_view, mailing_view
        public function visteJobLingueMailing( BackendTester $I ) {

            $this->vedoColonne( $I, array(
                'job_view' => 'id, nome, job, totale, corrente, iterazioni, delay, token, se_foreground, timestamp_apertura, velocita, proiezione, data_ora_apertura, timestamp_esecuzione, data_ora_esecuzione, timestamp_completamento, data_ora_completamento, id_account_inserimento, id_account_aggiornamento, __label__',
                'lingue_view' => 'id, nome, note, iso6391alpha2, iso6393alpha3, ietf, __label__',
                'mailing_view' => 'id, nome, note, timestamp_invio, data_ora_invio, id_account_inserimento, id_account_aggiornamento, __label__'
            ) );

        }

        // patch 202611061200: caratteristiche_prodotti si scrive, come promette il suo commento; con una colonna
        // derivata la INSERT prende l'errore 1471 e haveInDatabase() fallisce
        public function vistaCaratteristicheProdottiInseribile( BackendTester $I ) {

            $I->deleteTestRecords( 'caratteristiche', 'nome' );

            $nome = $I->grabTestName( 'caratteristica-vista' );

            $id = $I->haveInDatabase( 'caratteristiche_prodotti', array( 'nome' => $nome, 'se_articolo' => 1 ) );

            $I->seeInDatabase( 'caratteristiche', array( 'id' => $id, 'nome' => $nome, 'se_articoli' => 1 ) );

            $I->deleteTestRecords( 'caratteristiche', 'nome' );

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

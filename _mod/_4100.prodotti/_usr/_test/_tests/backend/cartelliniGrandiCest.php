<?php

    /**
     * test della stampa dei cartellini grandi degli articoli
     *
     * il PDF legge le caratteristiche dell'articolo e del prodotto da articoli_caratteristiche_view e
     * prodotti_caratteristiche_view; fino al 2026-11-03 chiedeva una colonna testo che nessuna delle due viste ha mai
     * avuto ( il valore sta in valore ), e su utensilerialughese la vista degli articoli era anche quella vecchia senza
     * caratteristica: la query moriva con 1054 e il cartellino usciva senza caratteristiche, a stampa riuscita
     *
     * il PDF non si legge, quindi il test guarda che esca un PDF e che la richiesta non scriva niente in mysql.err
     *
     */

    class cartelliniGrandiCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie i record di test, prima le righe che puntano al prodotto e all'articolo
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'articoli_caratteristiche', 'valore' );
            $I->deleteTestRecords( 'prodotti_caratteristiche', 'valore' );
            $I->deleteTestRecords( 'caratteristiche', 'nome' );
            $I->deleteTestRecords( 'articoli', 'nome' );
            $I->deleteTestRecords( 'prodotti', 'nome' );

        }

        // il cartellino di un prodotto con caratteristiche sull'articolo e sul prodotto esce senza errori MySQL
        public function caratteristicheSenzaErrori( BackendTester $I ) {

            // dove le viste delle caratteristiche sono ancora quelle vecchie ( blocchi del file base sotto il livello di patch
            // del database ) la stampa muore con 1054: la patch che le porta al canone e' in revisione, fino ad allora si salta
            foreach( array( 'articoli_caratteristiche_view', 'prodotti_caratteristiche_view' ) as $vista ) {
                foreach( array( 'caratteristica', 'valore' ) as $colonna ) {
                    if( ! $I->grabFromDatabase( 'SELECT count(*) FROM information_schema.columns WHERE table_schema = database() AND table_name = ? AND column_name = ?', array( $vista, $colonna ) ) ) {
                        $I->markTestSkipped( $vista . ' senza ' . $colonna . ': vista ferma a prima del canone' );
                    }
                }
            }

            $prodotto = $I->haveInDatabase( 'prodotti', array( 'nome' => $I->grabTestName( 'cartellini' ) ) );
            $articolo = $I->haveInDatabase( 'articoli', array( 'id_prodotto' => $prodotto, 'nome' => $I->grabTestName( 'cartellini' ) ) );
            $caratteristica = $I->haveInDatabase( 'caratteristiche', array( 'nome' => $I->grabTestName( 'cartellini' ) ) );

            $I->haveInDatabase( 'articoli_caratteristiche', array( 'id_articolo' => $articolo, 'id_caratteristica' => $caratteristica, 'valore' => $I->grabTestName( 'articolo' ) ) );
            $I->haveInDatabase( 'prodotti_caratteristiche', array( 'id_prodotto' => $prodotto, 'id_caratteristica' => $caratteristica, 'valore' => $I->grabTestName( 'prodotto' ) ) );

            // le richieste dei test scrivono i log in var/log/test/ ( vedi _src/_config/_020.debug.php )
            $log = DIR_VAR_LOG . 'test/mysql.err.' . date( 'Ym' ) . '.log';
            $prima = ( file_exists( $log ) ) ? filesize( $log ) : 0;

            $account = $I->grabTestAccount( 'roots' );
            $pdf = $this->scarica( '/_mod/_4100.prodotti/_src/_api/_print/_cartellini.grandi.articoli.pdf.php?prodotto=' . $prodotto, $account['username'], $account['password'] );

            clearstatcache();

            $I->assertStringStartsWith( '%PDF', $pdf );
            $I->assertEquals( $prima, ( file_exists( $log ) ) ? filesize( $log ) : 0, 'la stampa ha scritto in ' . $log );

        }

        /**
         * scarica il PDF senza browser, con l'header HTTP Basic, come authCest
         *
         * @return      string                      il contenuto della risposta
         *
         */
        protected function scarica( $pagina, $user, $pasw ) {

            global $cf;

            $raw = NULL;
            $status = NULL;
            $headers = array();

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, $headers, $user, $pasw, $error, NULL, CURLAUTH_BASIC, $raw );

            return (string) $raw;

        }

    }

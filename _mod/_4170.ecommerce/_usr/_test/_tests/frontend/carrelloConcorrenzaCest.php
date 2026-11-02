<?php

    /**
     * test delle richieste concorrenti al carrello
     *
     * con le sessioni su Redis PHP non serializza le richieste della stessa sessione: due richieste __carrello__
     * identiche nello stesso secondo, da un browser che non ha ancora un carrello, entrano insieme nello STEP 2 di
     * _750.controller.php; la seconda trova a database il carrello appena creato dalla prima, lo cancella come
     * carrello vecchio della sessione, e la prima fallisce scrivendo le righe su un carrello che non c'è più
     * ( 1452 carrelli_articoli_ibfk_01, polmasi 2026-10-30 12:12:35, 5 doppie su 2118 a ottobre ); dal 2026-10-30
     * il controller prende un lock per sessione, e le due richieste passano una dopo l'altra; le coppie si
     * sparano con curl_multi da sessioni nuove, e i carrelli si riconoscono dal nome dell'intestatario che porta il
     * prefisso TEST-E2E-
     *
     */

    class carrelloConcorrenzaCest {

        // pulizia prima del test
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // pulizia dopo il test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // prepara una richiesta curl verso la pagina del carrello, con la sessione data
        protected function richiesta( $sessione, $parametri = array() ) {

            global $cf;

            $url = rtrim( $cf['site']['url'], '/' ) . $cf['contents']['pages']['carrello']['path'][ $cf['localization']['language']['ietf'] ]
                . ( ( $parametri ) ? '?' . http_build_query( $parametri ) : '' );

            $ch = curl_init( $url );
            curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
            curl_setopt( $ch, CURLOPT_HEADER, true );
            curl_setopt( $ch, CURLOPT_TIMEOUT, 30 );
            curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, false );
            curl_setopt( $ch, CURLOPT_SSL_VERIFYHOST, 0 );
            curl_setopt( $ch, CURLOPT_USERAGENT, getenv( 'GLISWEB_TEST_USER_AGENT' ) );

            if( $sessione ) {
                curl_setopt( $ch, CURLOPT_COOKIE, 'PHPSESSID=' . $sessione );
            }

            return $ch;

        }

        // apre una sessione nuova, senza carrello, e ne restituisce l'id
        protected function apriSessione( FrontendTester $I ) {

            $ch = $this->richiesta( NULL );
            $risposta = curl_exec( $ch );
            curl_close( $ch );

            if( ! preg_match( '/^Set-Cookie:\s*PHPSESSID=([^;\s]+)/mi', (string) $risposta, $m ) ) {
                $I->fail( 'la pagina del carrello non ha aperto una sessione' );
            }

            return $m[1];

        }

        // due richieste identiche nello stesso istante lasciano un carrello solo, con la sua riga
        public function richiesteConcorrentiUnCarrello( FrontendTester $I ) {

            $articolo = $I->grabFromDatabase( 'SELECT id FROM articoli ORDER BY id DESC LIMIT 1' );
            if( empty( $articolo ) ) {
                $I->fail( 'nessun articolo a catalogo per il test' );
            }

            // la corsa non esce a ogni coppia: se ne sparano diverse
            for( $i = 1; $i <= 8; $i++ ) {

                $nome = $I->grabTestName( 'coppia' . $i );
                $sessione = $this->apriSessione( $I );

                $parametri = array( '__carrello__' => array(
                    'intestazione_nome' => $nome,
                    '__articolo__' => array( 'id_articolo' => $articolo, 'quantita' => 1 )
                ) );

                // le due richieste partono insieme
                $mh = curl_multi_init();
                $handles = array( $this->richiesta( $sessione, $parametri ), $this->richiesta( $sessione, $parametri ) );
                foreach( $handles as $ch ) {
                    curl_multi_add_handle( $mh, $ch );
                }
                do {
                    curl_multi_exec( $mh, $attive );
                    curl_multi_select( $mh );
                } while( $attive > 0 );
                foreach( $handles as $ch ) {
                    curl_multi_remove_handle( $mh, $ch );
                    curl_close( $ch );
                }
                curl_multi_close( $mh );

                // un carrello solo per la sessione, ed è quello col nome della richiesta
                $carrelli = (int) $I->grabFromDatabase( 'SELECT count(*) FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
                $I->assertEquals( 1, $carrelli, 'carrelli della coppia ' . $i );

                // il carrello rimasto ha la sua riga
                $id = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
                $righe = (int) $I->grabFromDatabase( 'SELECT count(*) FROM carrelli_articoli WHERE id_carrello = ?', array( $id ) );
                $I->assertEquals( 1, $righe, 'righe del carrello della coppia ' . $i );

            }

        }

        // il carrello cancellato mentre la richiesta aspetta il lock non riceve righe
        // NOTA la richiesta passa lo STEP 0.1 col carrello ancora vivo, poi si ferma sul lock che tiene il test, sulla
        // connessione dell'helper; il test cancella il carrello, come faceva una richiesta sorella allo STEP 2, e
        // rilascia il lock; senza lo STEP 1.2 le righe andavano sul carrello cancellato ( 1452 carrelli_articoli_ibfk_01,
        // polmasi 2026-11-02 09:42:35 ) e lo STEP 8 lo ricreava vuoto
        public function carrelloCancellatoDuranteIlLock( FrontendTester $I ) {

            global $cf;

            $articolo = $I->grabFromDatabase( 'SELECT id FROM articoli ORDER BY id DESC LIMIT 1' );
            if( empty( $articolo ) ) {
                $I->fail( 'nessun articolo a catalogo per il test' );
            }

            $nome = $I->grabTestName( 'lock' );
            $sessione = $this->apriSessione( $I );
            $nomeLock = 'concat( "carrello.", md5( concat( database(), ".carrello.", ? ) ) )';

            $parametri = array( '__carrello__' => array(
                'intestazione_nome' => $nome,
                '__articolo__' => array( 'id_articolo' => $articolo, 'quantita' => 1 )
            ) );

            // la prima richiesta crea il carrello della sessione
            $ch = $this->richiesta( $sessione, $parametri );
            curl_exec( $ch );
            curl_close( $ch );
            $vecchio = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
            if( empty( $vecchio ) ) {
                $I->fail( 'la prima richiesta non ha creato il carrello' );
            }

            // il test prende il lock del carrello della sessione, con lo stesso nome del controller
            $lock = $I->grabFromDatabase( 'SELECT GET_LOCK( ' . $nomeLock . ', 0 )', array( $sessione ) );
            $I->assertEquals( 1, (int) $lock, 'lock del carrello preso dal test' );

            // la seconda richiesta parte e si ferma sul lock
            $mh = curl_multi_init();
            $ch = $this->richiesta( $sessione, $parametri );
            curl_multi_add_handle( $mh, $ch );
            $inAttesa = 0;
            for( $t = 0; $t < 100 && ! $inAttesa; $t++ ) {
                curl_multi_exec( $mh, $attive );
                curl_multi_select( $mh, 0.1 );
                $inAttesa = (int) $I->grabFromDatabase(
                    'SELECT count(*) FROM information_schema.processlist WHERE id <> connection_id() AND info LIKE "%GET_LOCK%carrello.%"'
                );
            }

            // il carrello sparisce mentre la richiesta aspetta, poi il lock si rilascia
            if( $inAttesa ) {
                mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM carrelli_articoli WHERE id_carrello = ?', array( array( 's' => $vecchio ) ) );
                mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM carrelli WHERE id = ?', array( array( 's' => $vecchio ) ) );
            }
            $I->grabFromDatabase( 'SELECT RELEASE_LOCK( ' . $nomeLock . ' )', array( $sessione ) );

            // la richiesta finisce
            do {
                curl_multi_exec( $mh, $attive );
                curl_multi_select( $mh );
            } while( $attive > 0 );
            curl_multi_remove_handle( $mh, $ch );
            curl_close( $ch );
            curl_multi_close( $mh );

            if( ! $inAttesa ) {
                $I->fail( 'la seconda richiesta non è arrivata al lock entro dieci secondi' );
            }

            // il carrello cancellato non torna, e quello nuovo ha la sua riga
            $I->dontSeeInDatabase( 'carrelli', array( 'id' => $vecchio ) );
            $id = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
            $I->assertNotEmpty( $id, 'carrello nuovo dopo il lock' );
            $righe = (int) $I->grabFromDatabase( 'SELECT count(*) FROM carrelli_articoli WHERE id_carrello = ?', array( $id ) );
            $I->assertEquals( 1, $righe, 'righe del carrello nuovo' );

        }

    }

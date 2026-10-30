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

    }

<?php

    /**
     * test del rendering delle pagine del nucleo
     *
     * verifica _src/_api/_pages.php: l'HTML non lascia uscire l'id di sessione ne' gli header di risposta nei commenti ( S-019 ), una pagina
     * riservata chiesta da anonimo mostra solo il login ( S-020 ) e un host sconosciuto non serve il sito ( S-021 )
     *
     * si usano solo richieste HTTP senza browser, per leggere header e corpo cosi' come escono
     *
     * l'host maiuscolo e' coperto da hostCest, il resto dell'ACL da aclGuestsCest
     *
     */

    class pagesCest {

        // scarica un percorso senza login ( o con l'host indicato ); restituisce lo status e riempie header e corpo
        private function scarica( $percorso, &$header, &$corpo, $host = NULL ) {

            global $cf;

            $url = rtrim( $cf['site']['url'], '/' ) . $percorso;

            $ch = curl_init( $url );
            curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
            curl_setopt( $ch, CURLOPT_HEADER, true );
            curl_setopt( $ch, CURLOPT_TIMEOUT, 30 );
            curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, false );
            curl_setopt( $ch, CURLOPT_SSL_VERIFYHOST, 0 );

            if( $host ) {
                curl_setopt( $ch, CURLOPT_HTTPHEADER, array( 'Host: ' . $host ) );
            }

            $risposta = curl_exec( $ch );
            $status = (int) curl_getinfo( $ch, CURLINFO_HTTP_CODE );
            $dimensione = (int) curl_getinfo( $ch, CURLINFO_HEADER_SIZE );
            curl_close( $ch );

            $header = substr( (string) $risposta, 0, $dimensione );
            $corpo = substr( (string) $risposta, $dimensione );

            return $status;

        }
        // S-019 pagine: nell'HTML non escono ne' l'id di sessione ne' gli header di risposta
        public function nessunaSessioneNelHtml( FrontendTester $I ) {

            foreach( array( '/', '/admin.it-IT.html' ) as $percorso ) {

                $this->scarica( $percorso, $header, $corpo );

                $I->assertDoesNotMatchRegularExpression( '/<!--\s*sessione:/i', $corpo, $percorso . ': l\'id di sessione e\' in un commento HTML' );
                $I->assertDoesNotMatchRegularExpression( '/<!--\s*header:\s*Set-Cookie/i', $corpo, $percorso . ': il Set-Cookie e\' in un commento HTML' );
                $I->assertDoesNotMatchRegularExpression( '/PHPSESSID=[a-z0-9,-]{10,}/i', $corpo, $percorso . ': l\'id di sessione e\' nell\'HTML' );

            }

        }

        // S-020 pagine: una pagina riservata chiesta da anonimo mostra solo il login
        public function paginaRiservataDaAnonimo( FrontendTester $I ) {

            $status = $this->scarica( '/admin.it-IT.html', $header, $corpo );

            $I->assertContains( $status, array( 200, 401, 403 ), 'la pagina riservata risponde ' . $status );
            $I->assertStringContainsString( 'formLogin', $corpo, 'la pagina riservata non mostra il login' );
            $I->assertStringNotContainsString( 'logout', strtolower( $corpo ), 'la pagina riservata mostra il menu di un utente autenticato' );

        }

        // S-021 multi-tenant: un host sconosciuto non serve il contenuto del sito
        public function hostSconosciuto( FrontendTester $I ) {

            $status = $this->scarica( '/', $header, $corpo, 'sconosciuto-' . uniqid() . '.example.org' );

            $I->assertNotEquals( 200, $status, 'un host sconosciuto riceve la home del sito' );
            $I->assertStringNotContainsString( 'GlisWeb framework', $corpo, 'un host sconosciuto riceve pagine del framework' );

        }

    }

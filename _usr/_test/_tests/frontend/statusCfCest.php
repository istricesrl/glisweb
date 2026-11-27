<?php

    /**
     * test della pagina /cf del nucleo
     *
     * verifica _src/_api/_status/_cf.php, che stampa l'albero di $cf navigabile con __lvl__: nessun valore segreto
     * deve uscire in chiaro, qualunque sia il nome della chiave che lo contiene ( array2censored() di
     * _src/_config.php censura solo le chiavi esatte ), e un livello inesistente o con codice dentro non deve
     * riflettere l'input senza escape ( S-009 )
     *
     * i valori segreti si ricavano da $cf, che il bootstrap dei test carica dallo stesso deploy; per ognuno si apre la
     * pagina del livello che lo contiene, perche' i valori si stampano solo li'
     *
     */

    class statusCfCest {

        // nomi di chiave che di solito contengono un segreto
        const CHIAVI = '/pass|pwd|secret|token|private|salt|hash|key|jwt/i';

        // scarica un percorso senza login; restituisce lo status HTTP
        private function scarica( $percorso, &$raw ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . $percorso,
                METHOD_GET,
                NULL,
                MIME_APPLICATION_JSON,
                MIME_TEXT_PLAIN,
                $status,
                array(),
                NULL,
                NULL,
                $error,
                NULL,
                CURLAUTH_BASIC,
                $raw
            );

            return (int) $status;

        }

        // raccoglie le foglie segrete: percorso del livello che le contiene => elenco dei valori
        private function segreti( $a, $percorso, &$trovati ) {

            foreach( $a as $k => $v ) {

                if( is_array( $v ) ) {
                    $this->segreti( $v, array_merge( $percorso, array( $k ) ), $trovati );
                } elseif( is_string( $v ) && strlen( $v ) >= 8 && preg_match( self::CHIAVI, (string) $k ) && ! preg_match( '/^(\d+|[a-z_]+)$/i', $v ) ) {
                    $trovati[ json_encode( $percorso ) ][ $k ] = $v;
                }

            }

        }

        // S-009 /cf: nessun segreto in chiaro in nessuna pagina dell'albero
        public function nessunSegretoInChiaro( FrontendTester $I ) {

            global $cf;

            $trovati = array();
            $this->segreti( $cf, array(), $trovati );

            $I->assertNotEmpty( $trovati, 'in $cf non ci sono segreti da cercare: il test non prova niente' );

            $usciti = array();

            foreach( array_slice( $trovati, 0, 60, true ) as $percorso => $foglie ) {

                $qs = array();
                foreach( json_decode( $percorso, true ) as $livello ) {
                    $qs[] = '__lvl__[]=' . rawurlencode( $livello );
                }

                $status = $this->scarica( '/cf?' . implode( '&', $qs ), $raw );

                // se la pagina e' negata ( 401, 403, 404 ) non esce niente, ed e' il comportamento voluto
                if( in_array( $status, array( 401, 403, 404 ) ) ) {
                    continue;
                }

                foreach( $foglie as $chiave => $valore ) {
                    if( strpos( (string) $raw, $valore ) !== false || strpos( (string) $raw, htmlspecialchars( $valore ) ) !== false ) {
                        $usciti[] = $percorso . '/' . $chiave;
                    }
                }

            }

            $I->assertEmpty( $usciti, 'segreti in chiaro in /cf: ' . implode( ', ', $usciti ) );

        }

        // S-009 /cf: un livello inesistente non riflette l'input senza escape
        public function livelloInesistente( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            $status = $this->scarica( '/cf?__lvl__[]=' . rawurlencode( '<script>' . $marcatore . '</script>' ), $raw );

            $I->assertStringNotContainsString( '<script>' . $marcatore, (string) $raw, 'il livello inesistente e\' riflesso senza escape' );

        }

    }

<?php

    namespace Helper;

    /**
     * finto REST per i test
     *
     * Il finto REST ( _usr/_test/_rest.mock.php ) lo avvia e lo spegne _src/_sh/_codeception.run.sh, e durante il giro
     * restCall() gli manda le chiamate verso gli host elencati in $cf['rest']['mock']['hosts'] ( vedi
     * _src/_config/_590.rest.php ). Con questa classe un test prepara le risposte e alla fine legge le richieste che
     * il sito ha fatto, per verificare cosa sarebbe arrivato al servizio vero.
     *
     * Uso tipico in un Cest:
     *
     *     public function _before( FrontendTester $I ) {
     *         \Helper\RestMock::pulisci();
     *         \Helper\RestMock::risposta( 'GET', '#^/v1/ordini/\d+$#', array( 'id' => 7 ), 200, 'api.gestionale.it' );
     *     }
     *     public function ordine( FrontendTester $I ) {
     *         ...
     *         $I->assertCount( 1, \Helper\RestMock::richieste( 'POST', '#^/v1/ordini$#' ) );
     *     }
     *
     * Tre cose da sapere:
     *
     * - le risposte valgono per tutte le chiamate deviate, sia quelle del sito aperto dal browser dei test sia quelle
     *   fatte dal processo di Codeception, e mentre il giro e' in corso anche per chi usa il sito DEV;
     * - le regole si provano nell'ordine in cui sono state preparate, e vince la prima che corrisponde: ogni test
     *   comincia con pulisci(), altrimenti eredita le regole del test prima;
     * - le risposte finte possono finire nelle cache del sito ( memcache, var/cache/pages/ ): un test che ne dipende
     *   le svuota da se'.
     *
     */

    class RestMock {

        /**
         * la cartella del finto REST
         *
         * @return      string                      il percorso di var/test/rest.mock.d/
         *
         */
        public static function cartella() {

            return DIR_VAR . 'test/rest.mock.d/';

        }

        /**
         * dice se il finto REST e' acceso
         *
         * @return      boolean                     true se _codeception.run.sh l'ha avviato
         *
         */
        public static function attivo() {

            return file_exists( DIR_VAR . 'test/rest.mock' );

        }

        /**
         * l'URL del finto REST
         *
         * @return      string                      p.es. http://127.0.0.1:8790, NULL se il finto REST e' spento
         *
         */
        public static function url() {

            return ( self::attivo() ) ? 'http://127.0.0.1:' . (int) file_get_contents( DIR_VAR . 'test/rest.mock' ) : NULL;

        }

        /**
         * prepara una risposta
         *
         * @param       string      $metodo         GET, POST, PATCH, PUT, DELETE, oppure * per tutti
         * @param       string      $percorso       espressione regolare sul percorso, p.es. #^/v1/ordini/\d+$#
         * @param       mixed       $risposta       quello che il servizio risponde, restituito in JSON
         * @param       integer     $status         lo status HTTP
         * @param       string      $host           l'host a cui era diretta la chiamata, NULL per tutti
         *
         * @return      void
         *
         */
        public static function risposta( $metodo, $percorso, $risposta, $status = 200, $host = NULL ) {

            $n = count( glob( self::cartella() . 'risposte/*.json' ) );

            file_put_contents(
                self::cartella() . 'risposte/' . sprintf( '%04d', $n ) . '.json',
                json_encode( array( 'metodo' => $metodo, 'host' => $host, 'percorso' => $percorso, 'status' => $status, 'risposta' => $risposta ), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES )
            );

            // l'interruttore scade dopo un'ora ( vedi _src/_config/_595.rest.php ), e un test che prepara risposte lo rinnova
            touch( DIR_VAR . 'test/rest.mock' );

        }

        /**
         * le richieste arrivate al finto REST
         *
         * @param       string      $metodo         per filtrare sul metodo, NULL per tutti
         * @param       string      $percorso       espressione regolare per filtrare sul percorso, NULL per tutti
         * @param       string      $host           per filtrare sull'host, NULL per tutti
         *
         * @return      array                       una riga per richiesta: ora, metodo, host, percorso, query, corpo
         *
         */
        public static function richieste( $metodo = NULL, $percorso = NULL, $host = NULL ) {

            $righe = array();

            if( file_exists( self::cartella() . 'richieste.jsonl' ) ) {
                foreach( file( self::cartella() . 'richieste.jsonl', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) as $riga ) {
                    $r = json_decode( $riga, true );
                    if( ( $metodo === NULL || $r['metodo'] === $metodo ) && ( $percorso === NULL || preg_match( $percorso, $r['percorso'] ) ) && ( $host === NULL || $r['host'] === $host ) ) {
                        $righe[] = $r;
                    }
                }
            }

            return $righe;

        }

        /**
         * toglie le risposte e le richieste dei test precedenti
         *
         * @return      void
         *
         */
        public static function pulisci() {

            foreach( array_merge( glob( self::cartella() . 'risposte/*.json' ), glob( self::cartella() . '*.jsonl' ) ) as $f ) {
                unlink( $f );
            }

        }

    }

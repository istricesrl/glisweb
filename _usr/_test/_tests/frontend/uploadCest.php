<?php

    /**
     * test dell'API di upload del nucleo
     *
     * verifica _src/_api/_upload.php: il nome del file che non deve poter uscire dalla cartella di destinazione
     * ( S-001 ), la cartella di destinazione che non deve poter uscire dalle due consentite con i '..' ( S-002 ) e
     * l'upload anonimo, che senza il privilegio giusto deve essere respinto ( S-003 )
     *
     * le richieste partono da restCall() senza alcun login; i file di prova hanno sempre nome TEST-E2E-<id>.txt,
     * mai un'estensione eseguibile, e vengono tolti con la glob di pulisci() prima e dopo ogni test anche se il
     * test fallisce, dalle cartelle dove un'uscita dal percorso potrebbe lasciarli
     *
     * un test rosso qui vuol dire che l'API lascia scrivere dove non deve: non va coperto, va corretta l'API
     *
     */

    class uploadCest {

        // cartelle dove un file di prova potrebbe finire
        private function cartelle() {
            return array(
                DIR_BASE,
                DIR_BASE . 'tmp/',
                DIR_BASE . 'src/',
                DIR_BASE . 'etc/',
                DIR_BASE . 'var/',
                DIR_BASE . 'var/contenuti/',
            );
        }

        // pulizia prima e dopo ogni test
        public function _before( FrontendTester $I ) {
            $this->pulisci();
        }

        public function _after( FrontendTester $I ) {
            $this->pulisci();
        }

        // tolgo tutti i file di prova e i loro chunk
        private function pulisci() {
            foreach( $this->cartelle() as $d ) {
                foreach( (array) glob( $d . \Helper\Glisweb::RECORD_PREFIX . '*' ) as $f ) {
                    if( is_file( $f ) ) {
                        unlink( $f );
                    }
                }
            }
        }

        // trovo i file di prova rimasti, con il percorso
        private function trovati() {
            $trovati = array();
            foreach( $this->cartelle() as $d ) {
                foreach( (array) glob( $d . \Helper\Glisweb::RECORD_PREFIX . '*' ) as $f ) {
                    $trovati[] = $f;
                }
            }
            return $trovati;
        }

        // upload di un file di un solo chunk; restituisce lo status HTTP
        private function carica( $cartella, $nome, &$raw ) {

            global $cf;

            $headers = array(
                'X-Target-Folder' => $cartella,
                'X-File-Name' => $nome,
                'X-File-Size' => '9',
                'X-Chunk-Number' => '1',
                'X-Chunk-Total' => '1',
            );

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . '/api/upload',
                METHOD_POST,
                'contenuto',
                'text/plain',
                MIME_APPLICATION_JSON,
                $status,
                $headers,
                NULL,
                NULL,
                $error,
                NULL,
                CURLAUTH_BASIC,
                $raw
            );

            return (int) $status;

        }

        // S-001 upload: il nome del file non esce dalla cartella di destinazione
        public function nomeFilePathTraversal( FrontendTester $I ) {

            $id = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            foreach( array( '../' . $id . '.txt', '..%2f' . $id . '.txt', '../../src/' . $id . '.txt' ) as $nome ) {

                $this->carica( 'tmp/', $nome, $raw );

                // il file ammesso e' solo dentro tmp/, e se ne deve accorgere la risposta
                $fuori = array_filter( $this->trovati(), function( $f ) {
                    return strpos( $f, DIR_BASE . 'tmp/' ) !== 0;
                } );

                $I->assertEmpty( $fuori, 'il nome file ' . $nome . ' ha scritto fuori da tmp/: ' . implode( ', ', $fuori ) );

                $this->pulisci();

            }

        }

        // S-002 upload: la cartella di destinazione con '..' dopo il prefisso consentito e' rifiutata
        public function cartellaDestinazioneConPuntiPunti( FrontendTester $I ) {

            $id = \Helper\Glisweb::RECORD_PREFIX . uniqid() . '.txt';

            foreach( array( 'tmp/../etc/', 'tmp/../src/', 'var/contenuti/../../src/' ) as $cartella ) {

                $status = $this->carica( $cartella, $id, $raw );

                // il rifiuto puo' venire dall'API o dal firewall davanti a lei: l'importante e' che ci sia
                $rifiutata = ( $status >= 400 || strpos( (string) $raw, 'percorso non consentito' ) !== false );
                $I->assertTrue( $rifiutata, 'la cartella ' . $cartella . ' non e\' stata rifiutata: ' . $status . ' ' . substr( (string) $raw, 0, 120 ) );
                $I->assertEmpty( $this->trovati(), 'la cartella ' . $cartella . ' ha scritto un file' );

                $this->pulisci();

            }

        }

        // S-003 upload: un anonimo senza privilegio viene respinto e non scrive niente
        public function uploadAnonimo( FrontendTester $I ) {

            $id = \Helper\Glisweb::RECORD_PREFIX . uniqid() . '.txt';

            $status = $this->carica( 'tmp/', $id, $raw );

            $I->assertContains( $status, array( 401, 403 ), 'l\'upload anonimo risponde ' . $status . ' invece di 401/403' );
            $I->assertEmpty( $this->trovati(), 'l\'upload anonimo ha scritto un file' );

        }

    }

<?php

    /**
     * test delle protezioni del .htaccess del nucleo
     *
     * verifica le due difese di Apache che stanno davanti a PHP: le cartelle interne ad accesso vietato con le
     * RewriteRule [F] ( S-006 ) e il FilesMatch che nega i file con le estensioni pericolose o riservate e le copie di backup dei sorgenti ( S-007 )
     *
     * le richieste partono da restCall() senza login. Per S-006 basta il percorso, la regola [F] scatta anche se il
     * file non esiste; per S-007 servono file veri, che si creano in var/ ( la document root non e' scrivibile da chi lancia i test ) con nome TEST-E2E-<id>.<ext>
     * e contenuto innocuo, e si tolgono in _before() e _after(): il FilesMatch e' ancorato alla fine del nome e va
     *
     * il rifiuto puo' venire anche dal firewall applicativo o da ModSecurity: quello che conta e' che un anonimo
     * non riceva mai il file
     *
     */

    class htaccessCest {

        // pulizia prima e dopo ogni test
        public function _before( FrontendTester $I ) {
            $this->pulisci();
        }

        public function _after( FrontendTester $I ) {
            $this->pulisci();
        }

        // tolgo i file di prova da var/
        private function pulisci() {
            foreach( (array) glob( DIR_BASE . 'var/' . \Helper\Glisweb::RECORD_PREFIX . '*' ) as $f ) {
                if( is_file( $f ) ) {
                    unlink( $f );
                }
            }
        }

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

        // scrivo un file di prova in var/ ( la document root non e' scrivibile da chi lancia i test ), leggibile da Apache
        private function creaFile( $estensione, $contenuto ) {

            $nome = \Helper\Glisweb::RECORD_PREFIX . uniqid() . $estensione;

            file_put_contents( DIR_BASE . 'var/' . $nome, $contenuto );
            chmod( DIR_BASE . 'var/' . $nome, 0644 );

            return $nome;

        }

        // S-006 .htaccess: le cartelle interne rispondono 403, anche con le maiuscole
        public function cartelleInterneVietate( FrontendTester $I ) {

            $cartelle = array(
                '/.git/config',
                '/.GIT/config',
                '/etc/secret/x',
                '/ETC/SECRET/x',
                '/tmp/x',
                '/usr/database/x',
                '/usr/test/x',
                '/var/log/x',
                '/var/session/x',
                '/var/spool/security/ban/x',
                '/var/work/x',
                '/var/contenuti/upload/x',
                '/mod/x/src/inc/x.php',
                '/_src/_inc/x.php',
                '/src/inc/x.php',
            );

            foreach( $cartelle as $percorso ) {
                $I->assertEquals( 403, $this->scarica( $percorso, $raw ), 'il percorso ' . $percorso . ' non risponde 403' );
            }

        }

        // S-007 .htaccess: le estensioni dei file riservati rispondono 403
        public function estensioniVietate( FrontendTester $I ) {

            $contenuto = 'riservato-' . uniqid();

            $serviti = array();

            foreach( array( '.inc', '.tpl', '.sql', '.old', '.orig', '.bk', '.php~', '.SQL' ) as $estensione ) {

                $nome = $this->creaFile( $estensione, $contenuto );
                $status = $this->scarica( '/var/' . rawurlencode( $nome ), $raw );

                if( $status != 403 || strpos( (string) $raw, $contenuto ) !== false ) {
                    $serviti[] = $estensione . ' ( ' . $status . ' )';
                }

            }

            $I->assertEmpty( $serviti, 'estensioni non protette: ' . implode( ', ', $serviti ) );

        }

        // S-007 .htaccess: la copia di un sorgente o di una configurazione con un suffisso di backup o una data in
        // fondo non fa passare il file ( il FilesMatch delle estensioni e' ancorato alla fine del nome )
        public function doppiaEstensioneDatata( FrontendTester $I ) {

            $contenuto = 'riservato-' . uniqid();

            $serviti = array();

            foreach( array( '.php.bak.20260827', '.yaml.old', '.sql.20261028', '.json.orig', '.PHP.Save.1' ) as $estensione ) {

                $nome = $this->creaFile( $estensione, $contenuto );
                $status = $this->scarica( '/var/' . rawurlencode( $nome ), $raw );

                if( $status != 403 || strpos( (string) $raw, $contenuto ) !== false ) {
                    $serviti[] = $estensione . ' ( ' . $status . ' )';
                }

            }

            $I->assertEmpty( $serviti, 'copie di backup non protette: ' . implode( ', ', $serviti ) );

        }

        // S-007 .htaccess: i formati che i siti scaricano davvero ( export, listini, allegati ) restano scaricabili;
        // l'accesso ai file riservati si decide nell'API di download, non sull'estensione
        public function estensioniScaricabili( FrontendTester $I ) {

            $contenuto = 'pubblico-' . uniqid();

            foreach( array( '.csv', '.xlsx', '.zip', '.pdf', '.jpg' ) as $estensione ) {

                $nome = $this->creaFile( $estensione, $contenuto );
                $status = $this->scarica( '/var/' . rawurlencode( $nome ), $raw );

                $I->assertEquals( 200, $status, 'il file ' . $estensione . ' non si scarica piu\'' );
                $I->assertStringContainsString( $contenuto, (string) $raw );

            }

        }

    }

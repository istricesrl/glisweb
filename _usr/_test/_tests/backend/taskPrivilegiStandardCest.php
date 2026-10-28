<?php

    /**
     * test dei privilegi dei task del nucleo chiamati da HTTP
     *
     * ogni task di _src/_api/_task/ e' raggiungibile come /task/<nome>; quelli che dichiarano checkTaskPrivilege()
     * devono rispondere 401 o 403 a un anonimo e a un account senza il privilegio ( test-users ), senza eseguire niente ( S-011 )
     *
     * si chiamano solo i task che hanno la guardia nel sorgente: un task senza guardia, chiamato da un anonimo,
     * verrebbe eseguito davvero ( pulizie, invio di mail ), e a quelli pensa il test statico staticoTaskCest ( S-010 )
     *
     */

    class taskPrivilegiStandardCest {

        // chiama /task/<nome>, con il JWT dell'account se c'e'; restituisce lo status HTTP
        private function chiama( $nome, $jwt = NULL ) {

            global $cf;

            $status = NULL;
            $error = NULL;
            $raw = NULL;

            restCall(
                rtrim( $cf['site']['url'], '/' ) . '/task/' . $nome . ( $jwt ? '?j=' . rawurlencode( $jwt ) : '' ),
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

        // task del nucleo con checkTaskPrivilege() nel sorgente: nome => true se chiede un privilegio specifico
        private function taskProtetti() {

            $nomi = array();

            foreach( (array) glob( DIR_BASE . '_src/_api/_task/*.php' ) as $file ) {
                $codice = file_get_contents( $file );
                if( strpos( $codice, 'checkTaskPrivilege' ) !== false ) {
                    // checkTaskPrivilege() senza argomento chiede solo una sessione autenticata: a un utente semplice si concede
                    $nomi[ preg_replace( '/^_|\.php$/', '', basename( $file ) ) ] = preg_match( '/checkTaskPrivilege\(\s*[\'"]/', $codice ) ? true : false;
                }
            }

            return $nomi;

        }

        // S-011 task: un anonimo e un account senza privilegio sono respinti da ogni task protetto
        public function taskNegatiSenzaPrivilegio( BackendTester $I ) {

            $nomi = $this->taskProtetti();

            $I->assertNotEmpty( $nomi, 'nessun task protetto trovato: il test non prova niente' );

            $jwt = $I->grabTestAccount( 'users' )['jwt'];

            $aperti = array();

            foreach( $nomi as $nome => $conPrivilegio ) {

                $anonimo = $this->chiama( $nome );
                $utente = $this->chiama( $nome, $jwt );

                if( ! in_array( $anonimo, array( 401, 403 ) ) ) {
                    $aperti[] = $nome . ' anonimo ( ' . $anonimo . ' )';
                }

                if( $conPrivilegio && ! in_array( $utente, array( 401, 403 ) ) ) {
                    $aperti[] = $nome . ' test-users ( ' . $utente . ' )';
                }

            }

            $I->assertEmpty( $aperti, 'task che non respingono: ' . implode( ', ', $aperti ) );

        }

    }

<?php

    /**
     * test del modulo registrazione
     *
     * manda alla pagina di registrazione una richiesta con un nome che contiene sintassi Twig e verifica che nella
     * mail di attivazione accodata il nome arrivi come testo; fino al 14/10/2026 nome, cognome e mail del form
     * venivano passati a queueMailFromTemplate() come destinatari, che li compila come template Twig, e chiunque
     * poteva far eseguire codice al server dal form pubblico
     *
     * la registrazione non crea l'account, che nasce solo alla conferma: scrive la mail in mail_out e i dati in
     * var/spool/signup/, e il test toglie le une e gli altri
     *
     */

    class registrazioneCest {

        // pulizia prima del test
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'mail_out', 'destinatari', true );

        }

        // pulizia dopo il test, compresi i file di spool del test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'mail_out', 'destinatari', true );

            foreach( glob( DIR_VAR_SPOOL . 'signup/*.txt' ) as $file ) {
                if( strpos( file_get_contents( $file ), \Helper\Glisweb::RECORD_PREFIX ) !== false ) {
                    unlink( $file );
                }
            }

        }

        // il nome scritto nel form non viene compilato come Twig
        public function nomeNonCompilato( FrontendTester $I ) {

            $nome = $I->grabTestName( 'registrazione' );
            $mail = strtolower( $nome ) . '@example.com';

            $I->amOnPageId( 'registrazione', array( '__signup__' => array(
                'nome'      => $nome . '{{ 7*7 }}',
                'cognome'   => 'test',
                'email'     => $mail
            ) ) );

            // la mail di attivazione e' accodata col nome cosi' come e' stato scritto
            $destinatari = $I->grabFromDatabase( 'SELECT destinatari FROM mail_out WHERE destinatari LIKE ?', array( '%' . $nome . '%' ) );
            $I->assertNotEmpty( $destinatari, 'la mail di attivazione non e\' stata accodata' );
            $I->assertStringContainsString( $nome . '{{ 7*7 }} test', $destinatari );
            $I->assertStringNotContainsString( $nome . '49', $destinatari );
            $I->assertStringContainsString( $mail, $destinatari );

        }

    }

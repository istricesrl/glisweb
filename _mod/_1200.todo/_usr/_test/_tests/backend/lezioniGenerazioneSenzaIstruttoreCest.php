<?php

    /**
     * test della generazione delle lezioni di un corso senza istruttore
     *
     * il pulsante GENERA del calendario del corso ( corsi.form.calendario ) chiama _mod/_1200.todo/_src/_api/_task/_todo.generate.php
     * con l'istruttore scelto in __a__; fino al 2026-10-15, se il corso non aveva un istruttore ( ruolo 16 in
     * progetti_anagrafica ) e __a__ era vuoto, la stringa vuota finiva in todo.id_anagrafica e in
     * attivita.id_anagrafica_programmazione, colonne intere: errore 1366 in mysql.err e presenza dell'istruttore non creata;
     * la lezione senza istruttore deve nascere con NULL in tutte e due le colonne
     *
     * corso e luogo si scrivono nel database, la generazione si chiama dalla pagina con la stessa GET del pulsante; le
     * lezioni e le presenze generate non portano il prefisso TEST-E2E-, quindi la pulizia le rinomina prima di toglierle
     *
     */

    class lezioniGenerazioneSenzaIstruttoreCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie presenze, lezioni, corso e luogo di test, in quest'ordine per le chiavi esterne
        protected function pulisci( BackendTester $I ) {

            // le righe generate prendono il prefisso dal corso di test, e la statica il nome nuovo
            foreach( array( 'attivita', 'todo' ) as $tabella ) {
                while( $id = $I->grabFromDatabase(
                    'SELECT t.id FROM ' . $tabella . ' AS t INNER JOIN progetti ON progetti.id = t.id_progetto'
                    .' WHERE progetti.nome LIKE "TEST-E2E-%" AND coalesce( t.nome, "" ) NOT LIKE "TEST-E2E-%" LIMIT 1'
                ) ) {
                    $I->updateInDatabase( $tabella, array( 'id' => $id, 'nome' => $I->grabTestName( 'generata' ) ) );
                    $I->haveInStaticView( $tabella, $id );
                }
            }

            $I->deleteTestRecords( 'attivita_view_static', 'nome' );
            $I->deleteTestRecords( 'attivita', 'nome' );
            $I->deleteTestRecords( 'todo_view_static', 'nome' );
            $I->deleteTestRecords( 'todo', 'nome' );
            $I->deleteTestRecords( 'progetti', 'nome' );
            $I->deleteTestRecords( 'luoghi', 'nome' );

        }

        // senza istruttore sul corso ne' in __a__ le lezioni nascono, con la presenza dell'istruttore a NULL
        public function generazioneSenzaIstruttore( BackendTester $I ) {

            $corso = $I->haveInDatabase( 'progetti', array(
                'id' => 990000000000 + ( time() % 1000000 ) * 10,
                'nome' => $I->grabTestName( 'corso' )
            ) );

            $luogo = $I->haveInDatabase( 'luoghi', array(
                'nome' => $I->grabTestName( 'luogo' )
            ) );

            // due settimane a partire da fra dieci giorni, nel giorno della settimana della prima data ( 0 lunedi' )
            $inizio = strtotime( '+10 days' );

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'todo.view' );

            $risposta = $I->executeAsyncJS(
                'var done = arguments[ arguments.length - 1 ];'
                .' fetch( window.location.origin + "/_mod/_1200.todo/_src/_api/_task/_todo.generate.php?" + new URLSearchParams( arguments[0] ), { credentials: "same-origin" } )'
                .'.then( function( r ) { return r.text(); } ).then( function( t ) { done( t ); } );',
                array( array(
                    'progetto' => $corso,
                    '__g__' => date( 'N', $inizio ) - 1,
                    '__di__' => date( 'Y-m-d', $inizio ),
                    '__df__' => date( 'Y-m-d', strtotime( '+13 days', $inizio ) ),
                    '__oi__' => '17:00',
                    '__of__' => '18:00',
                    '__l__' => $luogo,
                    '__a__' => '',
                    '__periodi__' => ''
                ) )
            );

            $status = json_decode( $risposta, true );
            $I->assertEquals( 'OK', $status['__status__'] ?? NULL, 'la generazione ha risposto ' . $risposta );
            $I->assertEquals( 2, $status['__new__'], 'lezioni generate: ' . $risposta );

            // due lezioni senza istruttore, ciascuna con la sua presenza dell'istruttore a NULL
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM todo WHERE id_progetto = ? AND id_anagrafica IS NULL', array( $corso ) ) );
            $I->assertEquals( 2, $I->grabFromDatabase( 'SELECT count(*) FROM attivita WHERE id_progetto = ? AND id_tipologia = 30 AND id_anagrafica_programmazione IS NULL', array( $corso ) ) );

        }

    }

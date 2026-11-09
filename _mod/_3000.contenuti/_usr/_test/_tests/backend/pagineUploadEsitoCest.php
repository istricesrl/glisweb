<?php

    /**
     * test dell'esito della pubblicazione di una pagina, o di un redirect, su un altro stage
     *
     * il task _pagine.upload.php copia la pagina nel database dello stage di destinazione e ne carica i file via FTP;
     * fino al 09/11/2026 la modale "pubblica pagina" ricaricava la pagina qualunque cosa rispondesse il task, quindi
     * una pubblicazione fallita ( su gimbe il MySQL di PROD irraggiungibile dal DEV ) si presentava come riuscita
     *
     * ora il task risponde con esito OK o KO e la modale ricarica solo con OK; il test chiama il task su uno stage che
     * non esiste, quindi non tocca nessun database, e controlla che la modale guardi l'esito prima di ricaricare
     *
     */

    class pagineUploadEsitoCest {

        // su uno stage senza server il task risponde KO col motivo
        public function esitoKoSenzaServer( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/_mod/_3000.contenuti/_src/_api/_task/_pagine.upload.php?id=1&target=TEST-E2E-INESISTENTE' );
            $I->see( '"esito"' );
            $I->see( 'KO' );
            $I->see( 'server non disponibile' );

        }

        // senza la pagina il task risponde KO col motivo
        public function esitoKoSenzaPagina( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/_mod/_3000.contenuti/_src/_api/_task/_pagine.upload.php' );
            $I->see( 'KO' );
            $I->see( 'ID della pagina non passato' );

        }

        // anche il task dei redirect risponde KO col motivo su uno stage senza server
        public function esitoKoRedirectSenzaServer( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            $I->amOnPage( '/_mod/_3000.contenuti/_src/_api/_task/_redirect.upload.php?id=1&target=TEST-E2E-INESISTENTE' );
            $I->see( '"esito"' );
            $I->see( 'KO' );
            $I->see( 'server non disponibile' );

        }

        // la modale dei redirect mostra la spunta solo se l'esito e' OK
        public function modaleRedirectGuardaEsito( BackendTester $I ) {

            $modale = file_get_contents( DIR_BASE . '_mod/_3000.contenuti/_src/_templates/_athena/inc/redirect.form.tools.modal.pubblica.html' );

            $I->assertEquals( 1, preg_match( '/if\( data\.esito == \'OK\' \) \{\s*\$\(\'#btnpubblica\'\)\.html\(\'<i class="fa fa-check">/', $modale ) );
            $I->assertEquals( 1, substr_count( $modale, 'fa-check' ) );

        }

        // la modale ricarica solo se l'esito e' OK, e ferma il controllo dell'avanzamento
        public function modaleGuardaEsito( BackendTester $I ) {

            $modale = file_get_contents( DIR_BASE . '_mod/_3000.contenuti/_src/_templates/_athena/inc/pagine.form.tools.modal.pubblica.html' );

            $I->assertEquals( 1, preg_match( '/if\( data\.esito == \'OK\' \) \{\s*[^}]*location\.reload\(\);/', $modale ) );
            $I->assertEquals( 1, substr_count( $modale, 'location.reload()' ) );
            $I->assertEquals( 2, substr_count( $modale, 'clearInterval( avanzamento )' ) );

        }

    }

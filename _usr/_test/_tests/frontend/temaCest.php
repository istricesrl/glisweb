<?php

    /**
     * test del tema dei template
     *
     * verifica che il tema richiesto per una pagina ( template.theme, forzato qui col parametro di debug ?c= di
     * _src/_config/_420.pages.php ) arrivi davvero nei link della testata: fino al 26/11/2026 _src/_api/_pages.php
     * lo accodava come stringa piatta anche quando i CSS del template sono divisi per media, e il ciclo della
     * testata ( _src/_twig/_inc/_page.head.twig ) su una stringa non emetteva niente, senza nessun errore
     *
     * il template forzato e' athena, che ha i CSS divisi per media e i temi standard in css/themes/; il parametro
     * ?t= vale solo fuori produzione, dove girano i test
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall()
     *
     */

    class temaCest {

        // il tema di un template coi CSS divisi per media esce nei link, e il file risponde
        public function temaNeiLink( FrontendTester $I ) {

            $I->assertEquals( 200, $this->scarica( '/?t=athena&c=blu', $raw ) );

            $I->assertMatchesRegularExpression( '/<link rel="stylesheet" href="[^"]*_src\/_tpl\/_athena\/css\/themes\/blu\.css" media="all">/', $raw, 'il tema blu non e\' fra i link della testata' );

            $I->assertEquals( 200, $this->scarica( '/_src/_tpl/_athena/css/themes/blu.css', $css ), 'il file del tema non risponde' );

        }

        // un tema inesistente viene ignorato e la pagina risponde lo stesso
        public function temaInesistenteIgnorato( FrontendTester $I ) {

            $I->assertEquals( 200, $this->scarica( '/?t=athena&c=temainesistente', $raw ) );

            // il nome resta nel commento di debug della testata ( <!-- tema: ... --> ), ma non deve diventare un link
            $I->assertDoesNotMatchRegularExpression( '/<link[^>]*temainesistente\.css/', $raw, 'il tema inesistente e\' finito fra i link' );

        }

        // scarica una pagina e ne restituisce lo status HTTP
        protected function scarica( $pagina, &$raw ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, array(), NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );

            return (int) $status;

        }

    }

<?php

    /**
     * test della forzatura dello schema
     *
     * verifica il parametro di debug ?s= di _src/_config/_420.pages.php, che fuori produzione forza lo schema della
     * pagina: fino al 26/11/2026 il controllo sul file era scritto DIR_BASE . file_exists( ... ), una stringa sempre
     * vera, e uno schema inesistente veniva forzato lo stesso; la pagina si fermava su "Unable to find template"
     * invece di restare sullo schema di default
     *
     * il template forzato e' athena, che ha lo schema default.tools.twig; il parametro ?t= vale solo fuori
     * produzione, dove girano i test
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall()
     *
     */

    class schemaCest {

        // uno schema esistente viene forzato
        public function schemaForzato( FrontendTester $I ) {

            $I->assertEquals( 200, $this->scarica( '/?t=athena&s=default.tools', $raw ) );

            $I->assertStringContainsString( '<!-- blocco default.tools.twig::main -->', $raw, 'lo schema default.tools non e\' stato forzato' );

        }

        // uno schema che esiste solo nella versione custom del template viene forzato anche lui: la prima correzione
        // del 26/11/2026 cercava il file solo nel template standard, e gli schemi di prova dei progetti sparivano
        public function schemaCustomForzato( FrontendTester $I ) {

            $cartella = DIR_BASE . path2custom( '_src/_tpl/_athena/' );
            $creata = ! is_dir( $cartella );
            if( $creata ) { mkdir( $cartella, 0755, true ); }
            $schema = $cartella . 'zz.test.schema.twig';
            file_put_contents( $schema, '<!-- schema custom di prova -->' );

            try {
                $I->assertEquals( 200, $this->scarica( '/?t=athena&s=zz.test.schema', $raw ) );
                $I->assertStringContainsString( '<!-- schema custom di prova -->', $raw, 'lo schema custom non e\' stato forzato' );
            } finally {
                unlink( $schema );
                if( $creata ) { rmdir( $cartella ); }
            }

        }

        // uno schema inesistente viene ignorato e la pagina resta sullo schema di default
        public function schemaInesistenteIgnorato( FrontendTester $I ) {

            $I->assertEquals( 200, $this->scarica( '/?t=athena&s=schemainesistente', $raw ) );

            $I->assertStringNotContainsString( 'schemainesistente.twig', $raw, 'lo schema inesistente e\' stato forzato' );

            $I->assertStringContainsString( '<!-- blocco default.twig::main -->', $raw, 'la pagina non e\' sullo schema di default' );

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

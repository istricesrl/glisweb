<?php

    /**
     * test del blocco title del template lydia
     *
     * verifica che il titolo della pagina ( h1 e h2 sotto la testata ) stia nel blocco title di
     * _src/_tpl/_lydia/ext/main.twig, come in minerva: fino al 27/11/2026 era fuori da ogni blocco, e uno
     * schema col suo h1 ( la home con un hero ) mandava in pagina due h1 senza poterne togliere uno
     *
     * il template e lo schema si forzano con ?t= e ?s=, che valgono solo fuori produzione, dove girano i test;
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall()
     *
     */

    class titoloCest {

        // lo schema di default mostra il titolo della pagina
        public function titoloPresente( FrontendTester $I ) {

            $I->assertEquals( 200, $this->scarica( '/?t=lydia&s=default', $raw ) );

            $I->assertStringContainsString( '<!-- blocco default.twig::main -->', $raw, 'la pagina non e\' sullo schema di default di lydia' );

            $I->assertStringContainsString( '<h1>', $raw, 'lo schema di default ha perso il titolo della pagina' );

        }

        // uno schema che svuota il blocco title toglie il titolo, e il resto della pagina resta
        public function titoloSvuotato( FrontendTester $I ) {

            $cartella = DIR_BASE . path2custom( '_src/_tpl/_lydia/' );
            $creata = ! is_dir( $cartella );
            if( $creata ) { mkdir( $cartella, 0755, true ); }
            $schema = $cartella . 'zz.test.titolo.twig';
            file_put_contents( $schema, '{% extends "ext/main.twig" %}{% block title %}{% endblock title %}{% block main %}<!-- schema senza titolo -->{% endblock main %}' );

            try {
                $I->assertEquals( 200, $this->scarica( '/?t=lydia&s=zz.test.titolo', $raw ) );
                $I->assertStringContainsString( '<!-- schema senza titolo -->', $raw, 'lo schema di prova non e\' stato forzato' );
                $I->assertStringNotContainsString( '<h1>', $raw, 'il blocco title svuotato non ha tolto il titolo' );
            } finally {
                unlink( $schema );
                if( $creata ) { rmdir( $cartella ); }
            }

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

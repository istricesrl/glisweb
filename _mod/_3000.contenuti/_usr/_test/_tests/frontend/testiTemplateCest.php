<?php

    /**
     * test dei testi delle pagine nelle due generazioni di template
     *
     * il 420 del modulo mette in testa al testo di una pagina del database gli import delle librerie di macro, cosi'
     * il testo puo' chiamare cms.*, prv.* e tpl.*; le librerie pero' sono diverse nelle due generazioni di template,
     * _src/_twig/_lib/ e lib/default.twig per i template Twig ( _tpl ), _src/_html/_bin/ e bin/default.html per quelli
     * HTML ( _templates ), e fino al 2026-11-10 il 420 importava sempre quelle HTML: una pagina del database su un
     * template Twig si fermava su Unable to find template "bin/default.html", e il sito ufficiale su _lydia non partiva
     *
     * il test crea una pagina pubblicata per ciascuna generazione, con un testo che chiama una macro della libreria
     * di base, e verifica che il testo arrivi nella pagina
     *
     */

    class testiTemplateCest {

        // pulizia prima del test; contenuti e pubblicazioni prima delle pagine
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'contenuti', 'title' );
            $I->deleteTestRecords( 'pubblicazioni', 'note' );
            $I->deleteTestRecords( 'pagine', 'nome' );

        }

        // pulizia dopo il test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'contenuti', 'title' );
            $I->deleteTestRecords( 'pubblicazioni', 'note' );
            $I->deleteTestRecords( 'pagine', 'nome' );

        }

        // template Twig: gli import vengono da _src/_twig/_lib/ e da lib/default.twig del template
        public function testoInTemplateTwig( FrontendTester $I ) {

            $this->testoInTemplate( $I, '_src/_tpl/_lydia/', 'default.twig' );

        }

        // template HTML: gli import vengono da _src/_html/_bin/ e da bin/default.html del template
        public function testoInTemplateHtml( FrontendTester $I ) {

            $this->testoInTemplate( $I, '_src/_templates/_lydia/', 'default.html' );

        }

        // crea una pagina pubblicata col template dato e ne apre il testo
        protected function testoInTemplate( FrontendTester $I, $template, $schema ) {

            global $cf;

            $segno = $I->grabTestName( 'testo' );

            $id = $I->haveInDatabase( 'pagine', array( 'id_sito' => SITE_CURRENT, 'nome' => $I->grabTestName( 'pagina' ), 'template' => $template, 'schema_html' => $schema, 'timestamp_aggiornamento' => time() ) );
            $I->haveInDatabase( 'contenuti', array( 'id_pagina' => $id, 'id_lingua' => $cf['localization']['language']['id'], 'title' => $I->grabTestName( 'contenuto' ), 'h1' => $segno, 'testo' => '<p id="testo-di-prova">' . $segno . '</p>' ) );
            $I->haveInDatabase( 'pubblicazioni', array( 'id_pagina' => $id, 'id_tipologia' => 2, 'note' => $I->grabTestName( 'pubblicazione' ), 'timestamp_aggiornamento' => time() ) );

            // l'array delle pagine sta in cache, e lo svuotamento da CLI non arriva a APCu; il framework pero' lo rigenera
            // da solo quando una pagina o una pubblicazione ha un timestamp_aggiornamento piu' recente della cache: la
            // richiesta che se ne accorge ( 310, scritto dal 330 ) serve ancora la struttura vecchia, la successiva quella nuova
            $I->clearGliswebCache();
            $I->amOnPage( '/' );

            $I->amOnPage( '/?p=' . $id );

            $I->dontSee( 'Unable to find template' );
            $I->see( $segno, '#testo-di-prova' );

        }

    }

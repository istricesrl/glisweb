<?php

    /**
     * test della scheda di un contatto
     *
     * fino al 2026-11-04 contenuti.contatti.form e contenuti.contatti.form.dati importavano le librerie di macro
     * lib/contenuti.notizie.form.sub.twig e lib/contenuti.pagine.form.sub.twig, che stanno in _NO000.notizie e
     * _PA000.pagine, senza usarne nessuna macro: in un deploy senza quei due moduli ( segnalato da utensilerialughese
     * il 2026-10-15 ) le due schede si fermavano su Unable to find template; il test apre le due schede su un
     * contatto di prova e controlla che mostrino i suoi dati
     *
     */

    class contattiFormCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'contatti', 'nome' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'contatti', 'nome' );

        }

        // le schede generale e dati si aprono e mostrano il contatto
        public function schede( BackendTester $I ) {

            $nome = $I->grabTestName( 'contatti' );

            $contatto = $I->haveInDatabase( 'contatti', array(
                'nome' => $nome,
                'yaml' => 'nome: ' . $nome
            ) );

            $I->amLoggedInAs( 'roots' );

            $I->amOnPageId( 'contenuti.contatti.form', array( 'contatti' => array( 'id' => $contatto ) ) );
            $I->dontSee( 'Unable to find template' );
            $I->seeInField( 'contatti[nome]', $nome );

            $I->amOnPageId( 'contenuti.contatti.form.dati', array( 'contatti' => array( 'id' => $contatto ) ) );
            $I->dontSee( 'Unable to find template' );
            $I->seeInField( 'contatti[yaml]', 'nome: ' . $nome );

        }

    }

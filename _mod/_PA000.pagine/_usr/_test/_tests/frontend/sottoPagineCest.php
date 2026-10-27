<?php

    /**
     * test delle sotto pagine
     *
     * il 420 del modulo assegna alla pagina corrente cappello e abstract delle sue sotto pagine; una sotto pagina
     * che non e' stata caricata dal 310 ( non pubblicata o fuori finestra ) va saltata, altrimenti nell'array
     * delle pagine nasce un guscio senza path ne' template che i menu e gli elenchi mostrano come pagina vera
     *
     * l'effetto non si vede nell'HTML di una pagina qualsiasi, quindi il test legge il log debug che il 420
     * scrive quando salta una sotto pagina; per questo gira solo dove il livello di log arriva a LOG_DEBUG
     * ( di default il profilo DEV )
     *
     * le pagine di categoria ( prodotti, notizie, risorse ) passano dallo stesso blocco ma dipendono dai template
     * del progetto, e si provano nei test del progetto
     *
     */

    class sottoPagineCest {

        // pulizia prima del test; le figlie prima della madre la fa l'helper, contenuti e pubblicazioni prima delle pagine
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

        // una sotto pagina non pubblicata viene saltata, una pubblicata no
        public function sottoPagineNonPubblicate( FrontendTester $I, \Codeception\Scenario $scenario ) {

            global $cf;

            if( ! defined( 'LOG_CURRENT_LEVEL' ) || LOG_CURRENT_LEVEL < LOG_DEBUG ) {
                $scenario->skip( 'il livello di log non arriva a LOG_DEBUG, il salto delle sotto pagine non viene registrato' );
            }

            // template e schema presi da una pagina esistente del sito che li ha, altrimenti quelli standard di aurora: una
            // pagina senza template fa scrivere a _pages.php un crit su dev/etc/template.conf a ogni giro
            $idModello = $I->grabFromDatabase( 'SELECT id FROM pagine WHERE id_sito = ? AND template IS NOT NULL AND schema_html IS NOT NULL ORDER BY id LIMIT 1', array( SITE_CURRENT ) );
            $base = array(
                'id_sito' => SITE_CURRENT,
                'template' => ( $idModello ) ? $I->grabFromDatabase( 'SELECT template FROM pagine WHERE id = ?', array( $idModello ) ) : '_src/_tpl/_aurora/',
                'schema_html' => ( $idModello ) ? $I->grabFromDatabase( 'SELECT schema_html FROM pagine WHERE id = ?', array( $idModello ) ) : 'default.twig'
            );

            // la madre e due figlie
            $idMadre = $I->haveInDatabase( 'pagine', array_merge( $base, array( 'nome' => $I->grabTestName( 'madre' ) ) ) );
            $idPubblicata = $I->haveInDatabase( 'pagine', array_merge( $base, array( 'id_genitore' => $idMadre, 'nome' => $I->grabTestName( 'pubblicata' ) ) ) );
            $idBozza = $I->haveInDatabase( 'pagine', array_merge( $base, array( 'id_genitore' => $idMadre, 'nome' => $I->grabTestName( 'bozza' ) ) ) );

            // i contenuti nella lingua corrente, che il 420 cerca per le sotto pagine
            foreach( array( $idMadre, $idPubblicata, $idBozza ) as $id ) {
                $I->haveInDatabase( 'contenuti', array( 'id_pagina' => $id, 'id_lingua' => $cf['localization']['language']['id'], 'title' => $I->grabTestName( 'contenuto' ), 'abstract' => 'abstract di prova' ) );
            }

            // pubblicate la madre e una sola figlia
            foreach( array( $idMadre, $idPubblicata ) as $id ) {
                $I->haveInDatabase( 'pubblicazioni', array( 'id_pagina' => $id, 'id_tipologia' => 2, 'note' => $I->grabTestName( 'pubblicazione' ) ) );
            }

            // l'array delle pagine sta in memcache
            $I->clearGliswebCache();

            $I->amOnPage( '/?p=' . $idMadre );

            // il 420 salta la figlia non pubblicata e lo scrive nel log
            $log = DIR_VAR_LOG . 'pagine.debug.' . date( 'Ym' ) . '.log';
            $saltata = false;
            for( $i = 0; $i < 10 && $saltata === false; $i++ ) {
                if( file_exists( $log ) && strpos( file_get_contents( $log ), 'sotto pagina ' . $idBozza . ' della pagina ' . $idMadre . ' ' ) !== false ) {
                    $saltata = true;
                } else {
                    sleep( 1 );
                }
            }

            $I->assertTrue( $saltata, 'la sotto pagina non pubblicata ' . $idBozza . ' non e\' stata saltata, vedi ' . $log );
            $I->assertStringNotContainsString( 'sotto pagina ' . $idPubblicata . ' della pagina ' . $idMadre . ' ', file_get_contents( $log ), 'la sotto pagina pubblicata e\' stata saltata' );

        }

    }

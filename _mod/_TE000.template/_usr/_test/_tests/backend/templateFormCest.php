<?php

    /**
     * test delle schede dei template mail e SMS
     *
     * fino al 2026-11-05 la chiave con cui l'applicazione chiama un template stava nella colonna ruolo, che il canone
     * ha rinominato in codice ( _202611051200.template.codice.sql, punto 6 dello schema canonico, riga 189 ): il test
     * salva un template dalla scheda e controlla che il codice finisca nella colonna nuova, poi apre le schede e gli
     * elenchi mail e SMS su un template di prova e controlla che mostrino il codice
     *
     */

    class templateFormCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $I->deleteTestRecords( 'template', 'codice' );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $I->deleteTestRecords( 'template', 'codice' );

        }

        // un template mail salvato dalla scheda ha il suo codice nella colonna codice
        public function salvataggio( BackendTester $I ) {

            $codice = $I->grabTestName();

            $I->amLoggedInAs( 'roots' );

            $I->amOnPageId( 'mail.template.form' );
            $I->fillField( 'template[nome]', $codice );
            $I->fillField( 'template[codice]', $codice );
            $I->click( '#form-template button .fa-floppy-disk' );

            $I->seeInDatabase( 'template', array( 'codice' => $codice, 'se_mail' => 1 ) );

        }

        // le schede e gli elenchi mail e SMS mostrano il codice
        public function schede( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            foreach( array( 'mail' => 'se_mail', 'sms' => 'se_sms' ) as $tipo => $flag ) {

                $codice = $I->grabTestName();

                $template = $I->haveInDatabase( 'template', array(
                    'codice' => $codice,
                    'nome' => $codice,
                    'tipo' => 'twig',
                    $flag => 1
                ) );

                $I->amOnPageId( $tipo . '.template.form', array( 'template' => array( 'id' => $template ) ) );
                $I->seeInField( 'template[codice]', $codice );

                $I->amOnPageId( $tipo . '.template.view' );
                $I->see( $codice );

            }

        }

    }

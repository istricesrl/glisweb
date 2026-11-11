<?php

    /**
     * test della tendina dei reparti nella scheda di una riga di documento
     *
     * fino al 2026-11-11 le macro delle righe filtravano iva e iva_view su timestamp_archiviazione, che il canone ha
     * rinominato in data_archiviazione ( patch 202611042330 ): la query si fermava con un 1054 e le tendine di
     * aliquote e reparti restavano vuote ( crmfia e utensilerialughese, 2026-11-06/11 ); questo test prova che la
     * tendina dei reparti mostra quelli con l'aliquota attiva e non quelli con l'aliquota archiviata
     *
     */

    class documentiArticoliFormIvaCest {

        // pulizia prima del test
        public function _before( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // pulizia dopo il test
        public function _after( BackendTester $I ) {

            $this->pulisci( $I );

        }

        // toglie i record di test, dalle foglie verso il documento
        protected function pulisci( BackendTester $I ) {

            $I->deleteTestRecords( 'documenti_articoli', 'nome' );
            $I->deleteTestRecords( 'documenti', 'nome' );
            $I->deleteTestRecords( 'reparti', 'nome' );
            $I->deleteTestRecords( 'iva', 'nome' );

        }

        // la tendina mostra il reparto con l'aliquota attiva e non quello con l'aliquota archiviata
        public function repartiSenzaAliquoteArchiviate( BackendTester $I ) {

            $attivo = $I->grabTestName( 'reparto attivo' );
            $archiviato = $I->grabTestName( 'reparto archiviato' );

            $iva = $I->haveInDatabase( 'iva', array(
                'nome' => $I->grabTestName( 'aliquota attiva' ),
                'aliquota' => '22.00'
            ) );

            $I->haveInDatabase( 'reparti', array(
                'nome' => $attivo,
                'id_iva' => $iva
            ) );

            $iva = $I->haveInDatabase( 'iva', array(
                'nome' => $I->grabTestName( 'aliquota archiviata' ),
                'aliquota' => '21.00',
                'data_archiviazione' => '2026-01-01'
            ) );

            $I->haveInDatabase( 'reparti', array(
                'nome' => $archiviato,
                'id_iva' => $iva
            ) );

            $documento = $I->haveInDatabase( 'documenti', array(
                'nome' => $I->grabTestName( 'documento' )
            ) );

            $riga = $I->haveInDatabase( 'documenti_articoli', array(
                'id_documento' => $documento,
                'nome' => $I->grabTestName( 'riga' )
            ) );

            // la tendina sta nella cache delle query indicizzate
            $I->clearGliswebCache();

            $I->amLoggedInAs( 'roots' );
            $I->amOnPageId( 'documenti.articoli.form', array( 'documenti_articoli' => array( 'id' => $riga ) ) );

            $I->seeInSource( $attivo );
            $I->dontSeeInSource( $archiviato );

        }

    }

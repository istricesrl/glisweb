<?php

    /**
     * test della vista dei template delle pagine
     *
     * la vista elenca i template dello standard ( _src/_templates/ ) e quelli del progetto ( src/templates/ ): fino al
     * 26/10/2026 i secondi non comparivano, e nel CMS spariva il template del sito; un template del progetto che ha lo
     * stesso nome di uno standard ne è la personalizzazione e compare una volta sola
     *
     * su un deploy senza src/templates/ la verifica sui template del progetto non trova niente e passa senza provare
     * niente
     *
     */

    class templatePagineViewCest {

        // i template del progetto compaiono nella vista
        public function templateDelProgetto( BackendTester $I ) {

            $I->amLoggedInAs( 'roots' );

            $I->amOnPageId( 'template.pagine.view' );

            foreach( glob( DIR_BASE . 'src/templates/*', GLOB_ONLYDIR ) as $template ) {
                if( basename( $template ) != 'athena' ) {
                    $I->see( basename( $template ) );
                }
            }

        }

    }

<?php

    /**
     * test della session del carrello
     *
     * carrelli.session e' chiave unica e mysqlInsertRow() fa INSERT ... ON DUPLICATE KEY UPDATE, quindi un carrello
     * nuovo che nasce con la session o l'id di un carrello esistente ne riscrive la riga; fino al 2026-10-12 un
     * carrello nuovo poteva cosi' riscrivere o cancellare un carrello gia' pagato dallo stesso browser ( gimbe,
     * carrello 34663 ); i carrelli si aprono con una richiesta __carrello__ su una pagina qualsiasi del sito, e si
     * riconoscono dal nome dell'intestatario che porta il prefisso TEST-E2E-
     *
     */

    class carrelloSessioneCest {

        // pulizia prima del test
        public function _before( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // pulizia dopo il test
        public function _after( FrontendTester $I ) {

            $I->deleteTestRecords( 'carrelli', 'intestazione_nome' );

        }

        // apre un carrello dal browser e ne restituisce l'id
        protected function apriCarrello( FrontendTester $I, $nome, $parametri = array() ) {

            // la pagina del carrello e non la home: dove / e' rediretta il redirect arriva prima dei controller del carrello
            $I->amOnPageId( 'carrello', array( '__carrello__' => array_merge( $parametri, array( 'intestazione_nome' => $nome ) ) ) );

            $id = $I->grabFromDatabase( 'SELECT id FROM carrelli WHERE intestazione_nome = ?', array( $nome ) );
            if( empty( $id ) ) {
                $I->fail( 'carrello ' . $nome . ' non creato, vedi var/log/cart' );
            }

            return $id;

        }

        // un carrello chiuso ancora legato alla sessione non viene ne' riscritto ne' cancellato dal carrello nuovo
        public function carrelloChiusoNonRiscritto( FrontendTester $I ) {

            $chiuso = $I->grabTestName( 'chiuso' );
            $nuovo = $I->grabTestName( 'nuovo' );

            // primo carrello, poi chiuso come farebbe il listener di pagamento
            $idChiuso = $this->apriCarrello( $I, $chiuso );
            $I->updateInDatabase( 'carrelli', array( 'id' => $idChiuso, 'timestamp_checkout' => time() ) );

            // sessione nuova col carrello vuoto, a cui resta legato il carrello chiuso
            $I->resetCookie( 'PHPSESSID' );
            $I->amOnPageId( 'carrello' );
            $I->updateInDatabase( 'carrelli', array( 'id' => $idChiuso, 'session' => $I->grabCookie( 'PHPSESSID' ) ) );

            // secondo carrello dallo stesso browser
            $idNuovo = $this->apriCarrello( $I, $nuovo );

            $I->assertNotEquals( $idChiuso, $idNuovo );
            $I->seeInDatabase( 'carrelli', array( 'id' => $idChiuso, 'intestazione_nome' => $chiuso ) );
            $I->assertEmpty( $I->grabFromDatabase( 'SELECT session FROM carrelli WHERE id = ?', array( $idChiuso ) ) );

        }

        // l'id di un carrello esistente passato dalla richiesta non viene usato
        public function idDallaRichiestaIgnorato( FrontendTester $I ) {

            $altrui = $I->grabTestName( 'altrui' );
            $nuovo = $I->grabTestName( 'nuovo' );

            // carrello di un altro browser
            $idAltrui = $this->apriCarrello( $I, $altrui );

            // carrello nuovo da un'altra sessione che prova a prendersi l'id del primo
            $I->resetCookie( 'PHPSESSID' );
            $idNuovo = $this->apriCarrello( $I, $nuovo, array( 'id' => $idAltrui ) );

            $I->assertNotEquals( $idAltrui, $idNuovo );
            $I->seeInDatabase( 'carrelli', array( 'id' => $idAltrui, 'intestazione_nome' => $altrui ) );

        }

    }

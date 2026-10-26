<?php

    /**
     * test dei privilegi del gruppo guests
     *
     * dal 2026-10-26 un task che deve girare senza login non toglie checkTaskPrivilege(): il progetto assegna il suo
     * privilegio al gruppo guests ( auth.groups.guests.privilegi ) e getPrivilege() lo riconosce a chiunque, anonimo
     * o collegato; senza privilegio richiesto, invece, serve sempre una sessione autenticata
     *
     * il test modifica $cf e $_SESSION e li rimette com'erano alla fine
     *
     */

    class privilegiGuestsCest {

        // copia di quello che il test modifica
        protected $guests;
        protected $sessione;

        // salvo lo stato
        public function _before( UnitTester $I ) {

            global $cf;

            $this->guests = $cf['auth']['groups']['guests'] ?? NULL;
            $this->sessione = $_SESSION['account'] ?? NULL;

        }

        // rimetto lo stato
        public function _after( UnitTester $I ) {

            global $cf;

            $cf['auth']['groups']['guests'] = $this->guests;
            $_SESSION['account'] = $this->sessione;

        }

        // lo standard dichiara il gruppo guests senza privilegi
        public function guestsNelloStandard( UnitTester $I ) {

            $I->assertIsArray( $this->guests, 'manca il gruppo guests in $cf[\'auth\'][\'groups\']' );
            $I->assertSame( array(), $this->guests['privilegi'], 'nello standard guests non deve avere privilegi' );

        }

        // un anonimo non ha privilegi, salvo quelli dati a guests
        public function anonimo( UnitTester $I ) {

            global $cf;

            $_SESSION['account'] = NULL;

            $cf['auth']['groups']['guests']['privilegi'] = array();
            $I->assertFalse( getPrivilege( 'TEST_GUESTS' ), 'un anonimo ha un privilegio che guests non ha' );

            $cf['auth']['groups']['guests']['privilegi'] = array( 'TEST_GUESTS' );
            $I->assertTrue( getPrivilege( 'TEST_GUESTS' ), 'un anonimo non ha il privilegio dato a guests' );
            $I->assertFalse( getPrivilege( 'ALTRO' ), 'un anonimo ha un privilegio che guests non ha' );
            $I->assertFalse( getPrivilege( NULL ), 'senza privilegio richiesto un anonimo deve essere rifiutato' );

        }

        // un utente collegato ha i suoi privilegi e quelli di guests
        public function collegato( UnitTester $I ) {

            global $cf;

            $_SESSION['account'] = array( 'gruppi' => array( 'users' ), 'privilegi' => array( 'SUO' ) );

            $cf['auth']['groups']['guests']['privilegi'] = array();
            $I->assertTrue( getPrivilege( 'SUO' ), 'un collegato non ha il suo privilegio' );
            $I->assertFalse( getPrivilege( 'TEST_GUESTS' ), 'un collegato ha un privilegio che non gli e\' stato dato' );
            $I->assertTrue( getPrivilege( NULL ), 'senza privilegio richiesto un collegato deve passare' );

            $cf['auth']['groups']['guests']['privilegi'] = array( 'TEST_GUESTS' );
            $I->assertTrue( getPrivilege( 'TEST_GUESTS' ), 'un collegato non ha il privilegio dato a guests' );

        }

    }

<?php

    /**
     * test dell'integrazione dei permessi da file Json/Yaml
     *
     * _205.auth.php integra $cx['auth'] in $cf['auth'], ma _250.auth.php dichiara dopo di lui l'array dei permessi e lo
     * riassegna da capo: fino al 2026-11-18 i permessi scritti in config.json / config.yaml andavano persi in silenzio
     * ( bernispa, auth.permissions.__report_barcode_qta__ ); ora li integra _255.auth.php, e questo test lo controlla
     * includendo il runlevel con un $cf e un $cx costruiti apposta, e sul bootstrap vero del deploy se la sua
     * configurazione dichiara dei permessi
     *
     */

    class authPermessiCest {

        // un'entità nuova da config si aggiunge, e un gruppo nuovo su un'entità dello standard si aggiunge anche lui
        public function permessiDaConfigIntegrati( UnitTester $I ) {

            $permessi = $this->runlevel(
                array(
                    'anagrafica' => array( CONTROL_FULL => array( 'roots', 'staff' ) ),
                    'account' => array( CONTROL_FULL => array( 'roots' ) )
                ),
                array(
                    '__report_test__' => array( CONTROL_FULL => array( 'roots' ) ),
                    'account' => array( CONTROL_FULL => array( 1 => 'staff' ) )
                )
            );

            $I->assertEquals( array( 'roots' ), $permessi['__report_test__'][ CONTROL_FULL ] );
            $I->assertEquals( array( 'roots', 'staff' ), $permessi['account'][ CONTROL_FULL ] );
            $I->assertEquals( array( 'roots', 'staff' ), $permessi['anagrafica'][ CONTROL_FULL ] );

        }

        // senza permessi in configurazione l'array dello standard resta com'è
        public function senzaConfigNienteCambia( UnitTester $I ) {

            $standard = array( 'anagrafica' => array( CONTROL_FULL => array( 'roots', 'staff' ) ) );

            $I->assertEquals( $standard, $this->runlevel( $standard, NULL ) );

        }

        // sul bootstrap vero, ogni permesso dichiarato in configurazione arriva in $cf['auth']['permissions']
        public function bootstrapDelDeploy( UnitTester $I ) {

            global $cf, $cx;

            if( empty( $cx['auth']['permissions'] ) ) {
                $I->markTestSkipped( 'la configurazione del deploy non dichiara permessi' );
            }

            foreach( $cx['auth']['permissions'] as $t => $w ) {
                foreach( $w as $k => $j ) {
                    foreach( $j as $g ) {
                        $I->assertContains( $g, $cf['auth']['permissions'][ $t ][ $k ] ?? array(), 'il permesso ' . $k . ' di ' . $g . ' su ' . $t . ' non è arrivato' );
                    }
                }
            }

        }

        /**
         * include _255.auth.php con un $cf e un $cx costruiti apposta
         *
         * @param       array       $standard       i permessi come li lascia _250.auth.php
         * @param       array       $config         i permessi di config.json / config.yaml, o NULL se non ce ne sono
         *
         * @return      array                       i permessi dopo il runlevel
         *
         */
        protected function runlevel( $standard, $config ) {

            $cf = array( 'auth' => array( 'status' => NULL, 'permissions' => $standard ) );
            $cx = ( $config === NULL ) ? array() : array( 'auth' => array( 'permissions' => $config ) );

            include DIR_BASE . '_src/_config/_255.auth.php';

            return $cf['auth']['permissions'];

        }

    }

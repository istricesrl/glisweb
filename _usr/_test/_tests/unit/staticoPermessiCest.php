<?php

    /**
     * test statico degli script dei permessi
     *
     * _lamp.permissions.secure.sh e _lamp.permissions.open.sh girano anche da cron ( manutenzione-siti,
     * _gw.upgrade.sh ), dove TERM non c'e' e molti deploy non hanno src/templates, src/tpl, tmp o mod/<modulo>/src/tpl:
     * ogni riga che lo segnala finisce nel log di cron come rumore, e il controllo dei log la conta
     *
     * il test legge i sorgenti e non li esegue; una riga rumorosa e' un test rosso che indica lo script da correggere
     *
     */

    class staticoPermessiCest {

        // clear solo a terminale: senza TERM scrive 'TERM environment variable not set'
        public function clearSoloATerminale( UnitTester $I ) {

            foreach( array( 'secure', 'open' ) as $modo ) {

                $codice = file_get_contents( DIR_BASE . '_src/_sh/_lamp.permissions.' . $modo . '.sh' );

                $I->assertDoesNotMatchRegularExpression( '/^\s*clear\s*$/m', $codice, '_lamp.permissions.' . $modo . '.sh: clear senza [ -t 1 ]' );

            }

        }

        // chown e find sulle cartelle che non tutti i deploy hanno tacciono se la cartella manca
        public function cartelleOpzionaliSilenziose( UnitTester $I ) {

            $codice = file_get_contents( DIR_BASE . '_src/_sh/_lamp.permissions.secure.sh' );

            $rumorose = array();

            foreach( explode( "\n", $codice ) as $n => $riga ) {
                if( preg_match( '/^(chown|find)\s.*\.\/\$SUB\/(src\/tpl|src\/templates|mod\/\*\/src\/tpl|mod\/\*\/src\/templates|tmp)([\s\/]|$)/', $riga ) && strpos( $riga, '2>/dev/null' ) === false ) {
                    $rumorose[] = ( $n + 1 );
                }
            }

            $I->assertEmpty( $rumorose, 'righe senza 2>/dev/null in _lamp.permissions.secure.sh: ' . implode( ', ', $rumorose ) );

        }

    }

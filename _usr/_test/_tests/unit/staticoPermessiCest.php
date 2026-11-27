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

        // su CloudPanel php-fpm gira come l'utente del sito: proprietario e gruppo sono i suoi, non root:www-data
        public function cloudPanelUtenteDelSito( UnitTester $I ) {

            $codice = file_get_contents( DIR_BASE . '_src/_sh/_lamp.permissions.secure.sh' );

            $I->assertMatchesRegularExpression( '/\/home\/\(\[\^\/\]\+\)\/htdocs\//', $codice, 'manca il riconoscimento del deploy CloudPanel' );
            $I->assertDoesNotMatchRegularExpression( '/^chown\s.*(root|www-data):(root|www-data)\s/m', $codice, 'chown con proprietario fisso: su CloudPanel il pool non legge piu\' il deploy' );
            $I->assertDoesNotMatchRegularExpression( '/-exec chmod (2550|640|550) /', $codice, 'modi fissi nei find: su CloudPanel il proprietario deve scrivere' );

        }

        // composer si cerca anche in /usr/local/bin, e senza composer l'aggiornamento si ferma PRIMA del backup e del rm
        public function upgradeTrovaComposer( UnitTester $I ) {

            $codice = file_get_contents( DIR_BASE . '_src/_sh/_gw.upgrade.sh' );

            $I->assertStringContainsString( '/usr/local/bin', $codice, '_gw.upgrade.sh non cerca composer in /usr/local/bin' );
            $I->assertDoesNotMatchRegularExpression( '/^\s*(if\s+)?composer\s/m', $codice, '_gw.upgrade.sh chiama composer dal PATH invece che da $COMPOSER' );

            $cerca  = strpos( $codice, 'command -v composer' );
            $backup = strpos( $codice, 'inizio il backup' );
            $I->assertNotFalse( $cerca, '_gw.upgrade.sh non cerca composer' );
            $I->assertLessThan( $backup, $cerca, '_gw.upgrade.sh cerca composer dopo il backup' );

        }

        // NODB al posto del profilo salta sia il gradino sia le patch: il controllo sta prima di tutt'e due
        public function upgradeNodbNonToccaIlDatabase( UnitTester $I ) {

            $codice = file_get_contents( DIR_BASE . '_src/_sh/_gw.upgrade.sh' );

            $nodb    = strpos( $codice, 'if [ "$STATO" = "NODB" ]; then' );
            $gradino = strpos( $codice, 'gw-gradino $STATO' );
            $patch   = strpos( $codice, '_mysql.upgrade.sh $STATO --si' );
            $I->assertNotFalse( $nodb, '_gw.upgrade.sh non riconosce NODB' );
            $I->assertLessThan( $gradino, $nodb, 'il controllo di NODB viene dopo gw-gradino' );
            $I->assertLessThan( $patch, $nodb, 'il controllo di NODB viene dopo _mysql.upgrade.sh' );
            $I->assertMatchesRegularExpression( '/if \[ "\$STATO" = "NODB" \]; then.*?\n\s*elif \[ -x \.\/_src\/_sh\/_mysql\.upgrade\.sh \]; then/s', $codice, 'gradino e patch non stanno nel ramo alternativo a NODB' );

        }

    }

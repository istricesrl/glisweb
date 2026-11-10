<?php

    /**
     * test statico dei task del nucleo e dei moduli
     *
     * ogni file di _src/_api/_task/ ( e dei corrispondenti nei moduli ) e' raggiungibile da HTTP come /task/<nome>,
     * quindi deve avere una guardia: checkTaskPrivilege() per chi arriva dal browser, oppure il controllo di
     * CRON_RUNNING per i task che girano solo da cron ( S-010 )
     *
     * il test legge i sorgenti e non li esegue; un task senza guardia e' un test rosso che indica il file da correggere
     *
     */

    class staticoTaskCest {

        // S-010 task: ogni task richiama checkTaskPrivilege() o controlla CRON_RUNNING
        public function taskConGuardia( UnitTester $I ) {

            $task = array_merge(
                (array) glob( DIR_BASE . '_src/_api/_task/*.php' ),
                (array) glob( DIR_BASE . '_mod/*/_src/_api/_task/*.php' )
            );

            $I->assertNotEmpty( $task, 'nessun task trovato: il test non prova niente' );

            $senzaGuardia = array();

            foreach( $task as $file ) {

                $codice = file_get_contents( $file );

                // un task che rimanda a un altro task ( require __DIR__ . '/_altro.php' ) eredita la guardia di quello
                if( preg_match( '/require(_once)?\s+(__DIR__\s*\.\s*[\'"]\/|[\'"])([^\'"\/]+\.php)[\'"]/', $codice, $m ) && is_file( dirname( $file ) . '/' . $m[3] ) ) {
                    $codice .= file_get_contents( dirname( $file ) . '/' . $m[3] );
                }

                if( strpos( $codice, 'checkTaskPrivilege' ) === false && strpos( $codice, 'CRON_RUNNING' ) === false ) {
                    $senzaGuardia[] = str_replace( DIR_BASE, '', $file );
                }

            }

            $I->assertEmpty( $senzaGuardia, 'task senza guardia: ' . implode( ', ', $senzaGuardia ) );

        }

        // il resoconto di _security.clean.php va nel log a LOG_WARNING: la produzione lo scrive ancora, e da LOG_CRIT
        // in su il controllo dei log lo contava come errore grave anche quando era solo un possibile falso positivo
        public function securityCleanResocontoWarning( UnitTester $I ) {

            $codice = file_get_contents( DIR_BASE . '_src/_api/_task/_security.clean.php' );

            $I->assertStringContainsString( "logWrite( \$resoconto, 'security', LOG_WARNING )", $codice );
            $I->assertDoesNotMatchRegularExpression( "/logWrite\(\s*\\\$resoconto[^;]*LOG_(CRIT|ALERT|EMERG)/", $codice );

        }

    }

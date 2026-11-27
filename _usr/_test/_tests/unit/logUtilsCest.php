<?php

/**
 * test di _src/_lib/_log.utils.php
 *
 * le richieste dei test, che portano il marcatore nello User-Agent, scrivono i log in var/log/test/; quelle senza
 * marcatore, cioè il traffico vero che arriva durante un giro, nei log del deploy ( _src/_config/_020.debug.php )
 *
 */

class logUtilsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $I->assertTrue( defined( 'LOG_TEST_USER_AGENT' ), 'il segreto del giro lo scrive _src/_sh/_codeception.run.sh' );
    }

    // logWrite() -> una richiesta col marcatore scrive in var/log/test/
    public function logDelTestAParte(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_log.utils/_logWrite.01.php');
        $I->see('riga scritta in var/log/test/');
    }

    // logWrite() -> una richiesta senza marcatore scrive nei log del deploy
    public function logSenzaMarcatore(UnitTester $I)
    {
        global $cf;

        $curl = curl_init( rtrim( $cf['site']['url'], '/' ) . '/_usr/_examples/_lib/_log.utils/_logWrite.01.php' );
        curl_setopt( $curl, CURLOPT_RETURNTRANSFER, true );
        curl_setopt( $curl, CURLOPT_USERAGENT, 'Mozilla/5.0' );
        curl_setopt( $curl, CURLOPT_SSL_VERIFYPEER, false );
        curl_setopt( $curl, CURLOPT_SSL_VERIFYHOST, 0 );
        $raw = curl_exec( $curl );
        curl_close( $curl );

        $I->assertStringContainsString( 'riga scritta in var/log/', (string) $raw );
        $I->assertStringNotContainsString( 'var/log/test/', (string) $raw );
    }

}

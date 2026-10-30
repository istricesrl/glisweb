<?php

/**
 * test di _src/_lib/_mail.tools.php
 *
 */

class mailToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // sendMail() -> senza un destinatario valido in A la mail non parte, nemmeno verso i CC, e l'errore va a LOG_CRIT
    public function sendMailSenzaDestinatari(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_mail.tools/_sendMail.01.php');
        $I->see('status: false');
        $I->see('errore scritto a LOG_CRIT');
    }

}

<?php

/**
 * test di _src/_lib/_controller.tools.php
 *
 * controller() non deve scrivere le sottoform quando la scrittura del padre è fallita: senza l'id del padre
 * resterebbero con la chiave esterna NULL ( account_gruppi orfane su polmasi, 29/10/2026 )
 *
 */

class controllerToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // controller() -> un account con username già usato dà 409 e la sua sottoform account_gruppi non viene scritta
    public function sottoformPadreFallito(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_controller.tools/_controller.01.php');
        $I->dontSee('segreto di importazione assente');
        $I->see('primo account: 200');
        $I->see('secondo account: 409');
        $I->see('sottoform orfane: 0');
    }

}

<?php

/**
 * test di /status/uptime
 *
 * la pagina che il controllo di uptime ( il progetto glisweb-check-24x7, fuori dal framework dal 05/11/2026 ) legge
 * da ogni deploy: per tutti solo OK o KO, e nessun ramo col token, che fino al 05/11/2026 serviva la vista del server
 *
 */

class statusUptimeCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // /status/uptime -> OK, senza versioni né nomi
    public function statusPubblico(UnitTester $I)
    {
        $I->amOnPage('/status/uptime');
        $I->seeResponseCodeIs(200);
        $I->see('OK');
        $I->dontSee('versione');
    }

    // /status/uptime -> col vecchio header del token risponde come a tutti: niente 403, niente vista in JSON
    public function senzaVista(UnitTester $I)
    {
        $I->haveHttpHeader('X-Glisweb-Uptime', 'un-token-qualsiasi');
        $I->amOnPage('/status/uptime');
        $I->seeResponseCodeIs(200);
        $I->see('OK');
        $I->dontSee('"siti"');
    }

}

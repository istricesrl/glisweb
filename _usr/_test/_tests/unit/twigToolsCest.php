<?php

class twigToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // twigPulisci() -> deve lasciare intatti i segnaposto puri e rendere testo tutto il resto della sintassi Twig
    // NOTA si controlla l'output di var_dump() senza xdebug, che non e' installato ovunque
    public function twigPulisci(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_twig.tools/_twigPulisci.01.php');
        $I->see('string(30) "{{ dt.nome }} {{ dt.cognome }}"');
        $I->see('string(30) "{ {[\'id\']|map(\'system\')|join}}"');
        $I->see('string(15) "{ {{ dt.nome }}"');
        $I->see('string(41) "{ % set x = 1 %}{ # nota #}{ { dt.nome }}"');
        $I->see('string(26) "Pinco {{ 7*7 }} { { 7*7 }}"');
    }

}

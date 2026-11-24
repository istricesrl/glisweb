<?php

class mastriUtilsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // creaMissioneRifornimento() -> deve creare la missione legata alla richiesta, con tutte le righe nel database
    public function creaMissioneRifornimento(UnitTester $I)
    {
        $I->amOnPage('/_mod/_0500.mastri/_usr/_examples/_lib/_mysql.utils/_creaMissioneRifornimento.01.php');
        $I->see('errore NULL');
        $I->see('tipologia 36');
        $I->see('relazioni 1');
        $I->see('righe in missione 2 su 2');
        $I->see('quantita 5');
        $I->see('pulizia 0');
        $I->see('pulizia appoggio 0');
    }

}

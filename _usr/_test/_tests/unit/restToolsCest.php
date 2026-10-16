<?php

class restToolsCest
{

    // settaggi pre test
    public function _before(UnitTester $I)
    {
    }

    // restMaskSecrets() -> deve mascherare password, secret e token e lasciare intatto tutto il resto
    public function restMaskSecrets(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_rest.tools/_restMaskSecrets.01.php');
        $I->see('["username"]=> string(5) "mario"');
        $I->see('["password"]=> string(3) "***"');
        $I->see('["client_secret"]=> string(0) ""');
        $I->see('["pwd"]=> string(3) "***"');
        $I->see('{"access_token":"***","token_type":"Bearer","expires_in":3600,"refreshToken":null}');
        $I->see('grant_type=password&username=mario&password=***&api_key=');
        $I->see('https://example.com/api?id=7&apikey=***');
        $I->seeInSource('<login><user>mario</user><Password type="x">***</Password></login>');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}

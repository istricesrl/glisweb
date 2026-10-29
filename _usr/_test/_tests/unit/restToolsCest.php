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

    // restMockUrl() -> devia solo gli host elencati, con percorso e query, e lascia stare il resto
    public function restMockUrl(UnitTester $I)
    {
        $I->amOnPage('/_usr/_examples/_lib/_rest.tools/_restMockUrl.01.php');
        $I->see('http://127.0.0.1:8790/api.esempio.test/v1/ordini?id=7');
        $I->see('http://127.0.0.1:8790/api.esempio.test/');
        $I->see('https://altro.esempio.test/v1/ordini');
        $I->see('non e un url');
    }

    // restCall() durante i test -> la chiamata a esempio.test arriva al finto REST, che risponde come gli si e' detto
    // e registra la richiesta con le credenziali mascherate
    public function restCallFintoRest(UnitTester $I)
    {
        $I->assertTrue( \Helper\RestMock::attivo(), 'il finto REST lo avvia _src/_sh/_codeception.run.sh' );
        \Helper\RestMock::pulisci();
        \Helper\RestMock::risposta( 'POST', '#^/v1/ordini$#', array( 'id' => 42 ), 201, 'esempio.test' );
        $I->amOnPage('/_usr/_examples/_lib/_rest.tools/_restCall.mock.01.php');
        $I->see('status: 201');
        $I->see('risposta: {"id":42}');
        $richieste = \Helper\RestMock::richieste( 'POST', '#^/v1/ordini$#', 'esempio.test' );
        $I->assertCount( 1, $richieste );
        $I->assertEquals( 7, $richieste[0]['corpo']['numero'] );
        $I->assertEquals( '***', $richieste[0]['corpo']['password'] );
        $I->assertEquals( 'apikey=***', $richieste[0]['query'] );
    }

    // restCall() senza una risposta preparata -> 404, cosi' un test che se l'e' dimenticata non passa per caso
    public function restCallFintoRestSenzaRisposta(UnitTester $I)
    {
        \Helper\RestMock::pulisci();
        $I->amOnPage('/_usr/_examples/_lib/_rest.tools/_restCall.mock.01.php');
        $I->see('status: 404');
        $I->see('nessuna risposta preparata per POST esempio.test/v1/ordini');
        \Helper\RestMock::pulisci();
    }

    // il finto REST aperto da Apache non fa niente
    public function fintoRestNonRispondeDaApache(UnitTester $I)
    {
        $I->amOnPage('/_usr/_test/_rest.mock.php');
        $I->see('questo file lo avvia _src/_sh/_codeception.run.sh');
        $I->dontSee('nessuna risposta preparata');
    }

    // settaggi post test
    public function _after(UnitTester $I)
    {
    }

}

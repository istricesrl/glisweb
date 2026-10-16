<?php

    /**
     * esempio di restMaskSecrets()
     *
     * L'output è controllato da _usr/_test/_tests/unit/restToolsCest.php: i valori di password, secret e token devono
     * uscire come ***, tutto il resto ( token_type, expires_in, i valori vuoti, gli altri campi ) deve restare intatto,
     * in array, JSON, corpo urlencoded e XML.
     *
     */

    require '../../../../_src/_config.php';

    var_dump( restMaskSecrets( array( 'username' => 'mario', 'password' => 'Segreta1', 'client_secret' => '', 'login' => array( 'pwd' => 'x9' ) ) ) );
    var_dump( restMaskSecrets( '{"access_token":"eyJ.abc\"def","token_type":"Bearer","expires_in":3600,"refreshToken":null}' ) );
    var_dump( restMaskSecrets( 'grant_type=password&username=mario&password=Segreta%261&api_key=' ) );
    var_dump( restMaskSecrets( 'https://example.com/api?id=7&apikey=K123' ) );
    var_dump( restMaskSecrets( '<login><user>mario</user><Password type="x">Segreta1</Password></login>' ) );

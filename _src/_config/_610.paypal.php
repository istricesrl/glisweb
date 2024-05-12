<?php

    /**
     * server e profili paypal
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * configurazione dei profili
     * ==========================
     *
     * 
     * variabile    | descrizione
     * -------------|---------------------------------------------------------
     * sandbox      | variabile booleana che indica se il profilo deve andare su sandbox o no
     *
     *
     *
     *
     * @todo documentare
     * 
     */

    // profili di funzionamento per DEV e TEST
	$cf['paypal']['profiles'][ DEVELOPEMENT ]   =
	$cf['paypal']['profiles'][ TESTING ]        = array(
        'auth_api'      => 'https://api-m.sandbox.paypal.com/v1/oauth2/token',              // API alla quale richiedere l'Access Token
        'token_api'     => 'https://api-m.sandbox.paypal.com/v1/identity/generate-token',   // API alla quale richiedere il Client Token
        'order_api'     => 'https://api-m.sandbox.paypal.com/v2/checkout/orders',           // API alla quale richiedere l'Order ID
    );

    // profilo di funzionamento per PROD
    $cf['paypal']['profiles'][ PRODUCTION ]	= NULL;

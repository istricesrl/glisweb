<?php

    /**
     * libreria per la gestione di Google reCaptcha
     * 
     * @todo documentare
     * 
     * @file
     * 
     */


    function reCaptchaVerifyV3( $t, $k ) {

	$dati = array(
        'secret' => $k,
        'response' => $t
    );
	
	$r = restCall( 'https://www.google.com/recaptcha/api/siteverify', METHOD_POST, $dati, 'query', MIME_APPLICATION_JSON, $status );

	if( isset( $r['score'] ) ){
		appendToFile(  $r['score']  . PHP_EOL, 'var/log/google_recaptcha_score.log' );
	}
	else{
		appendToFile(  'nessuno score restituito'  . PHP_EOL, 'var/log/google_recaptcha_score.log' );
	}
	
    return $r['score'];

    }

?>

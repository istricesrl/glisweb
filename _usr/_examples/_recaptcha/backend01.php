<?php

    function reCaptchaVerifyV3( $t ) {

	$h = 'https://www.google.com/recaptcha/api/siteverify';
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $h);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array(
	    'secret' => '6LeWItIZAAAAAOnXSW6ISp-Af8A2dzElj_r1HB-1',
	    'response' => $t
	)));
	$output = curl_exec($ch);
	curl_close($ch);

	return json_decode( $output, true );

    }

    print_r( $_REQUEST );

    print_r( reCaptchaVerifyV3($_REQUEST['g-recaptcha-response']));

?>

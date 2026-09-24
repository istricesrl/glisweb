<?php

    // inclusione del framework
	require '../../../_src/_config.php';

    print_r( $_REQUEST );

    print_r( 
		reCaptchaVerifyV3(
			$_REQUEST['g-recaptcha-response'],
			$cf['google']['profile']['recaptcha']['keys']['private']
		)
	);

	// NOTA: se la funzione reCaptchaVerifyV3 restituisce uno score alto (es. > 0.7) probabilmente si tratta di una persona, quindi procedere con le
	// eventuali operazioni lato backend

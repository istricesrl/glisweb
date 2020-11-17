<?php

    // inclusione del framework
	require '../../../_src/_config.php';

    print_r( $_REQUEST );

    print_r( 
		reCaptchaVerifyV3(
			$_REQUEST['g-recaptcha-response'],
			$cf['google']['recaptcha']['profile']['secret']
		)
	);

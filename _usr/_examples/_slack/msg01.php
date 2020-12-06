<?php

    // inclusione del framework
	require '../../../_src/_config.php';

    // messaggio
    print_r( slackTxtMsg( $cf['slack']['profile']['webhooks']['default'], 'prova' ) );

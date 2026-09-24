<?php

    // inclusione del framework
	require '../../../_src/_config.php';

    echo '<pre>' . print_r( xml2array( readStringFromFile( '_usr/_examples/_xml/_esempio.01.xml' ) ), true ) . '</pre>';

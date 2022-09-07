<?php

	// inclusione del framework
	require '../../../../../_src/_config.php';

	// output
	buildJson( ( ( isset( $_SESSION['popup'] ) ) ? $_SESSION['popup'] : NULL ) );

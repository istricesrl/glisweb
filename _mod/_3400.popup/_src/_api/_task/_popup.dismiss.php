<?php

	require '../../../../../_src/_config.php';
	
	if( isset( $_REQUEST['idPopup'] ) ){

		print_r( $_REQUEST['idPopup'] );
		
		$idPopup = $_REQUEST['idPopup'];
		
		$_SESSION['popup']['chiusi'][] = $idPopup;

		print_r( $_SESSION['popup'] );
		
	}
	
	

<?php

	require '../../../../../_src/_config.php';
	
	if( isset( $_REQUEST['idPopup'] ) ){
		
		$idPopup = str_replace( 'popup-', '', $_REQUEST['idPopup'] );
		
		$_SESSION['popup']['chiusi'][] = $idPopup;
		
	}
	
	

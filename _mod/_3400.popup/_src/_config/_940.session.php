<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * // NOTA: ho dovuto metterlo in standard se no non lo leggeva, non so perché... ricordarselo al prossimo update
     *
     *
     * @file
     *
     */

	// se è richiesta la chiusura di un popup
	if( isset( $_REQUEST['idPopup'] ) ){

        $_SESSION['popup']['chiusi'][] = $_REQUEST['idPopup'];
	}

    // scrivo i popup chiusi
	if( isset( $_SESSION['popup']['chiusi'] ) ) {
		setcookie( 'popup', serialize( $_SESSION['popup']['chiusi'] ), time()+60*60*24*30 );
	}

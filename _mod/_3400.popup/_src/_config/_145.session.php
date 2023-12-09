<?php

    /**
     *
     *
     * @todo finire di documentare
     * 
     * // NOTA: ho dovuto metterlo in standard se no non lo leggeva, non so perché... ricordarselo al prossimo update
     *
     * @file
     *
     */

     // recupero i popup chiusi
	if( isset( $_COOKIE['popup'] ) ) {
		if( !isset( $_SESSION['popup']['chiusi'] ) ){
			$_SESSION['popup']['chiusi'] = array();
		}
	    $_SESSION['popup']['chiusi'] = array_replace_recursive( unserialize( $_COOKIE['popup'] ), $_SESSION['popup']['chiusi'] );
	}

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
     *
     *
     *
     * @file
     *
     */

    // recupero i popup chiusi
	if( isset( $_COOKIE['popup'] ) ) {
	    $_SESSION['popup']['chiusi'] = array_replace_recursive( unserialize( $_COOKIE['popup'] ), $_SESSION['popup']['chiusi'] );
	}

<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // se ...
    if( isset( $ct['page']['contents']['metro'] ) && is_array( $ct['page']['contents']['metro'] ) ) {

	// per ogni ...
	    foreach( $ct['page']['contents']['metro'] as $sezione => $metros ) {

		// per ogni ...
		    foreach( $metros as $metro ) {

			// se ...
			    if( isset( $metro['modal']['include'] ) ) {
					$ct['page']['contents']['modals']['metro'][] = array(
						'schema' => $metro['modal']['include']
					);
			    }

		    }

	    }

    }

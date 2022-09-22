<?php

    /**
     * 
     * 
     *
     * @todo finire la documentazione
     *
     * @file
     *
     */

    // definisco i gruppi funzionali per cui possono essere aggiunti bookmarks
    foreach( $cf['bookmarks'] as $section => $details ) {
        if( isset( $_SESSION['__work__'][ $section ] ) ) {
            $_SESSION['__work__'][ $section ] = array_replace_recursive(
                $_SESSION['__work__'][ $section ],
                $details
            );
        }
    }

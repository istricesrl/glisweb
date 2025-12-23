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
    if( isset( $cf['contents']['pages']['iscrizioni.form']['url'][ LINGUA_CORRENTE ] ) ) {
        $cf['bookmarks'] = array_replace_recursive(
            $cf['bookmarks'],
            array(
                'corsi' => array(
                    'label' => 'gestione corsi',
                    'actions' => array(
                        'iscrizione' => array(
                            'label' => 'vai all\'iscrizione',
                            'url' => $cf['contents']['pages']['iscrizioni.form']['url'][ LINGUA_CORRENTE ]
                        )
                    )
                )
            )
        );
    }

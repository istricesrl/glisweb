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
    // TODO spostare il blocco iscrizioni nel modulo iscrizioni
    $cf['bookmarks'] = array_replace_recursive(
        $cf['bookmarks'],
        array(
            'iscrizioni' => array(
                'label' => 'iscrizione corsi',
                'action' => array(
                    'label' => 'vai all\'iscrizione',
                    'url' => $cf['contents']['pages']['iscrizioni.form']['url'][ LINGUA_CORRENTE ]
                )
            )
        )
    );

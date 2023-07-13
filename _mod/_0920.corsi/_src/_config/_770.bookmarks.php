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
    $cf['bookmarks'] = array_replace_recursive(
        $cf['bookmarks'],
        array(
            'corsi' => array(
                'label' => 'gestione corsi',
                'actions' => array(
                    'duplicazione' => array(
                        'label' => 'vai alla duplicazione',
                        'url' => $cf['contents']['pages']['corsi.tools']['url'][ LINGUA_CORRENTE ]
                    )
                )
            )
        )
    );

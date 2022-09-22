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
    $cf['bookmarks'] = array(
        'mailattach' => array(
            'label' => 'allegati mail',
            'action' => array(
                'label' => 'vai alla creazione della mail',
                'url' => $cf['contents']['pages']['mail.out.form']['url'][ LINGUA_CORRENTE ]
            )
        )
    );

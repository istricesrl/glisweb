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
        'anagrafica' => array(
            'label' => 'anagrafica'
        ),
        'documenti' => array(
            'label' => 'documenti',
            'actions' => array(
                'mailattach' => array(
                    'label' => 'vai alla creazione della mail',
                    'url' => $cf['contents']['pages']['mail.out.form']['url'][ LINGUA_CORRENTE ]
                )
            )
        )
    );

<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'indirizzi';

    // base per le chiamate
    $base = '/task/';

    // gruppi di controlli
        $ct['page']['contents']['metros'] = array(
            'geocode' => array(
            'label' => 'geolocalizzazione'
            )
        );
    
        // geolocalizzazione
        if( ! empty( $cf['mapquest']['server'] ) ) {
            $ct['page']['contents']['metro']['geocode'][] = array(
            'ws' => $base . 'indirizzi.geocode?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-globe',
            'title' => 'geolocalizzazione',
            'text' => 'geolocalizza l\'indirizzo'
            );
        }
    
        // macro di default
	    require DIR_SRC_INC_MACRO . '_default.form.php';

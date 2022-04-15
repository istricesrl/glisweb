<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'risorse';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // tendina tipologie
    $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_risorse_view' 
    );

    // tendina categorie
    $ct['etc']['select']['categorie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM categorie_risorse_view' 
    );

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][] = array('id' => $mese, '__label__' => int2month( $mese ) );
	}

    // tendina giorni
	foreach( range( 1, 31 ) as $giorno ) {
	    $ct['etc']['select']['giorni'][] = array( 'id' => $giorno.'', '__label__' =>  $giorno  );
	}

    // tendina tipologie pubblicazioni
    $ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
    );

    // tendina templates
    $tpl = glob(DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE);
    foreach ($tpl as $t) {
        if (file_exists($t . '/etc/template.conf')) {
            $ct['etc']['select']['templates'][] = array('id' => str_replace(DIR_BASE, '', $t) . '/', '__label__' => basename($t));
        }
    }

    // dati che dipendono dal sito
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_sito'] ) ) {

        // tendina genitori
        $ct['etc']['select'][ $ct['form']['table'] ] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
                $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pagine_view WHERE id_sito = ? AND pagine_path_check( pagine_view.id, ? ) = 0',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_sito'] ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
            );

    }

    // dati che dipendono dal template
    if (isset($_REQUEST[$ct['form']['table']]['template'])) {

        // controllo file
        if (file_exists(DIR_BASE . $_REQUEST[$ct['form']['table']]['template'] . '/etc/template.conf')) {

            // tendina schemi
            $schemi = glob(DIR_BASE . glob2custom($_REQUEST[$ct['form']['table']]['template']) . '/*.html', GLOB_BRACE);
            foreach ($schemi as $t) {
                $ct['etc']['select']['schemi'][] = array('id' => basename($t), '__label__' => basename($t));
            }

            // tendina temi
            $temi = glob(DIR_BASE . glob2custom($_REQUEST[$ct['form']['table']]['template']) . '/css/{,themes/}*.css', GLOB_BRACE);
            foreach ($temi as $t) {
                $ct['etc']['select']['temi'][] = array('id' => basename($t), '__label__' => basename($t));
            }
        }
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

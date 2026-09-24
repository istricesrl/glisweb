<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'categorie_notizie';

    // dati che dipendono dal template
    if( isset( $_REQUEST['categorie_notizie']['template'] ) ) {

        // controllo file standard
        if( file_exists( DIR_BASE . $_REQUEST['categorie_notizie']['template'] . '/etc/template.conf' ) ) {

            // configurazione del template
            $config = parse_ini_file( DIR_BASE . $_REQUEST['categorie_notizie']['template'] . '/etc/template.conf', true, INI_SCANNER_RAW );

        } elseif( file_exists( DIR_BASE . $_REQUEST['categorie_notizie']['template'] . '/etc/template.yaml' ) ) {

            // configurazione del template
            $yaml = new \Symfony\Component\Yaml\Parser();
            $config = $yaml->parse( file_get_contents( DIR_BASE . $_REQUEST['categorie_notizie']['template'] . '/etc/template.yaml' ) );

        } else {

            $config = array();

        }

        foreach( glob( DIR_BASE . glob2custom( $_REQUEST['categorie_notizie']['template'] ) . 'etc/template.add.conf', GLOB_BRACE ) as $addCnf ) {
            $config = array_merge_recursive(
                $config,
                parse_ini_file( $addCnf, true, INI_SCANNER_RAW )
            );
        }


        // tendina menù
        if( isset( $config['template']['menu'] ) ) {
            foreach( array_keys( $config['template']['menu'] ) as $menu ) {
                $ct['etc']['select']['menu'][] = array( 'id' => $menu, '__label__' => $menu );
            }
        }
        

    }

    // tendina comportamento dei menù
    $ct['etc']['select']['sottopagine'] = array(
        array( 'id' => 'SHOW_IF_ACTIVE', '__label__' => 'espandi sottovoci' ),
        array( 'id' => 'NEVER_SHOW', '__label__' => 'non mostrare sottovoci' ),
        array( 'id' => 'ALWAYS_SHOW', '__label__' => 'mostra sempre sottovoci' )
    );

    // tendina dei target
    $ct['etc']['select']['target'] = array( 
        array( 'id' => '_blank', '__label__' => 'apri in nuova scheda' )
    );

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['tr']['languages'];

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

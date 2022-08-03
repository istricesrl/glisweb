<?php

    /**
     * macro form progetti
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

     // tabella gestita
	$ct['form']['table'] = 'progetti';

    // tendina periodi
	$ct['etc']['select']['periodi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT periodi_view.id, periodi_view.__label__ FROM periodi_view LEFT JOIN tipologie_periodi ON tipologie_periodi.id = periodi_view.id_tipologia WHERE tipologie_periodi.nome = "corsi"' );

    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_cliente = 1' );

    // tendina anagrafica per referenti e operatori (TODO vedere se filtrare sui referenti del cliente)
    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );

    if( isset( $_REQUEST[$ct['form']['table']]['id_cliente'] ) ){

        if( !empty( $_REQUEST[$ct['form']['table']]['id_indirizzo'] ) ){
            // tendina indirizzi
            $ct['etc']['select']['indirizzi'] = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT id, __label__ FROM indirizzi_view WHERE id = ? '
				.'UNION SELECT id_indirizzo AS id, indirizzo AS __label__ FROM anagrafica_indirizzi_view WHERE id_anagrafica = ? AND id_indirizzo != ?',
                array( 
					array( 's' => $_REQUEST[$ct['form']['table']]['id_indirizzo'] ),
					array( 's' => $_REQUEST[$ct['form']['table']]['id_cliente'] ),
					array( 's' => $_REQUEST[$ct['form']['table']]['id_indirizzo'] )
				)
            );
        }
        else{
            // tendina indirizzi
            $ct['etc']['select']['indirizzi'] = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT id_indirizzo AS id, indirizzo AS __label__ FROM anagrafica_indirizzi_view WHERE id_anagrafica = ?',
                array( array( 's' => $_REQUEST[$ct['form']['table']]['id_cliente'] ) )
            );
        }
        
    }

    // tendina tipologie progetti
	$ct['etc']['select']['tipologie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_progetti_view WHERE se_didattica = 1'
    );
    
    // tendina ruoli progetti
	$ct['etc']['select']['ruoli_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_anagrafica_view WHERE se_progetti = 1'
    );
    
     // tendina funzioni
	$ct['etc']['select']['funzioni'] = array(
	    array( 'id' => NULL, '__label__' => 'titolare' ),
	    array( 'id' => 1, '__label__' => 'sostituto' )
	);

    // tendina mastri attivita
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 3'
    );

    // tendina categorie progetti
	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

	$ct['etc']['select']['classi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_classe = 1'
	);

	$ct['etc']['select']['fasce'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_fascia = 1'
	);

    $ct['etc']['select']['certificazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM certificazioni_view'
	);

    $ct['etc']['select']['sn'] = array(
        array( 'id' => NULL, '__label__' => 'no' ),
        array( 'id' => 1, '__label__' => 'sì' )
    );
/*
    if ( isset( $_REQUEST[ $ct['form']['table'] ]['progetti_anagrafica'] ) )
    { 

        // riordino l'array dei ruoli mettendo prima i titolari
        foreach( $_REQUEST[ $ct['form']['table'] ]['progetti_anagrafica'] as $key => $value ) {
            $sort_data[ $key ] = $value['id_ruolo'] . ' ' . $value['se_sostituto'];
        }

        if( isset( $sort_data ) ){
            array_multisort( $sort_data, $_REQUEST[ $ct['form']['table'] ]['progetti_anagrafica'] );
        }

    }
*/
        // tendina siti
        $ct['etc']['select']['siti'] = $cf['sites'];

        // tendina tipologie pubblicazioni
        $ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
        );

        // tendina templates
        $tpl = glob( DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE );
        foreach( $tpl as $t ) {
            if( file_exists( $t . '/etc/template.conf' ) ) {
                $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
            }
        }

        // dati che dipendono dal template
        if( isset( $_REQUEST[ $ct['form']['table'] ]['template'] ) ) {

            // controllo file
            if( file_exists( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/etc/template.conf' ) ) {

            // ricerca schemi
            $schemi = array_merge(
                glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE ),
                glob( DIR_MOD_ATTIVI . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE )
            );

            // tendina schemi
            foreach( $schemi as $t ) {
                $ct['etc']['select']['schemi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
            }

                // tendina temi
                $temi = glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/css/{,themes/}*.css', GLOB_BRACE );
                foreach( $temi as $t ) {
                    $ct['etc']['select']['temi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
                }

            }

        }


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

<?php

    /**
     * macro form ticket
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
	$ct['form']['table'] = 'todo';

    // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_ticket = 1' );
    
    // tendina collaboratori
	$ct['etc']['select']['anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );
	
    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_view' );


    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );

    // tendina categorie attivita
	$ct['etc']['select']['categorie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_attivita_view WHERE se_ticket = 1'
	);

    // settaggio di cliente, indirizzo, mastro attivita letti dal progetto
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ){
        $ct['etc']['id_cliente'] = mysqlSelectValue(
                 $cf['mysql']['connection'],
                'SELECT id_cliente FROM progetti WHERE id = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
            );

        $ct['etc']['id_indirizzo'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_indirizzo FROM progetti WHERE id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
        );
       
    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        $ct['page']['contents']['metro']['general'][] = array(
            'modal' => array( 'id' => 'send', 'include' => 'inc/mail.modal.html' )
            );
    
        if( isset($_SESSION['account']['id_anagrafica'])){
                $ct['etc']['mail_account'] = mysqlSelectValue( $cf['mysql']['connection'],'SELECT indirizzo FROM mail WHERE id_anagrafica = ?', array(array( 's' => $_SESSION['account']['id_anagrafica'])));
        }
    
        $ct['etc']['mail_cliente'] = mysqlSelectValue( $cf['mysql']['connection'],'SELECT indirizzo FROM mail WHERE id_anagrafica = ? ORDER BY id LIMIT 1', array(array( 's' => $_REQUEST['todo']['id_cliente'])));
      
        $ct['etc']['mail_responsabile'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT indirizzo FROM mail WHERE id_anagrafica = ? ORDER BY id LIMIT 1', array( array('s' => $_REQUEST['todo']['id_responsabile'] ) ) );

                
        $todo = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            "SELECT t.*, 
            p.id_cliente,
            coalesce(
            a.soprannome,
            a.denominazione,
            concat_ws(' ', coalesce(a.cognome, ''),
            coalesce(a.nome, '') ),
            ''
            ) AS cliente FROM ticket_view AS t
            LEFT JOIN progetti AS p ON t.id_progetto = p.id
            LEFT JOIN anagrafica AS a ON p.id_cliente = a.id 
            WHERE t.id = ?", array( array('s' =>$_REQUEST[ $ct['form']['table'] ]['id'] ) ) );

        $template = mailGetTemplateByRuolo('DEFAULT_TICKET_RESPONSABILE');
       // print_r($template[ $cf['localization']['language']['ietf'] ]['from'][array_key_first($template[ $cf['localization']['language']['ietf'] ]['from'])]);
        $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $template[ $cf['localization']['language']['ietf'] ] ) );
        $corpo = $twig->render( 'testo', array( 'dati' => $todo ) );

        $ct['etc']['mittente_responsabile'] = $template[ $cf['localization']['language']['ietf'] ]['from'][array_key_first($template[ $cf['localization']['language']['ietf'] ]['from'])];
        $ct['etc']['testo_responsabile'] = rawurlencode($corpo);
        $ct['etc']['oggetto_responsabile'] = $template[ $cf['localization']['language']['ietf'] ]['oggetto'];

        $template_c = mailGetTemplateByRuolo('DEFAULT_TICKET_CLIENTE');
        $twig = new \Twig\Environment( new Twig\Loader\ArrayLoader( $template_c[ $cf['localization']['language']['ietf'] ] ) );
        $corpo_c = $twig->render( 'testo', array( 'dati' => $todo ) ); 

        $ct['etc']['mittente_cliente'] = $template_c[ $cf['localization']['language']['ietf'] ]['from'][array_key_first($template_c[ $cf['localization']['language']['ietf'] ]['from'])];
        $ct['etc']['testo_cliente'] = rawurlencode($corpo_c);
        $ct['etc']['oggetto_cliente'] = $template_c[ $cf['localization']['language']['ietf'] ]['oggetto'];
    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';

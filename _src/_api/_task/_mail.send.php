<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */


    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}  

    // inizializzo l'array del risultato
	$status = array();

    // se ci sono i dati nella request
	if( isset($_REQUEST) && !empty($_REQUEST['__og__']) && !empty($_REQUEST['__from__']) && !empty($_REQUEST['__to__']) && !empty($_REQUEST['__t__']) ) {

    // log
	logWrite( 'metto in coda la mail', 'mail', LOG_DEBUG );

	
	$to = explode(";",str_replace(" ", "",$_REQUEST['__to__']));

	foreach( $to as $t ) {
		$destinatari[$t] = $t;
	}
		

	// template per la mail
	    $template = array(
		    'type' => 'twig',
		    'it-IT' => array(
			'from' => array( $_REQUEST['__from__'] => $_REQUEST['__from__'] ),
			'to' => $destinatari,
			'oggetto' => $_REQUEST['__og__'],
			'testo' => substr($_REQUEST['__t__'], 1,sizeof($_REQUEST['__t__'])-2 )
#			'testo' => $_REQUEST['__t__']
		    )
		);

		if( isset( $_REQUEST['__to_cc__'] ) && !empty( $_REQUEST['__to_cc__'] ) ){
			$template[ $cf['localization']['language']['ietf'] ]['to_cc'] =  array( $_REQUEST['__to_cc__'] => $_REQUEST['__to_cc__'] );
		} else {
			$template[ $cf['localization']['language']['ietf'] ]['to_cc'] = array();
		}

		if( isset( $_REQUEST['__to_bcc__'] ) && !empty( $_REQUEST['__to_bcc__'] ) ){
			$template[ $cf['localization']['language']['ietf'] ]['to_bcc'] =  array( $_REQUEST['__to_bcc__'] => $_REQUEST['__to_bcc__'] );
		} else {
			$template[ $cf['localization']['language']['ietf'] ]['to_bcc'] = array();
		}

		if( isset( $_REQUEST['__attach__']) && !empty( $_REQUEST['__attach__'] ) ){
			$template[ $cf['localization']['language']['ietf'] ]['attach'] = json_decode($_REQUEST['__attach__']);
		} else {
			$template[ $cf['localization']['language']['ietf'] ]['attach'] = array();
		}

	// istanzio il template
	    $twig = new Twig_Environment( new Twig_Loader_Array( $template[ $cf['localization']['language']['ietf'] ] ) );

	// accodo la mail
	    $result = queueMail(
		$cf['mysql']['connection'],
		strtotime( '+1 minutes' ),
		$template[ $cf['localization']['language']['ietf'] ]['from'],
		$template[ $cf['localization']['language']['ietf'] ]['to'],
		$template[ $cf['localization']['language']['ietf'] ]['oggetto'],
		$template[ $cf['localization']['language']['ietf'] ]['testo'],
		$template[ $cf['localization']['language']['ietf'] ]['to_cc'],
		$template[ $cf['localization']['language']['ietf'] ]['to_bcc'],
		$template[ $cf['localization']['language']['ietf'] ]['attach']
		);

		if( $result ){ $status['__status__'] = 'OK'; }
		else { $status['__status__'] = 'NO'; }

		buildJson( $status );
	    // log
	   

	} else {

	    // log
		logWrite( 'dati per invio mail mancanti', 'invio mail', LOG_DEBUG );

	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

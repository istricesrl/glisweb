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
        require '../../../../../_src/_config.php';
    }

    // inizializzo l'array del risultato
	$status = array();

    // log
	logWrite( 'inizio creazione pianificazione', 'pianificazione', LOG_ERR );

    if( isset($_REQUEST) && !empty($_REQUEST['__data__']) && !empty($_REQUEST['__dataf__']) && !empty( $_REQUEST['__id_contratto__'] ) && !empty( $_REQUEST['__turno__'] ) ){

        // workspace della pianificazione
        $wks = array();

        $nome = '';     // nome della pianificazione con i dettagli

        $wks['metadati']= array();
    //    $wks['campi'] = array( 'id_contratto', 'data_inizio', 'data_fine', 'turno' );

        $wks['pianificazione'] = array(
            'data' => $_REQUEST['__data__'],
            'dataf' => $_REQUEST['__dataf__'], 
            'p' => $_REQUEST['__p__'],
            'cad' => $_REQUEST['__cad__'],
            'datafine' => $_REQUEST['__datafine__'],
            'nr' => $_REQUEST['__nr__'],
            'gs' => $_REQUEST['__gs__'],
            'rm' => $_REQUEST['__rm__'],
            'ra' => $_REQUEST['__ra__']
        );

    //    $wks['ws'] = $cf['site']['url'] . '_mod/_1100.attivita/_src/_api/_task/_pianifica.turni.php';


        // periodicità settimanale
        if( $_REQUEST['__p__'] == 2  ){
            $nome .= 'periodicità settimanale, ';
            $nome .= ( isset( $_REQUEST['__giorni_s_desc__'] ) ) ? $_REQUEST['__giorni_s_desc__'] . ', ' : '';
            $nome .= 'ripetizione ogni ' . $_REQUEST['__cad__'] . ' settimane, ' ; 
        }
        elseif( $_REQUEST['__p__'] == 3 ){
            $nome .= 'periodicità mensile, ';
            $nome .= ( !empty( $_REQUEST['__rip_mese_desc__'] ) ) ? ( $_REQUEST['__rip_mese_desc__'] . ', ' ) : '';
            $nome .= 'ripetizione ogni ' . $_REQUEST['__cad__'] . ' mesi, ' ; 
        }
              
        $nome .= ( !empty( $_REQUEST['__datafine__'] ) ) ? ('fino al ' . $_REQUEST['__datafine__'] . ', ')  : '';
        $nome .= ( !empty( $_REQUEST['__nr__'] ) ) ? ( 'per ' . $_REQUEST['__nr__'] . ' volte')  : '';

        // ricavo i giorni che separano data iniziale e data finale
        $gg = ( strtotime($_REQUEST['__dataf__']) - strtotime($_REQUEST['__data__']) ) / (60*60*24);
             
        $result = creazionePianificazione( $cf['mysql']['connection'], $_REQUEST['__data__'], $_REQUEST['__p__'],$_REQUEST['__cad__'], $_REQUEST['__datafine__'], $_REQUEST['__nr__'],$_REQUEST['__gs__'],$_REQUEST['__rm__'],$_REQUEST['__ra__']);

        // numero di righe inserite, inizializzo a 0
        $righe = 0;


        if( $result ){

            $status['__status__'] = 'OK';
            
            if( is_array( $result ) ){

                // creo la pianificazione
                $pId = mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO pianificazioni (entita, nome, workspace) VALUES (?, ?, ?)',
                    array(
                        array( 's' => 'turni' ),
                        array( 's' => $nome ),
                        array( 's' => json_encode( $wks ) )
                    )
                );

                // se la riga di pianificazione è stata inserita correttamente creo i singoli turni
                if( !empty( $pId ) ){

                    $status['pianificazione'] = $pId;

                    $wks['template'] = array( 
                        'turni' => array(  
                            'id_contratto' => $_REQUEST['__id_contratto__'],
                            'turno' => $_REQUEST['__turno__'],
                            'data_inizio' => '%data%',
                            'data_fine' => '%data+' . $gg . '%',
                            'id_pianificazione' => $pId
                        )
                    );

                    foreach( $result as $di ){

                        // setto la data finale
                        $df = date('Y-m-d', strtotime( $di . "+" . $gg . " days"));

                        // inserisco le righe di turno
                        $q = mysqlQuery(
                            $cf['mysql']['connection'],
                            'INSERT INTO turni (id_contratto, turno, data_inizio, data_fine, id_pianificazione) VALUES( ?, ?, ?, ?, ?)',
                            array(
                                array( 's' => $_REQUEST['__id_contratto__'] ),
                                array( 's' => $_REQUEST['__turno__'] ),
                                array( 's' => $di ),
                                array( 's' => $df ),
                                array( 's' => $pId )
                            )
                        );

                        if( !empty( $q ) ){
                            $righe++;
                        }
                        
                    }
                }
            }

            $status['righe_inserite'] = $righe;
        }

    } else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

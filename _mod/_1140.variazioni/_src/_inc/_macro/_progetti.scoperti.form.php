<?php

    /**
     *
     * form che calcola e mostra l'elenco dei candidati sostituti per il progetto corrente
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'progetti';

    // se ho un progetto, estraggo le attività scoperte ad esso relative e per ciascuna calcolo l'elenco dei sostituti
    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        $ct['etc']['operatori'] = sostitutiProgetto( $_REQUEST[ $ct['form']['table'] ]['id'] );

        // tendina operatori per settaggio manuale
	    $ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );
    
        // se ho una richiesta di sostituzione creo il job relativo
        if( !empty( $_REQUEST['__sostituzione__']['id_anagrafica'] ) ){

            $anagrafica = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT __label__ FROM anagrafica_view_static WHERE id = ?',
                array( array( 's' => $_REQUEST['__sostituzione__']['id_anagrafica'] ) )
            );

            $nome =  ( !isset( $_REQUEST['__sostituzione__']['hard'] ) ) ? 'richiesta ' : '';
            $nome .= 'sostituzione progetto ' . $_REQUEST[ $ct['form']['table'] ]['id'] . ' con anagrafica ' . $_REQUEST['__sostituzione__']['id_anagrafica'] . ' - ' . $anagrafica;
            
            $job = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO job ( nome, job, iterazioni, workspace, se_foreground, delay ) VALUES ( ?, ?, ?, ?, ?, ? )',
                array(
                    array( 's' => $nome ),
                    array( 's' => '_mod/_1140.variazioni/_src/_api/_job/_sostituzioni.progetto.request.php' ),
                    array( 's' => 10 ),
                    array( 's' => json_encode(
                        array(
                            'id_progetto' => $_REQUEST[ $ct['form']['table'] ]['id'],
                            'id_anagrafica' => $_REQUEST['__sostituzione__']['id_anagrafica'],
                            'hard' => ( isset( $_REQUEST['__sostituzione__']['hard'] ) ) ? $_REQUEST['__sostituzione__']['hard'] : NULL
                        )
                    ) ),
                    array( 's' => 1 ),
                    array( 's' => 3 )
                )
            );
        }


        // se ho una richiesta di calcolo sostituzione creo il job relativo
        if( !empty( $_REQUEST['__calcolo_sostituti__'] ) ){

            $nome = 'calcolo sostituti progetto ' . $_REQUEST[ $ct['form']['table'] ]['id'];
            
            $job = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO job ( nome, job, iterazioni, workspace, se_foreground, delay ) VALUES ( ?, ?, ?, ?, ?, ? )',
                array(
                    array( 's' => $nome ),
                    array( 's' => '_mod/_1140.variazioni/_src/_api/_job/_sostituzioni.progetto.calculate.php' ),
                    array( 's' => 10 ),
                    array( 's' => json_encode(
                        array(
                            'id_progetto' => $_REQUEST[ $ct['form']['table'] ]['id']
                        )
                    ) ),
                    array( 's' => 1 ),
                    array( 's' => 3 )
                )
            );
        }
    
    }

     // modal per la conferma di invio richiesta sostituzione
     $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'richiesta', 'include' => 'inc/progetti.scoperti.form.modal.richiesta.html' )
    );
    
    // modal per la conferma di sostituzione diretta
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'sostituisci', 'include' => 'inc/progetti.scoperti.form.modal.sostituisci.html' )
    );

    // modal per la conferma di avvio calcolo sostituti
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'calcola', 'include' => 'inc/progetti.scoperti.form.modal.calcola.html' )
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';

   
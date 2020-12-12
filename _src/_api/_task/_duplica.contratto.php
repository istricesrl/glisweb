<?php

/**
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

      // inclusione del framework
    require '../../_config.php';

    // inizializzo l'array del risultato
    $status = array();

    // inizializzo gli array
    $oldCs = $oldOr = array();

    
    if( isset( $_REQUEST['id'] ) ){
        
        // id del contratto corrente
        $oldCnId = $_REQUEST['id'];

        // elenco dei costi associati al contratto corrente
        $oldCs = mysqlQuery( 
            $cf['mysql']['connection'], 
            'SELECT * FROM costi_contratti WHERE id_contratto = ?', 
            array( array( 's' => $oldCnId ) ) 
        );


        // duplico la riga di contratto e ottengo l'id della nuova riga creata
        $newCnId = mysqlDuplicateRow( $cf['mysql']['connection'], 'contratti', $oldCnId, NULL );

        // se la duplicazione ha avuto successo... 
        if ( is_int( $newCnId ) ) {
            
            // procedo con la duplicazione dei costi
			foreach( $oldCs as $cs ) {

                // elenco degli orari associati al contratto e costo corrente
                $oldOr = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    'SELECT * FROM orari_contratti WHERE id_contratto = ? AND id_costo = ?', 
                    array( 
                        array( 's' => $oldCnId ),
                        array( 's' => $cs['id'] )
                    ) 
                );


                // duplico il costo
                $newCsId = mysqlDuplicateRow( $cf['mysql']['connection'], 'costi_contratti', $cs['id'], NULL, array( 'id_contratto' => $newCnId ) );
                
                // se la duplicazione del costo ha avuto successo...
                if ( is_int( $newCsId ) ) {

                    // procedo con la duplicazione degli orari
                    foreach( $oldOr as $or ) {
                        $newOrId = mysqlDuplicateRow( 
                            $cf['mysql']['connection'], 'orari_contratti', $or['id'], NULL, array( 'id_contratto' => $newCnId, 'id_costo' => $newCsId ) );
                    }
                }
			}
        }
    }
    else{
        $status['error'] = true;
	    $status['message'] = 'manca id_contratto';
    }

    // header location sul nuovo id
    if(  isset( $newCnId ) && is_int( $newCnId ) ){
        header('Location: ' . $cf['contents']['pages']['contratti.form']['path']['it-IT'] . '?contratti[id]=' . $newCnId);
    }
    
?>
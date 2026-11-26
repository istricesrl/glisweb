<?php

    /**
     * proroga un contratto aggiungendogli un rinnovo e crea una riga di attività di proroga
     * riceve in ingresso:
     * - id: l'id del contratto
     * - data: la nuova data di fine contratto
     * - id_tipologia: la tipologia della riga di attività
     *
     * le date del contratto stanno su rinnovi ( contratti non ha data_fine né proroghe, canone punto 8,
     * 26/11/2026 ): il rinnovo nuovo parte il giorno dopo la fine dell'ultimo e finisce alla data passata
     * 
     *
     *
     * 
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_CONTRATTI' );

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un contratto e se sono settati la data di proroga e la tipologia
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['data'] ) && ! empty( $_REQUEST['id_tipologia'] ) ) {

        // ID del contratto in oggetto
        $status['id_contratto'] = $_REQUEST['id'];
        $status['data'] = $_REQUEST['data'];
        $status['id_tipologia'] = $_REQUEST['id_tipologia'];

        // estraggo l'ultimo rinnovo del contratto
        $c = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM rinnovi WHERE id_contratto = ? ORDER BY data_fine DESC LIMIT 1',
            array( array( 's' => $_REQUEST['id'] ) )
        );

        $testo = !empty( $_REQUEST['testo'] ) ? $_REQUEST['testo'] : NULL;

        // inserisco la riga di attività
        $nome = 'proroga contratto dal ' . $c['data_fine'] . ' al ' . $_REQUEST['data'];

        $at = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO attivita ( data_attivita, id_contratto, nome, id_tipologia, testo ) VALUES ( ?, ?, ?, ?, ? )',
            array(
                array( 's' => date('Y-m-d') ),
                array( 's' => $_REQUEST['id'] ),
                array( 's' => $nome ),
                array( 's' => $_REQUEST['id_tipologia'] ),
                array( 's' => $testo )
            )
        );

        $status['info'][] = 'inserita riga di attivita ' . $at;

        // data di inizio del rinnovo: il giorno dopo la fine dell'ultimo, o oggi se il contratto non ne ha
        $inizio = empty( $c['data_fine'] ) ? date('Y-m-d') : date( 'Y-m-d', strtotime( $c['data_fine'] . ' +1 day' ) );

        // inserisco il rinnovo che proroga il contratto
        $rn = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO rinnovi ( id_contratto, data_inizio, data_fine ) VALUES ( ?, ?, ? )',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => $inizio ),
                array( 's' => $_REQUEST['data'] )
            )
        );

        $status['info'][] = 'inserito rinnovo ' . $rn;


    } else {

        // status
        $status['err'][] = 'ID contratto o data non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

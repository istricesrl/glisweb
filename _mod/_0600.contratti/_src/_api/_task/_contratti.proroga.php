<?php

    /**
     * modifica la data di fine contratto e crea una riga di attività di proroga
     * riceve in ingresso:
     * - id: l'id del contratto
     * - data: la nuova data di fine contratto
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

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un contratto e se sono settati la data di proroga e la tipologia
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['data'] ) && ! empty( $_REQUEST['id_tipologia'] ) ) {

        // ID del contratto in oggetto
        $status['id_contratto'] = $_REQUEST['id'];
        $status['data'] = $_REQUEST['data'];
        $status['id_tipologia'] = $_REQUEST['id_tipologia'];

        // estraggo le informazioni complete del contratto
        $c = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM contratti WHERE id = ?',
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

        $proroghe = empty( $c['proroghe'] ) ? 1 : $c['proroghe']+1;

        // aggiorno la data di fine contratto e il numero di proroghe
        $upd = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE contratti SET data_fine = ?, proroghe = ? WHERE id = ?',
            array(
                array( 's' => $_REQUEST['data'] ),
                array( 's' => $proroghe ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        $status['info'][] = 'aggiornata ' . $upd . ' riga di contratto';


    } else {

        // status
        $status['err'][] = 'ID contratto o data non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

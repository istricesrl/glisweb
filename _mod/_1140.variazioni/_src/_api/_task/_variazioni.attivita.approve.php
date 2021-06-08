<?php

    /**
     * riceve in ingresso l'id della variazione da approvare
     * - approva la variazione
     * - crea un job in foreground per l'eleborazione delle attività coinvolte
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una variazione
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della variazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // leggo i dati completi della variazione corrente
        $v = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            'SELECT v.*, t.nome as tipologia_inps, min(p.data_inizio) as data_min, max(p.data_fine) as data_max, a.__label__ AS anagrafica FROM variazioni_attivita AS v '
            .'LEFT JOIN periodi_variazioni_attivita AS p ON p.id_variazione = v.id '
            .'LEFT JOIN tipologie_attivita_inps AS t ON v.id_tipologia_inps = t.id '
            .'LEFT JOIN anagrafica_view_static AS a ON v.id_anagrafica = a.id '
            .'WHERE v.id = ? GROUP BY v.id',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        // setto la data di approvazione della variazione alla data corrente
        $approva = mysqlQuery(
            $cf['mysql']['connection'],
            "UPDATE variazioni_attivita SET data_approvazione = ? WHERE id = ?",
            array(
                array( 's' => date('Y-m-d') ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        // creo il job in foreground
        $nome = 'approvazione variazione ' . $_REQUEST['id'] . ' per anagrafica ' . $v['id_anagrafica'] . ' - ' . $v['anagrafica'] . ' - dal ' . $v['data_min'] . ' al ' . $v['data_max'];
        $job = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO job ( nome, job, iterazioni, workspace, se_foreground, delay ) VALUES ( ?, ?, ?, ?, ?, ? )',
            array(
                array( 's' => $nome ),
                array( 's' => '_mod/_1140.variazioni/_src/_api/_job/_variazioni.attivita.update.php' ),
                array( 's' => 10 ),
                array( 's' => json_encode(
                    array(
                        'id_variazione' => $_REQUEST['id']
                    )
                ) ),
                array( 's' => 1 ),
                array( 's' => 3 )
            )
        );

        $status['info'][] = 'variazione ' . $_REQUEST['id'] . ' approvata con data ' . date('Y-m-d');


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

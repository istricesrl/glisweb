<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
		'label' => 'esportazioni'
	    )
	);

    // esportazione ore operatori
    $ct['page']['contents']['metro']['esportazioni'][] = array(
        'modal' => array('id' => 'operatori', 'include' => 'inc/attivita.tools.modal.export.operatori.html' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione ore per operatore',
        'text' => 'esporta le ore previste e fatte per operatore in un determinato mese e anno'
    );

    // esportazione ore clienti
    $ct['page']['contents']['metro']['esportazioni'][] = array(
        'modal' => array('id' => 'clienti', 'include' => 'inc/attivita.tools.modal.export.clienti.html' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione ore per cliente',
        'text' => 'esporta le ore previste e fatte per cliente in un determinato mese e anno'
    );

    // tendina mesi
    foreach( range( 1, 12 ) as $mese ) {
        $ct['etc']['select']['mesi'][ $mese ] = array( 'id' => $mese, '__label__' =>  int2month( $mese ) );
    }

    // tendina anni
    foreach( range( date( 'Y' ),  date( 'Y' ) ) as $y ) {
        $ct['etc']['select']['anni'][ $y ] = array( 'id' => $y, '__label__' => $y ) ;
    }


    
    // elenco dei job per export ore operatori
    $jo = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT j.* FROM job AS j INNER JOIN __report_ore_operatori__ AS r ON j.id = r.id_job GROUP BY j.id'
    );

    if( !empty( $jo ) ){
        foreach( $jo as $j ){
            $wksp = json_decode( $j['workspace'], true );

            $ct['etc']['report']['operatori'][ $j['id'] ] = $j;
            $ct['etc']['report']['operatori'][ $j['id'] ]['mese'] = $wksp['mese'];
            $ct['etc']['report']['operatori'][ $j['id'] ]['anno'] = $wksp['anno'];
            $ct['etc']['report']['operatori'][ $j['id'] ]['nome'] = int2month( $wksp['mese'] ) . ' ' . $wksp['anno'];
            
            if( !empty( $j['timestamp_completamento'] ) ){
                $ct['etc']['report']['operatori'][ $j['id'] ]['stato'] = 'completato';
            }
            elseif( $j['corrente'] < $j['totale'] ){
                $ct['etc']['report']['operatori'][ $j['id'] ]['stato'] = 'in corso';
            }
            
        }
    }

    // elenco dei job per export ore clienti
    $jc = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT j.* FROM job AS j INNER JOIN __report_ore_clienti__ AS r ON j.id = r.id_job GROUP BY j.id'
    );

    if( !empty( $jc ) ){
        foreach( $jc as $j ){
            $wksp = json_decode( $j['workspace'], true );

            $ct['etc']['report']['clienti'][ $j['id'] ] = $j;
            $ct['etc']['report']['clienti'][ $j['id'] ]['mese'] = $wksp['mese'];
            $ct['etc']['report']['clienti'][ $j['id'] ]['anno'] = $wksp['anno'];
            $ct['etc']['report']['clienti'][ $j['id'] ]['nome'] = int2month( $wksp['mese'] ) . ' ' . $wksp['anno'];
            
            if( !empty( $j['timestamp_completamento'] ) ){
                $ct['etc']['report']['clienti'][ $j['id'] ]['stato'] = 'completato';
            }
            elseif( $j['corrente'] < $j['totale'] ){
                $ct['etc']['report']['clienti'][ $j['id'] ]['stato'] = 'in corso';
            }
            
        }
    }


    // elenco dei job per export ore operatori per cliente
    $joc = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT j.* FROM job AS j INNER JOIN __report_ore_operatori_per_cliente__ AS r ON j.id = r.id_job GROUP BY j.id'
    );

    if( !empty( $joc ) ){
        foreach( $joc as $j ){
            $wksp = json_decode( $j['workspace'], true );

            $ct['etc']['report']['operatori_per_cliente'][ $j['id'] ] = $j;
            $ct['etc']['report']['operatori_per_cliente'][ $j['id'] ]['mese'] = $wksp['mese'];
            $ct['etc']['report']['operatori_per_cliente'][ $j['id'] ]['anno'] = $wksp['anno'];
            $ct['etc']['report']['operatori_per_cliente'][ $j['id'] ]['nome'] = int2month( $wksp['mese'] ) . ' ' . $wksp['anno'];
            
            if( !empty( $j['timestamp_completamento'] ) ){
                $ct['etc']['report']['operatori_per_cliente'][ $j['id'] ]['stato'] = 'completato';
            }
            elseif( $j['corrente'] < $j['totale'] ){
                $ct['etc']['report']['operatori_per_cliente'][ $j['id'] ]['stato'] = 'in corso';
            }
            
        }
    }

    // nelle tabelle di report inserire colonna id_job e salvare l'id del job
    // todo qui leggere id_job (con group by) dalla tabella dei report
    // controllo se job esiste ed è in corso, se è in corso metto stato "in corso"
    // nel modal con le tendine mese e anno mettere elenco report che possono già essere scaricati, al clic chiamo _api/_print che li stampa
    

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

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
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '03.elaborazioni' => array(
			'label' => 'elaborazioni'
		),
	    '05.static' => array(
			'label' => 'viste statiche'
		)
	);

    // esportazione ore operatori
    $ct['page']['contents']['metro']['01.esportazioni'][] = array(
        'modal' => array('id' => 'operatori', 'include' => 'inc/attivita.tools.modal.export.operatori.html' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione ore per operatore',
        'text' => 'esporta le ore previste e fatte per operatore in un determinato mese e anno'
    );

    // esportazione ore progetti
    $ct['page']['contents']['metro']['01.esportazioni'][] = array(
        'modal' => array('id' => 'progetti', 'include' => 'inc/attivita.tools.modal.export.progetti.html' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione ore per progetto',
        'text' => 'esporta le ore previste e fatte per progetto in un determinato mese e anno'
    );

    // esportazione ore progetti per tipologia e conto ore
    $ct['page']['contents']['metro']['01.esportazioni'][] = array(
        'modal' => array('id' => 'progetti-tipologie-mastri', 'include' => 'inc/attivita.tools.modal.export.progetti.tipologie.mastri.html' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione ore per progetto, tipologia e conto ore',
        'text' => 'esporta le ore previste e fatte per progetto, tipologia e conto ore in un determinato mese e anno'
    );

    // esportazione ore operatore per progetto
    $ct['page']['contents']['metro']['01.esportazioni'][] = array(
        'modal' => array('id' => 'operatori-per-progetto', 'include' => 'inc/attivita.tools.modal.export.operatori.per.progetto.html' ),
        'icon' => NULL,
        'fa' => 'fa-file-excel-o',
        'title' => 'esportazione ore operatori per progetto',
        'text' => 'esporta le ore fatte per operatore e per progetto in un determinato mese e anno'
    );

	$ct['page']['contents']['metro']['05.static'][] = array(
		'lws' => '/task/0200.attivita/attivita.view.static.popolazione',
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'ripopola attivita view static',
		'text' => 'ripopola la view static delle attività'
	);

    // tendina mesi
    foreach( range( 1, 12 ) as $mese ) {
        $ct['etc']['select']['mesi'][ $mese ] = array( 'id' => $mese, '__label__' =>  int2month( $mese ) );
    }

    // tendina anni
    foreach( range( date( 'Y' ) - 1,  date( 'Y' ) + 1 ) as $y ) {
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

    // elenco dei job per export ore progetti
    $jp = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT j.* FROM job AS j INNER JOIN __report_ore_progetti__ AS r ON j.id = r.id_job GROUP BY j.id'
    );

    if( !empty( $jp ) ){
        foreach( $jp as $j ){
            $wksp = json_decode( $j['workspace'], true );

            $ct['etc']['report']['progetti'][ $j['id'] ] = $j;
            $ct['etc']['report']['progetti'][ $j['id'] ]['mese'] = $wksp['mese'];
            $ct['etc']['report']['progetti'][ $j['id'] ]['anno'] = $wksp['anno'];
            $ct['etc']['report']['progetti'][ $j['id'] ]['nome'] = int2month( $wksp['mese'] ) . ' ' . $wksp['anno'];
            
            if( !empty( $j['timestamp_completamento'] ) ){
                $ct['etc']['report']['progetti'][ $j['id'] ]['stato'] = 'completato';
            }
            elseif( $j['corrente'] < $j['totale'] ){
                $ct['etc']['report']['progetti'][ $j['id'] ]['stato'] = 'in corso';
            }
            
        }
    }

    // elenco dei job per export ore progetti, tipologie e mastri
    $jptm = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT j.* FROM job AS j INNER JOIN __report_ore_progetti_tipologie_mastri__ AS r ON j.id = r.id_job GROUP BY j.id'
    );

    if( !empty( $jptm ) ){
        foreach( $jptm as $j ){
            $wksp = json_decode( $j['workspace'], true );

            $ct['etc']['report']['progetti_tipologie_mastri'][ $j['id'] ] = $j;
            $ct['etc']['report']['progetti_tipologie_mastri'][ $j['id'] ]['mese'] = $wksp['mese'];
            $ct['etc']['report']['progetti_tipologie_mastri'][ $j['id'] ]['anno'] = $wksp['anno'];
            $ct['etc']['report']['progetti_tipologie_mastri'][ $j['id'] ]['nome'] = int2month( $wksp['mese'] ) . ' ' . $wksp['anno'];
            
            if( !empty( $j['timestamp_completamento'] ) ){
                $ct['etc']['report']['progetti_tipologie_mastri'][ $j['id'] ]['stato'] = 'completato';
            }
            elseif( $j['corrente'] < $j['totale'] ){
                $ct['etc']['report']['progetti_tipologie_mastri'][ $j['id'] ]['stato'] = 'in corso';
            }
            
        }
    }


    // elenco dei job per export ore operatori per progetto
    $jop = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT j.* FROM job AS j INNER JOIN __report_ore_operatori_per_progetto__ AS r ON j.id = r.id_job GROUP BY j.id'
    );

    if( !empty( $jop ) ){
        foreach( $jop as $j ){
            $wksp = json_decode( $j['workspace'], true );

            $ct['etc']['report']['operatori_per_progetto'][ $j['id'] ] = $j;
            $ct['etc']['report']['operatori_per_progetto'][ $j['id'] ]['mese'] = $wksp['mese'];
            $ct['etc']['report']['operatori_per_progetto'][ $j['id'] ]['anno'] = $wksp['anno'];
            $ct['etc']['report']['operatori_per_progetto'][ $j['id'] ]['nome'] = int2month( $wksp['mese'] ) . ' ' . $wksp['anno'];
            
            if( !empty( $j['timestamp_completamento'] ) ){
                $ct['etc']['report']['operatori_per_progetto'][ $j['id'] ]['stato'] = 'completato';
            }
            elseif( $j['corrente'] < $j['totale'] ){
                $ct['etc']['report']['operatori_per_progetto'][ $j['id'] ]['stato'] = 'in corso';
            }
            
        }
    }

    // nelle tabelle di report inserire colonna id_job e salvare l'id del job
    // todo qui leggere id_job (con group by) dalla tabella dei report
    // controllo se job esiste ed è in corso, se è in corso metto stato "in corso"
    // nel modal con le tendine mese e anno mettere elenco report che possono già essere scaricati, al clic chiamo _api/_print che li stampa
    

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

<?php

    /**
     *
     *
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

    // debug
	// print_r( $_SESSION );

    // tabella della vista
#    $ct['view']['table'] = 'todo';
    $ct['view']['data']['__report_mode__'] = 1;
    $ct['view']['table'] = '__report_lezioni_corsi__';

    // id della vista
    // TODO fare una funzione getViewId()
    /*
    $ct['view']['id'] = md5(
		$ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
	);
    */
        
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'lezioni.form';
	$ct['view']['open']['table'] = 'todo';

/*
    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_attivita' => 'data',
        'anagrafica' => 'operatore',
        'id_anagrafica' => 'id_anagrafica',
        'cliente' => 'cliente',
        'tipologia' => 'tipologia',
        'nome' => 'attivita',
        'ore' => 'ore'
    //    'tipologia_inps' => 'tipologia INPS',
        
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'id_anagrafica' => 'd-none',
        'anagrafica' => 'no-wrap',
        'cliente' => 'text-left d-none d-md-table-cell',
        'data_attivita' => 'no-wrap',
        'ore' => 'text-right no-wrap',
        'nome' => 'text-left',
        'tipologia' => 'text-left',
        '__label__' => 'text-left',
        'testo' => 'text-left no-wrap'
    );
*/
     // campi della vista
     $ct['view']['cols'] = array(
	    'id' => '#',
        'tipologia' => 'tipologia',
//        'cliente' => 'cliente',
        'data_programmazione' => 'data',
        'ora_inizio_programmazione' => 'ora',
//        'ora_fine_programmazione' => 'ora fine',
        'note_programmazione' => 'ora',
        'id_progetto' => 'ID corso',
        'corso' => 'corso',
        'discipline' => 'disciplina',
        'posti_disponibili' => 'posti',
//        'anagrafica_programmazione' => 'assegnata a',
//        'data_programmazione' => 'data',
//	    'anagrafica' => 'svolta da',
/*        'nome' => 'attività',
	    'ore' => 'ore',
        'ora_inizio' => 'oi',
        'ora_fine' => 'of' */
        NULL => 'azioni'
      );

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    '__label__' => 'text-left',
        'cliente' => 'text-left d-none d-md-table-cell',
        'anagrafica_programmazione' => 'text-left',
        'id_progetto' => 'd-none',
        'corso' => 'text-left',
        'discipline' => 'text-left',
	    'data_programmazione' => 'no-wrap',
        'ora_inizio_programmazione' => 'd-none',
        'ora_fine_programmazione' => 'd-none',
        'note_programmazione' => 'd-none',
//        'data_attivita' => 'no-wrap',
	    'anagrafica' => 'text-left no-wrap',
        'nome' => 'text-left',
        'ora_inizio' => 'd-none',
        'ora_fine' => 'd-none',
        NULL => 'nowrap'
    );

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );


    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/lezioni.view.filters.html';

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][$mese] =  int2month( $mese ) ;
	}

    // tendina anni
	foreach( range( date( 'Y' ) - 5,  date( 'Y' ) ) as $y ) {
	    $ct['etc']['select']['anni'][$y] = $y ;
	}

    // tendina operatori
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_collaboratore = 1 ORDER BY __label__');

    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'], 
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static ORDER BY __label__');

    // tendina tipologie attività
	$ct['etc']['select']['tipologie_attivita'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__');
/*
    // tendina tipologie attività inps
	$ct['etc']['select']['tipologie_attivita_inps'] = mysqlCachedQuery(
        $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_inps_view ORDER BY id');
*/
/*
    // preset filtri custom
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno_attivita']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_attivita']['EQ'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese_attivita']['EQ'] ) ) {
	    // $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['mese']['EQ'] = date('m');
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['anno_attivita']['EQ'] = date('Y');
	//    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['giorno']['EQ'] = date('d');
    }
*/
/*	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] ) && isset($_SESSION['account']['id_anagrafica'] ) ){
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['id_anagrafica']['EQ'] = $_SESSION['account']['id_anagrafica'] ;
	} */

    if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_programmazione']) ){
        $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['data_programmazione']	= 'DESC';
    } 

    // preset filtro custom progetti aperti
    $ct['view']['__restrict__']['id_tipologia']['EQ'] = 15;

    // ...
    // if( isset( $_REQUEST['idRecupero'] ) ) {
    if( isset( $_SESSION['__work__']['recuperi']['items'] ) ) {

        // ...
        $recupero = reset( $_SESSION['__work__']['recuperi']['items'] );
        $idRecupero = $recupero['id'];

        // ...
        // die( print_r( $recupero, true ) );
        // die( 'ID recupero: ' . $idRecupero );
        // die( 'recupero lezione #' . $_REQUEST['idRecupero'] );

        // seleziono la disciplina
#        $disciplina = mysqlSelectCachedRow(
#            $cf['memcache']['connection'],
        $disciplina = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT categorie_progetti.id, categorie_progetti.id_genitore, todo.id_progetto '.
            'FROM attivita '.
            'INNER JOIN todo ON todo.id = attivita.id_todo '.
            'INNER JOIN progetti_categorie ON progetti_categorie.id_progetto = todo.id_progetto '.
            'INNER JOIN categorie_progetti ON categorie_progetti.id = progetti_categorie.id_categoria '.
            'WHERE categorie_progetti.se_disciplina IS NOT NULL '.
            'AND attivita.id = ?',
            array(
                array( 's' => $idRecupero )
            )
        );

        // ...
        $idDisciplina = $disciplina['id'];
        $idDisciplinaGenitore = $disciplina['id_genitore'];
        $idCorso = $disciplina['id_progetto'];

        // debug
        // die( print_r( $disciplina, true ) );
        // die( 'disciplina: ' . $idDisciplina );

        // ...
        // echo 'dall\'assenza #' . $idRecupero . ' ricavo il corso #' . $idCorso . ' e la disciplina #' . $idDisciplina . PHP_EOL;


        // seleziono le discipline collegate
#        $disciplineCollegate = mysqlSelectCachedColumn(
#            $cf['memcache']['connection'],
        $disciplineCollegate = mysqlSelectColumn(
            'id',
            $cf['mysql']['connection'],
            'SELECT categorie_progetti.id '.
            'FROM categorie_progetti '.
            'LEFT JOIN metadati AS mn ON mn.id_categoria_progetti = categorie_progetti.id AND mn.nome = "non_disponibile_per_recuperi" AND mn.testo = "1" '.
            'LEFT JOIN metadati AS my ON my.id_categoria_progetti = categorie_progetti.id AND my.nome = "recuperi_da_qualsiasi_disciplina" AND my.testo = "1" '.
            'LEFT JOIN relazioni_categorie_progetti AS r1 ON r1.id_categoria = categorie_progetti.id '.
            'LEFT JOIN relazioni_categorie_progetti AS r2 ON r2.id_categoria_collegata = categorie_progetti.id '.
//            'WHERE categorie_progetti_path_check( categorie_progetti.id, ? ) = 1 AND metadati.id IS NULL ',
//2            'WHERE categorie_progetti.id_genitore = ? AND metadati.id IS NULL AND ( relazioni_categorie_progetti.id IS NULL OR relazioni_categorie_progetti.id_categoria_collegata = ? )',
            'WHERE r1.id_categoria_collegata = ? OR r2.id_categoria = ? OR my.id IS NOT NULL AND mn.id IS NULL '.
            'GROUP BY categorie_progetti.id',
            array(
//2                array( 's' => $idDisciplinaGenitore ),
                array( 's' => $idDisciplina ),
                array( 's' => $idDisciplina )
            )
        );

        // aggiungo la disciplina corrente alle discipline da considerare
        $disciplineCollegate[] = $idDisciplina;

        // ...
        // die( print_r( $disciplineCollegate, true ) );
        // echo 'le discipline collegate per la #' . $idDisciplina . ' sono: ' . implode( ', ', $disciplineCollegate ) . PHP_EOL;

        // ...
        // $disciplineCollegate = array_unique( $disciplineCollegate );

        // ...
        if( count( $disciplineCollegate ) ) {

        // seleziono i corsi per le discipline collegate
#        $idCorsi = mysqlSelectCachedColumn(
#            $cf['memcache']['connection'],
        $idCorsi = mysqlSelectColumn(
            'id_progetto',
            $cf['mysql']['connection'],
            'SELECT progetti_categorie.id_progetto '.
            'FROM progetti_categorie '.
            'WHERE progetti_categorie.id_progetto != ? '.
            'AND progetti_categorie.id_categoria IN (' . trim( implode( ',', $disciplineCollegate ), ',' ) . ') '.
            'GROUP BY progetti_categorie.id_progetto ',
            array(
                array( 's' => $idCorso )
            )
        );

        // ...
        // die( 'recupero per la disciplina #' . $idDisciplina );
        // die( 'genitore della disciplina #' . $idDisciplinaGenitore );
        // die( print_r( $idCorsi, true ) );

    }


/*
        // ...
        $disciplineSorelle = mysqlSelectCachedColumn(
            $cf['memcache']['connection'],
            'id',
            $cf['mysql']['connection'],
            'SELECT categorie_progetti.id '.
            'FROM categorie_progetti '.
            'LEFT JOIN metadati ON metadati.id_categoria_progetti = categorie_progetti.id AND metadati.nome = "non_disponibile_per_recuperi" AND metadati.testo = "1" '.
            'LEFT JOIN relazioni_categorie_progetti ON relazioni_categorie_progetti.id_categoria = categorie_progetti.id '.
//            'WHERE categorie_progetti_path_check( categorie_progetti.id, ? ) = 1 AND metadati.id IS NULL ',
//2            'WHERE categorie_progetti.id_genitore = ? AND metadati.id IS NULL AND ( relazioni_categorie_progetti.id IS NULL OR relazioni_categorie_progetti.id_categoria_collegata = ? )',
            'WHERE categorie_progetti.id = ? AND metadati.id IS NULL AND ( relazioni_categorie_progetti.id IS NULL OR relazioni_categorie_progetti.id_categoria_collegata = ? )',
            array(
//2                array( 's' => $idDisciplinaGenitore ),
                array( 's' => $idDisciplina ),
                array( 's' => $idDisciplina )
            )
        );

        // ...
         die( print_r( $disciplineSorelle, true ) );

        if( count( $disciplineSorelle ) > 0 ) {
        $idCorsi = mysqlSelectCachedColumn(
            $cf['memcache']['connection'],
            'id_progetto',
            $cf['mysql']['connection'],
            'SELECT progetti_categorie.id_progetto '.
            'FROM progetti_categorie '.
            'WHERE progetti_categorie.id_categoria IN (' . implode( ',', $disciplineSorelle ) . ')'
        );
        }
*/
        // ...
        // die( print_r( $idCorsi, true ) );
        if( in_array( $idCorso, $idCorsi ) ) {
            die('WTF?');
        }

        // preset filtro custom progetti aperti
        if( count( $idCorsi ) > 0 ) {
            $ct['view']['__restrict__']['id_progetto']['IN'] = implode( '|', $idCorsi );
//            die( print_r( implode( ',', $idCorsi ), true ) );
        } else {
            $ct['view']['__restrict__']['id_progetto']['NL'] = true;
        }

        // preset filtro custom progetti aperti
        // $ct['view']['__restrict__']['data_programmazione']['GE'] = '2023-06-01';
#        $ct['view']['__restrict__']['data_programmazione']['GE'] = date( 'Y-m-d' );

        // campo preset per la data attività
        $ct['view']['open']['context'] = array(
            '__recupero__' => $_REQUEST['idRecupero']
        );
    
        // ...
        $ct['view']['open']['page'] = 'lezioni.form.presenze';

        // ...
        // unset( $_SESSION['__work__']['recuperi']['items'] );

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            $buttons = '';
            if(!empty($row['data_programmazione'])){
                $row['data_programmazione'] = date('d/m/Y', strtotime($row['data_programmazione'])).' '.substr($row['ora_inizio_programmazione'],0,5);
            }
            $buttons .=  '<a href="'.$cf['contents']['pages']['lezioni.form.presenze']['path'][LINGUA_CORRENTE].'?todo[id]='.$row['id'].'"><span class="media-left"><i class="fa fa-graduation-cap"></i></span></a>';
            $row[ NULL ] = $buttons;
        }
	}

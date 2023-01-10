<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = '__report_sprint_todo__';
    $ct['view']['data']['__report_mode__'] = 1;
	$ct['view']['etc']['__force_backurl__'] = 1;

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['table'] = 'todo';
	$ct['view']['open']['page'] = 'todo.form';

    $ct['view']['cols'] = array(
	    'id' => '#',
#	    'data_programmazione' => 'pianificato',
#	    'priorita' => 'priorità',
		'tipologia' => 'tipologia',
		'id_progetto' => 'ID progetto',
		'progetto' => 'progetto',
	    'nome' => 'titolo',
	    'anagrafica' => 'assegnato a',
#		'settimana_programmazione' => 'settimana',
#		'anno_programmazione' => 'anno'
#	    'progresso' => 'ore',
#	    'completato' => 'stato',
#	    'id_priorita' => 'id_priorita'
		'se_pacchetto' => 'pacchetto',
		NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'id_priorita' => 'd-none',
		'se_pacchetto' => 'd-none',
#		'completato' => 'd-none',
	    'cliente' => 'text-left d-none d-md-table-cell',
	    'nome' => 'text-left',
#	    'id_progetto' => 'd-none',
	    'priorita' => 'text-left',
	    'anagrafica' => 'text-left no-wrap d-none d-sm-table-cell',
	    'progresso' => 'text-right no-wrap d-none d-sm-table-cell',
		'progetto' => 'text-left'
#	    'completato' => 'text-left'
	);
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'todo.form';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'todo.form';

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    $ct['page']['contents']['modals']['metro'][] = array(
        'schema' => 'inc/produzione.modal.attivita.html'
    );

	// tendina tipologie
	$ct['etc']['select']['tipologie_attivita'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL'
	);

	// tendina collaboratori
	$ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'], 
		'SELECT id, __label__ FROM anagrafica_view_static'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

	// icone
	foreach( $ct['view']['data'] as &$row ) {
		if( ! empty( $row['se_pacchetto'] ) ) {
			$idMastro = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM mastri INNER JOIN tipologie_mastri ON tipologie_mastri.id = mastri.id_tipologia WHERE mastri.id_progetto = ? AND tipologie_mastri.se_registro IS NOT NULL', array( array( 's' => $row['id_progetto'] ) ) );
			$mastro = '$(\'#attivita_id_mastro_provenienza\').val(\''.$idMastro.'\');$(\'#attivita_note_mastro_provenienza\').html(\'<b>ATTENZIONE!</b> queste ore verranno scaricate dal pacchetto ore principale del progetto\');';
		} else {
			$mastro = '$(\'#attivita_id_mastro_provenienza\').val(\'\');$(\'#attivita_note_mastro_provenienza\').html(\'\');';
		}
		$row['id_mastro_provenienza'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM __report_giacenza_ore__ WHERE id_progetto = ?', array( array( 's' => $row['id_progetto'] ) ) );
		$row[ NULL ] = '<a href="#" data-toggle="modal" data-target="#scorciatoia_attivita" onclick="$(\'#attivita_id_progetto\').val(\''.$row['id_progetto'].'\');'.$mastro.'$(\'#attivita_id_mastro_provenienza\').val(\''.$row['id_mastro_provenienza'].'\');$(\'#scorciatoia_attivita\').modal(\'show\');"><i class="fa fa-pencil-square-o"></i></a>';
	}

	// preset ordinamento
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['anno_programmazione'] = 'ASC';
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['settimana_programmazione'] = 'ASC';
    }

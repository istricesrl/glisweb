<?php

    /**
     * macro view archivio contratti
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

   // tabella della vista
   $ct['view']['table'] = 'licenze';

   $ct['view']['open']['page'] = 'licenze.form';
   $ct['view']['open']['table'] = 'licenze';
   $ct['view']['open']['field'] = 'id';

   // pagina per l'inserimento di un nuovo oggetto
   $ct['view']['insert']['page'] = 'licenze.form';

   // campi della vista
   $ct['view']['cols'] = array(
    'id' => '#',
    'id_contratto' => 'ID contratto',
    'id_anagrafica' => 'ID anagrafica',
    'anagrafica' => 'cliente',
    'tipologia_contratto' => 'contratto',
    'data_inizio' => 'data inizio',
    'data_fine' => 'data fine',
    'tipologia' => 'tipologia',
      'codice' => 'codice',
      'software' => 'software',
     '__label__' => 'contratto'
    );

   // stili della vista
   $ct['view']['class'] = array(
    'id_contratto' => 'd-none',
    'id_anagrafica' => 'd-none',
    'anagrafica' => 'text-left',
    'data_inizio' => 'no-wrap',
    'data_fine' => 'no-wrap',
    'software' => 'text-left',
	   '__label__' => 'd-none text-left no-wrap'
   );

/*
   if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
    // preset filtro contratto attuale
    $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    $ct['etc']['include']['insert'][] = array(
      'name' => 'rinnovi',
      'file' => 'inc/contratti.form.rinnovi.insert.html',
      'fa' => 'fa-plus-circle'
    );

    // tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_rinnovi_view'
    );
*/
/*
  // ...
	if( in_array( "V900.software", $cf['mods']['active']['array'] ) ) {
		arrayInsertAssoc( '__label__', $ct['view']['cols'], array('codice_licenza' => 'licenza') );
	}
*/
  // debug
  // print_r( $ct['etc']['select']['tipologie_rinnovi'] );

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

  // bottoni
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {
      if( isset( $row['software'] ) ) {

          // ...
          $sws = array();
          
          // ...
          $software = explode( ' | ', $row['software'] );

          // ...
          foreach( $software as $sw ) {
            $dts = explode( ' ', $sw );
            $sws[ $dts[0] ] = $dts[1];
          }

          // ...
          sort( $dts );

          // ...
          $row['software'] = implode( ', ', $dts );

      }
    }
  }

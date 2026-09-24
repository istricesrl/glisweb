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
   $ct['view']['table'] = 'anagrafica_certificazioni';

  /* $ct['view']['id'] = md5(
      $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
   );*/
    
   // pagina per la gestione degli oggetti esistenti
  $ct['view']['open']['page'] = 'anagrafica.certificazioni.form';

   // campi della vista
  $ct['view']['cols'] = array(
       'id' => '#',
       'anagrafica' => 'anagrafica',
       'tipologia_certificazione' => 'tipologia',
       'certificazione' => 'certificazione',
       'emittente' => 'emittente',
       'data_emissione' => 'data emissione',
       'data_scadenza' => 'data scadenza'
   );

   // stili della vista
  $ct['view']['class'] = array(
      'anagrafica' => 'text-left',
       'certificazione' => 'text-left',
       'emittente' => 'text-left'
  );

  // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
      $cf['memcache']['index'],
      $cf['memcache']['connection'],
      $cf['mysql']['connection'],
      'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1'
   );
   
   // tendina per le tipologie di certificazioni
   $ct['etc']['select']['tipologie_certificazioni'] = mysqlCachedIndexedQuery(
      $cf['memcache']['index'],
      $cf['memcache']['connection'],
      $cf['mysql']['connection'],
      'SELECT id, __label__ FROM tipologie_certificazioni_view'
   );

   // tendina per le certificazioni
   $ct['etc']['select']['certificazioni'] = mysqlCachedIndexedQuery(
      $cf['memcache']['index'],
      $cf['memcache']['connection'],
      $cf['mysql']['connection'],
      'SELECT id, __label__ FROM certificazioni_view'
   );

   // preset filtri per il mese corrente
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_scadenza']['LE'] ) && ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_scadenza']['GE'] )  ) {
      $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_scadenza']['GE'] = date('Y-m-01', strtotime( 'now' ) );
      $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['data_scadenza']['LE'] = date('Y-m-t', strtotime( 'now' ) );
      
   }

   // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/certificazioni.scadenze.view.filters.html';

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

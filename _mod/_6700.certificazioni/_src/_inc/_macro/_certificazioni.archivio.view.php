<?php

    /**
     * macro view archivio certificazioni
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
   $ct['view']['table'] = 'certificazioni_archiviati';

	// tabella per l'apertura
	$ct['view']['open']['table'] = 'certificazioni';
    
   // pagina per la gestione degli oggetti esistenti
   $ct['view']['open']['page'] = 'certificazioni.form';

   // campi della vista
   $ct['view']['cols'] = array(
	   'id' => '#',
	   'data_emissione' => 'data emissione',
	   'data_scadenza' => 'data scadenza',
      'emittente' => 'emittente',
	   '__label__' => 'certificazione'
   );

   // stili della vista
   $ct['view']['class'] = array(
	   '__label__' => 'text-left no-wrap'
   );

   // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/certificazioni.view.filters.html';

   // tendina tipologia
  $ct['etc']['select']['tipologie_certificazioni'] = mysqlCachedQuery(
      $cf['memcache']['connection'],
      $cf['mysql']['connection'],
      'SELECT id, __label__ FROM tipologie_certificazioni_view'
   );

   // tendina anagrafica
   $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
      $cf['memcache']['index'], 
      $cf['memcache']['connection'], 
      $cf['mysql']['connection'], 
      'SELECT id, __label__ FROM anagrafica_view_static WHERE se_interno = 1 OR se_collaboratore = 1');

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

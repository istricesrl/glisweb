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
   $ct['view']['table'] = 'contratti_completa';

	// tabella per l'apertura
	$ct['view']['open']['table'] = 'contratti';
    
   // pagina per la gestione degli oggetti esistenti
   $ct['view']['open']['page'] = 'contratti.form';

   // campi della vista
   $ct['view']['cols'] = array(
	   'id' => '#',
	   'data_inizio' => 'data inizio',
	   'data_fine' => 'data fine',
      'data_inizio_rapporto' => 'data inizio rapporto',
      'data_fine_rapporto' => 'data fine rapporto',
      '__label__' => 'contratto',
      'proroghe' => 'proroghe'
   );

   // stili della vista
   $ct['view']['class'] = array(
	   '__label__' => 'text-left no-wrap'
   );

   // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/contratti.scadenze.view.filters.html';

   // tendina anagrafica
  $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
      $cf['memcache']['index'],
      $cf['memcache']['connection'],
      $cf['mysql']['connection'], 
      'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1'
   );

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

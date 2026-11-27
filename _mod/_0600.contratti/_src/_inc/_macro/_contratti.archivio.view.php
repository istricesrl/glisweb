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

   // contratti_archiviati non esiste in nessuno schema ( canone punto 8, 26/11/2026 ): come in _0010
   // ( _anagrafica.archivio.view.php ) si filtrano i contratti con data_archiviazione valorizzata
   // $ct['view']['table'] = 'contratti_archiviati';
   $ct['view']['table'] = 'contratti';
   $ct['view']['__restrict__']['data_archiviazione']['NN'] = true;

	// tabella per l'apertura
	$ct['view']['open']['table'] = 'contratti';
    
   // pagina per la gestione degli oggetti esistenti
   $ct['view']['open']['page'] = 'contratti.form';

   // campi della vista
   $ct['view']['cols'] = array(
	   'id' => '#',
	   'data_inizio' => 'data inizio',
	   'data_fine' => 'data fine',
      'data_archiviazione' => 'archiviato',
	   '__label__' => 'contratto'
   );

   // stili della vista
   $ct['view']['class'] = array(
	   '__label__' => 'text-left no-wrap'
   );

   // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/contratti.view.filters.html';

   // tendina tipologia
  $ct['etc']['select']['tipologie_contratti'] = mysqlCachedQuery(
      $cf['memcache']['connection'],
      $cf['mysql']['connection'],
      'SELECT id, __label__ FROM tipologie_contratti_view'
   );

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

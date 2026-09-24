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
   $ct['view']['table'] = 'pianificazioni';

   $ct['form']['table'] = 'progetti';

   $ct['view']['open']['page'] = 'pianificazioni.form';
   $ct['view']['open']['table'] = 'pianificazioni';
   $ct['view']['open']['field'] = 'id';

   // pagina per l'inserimento di un nuovo oggetto
   $ct['view']['insert']['page'] = 'pianificazioni.form';
   $ct['view']['insert']['field'] = 'id_progetto';

   // campo per il preset di apertura
   $ct['view']['open']['preset']['field'] = 'id_progetto';

   // campi della vista
   $ct['view']['cols'] = array(
	   'id' => '#',
	   'id_progetto' => 'ID progetto',
      '__label__' => 'pianificazione'
     );

   // stili della vista
   $ct['view']['class'] = array(
    'id_progetto' => 'd-none',
	   '__label__' => 'text-left no-wrap'
   );

    // preset filtro contratto attuale
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
    $ct['view']['__restrict__']['id_progetto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

  // debug
  // print_r( $ct['etc']['select']['tipologie_rinnovi'] );

   // gestione default
   require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

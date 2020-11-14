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
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'mail_out';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'mail.out.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'data_ora_invio' => 'invio previsto',
	    'destinatari' => 'destinatari',
	    'destinatari_cc' => 'destinatari cc',
	    'destinatari_bcc' => 'destinatari bcc',
	    '__label__' => 'testo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
	    'data_ora_invio' => 'text-left',
	    'destinatari' => 'text-left',
	    'destinatari_cc' => 'text-left',
	    'destinatari_bcc' => 'text-left',
	    '__label__' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>

<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'mail_out';

    // memoria di lavoro (solo primo salvataggio)
    /*
	if( ! isset( $_REQUEST['mail_out']['id'] ) ) {
		if( isset( $_SESSION['__work__']['documenti']['items'] ) ) {
			if( isset( $_POST[ $ct['form']['table'] ]['file']) ) {
				unset( $_SESSION['__work__']['documenti'] );
			} else {
				$counter = 0;
				foreach( $_SESSION['__work__']['documenti']['items'] as $item ) {
					$_REQUEST[ $ct['form']['table'] ]['file'][] = array(
						'ordine' => $counter += 10,
						'id_mail_out' => $_REQUEST[ $ct['form']['table'] ]['id'],
						'nome' => $item['label'],
						'id_ruolo' => 1,
						'path' => $item['path']
					);
				}
			}
		}
	}
    */

    // gli allegati messi da parte ( gruppo mailattach dei bookmarks ) si tolgono dalla memoria di lavoro appena la
    // mail e' stata salvata con i suoi file, altrimenti si riaggiungerebbero a ogni mail nuova della sessione
    if( isset( $_SESSION['__work__']['mailattach']['items'] ) ) {
        if( isset( $_POST[ $ct['form']['table'] ]['file']) ) {
            unset( $_SESSION['__work__']['mailattach'] );
        }
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

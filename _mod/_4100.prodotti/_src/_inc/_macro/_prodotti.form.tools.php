<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'prodotti';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'azioni' => array(
        'label' => NULL
        )
    );

    // duplica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'duplica', 'include' => 'inc/prodotti.form.tools.modal.duplica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'duplica prodotto',
	    'text' => 'duplica il prodotto corrente'
	);

    // cambia il codice
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'codice', 'include' => 'inc/prodotti.form.tools.modal.codice.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-barcode',
	    'title' => 'cambia il codice',
	    'text' => 'cambia il codice prodotto e lo ripunta su tutto quello che ci sta attaccato'
	);
/*
    // pubblica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'pubblica', 'include' => 'inc/pagine.form.tools.modal.pubblica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-cloud-upload',
	    'title' => 'pubblica pagina',
	    'text' => 'pubblica la pagina corrente'
	);
*/
    // stages
    $ct['etc']['stages'] = array();

    foreach( array_keys( $cf['mysql']['profiles'] ) as $stage ) {
        if( $stage != SITE_STATUS ) {
            $ct['etc']['stages'][] = array( 'id' => $stage, '__label__' => $stage );
        }
    }

    /*
     * L'ELENCO DEI FILE DA CARICARE VIA FTP QUI NON SERVE, E FACEVA MORIRE LA PAGINA
     * ============================================================================
     *
     * Questo blocco arriva pari pari da _mod/_3000.contenuti/_src/_inc/_macro/_pagine.form.tools.php,
     * dove pero' e' commentato: serve solo alla modale "pubblica pagina", che qui sopra e'
     * commentata anche lei. Quindi era codice morto, che nessun template legge.
     *
     * Morto ma non gratis: cercava il template con "SELECT template FROM pagine WHERE id = ?"
     * passando l'id dell'ENTITA' DI QUESTA PAGINA, che non e' un id di pagine. Nessuna riga
     * tornava, $template restava vuoto, e getRecursiveFileList() finiva per scandire tutta la
     * document root: sul primo deploy con un .git non leggibile da www-data l'iteratore lanciava
     * una UnexpectedValueException non gestita e la scheda "azioni" moriva con un fatal error.
     *
     * Lasciato commentato come nell'originale invece che corretto: se un domani la modale
     * "pubblica" viene riattivata, va riscritto leggendo il template dalla tabella dell'entita'
     * ( $ct['form']['table'], che qui la colonna template ce l'ha ) e filtrando le immagini e i
     * file per la loro colonna, non per id_pagina.
     */
/*
    // ...
    $ct['etc']['upload'] = array_merge(
        mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM immagini WHERE id_pagina = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) )
        ,
        mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM file WHERE id_pagina = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) )
    );

    // ...
    $template = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT template FROM pagine WHERE id = ?',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
    );

    // ...
    $ct['etc']['upload'] = array_merge(
        $ct['etc']['upload'],
        getRecursiveFileList( path2custom( DIR_BASE . '/' . $template ) )
    );

    // dati della vista per i moduli
    foreach( $cf['mods']['active']['array'] as $mod ) {
        $ct['etc']['upload'] = array_merge(
            $ct['etc']['upload'],
            getRecursiveFileList( path2custom( DIR_MOD . '_' . $mod . '/' . $template ) )
        );
    }
*/

    // debug
    // die( $template );
    // die( print_r( $ct['etc']['upload'], true ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

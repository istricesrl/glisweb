<?php

    /**
     * macro della pagina di gestione dei template dei contenuti
     *
     * Questa macro imposta la pagina di gestione dei template dei contenuti. Si noti che la pagina
     * opera in __filesystem_mode__. La tabella __templates__ è una tabella virtuale che non esiste nel
     * database, ma serve soltanto a passare le informazioni corrette alle varie schede della gestione
     * dei contenuti.
     * 
     * Per il funzionamento del __filesystem_mode__ si veda il codice di /_src/_config/_750.controller.php,
     * di /_src/_inc/_macro/_delete.php, di /_src/_inc/_macro/_default/_default.form.php, di
     * /_src/_inc/_macro/_default/_default.view.php e di /_src/_lib/_controller.tools.php.
     * 
     * 
     *
     */

    // tabella gestita
    $ct['form']['table'] =  '__templates__';

    // modalità filesystem
    $ct['form']['__filesystem_mode__'] = 1;

    // macro di default
    require DIR_MOD . '_03000.contenuti/_src/_inc/_macro/_contenuti.template.form.default.php';
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // debug
    // print_r( $_REQUEST[ $ct['form']['table'] ] );

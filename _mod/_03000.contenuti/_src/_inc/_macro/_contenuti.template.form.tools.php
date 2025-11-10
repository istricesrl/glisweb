<?php

    /**
     *
     *
     *
     * TODO implementare
     * TODO documentare
     *
     */

    // tabella della vista
    $ct['form']['table'] = '__templates__';
    $ct['form']['__filesystem_mode__'] = 1;

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.esportazioni' => array(
            'label' => 'esportazioni'
        ),
        '02.importazioni' => array(
            'label' => 'importazioni'
        ),
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        )
    );

    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    require DIR_MOD . '_03000.contenuti/_src/_inc/_macro/_contenuti.template.form.default.php';
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
    
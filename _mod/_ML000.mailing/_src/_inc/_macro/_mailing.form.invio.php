<?php

    /**
     * destinatari del mailing
     *
     * L'elenco dei destinatari preparato da `_genera.elenco.destinatari.php`, con la data in cui ciascuna mail è
     * stata generata e quella in cui è stata consegnata.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing';

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'mailing_mail',
        'open' => array(
            'page' => 'mailing.mail.form',
            'table' => 'mailing_mail',
            'field' => 'id'
        ),
        'cols' => array(
            'id' => '#',
            'anagrafica' => 'destinatario',
            'mail' => 'indirizzo',
            'data_ora_generazione' => 'preparata',
            'data_ora_invio' => 'inviata',
            NULL => 'azioni'
        ),
        'class' => array(
            'anagrafica' => 'text-start',
            'mail' => 'text-start',
            'data_ora_generazione' => 'no-wrap',
            'data_ora_invio' => 'no-wrap',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_mailing' => array( 'EQ' => $_REQUEST[ $ct['form']['table'] ]['id'] ?? NULL )
        )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

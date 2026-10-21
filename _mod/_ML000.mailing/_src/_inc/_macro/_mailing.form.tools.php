<?php

    /**
     * strumenti del mailing
     *
     * La preparazione dei destinatari ( solo se il mailing ha una data di invio, che è quella con cui le mail
     * entrano nella coda ), l'invio di prova e l'applicazione di un template mail di `_TE000.template`.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'mailing';

    // percorsi
    $base = '/task/ML000.mailing/';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.strumenti' => array(
            'label' => 'strumenti'
        ),
        '02.invio' => array(
            'label' => 'gestione invio'
        )
    );

    // preparazione invio
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_invio'] ) ) {
        $ct['page']['contents']['metro']['02.invio'][] = array(
            'ws' => $base . 'genera.elenco.destinatari?idMailing=' . $_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-share-square-o',
            'title' => 'prepara invio',
            'text' => 'avvia la preparazione delle mail'
        );
    }

    // invio di test
    $ct['page']['contents']['metro']['02.invio'][] = array(
        'modal' => array( 'id' => 'invia', 'include' => 'inc/mailing.form.tools.modal.invio.test.twig' ),
        'icon' => NULL,
        'fa' => 'fa-share-square',
        'title' => 'invio di test',
        'text' => 'invia una mail di test'
    );

    // RELAZIONI CON IL MODULO TEMPLATE
    if( in_array( "TE000.template", $cf['mods']['active']['array'] ) ) {

        // applicazione template
        $ct['page']['contents']['metro']['01.strumenti'][] = array(
            'modal' => array( 'id' => 'applica_template', 'include' => 'inc/mailing.form.tools.modal.template.applica.twig' ),
            'icon' => NULL,
            'fa' => 'fa-clipboard',
            'title' => 'applica template',
            'text' => 'applica un template mail a questo mailing'
        );

        // tendina template
        $ct['etc']['select']['template'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM template_view WHERE se_mail = 1'
        );

    }

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

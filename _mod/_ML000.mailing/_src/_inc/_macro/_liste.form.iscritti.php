<?php

    /**
     * iscritti alla lista
     *
     * Gli indirizzi iscritti alla lista, con l'inserimento rapido di un indirizzo. La colonna del consenso dice
     * quali indirizzi verranno saltati al momento dell'invio, secondo la regola di mailingCondizioneConsenso():
     * l'iscrizione resta, perché chi si toglie dalla newsletter non deve rientrare ripopolando la lista, ma
     * `_genera.elenco.destinatari.php` non lo mette fra i destinatari.
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'liste';

    // inserimento rapido di un indirizzo nella lista
    if( ! empty( $_REQUEST['__link_mail__']['id_mail'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {

        // iscrizione, lasciando com'è chi è già iscritto
        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT IGNORE INTO liste_mail ( id_lista, id_mail, timestamp_inserimento ) VALUES ( ?, ?, ? )',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST['__link_mail__']['id_mail'] ),
                array( 's' => time() )
            )
        );

    }

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'liste_mail',
        'open' => array(
            'page' => 'liste.mail.form',
            'table' => 'liste_mail',
            'field' => 'id',
            'preset' => array(
                'field' => 'id_lista'
            )
        ),
        'insert' => array(
            'page' => 'liste.mail.form',
            'field' => 'id_lista'
        ),
        'cols' => array(
            'id' => '#',
            'id_mail' => 'ID mail',
            'anagrafica' => 'destinatario',
            'mail' => 'indirizzo',
            '__consenso__' => 'consenso',
            NULL => 'azioni'
        ),
        'class' => array(
            'id_mail' => 'd-none',
            'anagrafica' => 'text-start',
            'mail' => 'text-start',
            '__consenso__' => 'no-wrap',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_lista' => array( 'EQ' => $_REQUEST[ $ct['form']['table'] ]['id'] ?? NULL )
        ),
        '__sort__' => array(
            'mail' => 'ASC'
        )
    );

    // inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/liste.form.iscritti.insert.twig',
        'fa' => 'fa-plus-circle'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // indirizzi della lista che hanno revocato il consenso
    if( ! empty( $ct['view']['data'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {

        // indirizzi esclusi
        $esclusi = mysqlSelectColumn(
            'id',
            $cf['mysql']['connection'],
            'SELECT mail.id FROM liste_mail INNER JOIN mail ON mail.id = liste_mail.id_mail '.
            'WHERE liste_mail.id_lista = ? AND NOT ' . mailingCondizioneConsenso( 'mail' ),
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );

        // stato del consenso
        foreach( $ct['view']['data'] as &$row ) {
            if( is_array( $row ) ) {
                $row['__consenso__'] = ( in_array( $row['id_mail'], (array) $esclusi ) ) ? 'revocato' : NULL;
            }
        }

    }

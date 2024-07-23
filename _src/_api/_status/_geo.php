<?php

    // inclusione del framework
    require '../../_config.php';

    // ...
    if( ! empty( $_REQUEST['s'] ) ) {

        // seleziono gli stati
        $stati = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM stati WHERE id = ?',
            array( 
                array( 's' => $_REQUEST['s'] )
            )
        );

        // ...
        if( ! empty( $_REQUEST['r'] ) ) {

            // seleziono le regioni
            $regioni = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM regioni WHERE id = ?',
                array( 
                    array( 's' => $_REQUEST['r'] )
                )
            );

            // ...
            if( ! empty( $_REQUEST['p'] ) ) {

                // seleziono le provincie
                $provincie = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT * FROM provincie WHERE id = ?',
                    array( 
                        array( 's' => $_REQUEST['p'] )
                    )
                );

                // ...
                if( ! empty( $_REQUEST['c'] ) ) {

                    // seleziono i comuni
                    $comuni = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT * FROM comuni WHERE id = ?',
                        array( 
                            array( 's' => $_REQUEST['c'] )
                        )
                    );

                } else {

                    // seleziono i comuni
                    $comuni = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT * FROM comuni WHERE id_provincia = ?',
                        array( 
                            array( 's' => $_REQUEST['p'] )
                        )
                    );

                }

            } else {

                // seleziono le provincie
                $provincie = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT * FROM provincie WHERE id_regione = ? ORDER BY nome ASC',
                    array( 
                        array( 's' => $_REQUEST['r'] )
                    )
                );

            }

        } else {

            // seleziono le regioni
            $regioni = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM regioni WHERE id_stato = ? ORDER BY nome ASC',
                array( 
                    array( 's' => $_REQUEST['s'] )
                )
            );

        }

    } else {

        // seleziono gli stati
        $stati = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM stati ORDER BY nome ASC'
        );

    }

    // ...
    $lstati = array();
    $lregioni = array();
    $lprovincie = array();
    $lcomuni = array();

    // ...
    foreach( $stati as $stato ) {
        $lstati[] = '<a href="?s=' . $stato['id'] . '&r=&p=&c=">' . $stato['nome'] . '</a>';
    }   

    // ...
    foreach( $regioni as $regione ) {
        $lregioni[] = '<a href="?s=' . $regione['id_stato'] . '&r=' . $regione['id'] . '&p=&c=">' . ( ( ! empty( $regione['nome'] ) ) ? $regione['nome'] : '(vuoto)' ) . '</a>';
    }

    // ...
    foreach( $provincie as $provincia ) {
        $lprovincie[] = '<a href="?s=' . $regione['id_stato'] . '&r=' . $provincia['id_regione'] . '&p=' . $provincia['id'] . '&c=">' . ( ( ! empty( $provincia['nome'] ) ) ? $provincia['nome'] : '(vuoto)' ) . '</a>';
    }

    // ...
    foreach( $comuni as $comune ) {
        $lcomuni[] = ( ( ! empty( $comune['nome'] ) ) ? $comune['nome'] : '(vuoto)' );
    }

    // output
    $tx    = '<span style="font-family: monospace;">';

    $tx   .= '<style> td { vertical-align: top; padding: .2em; } button { width: 100%; }</style>';

    $tx    .= '<form action="" method="post">';

    // array da stampare
    $tx    .= '<table>';

    $tx   .= '<tr>';

    $tx     .= '<td><a href="?">stato</a></td>';
    $tx     .= '<td><a href="?s='.$_REQUEST['s'].'">regione</a></td>';
    $tx     .= '<td><a href="?s='.$_REQUEST['s'].'&r='.$_REQUEST['r'].'">provincia</a></td>';
    $tx     .= '<td>comune</td>';

    $tx   .= '</tr>';


    $tx   .= '<tr>';

    $tx     .= '<td>'.implode( '<br />', $lstati ).'</td>';
    $tx     .= '<td>'.implode( '<br />', $lregioni ).'</td>';
    $tx     .= '<td>'.implode( '<br />', $lprovincie ).'</td>';
    $tx     .= '<td>'.implode( '<br />', $lcomuni ).'</td>';

    $tx   .= '</tr>';


    $tx    .= '</table>';


    $tx    .= '</form>';

    // output
    $tx    .= '</span>';

    // debug
    // die( $tx );

    // output
    buildHtml( $tx, 'geografia del framework' );

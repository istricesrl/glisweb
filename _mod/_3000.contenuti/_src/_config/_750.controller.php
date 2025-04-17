<?php

    /**
     * 
     * 
     * 
     * @todo documentare
     * 
     */

    // debug
    // die( print_r( $_REQUEST, true ) );
    // die( print_r( $_REQUEST['__templates__'], true ) );
    // die( print_r( $_REQUEST['__template_files__'], true ) );

    // se è specificato un template
    if( isset( $_REQUEST['__templates__']['id'] ) && ! empty( $_REQUEST['__templates__']['id'] ) ) {

        // se è specificato un file per il template
        if( isset( $_REQUEST['__template_files__']['id'] ) && ! empty( $_REQUEST['__template_files__']['id'] ) ) {

            // ...
            $_REQUEST['__template_files__']['folder'] = trim( $_REQUEST['__template_files__']['folder'], './' );

            // se è specificato un modulo per il template
            if( isset( $_REQUEST['__template_files__']['modulo'] ) && ! empty( $_REQUEST['__template_files__']['modulo'] ) ) {
                $base = DIR_MOD . 
                    '_' . $_REQUEST['__template_files__']['modulo'] . 
                    '/_src/_templates/_' . $_REQUEST['__templates__']['id'] . 
                    ( ( isset( $_REQUEST['__template_files__']['folder'] ) ) ? $_REQUEST['__template_files__']['folder'] : NULL ) .
                    '/' . $_REQUEST['__template_files__']['id'];
            } else {
                $base = '_src/_templates/' . 
                    '_' . $_REQUEST['__templates__']['id'] . 
                    ( ( isset( $_REQUEST['__template_files__']['folder'] ) ) ? $_REQUEST['__template_files__']['folder'] : NULL ) .
                    '/' . $_REQUEST['__template_files__']['id'];
            }

            // debug
            // var_dump( $base );
            // var_dump( absolutePath( $base ) );

            // ...
            // if( realpath( $base ) !== $base ) {
            if( trim( absolutePath( $base ), '/' ) !== trim( $base , '/' ) ) {
                die( trim( absolutePath( $base ), '/' ) . ' !== ' . trim( $base , '/' ) );
            }

            // nome del file custom
            $custom = path2custom( $base );

            // debug
            // var_dump( $_REQUEST['__template_files__']['contenuto'] );
            // var_dump( $custom );
            // var_dump( file_exists( $custom ) );
            // die( 'custom: ' . $custom );

            // scrittura
            if( isset( $_REQUEST['__template_files__']['contenuto'] ) && ! empty( trim( $_REQUEST['__template_files__']['contenuto'] ) ) ) {

                // debug
                // die( 'sul file: ' . $custom . ' scrivo: ' . $_REQUEST['__template_files__']['contenuto'] );

                // ...
                writeToFile( $_REQUEST['__template_files__']['contenuto'], $custom );

            } elseif( ! file_exists( getFullPath( $custom ) ) && file_exists( getFullPath( $base ) ) ) {

                // debug
                // die( 'creazione nuovo file da standard' );
                // die( $custom );

                // ...
                $standard = readFromFile( $base );

                // ...
                writeToFile( $standard, $custom );

            } elseif( ! file_exists( getFullPath( $custom ) ) ) {

                // debug
                // die( 'creazione nuovo file vuoto' );
                // die( $custom );

                // ...
                writeToFile( PHP_EOL, $custom );

            }

            // cerco il contenuto custom e se non esiste prendo lo standard
            if( file_exists( getFullPath( $custom ) ) ) {

                // debug
                // die( $custom );
                // die( 'leggo dal file: ' . $custom );
                $_REQUEST['__template_files__']['contenuto'] = readFromFile( $custom, FILE_READ_AS_STRING );
                $ct['etc']['reading'] = $custom;

            } else {

                // die( $base );
                // die( 'leggo dal file: ' . $base . ' perché ' . $custom . ' non esiste' );
                $_REQUEST['__template_files__']['contenuto'] = readFromFile( $base, FILE_READ_AS_STRING );
                $ct['etc']['reading'] = $base;

            }

        }

        // debug
        // die( 'ok' );

    }

    // debug
    // die( 'ok' );

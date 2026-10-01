#!/bin/bash

## collaudo delle regole del firewall applicativo
#
# Rigioca un elenco di richieste contro le regole del firewall ( securityRules() e securityCheck() di _src/_config.php,
# lette da lì senza fare il bootstrap del framework; il formato delle regole è in _src/_inc/_macro/_security.php ) e le confronta con
# l'esito atteso. Va lanciato prima di promuovere qualunque modifica alle regole: un attacco che smette di essere
# bloccato o una richiesta legittima che comincia a esserlo si vedono qui, e non dopo mesi nei log.
#
# Gli elenchi sono _etc/_security/_firewall.test.conf ( standard ), etc/security/firewall.test.conf ( del deploy, se
# c'è ) e i file passati come argomento. Una richiesta per riga, campi separati da tabulazioni:
#
#     esito   url   [ user agent   [ corpo ] ]
#
# dove esito è passa, blocca ( scatta almeno una regola attiva ) oppure osserva ( scattano solo regole in
# osservazione ). Le righe vuote e quelle che cominciano con # si saltano. Si valutano solo le regole, non i punti né
# i 404: lo script non scrive niente.
#
# utilizzo: _src/_sh/_security.test.sh [ elenco ... ]
#

## livelli per la root del sito
RL="../../"

## passo alla cartella del deploy
cd $(dirname "$0")/$RL

## collaudo
php -d display_errors=stderr -- "$@" <<'EOF'
<?php

    // costanti che le funzioni si aspettano da _src/_config.php
    define( 'DIR_BASE', getcwd() . '/' );
    define( 'DIR_ETC_SECURITY', DIR_BASE . '_etc/_security/' );
    define( 'FILE_BANNED_WORDS', DIR_ETC_SECURITY . '_banned.words.conf' );
    define( 'FILE_FIREWALL_RULES', DIR_ETC_SECURITY . '_firewall.rules.conf' );
    define( 'FILE_FIREWALL_RULES_CUSTOM', DIR_BASE . 'etc/security/firewall.rules.conf' );

    // le due funzioni delle regole, prese dal sorgente di _src/_config.php
    $t = token_get_all( file_get_contents( DIR_BASE . '_src/_config.php' ) );
    foreach( array( 'securityRules', 'securityCheck' ) as $f ) {
        foreach( $t as $i => $x ) {
            if( is_array( $x ) && $x[0] == T_FUNCTION && isset( $t[ $i + 2 ][1] ) && $t[ $i + 2 ][1] == $f ) {
                $code = '';
                $depth = 0;
                for( $j = $i; $j < count( $t ); $j++ ) {
                    $code .= ( is_array( $t[ $j ] ) ) ? $t[ $j ][1] : $t[ $j ];
                    if( $t[ $j ] === '{' || ( is_array( $t[ $j ] ) && in_array( $t[ $j ][0], array( T_CURLY_OPEN, T_DOLLAR_OPEN_CURLY_BRACES ) ) ) ) {
                        $depth++;
                    } elseif( $t[ $j ] === '}' && --$depth == 0 ) {
                        break;
                    }
                }
                eval( $code );
            }
        }
    }

    // elenchi
    $elenchi = array_merge( array( DIR_ETC_SECURITY . '_firewall.test.conf', DIR_BASE . 'etc/security/firewall.test.conf' ), array_slice( $argv, 1 ) );
    $rules = securityRules();
    $totale = $errori = 0;

    foreach( $elenchi as $elenco ) {

        if( ! file_exists( $elenco ) ) {
            continue;
        }

        foreach( file( $elenco, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) as $riga ) {

            $c = explode( "\t", trim( $riga ) );
            if( count( $c ) < 2 || ! in_array( $c[0], array( 'passa', 'blocca', 'osserva' ) ) ) {
                continue;
            }

            // la POST si ricava dal corpo come farebbe PHP con un form
            $post = array();
            if( isset( $c[3] ) ) {
                parse_str( $c[3], $post );
            }
            $query = array();
            parse_str( (string) parse_url( $c[1], PHP_URL_QUERY ), $query );

            $attive = $osservate = array();
            foreach( securityCheck( $rules, $c[1], $post, ( isset( $c[2] ) ? $c[2] : '' ), array_merge( $query, $post ) ) as $r ) {
                if( $r['stato'] == 'obs' ) {
                    $osservate[] = $r['zona'] . ':' . $r['tipo'] . ':' . $r['valore'];
                } else {
                    $attive[] = $r['zona'] . ':' . $r['tipo'] . ':' . $r['valore'];
                }
            }
            $esito = ( ! empty( $attive ) ) ? 'blocca' : ( ( ! empty( $osservate ) ) ? 'osserva' : 'passa' );

            $totale++;
            if( $esito != $c[0] ) {
                $errori++;
                if( $errori <= 50 ) {
                    echo 'atteso ' . $c[0] . ', ottenuto ' . $esito . ': ' . substr( $c[1], 0, 160 ) . ( ( $attive || $osservate ) ? ' [' . implode( ' ', array_merge( $attive, $osservate ) ) . ']' : '' ) . PHP_EOL;
                }
            }

        }

    }

    echo $totale . ' richieste, ' . $errori . ' esiti diversi dall\'atteso' . PHP_EOL;
    exit( ( $errori > 0 || $totale == 0 ) ? 1 : 0 );
EOF

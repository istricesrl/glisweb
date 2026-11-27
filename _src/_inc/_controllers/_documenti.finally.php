<?php

    /**
     * controller finally della tabella documenti
     *
     * Tiene allineata documenti_view_static a ogni scrittura di un documento: dopo POST, PUT, REPLACE e UPDATE riscrive
     * la riga con refreshStaticView(), dopo DELETE la toglie. Sta nel nucleo e non in un modulo perche' la statica la
     * crea il file base _080000999999.static.sql su ogni deploy, qualunque modulo documenti sia attivo ( _DO000 o
     * _0400 ), e getStaticViewExtension() la legge appena c'e': una statica che nessuno aggiorna e' un elenco fermo.
     *
     * Il controller finally gira dopo i sottomoduli, quindi quando si salva un documento dal suo form con pagamenti e
     * relazioni la riga della statica li comprende gia'. Le scritture dirette di pagamenti e relazioni_documenti hanno
     * i loro controller ( _pagamenti.finally.php, _relazioni.documenti.finally.php ); quelle che non passano dal
     * controller le recupera a lotti il task _documenti.view.static.popolazione.php.
     *
     * Se la statica sul deploy non c'e', refreshStaticView() non fa niente e il DELETE non parte.
     *
     * @file
     *
     */

    // log
    logWrite( "controller finally per $t/$a", 'controller' );

    // elaborazioni di default dei dati
    switch( strtoupper( $a ) ) {

        case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

            // aggiorno la view statica
            if( ! empty( $d['id'] ) ) {
                refreshStaticView( $c, 'documenti', $d['id'] );
            }

        break;

        case METHOD_DELETE:

            // tolgo la riga dalla view statica
            if( ! empty( $d['id'] ) && ! empty( getStaticView( NULL, $c, 'documenti' ) ) ) {
                mysqlQuery( $c, 'DELETE FROM documenti_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            }

        break;

    }

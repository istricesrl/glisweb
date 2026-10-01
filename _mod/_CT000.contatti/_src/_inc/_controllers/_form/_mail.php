<?php

    /**
     * controller per i moduli contatti: invio delle mail
     * ==================================================
     *
     * Il ciclo di _mod/_CT000.contatti/_src/_config/_750.controller.php salva il contatto e include le controller
     * dichiarate dal modulo, ma da solo non manda nessuna mail; questa controller fa quello che faceva il blocco mail
     * di _mod/_0300.contatti/_src/_config/_750.controller.php, con la stessa forma di configurazione, così chi
     * conosceva l'una conosce l'altra:
     *
     * contatti:
     *   nomemodulo:
     *     controller:
     *       - "_mod/_CT000.contatti/_src/_inc/_controllers/_form/_mail.php"
     *     mail:
     *       interna:
     *         destinatari: { "nome": "indirizzo" }
     *         language: "it-IT"
     *         exclude: [ "__status__" ]
     *         template: "DEFAULT_CONTATTI"
     *       esterna:
     *         destinatari: { "{{ dt.nome }}": "{{ dt.mail }}" }
     *         template: "DEFAULT_RINGRAZIAMENTO_CONTATTI"
     *
     * I due template di default li dichiara _mod/_CT000.contatti/_src/_config/_350.mail.php; un progetto li
     * personalizza in mod/CT000.contatti/src/config/350.mail.php.
     *
     * Le chiavi che cominciano con il doppio underscore ( __spam__, __sito__, __privacy__ e simili ) sono dati
     * di servizio del modulo e non vanno nella mail: si tolgono sempre, oltre a quelle elencate in exclude.
     *
     * Portata nello standard dal progetto utensilerialughese il 01/10/2026, dove è stata provata con invii veri.
     *
     * @file
     *
     */

    // log
    logger( 'controller ' . __FILE__ . ' caricata per il modulo ' . $k, 'contatti' );

    // verifico se la configurazione prevede l'invio di una mail
    if( isset( $cf['contatti'][ $k ]['mail'] ) ) {

        // log
        logger( 'invio ' . count( $cf['contatti'][ $k ]['mail'] ) . ' mail per il modulo ' . $k, 'contatti' );

        // ciclo per ogni mail da mandare
        foreach( $cf['contatti'][ $k ]['mail'] as $conf ) {

            // lingua della mail
            if( ! isset( $conf['language'] ) ) {
                $conf['language'] = $v['ietf'] ?? $cf['localization']['language']['ietf'];
            }

            // template della mail
            if( is_array( $conf['template'] ) ) {
                $template = $conf['template'];
            } elseif( isset( $cf['mail']['tpl'][ $conf['template'] ] ) ) {
                $template = $cf['mail']['tpl'][ $conf['template'] ];
            } else {
                logger( 'template mail ' . $conf['template'] . ' non trovato per il modulo ' . $k, 'contatti', LOG_ERR );
                continue;
            }

            // dati da passare al template, senza quelli di servizio
            $dati = array_filter( $v, function( $chiave ) { return strpos( $chiave, '__' ) !== 0; }, ARRAY_FILTER_USE_KEY );
            if( isset( $conf['exclude'] ) ) {
                $dati = array_diff_key( $dati, array_combine( $conf['exclude'], $conf['exclude'] ) );
            }
            $dati['modulo'] = $k;

            // destinatari in copia
            $conf['destinatari_cc'] = ( ! empty( $conf['destinatari_cc'] ) ) ? $conf['destinatari_cc'] : array();
            $conf['destinatari_bcc'] = ( ! empty( $conf['destinatari_bcc'] ) ) ? $conf['destinatari_bcc'] : array();

            // accodo la mail
            queueMailFromTemplate(
                $cf['mysql']['connection'],
                $template,
                array( 'dt' => $dati, 'ct' => $ct ),
                strtotime( '+1 minutes' ),
                $conf['destinatari'],
                $conf['language'],
                $conf['destinatari_cc'],
                $conf['destinatari_bcc']
            );

        }

    } else {

        // log
        logger( 'nessuna mail configurata per il modulo ' . $k, 'contatti' );

    }

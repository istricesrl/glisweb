<?php

    // shortcut per il carrello
	$c = $_SESSION['carrello'];

    // shortcut per la lingua
	$l = $cf['localization']['language']['ietf'];

    // shortcut per il profilo
    $k = $cf['ecommerce']['profile']['provider'][ $_SESSION['carrello']['provider_pagamento'] ];

    // se è impostato un provider di pagamento
    if( isset( $_SESSION['carrello']['provider_pagamento'] ) && ! empty( $_SESSION['carrello']['provider_pagamento'] ) ) {

        // configurazione riepilogo e ambiente di pagamento in base al provider scelto
        switch( $_SESSION['carrello']['provider_pagamento'] ) {

            case 'contanti':

                // dati per la costruzione del modulo
                    $ct['etc']['meta']['method']	    = $k['method'];											        // metodo di chiamata al server
        
                // URL espliciti
                    if( isset( $k['action_url'] ) ) {
                        $ct['etc']['meta']['action']	= $k['action_url'];                                             // server da chiamare
                    } else {
                        $ct['etc']['meta']['action']	= $cf['contents']['pages'][ $k['action'] ]['url'][ $l ];		// server da chiamare
                    }

                // dati del modulo
                    $ct['etc']['fields']['id']		    = $c['id'];											            // id del carrello
        
            break;

            case 'paypal':

                // dati per la costruzione del modulo
                $ct['etc']['meta']['method']	    = $k['method'];											        // metodo di chiamata al server

            break;

        }

    }

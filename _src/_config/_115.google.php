<?php

    /**
     * server e profili Google
     *
     * introduzione
     * ============
     * In questo file vengono integrati i dati dichiarati al runlevel 110 con quelli presenti nei file di configurazione
     * JSON/YAML dopodiché la chiave $cf['google'] viene collegata a $ct['google'] per dare visibilità al template manager
     * delle informazioni sui profili. Infine il profilo relativo allo stato corrente del sito viene collegato alla
     * scorciatoia $cf['google']['profile'].
     *
     * Il framework supporta un'ampia gamma di servizi Google, fra cui Google Analytics, Google Tag Manager e Google reCAPTCHA.
     * La configurazione è strutturata in modo da rendere chiaro e il più possibile intuitivo l'inserimento e la modifica
     * delle informazioni.
     *
     * Google Analytics
     * ----------------
     * La configurazione di Google Analytics è relativamente semplice; di base, si tratta di specificare per i vari profili
     * l'ID di monitoraggio (UA) e, se pertinente, attivare il flag anonimo:
     * 
     * ```
     *"google": {
     *    "profiles": {
     *        "DEV": {
     *            "analytics": {
     *                "ua": "X-XXXXXXXXXX",
     *                "anonymous": true
     *            }
     *        }
     *    }
     *},
     * ```
     * 
     * Google Tag Manager
     * ------------------
     * La configurazione di Google Tag Manager è simile a quella di Google Analytics, con la necessità di specificare l'ID 
     * di monitoraggio (GTM) e, se necessario, attivare il flag anonimo:
     * 
     * ```
     *"google": {
     *    "profiles": {
     *        "DEV": {
     *            "gtm": {
     *                "property": "X-XXXXXXXXXX",
     *                "anonymous": true
     *            }
     *        }
     *    }
     *},
     * ```
     * 
     * Google reCAPTCHA
     * ----------------
     * La configurazione di Google reCAPTCHA richiede l'inserimento delle chiavi pubblica e privata per i vari profili:
     * 
     * ```
     *"google": {
     *    "profiles": {
     *        "DEV": {
     *            "recaptcha": {
     *                "keys": {
     *                    "public": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
     *                    "private": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
     *                }
     *            }
     *        }
     *    }
     *},
     * ```
     * 
     * YouTube
     * -------
     * Il framework supporta l'interazione con YouTube tramite API; la configurazione per YouTube è simile a quella già vista per
     * reCAPTCHA:
     * 
     * ```
     *"google": {
     *    "profiles": {
     *        "DEV": {
     *            "youtube": {
     *                "keys": {
     *                    "private": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
     *                }
     *            }
     *        }
     *    }
     *},
     * ```
     *
     */

    /**
     * integrazione della configurazione da file Json/Yaml
     * ===================================================
     * 
     * 
     */

    // configurazione extra
    if( isset( $cx['google'] ) ) {
        $cf['google'] = array_replace_recursive( $cf['google'], $cx['google'] );
    }

    // configurazione extra per sito
    if( isset( $cf['site']['google'] ) ) {
        $cf['google'] = array_replace_recursive( $cf['google'], $cf['site']['google'] );
    }

    /**
     * collegamento di $ct a $cf tramite puntatore
     * ===========================================
     * 
     * 
     */

    // collegamento all'array $ct
    $ct['google'] = &$cf['google'];

    /**
     * scorciatoia per il profilo corrente
     * ===================================
     * 
     * 
     */

    // link al profilo corrente
    $cf['google']['profile'] = &$cf['google']['profiles'][ SITE_STATUS ];

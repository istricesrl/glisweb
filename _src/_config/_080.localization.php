<?php

    /**
     * configurazione delle localizzazioni del sito
     *
     * Il framework utilizza diversi standard per identificare i paesi e le lingue.
     *
     * standard adottati dal framework
     * ===============================
     * Le questioni relative alla localizzazione e all'internazionalizzazione del framework
     * sono tutt'altro che secondarie; la filosofia di base è quella della maggior aderenza
     * possibile agli standard consolidati.
     *
     * per i paesi
     * -----------
     * Per identificare i paesi il framework prevede l'utilizzo dello standard ISO 3166-1,
     * nelle versioni a due e tre caratteri; questo consente la compatibilità con i codici
     * ISO 3166-2 per l'indicazione di regioni, provincie e città in quanto la prima parte
     * del codice ISO 3166-2 è un codice ISO 3166-1 alpha-2.
     *
     * - lo standard ISO 3166-1 alpha-2        http://it.wikipedia.org/wiki/ISO_3166-1_alpha-2
     * - lo standard ISO 3166-1 alpha-3        http://it.wikipedia.org/wiki/ISO_3166-1_alpha-3
     * - lo standard ISO 3166-2            https://it.wikipedia.org/wiki/ISO_3166-2
     *
     * Questi codici sono registrati nel \ref database "database di supporto", nelle tabelle
     * geografiche.
     *
     * per le bandiere nazionali
     * -------------------------
     * Il framework utilizza i codici ISO 3166-1 alpha-2 anche per identificare le
     * bandiere degli stati presenti in /_src/_img/_flags/.
     *
     * per le lingue
     * -------------
     * In quanto software basato sul web, il framework integra lo standard IETF per identificare
     * i linguaggi. Tutte le indicazioni relative alle lingue presenti nel framework sono,
     * salvo diversa indicazione, riferite a questo standard.
     *
     * - lo standard IETF language tag        http://en.wikipedia.org/wiki/IETF_language_tag
     * - lo standard ISO 639-1 alpha-2        http://it.wikipedia.org/wiki/ISO_639-1
     * - lo standard ISO 639-3 alpha-3        http://it.wikipedia.org/wiki/ISO_639-3
     *
     * Per compatibilità con altri sistemi, il framework supporta altresì lo standard ISO 639,
     * e in particolare ISO 639-1 per i codici a due lettere e ISO 639-3 per i codici a tre
     * lettere.
     *
     * Per riferimento, alcune liste utili sono:
     *
     * - https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
     * - http://www.lingoes.net/en/translator/langcode.htm
     * - http://unicode.org/cldr/utility/languageid.jsp
     * - https://www.w3schools.com/tags/ref_language_codes.asp
     * - https://www.w3schools.com/tags/ref_country_codes.asp
     * - https://it.wikipedia.org/wiki/ISO_3166-2:IT
     * - https://datahub.io/core/language-codes
     * - http://www-01.sil.org/iso639-3/download.asp
     *
     * per le valute
     * -------------
     * - https://en.wikipedia.org/wiki/ISO_4217
     *
     * per i fusi orari
     * ----------------
     * - https://it.wikipedia.org/wiki/Fuso_orario
     *
     * per le timezone
     * ---------------
     * - https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
     * - https://www.iana.org/time-zones
     * - https://timezonedb.com/download
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     *
     */

    // debug
    // print_r( $_REQUEST );

    // moduli attivi
    define( 'LINGUE_ATTIVE'            , implode( ',', array_keys( $cf['site']['name'] ) ) );

    // cerco di ricavare il sito corrente dal dominio
    foreach( $cf['sites'] as $id => &$site ) {

        // lingue attive per il sito
        foreach( array_keys( $site['name'] ) as $l ) {
            $site['localization']['languages'][ $l ]['id'] = NULL;
            $site['localization']['languages'][ $l ]['ietf'] = $l;
        }
    
    }

    // lingue attive in base ai titoli del sito nelle varie lingue
    $cf['localization']['languages'] = &$cf['site']['localization']['languages'];

    /*
    foreach( array_keys( $cf['site']['name'] ) as $l ) {
        $cf['localization']['languages'][ $l ]['id'] = NULL;
        $cf['localization']['languages'][ $l ]['ietf'] = $l;
    }
    */

    // timezone di default
    $cf['localization']['timezone']['name']     = 'Europe/Rome';

    // valuta di default
    $cf['localization']['currency']['iso4217']  = 'EUR';

    // charset utilizzato di default per l'output
    $cf['localization']['charset']              = ENCODING_UTF8;

    // debug
    // echo 'OUTPUT';
    // die( print_r( $cf['sites'] ) );
    // die( print_r( $cf['site'], true ) );
    // die( print_r( $cf['site']['localization']['languages'], true ) );
    // die( 'lingue attive: ' . print_r( $cf['localization']['languages'], true ) );

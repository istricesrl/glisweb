<?php

    /**
     * gestione dei tag UTM per la tracciatura delle conversione
     * 
     * In questo file andiamo a raccogliere dalla $_REQUEST eventuali tag UTM e li memorizziamo in sessione,
     * in questo modo è poi possibile associare diversi oggetti del framework (contatti, carrelli, eccetera)
     * a una specifica campagna sponsorizzata.
     * 
     * introduzione
     * ============
     * Per ulteriori dettagli sui tag UTM vedi https://ga-dev-tools.web.app/campaign-url-builder/
     * 
     * 
     * applicazione agli oggetti del framework
     * =======================================
     * I tag UTM sono applicabili agli oggetti più comuni (ad es. banner su newsletter, CPC da Facebook,
     * Google Ads, banner su siti terzi, volantini cartacei, eccetera)
     * 
     * 
     * 
     * 
     * 
     */

    // ...
    $cf['utm']['fields'] = array(
        'utm_id',                       // Used to identify which ads campaign this referral references. Use utm_id to identify a specific ads campaign.
        'utm_source',                   // Use utm_source to identify a search engine, newsletter name, or other source.
        'utm_medium',                   // Use utm_medium to identify a medium such as email or cost-per-click.
        'utm_campaign',                 // Used for keyword analysis. Use utm_campaign to identify a specific product promotion or strategic campaign.
        'utm_term',                     // Used for paid search. Use utm_term to note the keywords for this ad.
        'utm_content'                   // Used for A/B testing and content-targeted ads. Use utm_content to differentiate ads or links that point to the same URL.
    );

    // ...
    foreach( $cf['utm']['fields'] as $field ) {
        $_SESSION['utm'][ $field ] = ( isset( $_REQUEST[ $field ] ) ) ? $_REQUEST[ $field ] : ( ( isset( $_SESSION['utm'][ $field ] ) ) ? $_SESSION['utm'][ $field ] : NULL );
    }

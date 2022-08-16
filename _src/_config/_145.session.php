<?php

    /**
     * 
     * 
     * gestione dei tag UTM per la tracciatura delle conversione
     * 
     * 
     * 
     * vedi https://ga-dev-tools.web.app/campaign-url-builder/
     * 
     * 
     * 
     * 
     * 
     * @file
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

    // TODO
    foreach( $cf['utm']['fields'] as $field ) {
        $_SESSION['utm'][ $field ] = ( isset( $_REQUEST[ $field ] ) ) ? $_REQUEST[ $field ] : ( ( isset( $_SESSION['utm'][ $field ] ) ) ? $_SESSION['utm'][ $field ] : NULL );
    }

    // TODO
    // fare alcuni esempi di tag UTM da inserire per gli oggetti più comuni (ad es. banner su newsletter, CPC da Facebook, Google Ads, banner su siti terzi, volantini cartacei, eccetera)

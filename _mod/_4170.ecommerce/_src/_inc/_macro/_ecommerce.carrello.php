<?php

    error_reporting(E_ALL);
ini_set("display_errors", 1);

    $ct['etc']['id_provincia'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT provincie.nome AS __label__, provincie.sigla, provincie.id '
        .'FROM provincie '
        .'ORDER BY __label__ '
    );

    $ct['etc']['id_tipologia_documenti'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_documenti.nome AS __label__, tipologie_documenti.id '
        .'FROM tipologie_documenti '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    $ct['etc']['strategie_fatturazione'] = array( 
        array( 'id' => 'SINGOLA', '__label__' => 'documento unico' ),
        array( 'id' => 'MULTIPLA', '__label__' => 'documenti separati' ),
    );

    $ct['etc']['id_tipologia_anagrafica'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_anagrafica_view.__label__, tipologie_anagrafica_view.id '
        .'FROM tipologie_anagrafica_view '
        // TODO .'WHERE tipologie_anagrafica_view.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    // elenco dei siti gestiti dall'installazione, per attribuire dalla cassa il sito di competenza
    // del carrello ( il campo id_sito ); costruito esplicitamente perche la struttura standard del
    // sito ( _010.site.php ) non espone una chiave id all'interno del sotto array
    $ct['etc']['siti'] = array();
    foreach( $cf['sites'] as $idSito => $sito ) {
        $ct['etc']['siti'][] = array(
            'id'        => $idSito,
            '__label__' => ( ! empty( $sito['__label__'] ) ) ? $sito['__label__'] : $idSito
        );
    }

    $ct['etc']['id_zona'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT zone_view.__label__, zone_view.id '
        .'FROM zone_view '
        // TODO .'WHERE tipologie_anagrafica_view.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    $ct['etc']['id_listino'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT listini_view.__label__, listini_view.id '
        .'FROM listini_view '
        // TODO .'WHERE tipologie_anagrafica_view.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

    // esito della validazione del coupon inserito dall'utente, valorizzato dal controller al
    // runlevel 750; è un flash: si legge una volta sola, così il messaggio sopravvive al redirect
    // dopo il POST e sparisce al caricamento successivo.
    // NOTA la chiave è coupon_errore e non coupon.errore perché $ct['etc']['coupon'] qui sotto è
    // già l'elenco dei coupon disponibili
    $ct['etc']['coupon_errore'] = isset( $_SESSION['coupon']['errore'] ) ? $_SESSION['coupon']['errore'] : NULL;
    unset( $_SESSION['coupon']['errore'] );

    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, 
            coalesce( sum( pagamenti.coupon_valore ), 0 ) AS utilizzato, ( coupon.sconto_fisso - coalesce( sum( pagamenti.coupon_valore ), 0 ) ) AS residuo
        FROM coupon 
        LEFT JOIN pagamenti ON coupon.id = pagamenti.id_coupon
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= unix_timestamp( NOW() ) ) AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= unix_timestamp( NOW() ) )
        GROUP BY coupon.id
        HAVING utilizzato < coupon.sconto_fisso
        ORDER BY coupon.id 
        '
    );

    // link di recupero del carrello: consente all'operatore di dare al cliente un URL con cui
    // riaprire e pagare il carrello sul sito pubblico ( flusso di recupero al runlevel 710 ). Si
    // risolve in cascata: 1) pagina di provenienza fra i metadati del carrello; 2) pagina configurata
    // per il sito del carrello, montata sull'URL che quel sito ha nell'ambiente corrente. Il template
    // mostra l'opzione solo se etc.recupero.url e' valorizzato.
    $ct['etc']['recupero'] = array( 'url' => NULL );
    if( ! empty( $_SESSION['carrello']['id'] ) ) {

        $recCarrello = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT id_sito, timestamp_inserimento FROM carrelli WHERE id = ?', array( array( 's' => $_SESSION['carrello']['id'] ) ) );
        $recTs = ( isset( $recCarrello['timestamp_inserimento'] ) ) ? $recCarrello['timestamp_inserimento'] : NULL;

        // 1 - pagina di provenienza dai metadati
        $recPagina = NULL;
        if( ! empty( $cf['ecommerce']['recovery']['metadata'] ) ) {
            $recPagina = mysqlSelectValue( $cf['mysql']['connection'], "SELECT testo FROM metadati WHERE id_carrello = ? AND nome = ? AND testo <> '' ORDER BY id DESC LIMIT 1", array( array( 's' => $_SESSION['carrello']['id'] ), array( 's' => $cf['ecommerce']['recovery']['metadata'] ) ) );
        }

        // 2 - pagina configurata per il sito del carrello, sull'URL del sito nell'ambiente corrente
        if( empty( $recPagina ) && ! empty( $recCarrello['id_sito'] ) && isset( $cf['sites'][ $recCarrello['id_sito'] ] ) && ! empty( $cf['ecommerce']['recovery']['pages'][ $recCarrello['id_sito'] ] ) ) {
            $recSito = $cf['sites'][ $recCarrello['id_sito'] ];
            $recPagina =
                $recSito['protocols'][ SITE_STATUS ] . '://' .
                ( ( ! empty( $recSito['hosts'][ SITE_STATUS ] ) ) ? $recSito['hosts'][ SITE_STATUS ] . ( ( ! empty( $recSito['domains'][ SITE_STATUS ] ) ) ? '.' : NULL ) : NULL ) .
                $recSito['domains'][ SITE_STATUS ] . '/' .
                ( ( ! empty( $recSito['folders'][ SITE_STATUS ] ) ) ? $recSito['folders'][ SITE_STATUS ] : NULL ) .
                $cf['ecommerce']['recovery']['pages'][ $recCarrello['id_sito'] ];
        }

        if( ! empty( $recTs ) && ! empty( $recPagina ) ) {
            $ct['etc']['recupero']['url'] =
                $recPagina . ( ( strpos( $recPagina, '?' ) === false ) ? '?' : '&' ) .
                $cf['ecommerce']['recovery']['parameters']['cart'] . '=' . rawurlencode( $_SESSION['carrello']['id'] ) . '&' .
                $cf['ecommerce']['recovery']['parameters']['timestamp'] . '=' . rawurlencode( $recTs );
        }
    }

    // token client per il bottone PayPal Advanced della cassa: si genera solo quando il carrello
    // esiste e il provider paypal-advanced ha le credenziali ( client_id valorizzato ). Il template
    // mostra il bottone solo se etc.client_token e' presente, quindi il metodo online in-page
    // compare esclusivamente sui deploy dove PayPal Advanced e' davvero configurato.
    $ppa = isset( $cf['ecommerce']['profile']['provider']['paypal-advanced'] ) ? $cf['ecommerce']['profile']['provider']['paypal-advanced'] : NULL;
    if( ! empty( $_SESSION['carrello']['id'] ) && ! empty( $ppa['client_id'] ) && function_exists( 'paypalAdvancedGetClientToken' ) ) {
        $ct['etc']['client_token'] = paypalAdvancedGetClientToken( $ppa );
    }

    // print_r( $_SESSION['carrello'] );
    // die( print_r( $ct['etc'], true ) );

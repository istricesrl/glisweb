<?php

    /**
     * controlli di sicurezza sulla richiesta
     *
     * introduzione
     * ============
     * Questo runlevel gira prima delle sorgenti dati e dell'autenticazione, quindi e' il posto per ripulire la
     * richiesta da quello che il client non deve poter impostare, prima che qualunque runlevel ci scriva sopra
     * per conto suo. Chi vuole aggiungere logiche di sicurezza personalizzate lo fa in src/config/100.security.php.
     *
     */

    /**
     * pulizia dei flag dei moduli di account
     * ======================================
     *
     * Fix 2026-11-03: i flag __tk_ok__, __tk_sent__, __ts_check__ e __err__ dei blocchi __signup__,
     * __profile__ e __pwreset__ li scrivono le macro di registrazione, profilo e reimpostazione della
     * password, e i template li stampano con |raw perche' i testi contengono HTML. Se arrivano gia'
     * dalla richiesta ( ?__signup__[__tk_sent__][testo][it-IT]=<script>... ) sono HTML iniettato nella
     * pagina, anche dove la macro non gira ( il blocco di registrazione incluso nella pagina di login ):
     * quindi si tolgono, e restano solo quelli scritti dal server.
     *
     * Fix 2026-11-03: la pulizia stava in _710.session.php, e toglieva anche i messaggi scritti dai runlevel
     * precedenti ( su gimbe quello dell'attivazione dell'account, scritto da src/config/210.auth.php ): sta
     * qui perche' deve venire prima di ogni runlevel che li puo' scrivere. Il JSON di _user.php e' gia'
     * fuso in $_REQUEST prima del bootstrap, quindi la pulizia vale anche per quello.
     *
     */

    // tolgo i flag arrivati dal client
    foreach( array( '__signup__', '__profile__', '__pwreset__' ) as $blocco ) {
        if( isset( $_REQUEST[ $blocco ] ) && is_array( $_REQUEST[ $blocco ] ) ) {
            foreach( array( '__tk_ok__', '__tk_sent__', '__ts_check__', '__err__' ) as $flag ) {
                unset( $_REQUEST[ $blocco ][ $flag ] );
            }
        }
    }

    /**
     * __backurl__ solo come token
     * ===========================
     * __backurl__ porta l'indirizzo della pagina a cui tornare, ma non l'indirizzo stesso: è il token md5 con cui
     * backurlRegistra() ( _src/_lib/_menu.utils.php ) lo ha messo in $_SESSION['backurls'], e i template lo usano
     * così, attaccandolo ai link o cercandolo in session.backurls.
     *
     * Fix 2026-11-24: il valore arriva dalla querystring e i template lo stampano anche dentro gli onclick, dove
     * l'escape HTML non protegge; un valore con un apice usciva dalla stringa JavaScript ( XSS ). Un token è fatto
     * di 32 caratteri esadecimali e non contiene nessun host, quindi il controllo non scarta i ritorni fra siti
     * diversi di un deploy multisito: quelli li decide l'indirizzo in sessione, che il client non può impostare.
     * Qualunque altra cosa si toglie dalla richiesta.
     *
     */

    // tolgo il ritorno che non è un token
    if( isset( $_REQUEST['__backurl__'] ) && ( ! is_string( $_REQUEST['__backurl__'] ) || ! preg_match( '/^[0-9a-f]{32}$/', $_REQUEST['__backurl__'] ) ) ) {
        if( $_REQUEST['__backurl__'] !== '' ) {
            logger( 'indirizzo di ritorno che non è un token scartato', 'security', LOG_WARNING );
        }
        unset( $_REQUEST['__backurl__'], $_GET['__backurl__'], $_POST['__backurl__'] );
    }

    // debug
    // echo 'OUTPUT';

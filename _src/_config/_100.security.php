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

    // debug
    // echo 'OUTPUT';

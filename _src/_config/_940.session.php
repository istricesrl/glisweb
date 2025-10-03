<?php

    /**
     * integrazione delle informazioni di sessione
     * 
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * registrazione delle informazioni di sessione
     * ============================================
     * 
     * 
     */

    // timestamp dell'ultima azione sulla sessione
    $_SESSION['used']               = time();
    $_SESSION['ip']                 = $_SERVER['REMOTE_ADDR'];
    $_SESSION['user_agent']         = $_SERVER['HTTP_USER_AGENT'] ?? 'n/a';

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     * 
     */

    // debug
    // die( print_r( $_SESSION, true ) );

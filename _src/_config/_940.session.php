<?php

    /**
     * 
     * 
     * TODO documentare
     * 
     */

    /**
     * registrazione della timestamp di utilizzo della sessione
     * ========================================================
     * 
     * 
     */

    // timestamp dell'ultima azione sulla sessione
    $_SESSION['used']               = time();
    $_SESSION['ip']                 = $_SERVER['REMOTE_ADDR'];
    $_SESSION['user_agent']         = $_SERVER['HTTP_USER_AGENT'];

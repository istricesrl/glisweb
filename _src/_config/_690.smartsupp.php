<?php

    /**
     * profili Smartsupp
     *
     * In questo file sono impostati i profili di funzionamento di Smartsupp, la chat di assistenza
     * il cui widget viene caricato prima della chiusura del <body> da _src/_twig/_inc/_smartsupp.twig
     * ( _src/_html/_inc/_smartsupp.html per i template della linea .html ).
     *
     * struttura dei profili
     * =====================
     * Come per gli altri servizi di terze parti c'è un profilo per ambiente, e lo snippet legge il
     * profilo corrente:
     *
     * chiave           | dettagli
     * -----------------|----------------------------------------------------------------------------
     * key              | la chiave del widget, quella che il codice di installazione di Smartsupp
     *                  | assegna a _smartsupp.key
     *
     * I profili dello standard sono vuoti: Smartsupp si accende valorizzando key nella configurazione
     * del progetto, ad esempio in src/config.yaml:
     *
     * smartsupp:
     *   profiles:
     *     PROD:
     *       key: "<CHIAVE-SMARTSUPP>"
     *
     * NOTA il widget parte solo se l'utente ha prestato il consenso al cookie Smartsupp, che il progetto
     * deve dichiarare in privacy.cookie.terzi.analitici.Smartsupp perché l'overlay dei cookie possa
     * chiederlo; per ulteriori dettagli si vedano i commenti a _src/_twig/_inc/_smartsupp.twig.
     *
     */

    /**
     * definizione dei profili
     * =======================
     *
     *
     */

    // profili di funzionamento
    $cf['smartsupp']['profiles'][ DEVELOPEMENT ]    =
    $cf['smartsupp']['profiles'][ TESTING ]         =
    $cf['smartsupp']['profiles'][ PRODUCTION ]      = NULL;

    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene alcune righe commentate utili per il debug del runlevel.
     *
     */

    // debug
    // print_r( $cx['smartsupp'] );

<?php

    /**
     * profili Criteo
     *
     * In questo file sono impostati i profili di funzionamento di Criteo, il servizio di retargeting
     * pubblicitario il cui OneTag viene emesso prima della chiusura del <body> da
     * _src/_twig/_inc/_criteo.twig ( _src/_html/_inc/_criteo.html per i template della linea .html ).
     *
     * struttura dei profili
     * =====================
     * Come per gli altri servizi di terze parti c'è un profilo per ambiente, e lo snippet legge il
     * profilo corrente:
     *
     * chiave           | dettagli
     * -----------------|----------------------------------------------------------------------------
     * account          | l'identificativo numerico dell'account Criteo ( il parametro a= del OneTag )
     *
     * I profili dello standard sono vuoti: Criteo si accende valorizzando account nella configurazione
     * del progetto, di norma solo per PROD, ad esempio in src/config.yaml:
     *
     * criteo:
     *   profiles:
     *     PROD:
     *       account: 12345
     *
     * NOTA lo script parte solo se l'utente ha prestato il consenso al cookie Criteo, che il progetto
     * deve dichiarare in privacy.cookie.terzi.analitici.Criteo perché l'overlay dei cookie possa
     * chiederlo; per ulteriori dettagli si vedano i commenti a _src/_twig/_inc/_criteo.twig.
     *
     */

    /**
     * definizione dei profili
     * =======================
     *
     *
     */

    // profili di funzionamento
    $cf['criteo']['profiles'][ DEVELOPEMENT ]   =
    $cf['criteo']['profiles'][ TESTING ]        =
    $cf['criteo']['profiles'][ PRODUCTION ]     = NULL;

    /**
     * debug del runlevel
     * ==================
     * Questa sezione contiene alcune righe commentate utili per il debug del runlevel.
     *
     */

    // debug
    // print_r( $cx['criteo'] );

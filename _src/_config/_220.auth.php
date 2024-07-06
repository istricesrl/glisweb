<?php

    /**
     * questo file gestisce il logout
     *
     *
     *
     *
     * meccanismo di logout
     * ====================
     * Il logout dalla piattaforma può avvenire in due modi:
     *
     * - invio dati tramite $_REQUEST
     * - logout implicito per scadenza della sessione
     *
     * Il logout tramite $_REQUEST prevede l'invio al framework di un qualsiasi valore per la
     * chiave logout; un blocco dati simile è facile da realizzare, ad esempio:
     *
     * \code{.html}
     * <form method="post">
     *   <input type="hidden" name="__logout__" value="1">
     *   <input type="submit">
     * </form>
     * \endcode
     *
     * Volendo si può effettuare il logout anche tramite parametri GET aggiunti all'URL:
     *
     * http://glisweb.example.bho?__logout__=1
     *
     *
     * definizione di meccanismi custom per il logout
     * ==============================================
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
     */

    // tempo di riferimento
    $cf['auth']['expire'] = time() - SESSION_LIMIT;

    // verifica tempo di sessione
    if( $_SESSION['used'] <= $cf['auth']['expire'] ) {

        // logout implicito per timeout
        $_REQUEST['__logout__'] = true;

        // log
            logger( 'logout implicito per timeout: ' . $_SESSION['used'] . ' <= ' . $cf['auth']['expire'], 'session', LOG_NOTICE );

    } else {

        // log
            logger( 'sessione ancora attiva: ' . $_SESSION['used'] . ' > ' . $cf['auth']['expire'], 'session' );

    }

    // intercetto eventuali tentativi di logout
    if( isset( $_REQUEST['__logout__'] ) ) {

        // ...
        $cf['auth']['status'] = LOGIN_LOGOUT;

        // svuoto selettivamente la $_SESSION
        foreach( $_SESSION as $k => $v ) {
            if( ! in_array( $k, array( 'id', 'used' ) ) ) {
                unset( $_SESSION[ $k ] );
            }
        }

        // log
            logger( 'logout richiesto esplicitamente: ' . $_SESSION['id'], 'session' );

    }

    // debug
    // print_r( $cf['localization']['language'] );

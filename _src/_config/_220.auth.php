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
     * @todo documentare
     *
     * @file
     *
     */

    // tempo di riferimento
	$tRef = time() - SESSION_LIMIT;

    // verifica tempo di sessione
	if( $_SESSION['used'] <= $tRef ) {

	    // logout implicito per timeout
		$_REQUEST['__logout__'] = true;

	    // log
		logWrite( 'logout implicito per timeout: ' . $_SESSION['used'] . ' <= ' . $tRef, 'session' );

	} else {

	    // log
		logWrite( 'sessione ancora attiva: ' . $_SESSION['used'] . ' > ' . $tRef, 'session' );

	}

    // intercetto eventuali tentativi di logout
	if( isset( $_REQUEST['__logout__'] ) ) {

	    $cf['auth']['status'] = LOGIN_LOGOUT;
/*
	    if( ini_get( 'session.use_cookies' ) ) {

		$params = session_get_cookie_params();

		setcookie( session_name(), '', time() - 42000,
		    $params['path'], $params['domain'],
		    $params['secure'], $params['httponly']
		);

	    }

	    session_destroy();

	    require DIR_SRC_CONFIG . '_055.session.php';
*/

        // svuoto selettivamente la $_SESSION
        foreach( $_SESSION as $k => $v ) {
            if( ! in_array( $k, array( 'id', 'used' ) ) ) {
                unset( $_SESSION[ $k ] );
            }
        }

	    // TODO lanciare questo header serve?
	    // header('HTTP/1.0 401 Unauthorized');

	}

    // debug
	// print_r( $cf['localization']['language'] );

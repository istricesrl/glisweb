<?php

    /**
     * questo file definisce gli account, gli utenti e i gruppi del framework
     *
     * il sistema di autenticazione del framework
     * ==========================================
     * Il framework supporta un potente e flessibile sistema di autenticazione
     * e autorizzazione basato su account e gruppi di account. Account e gruppi
     * sono impostati nel file _200.auth.php e personalizzati nel file 200.auth.php.
     * Le password sono archiviate in forma crittografata tramite md5() per
     * ragioni di sicurezza.
     *
     * Se avete a disposizione una shell Bash, generare una password e cifrarla in MD5 è
     * molto semplice:
     *
     * \code{.bash}
     * pwgen -nyc 16 1
     * echo -n "<password>" | md5sum
     * \endcode
     *
     *
     *
     *
     *
     * account
     * -------
     * Gli account rappresentano i soggetti riconosciuti dal framework e autorizzati a operare
     * su di esso a vari livelli.
     *
     *
     *
     *
     *
     *
     *
     * gruppi
     * ------
     *
     *
     *
     *
     *
     * utenti
     * ------
     *
     *
     *
     *
     *
     * il sistema di autorizzazione del framework
     * ==========================================
     *
     *
     *
     * permessi
     * --------
     *
     * [...] sostanzialmente quali azioni un utente o un gruppo possono compiere su un'entità in generale [...]
     *
     *
     * diritti
     * -------
     *
     * [...] sostanzialmente quali azioni un utente o un gruppo possono compiere su una istanza (o riga) specifica di un'entità [...]
     *
     * privilegi
     * ---------
     *
     * [...] azioni speciali e particolari, come ad esempio [...]
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // costanti che descrivono lo stato del login
    // TODO hanno senso tutte queste costanti?
	define( 'LOGIN_ERR_NO_DATA'		, 'NODATA' );
	define( 'LOGIN_ERR_NO_CONNECTION'	, 'NOCONNECTION' );
	define( 'LOGIN_ERR_NO_USER'		, 'NOUSER' );
	define( 'LOGIN_ERR_WRONG_PW'		, 'WRONGPW' );
	define( 'LOGIN_ERR_INACTIVE'		, 'USERDOWN' );
	define( 'LOGIN_SUCCESS'			, 'SUCCESS' );
	define( 'LOGIN_LOGGED'			, 'LOGGED' );
	define( 'LOGIN_LOGOUT'			, 'LOGOUT' );

    // chiave segreta per JWT
    // TODO abbiamo abbandonato per ora il progetto di implementare JWT
	// $cf['auth']['jwt']['secret']		= false;

    // gruppi di default della piattaforma
	$cf['auth']['groups'] = array(
	    'roots' => array(
		'id' => NULL,
		'nome' => 'roots',
		'privilegi' => array(
		    'EDIT_CONFIGURAZIONE',
            'GESTIONE_ACCOUNT',
            'INVIO_DIRETTO_MAIL'
		)
	    ),
	    'staff' => array(
		'id' => NULL,
		'nome' => 'staff'
	    ),
	    'users' => array(
		'id' => NULL,
		'nome' => 'users'
	    )
	);

    // TODO gli ID dei privilegi dovrebbero essere delle costanti

    // privilegi della piattaforma
	$cf['auth']['privileges'] = array(
	    'EDIT_CONFIGURAZIONE' => array(
            'id' => NULL,
            'nome' => 'editare la configurazione del framework'
        ),
	    'INVIO_ANAGRAFICA_ARCHIVIUM' => array(
            'id' => NULL,
            'nome' => 'inviare una anagrafica ad Archivium'
        ),
        'CANCELLAZIONE_RICORSIVA' => array(
            'id' => NULL,
            'nome' => 'cancellare ricorsivamente oggetti dal database'
        ),
        'INVIO_DIRETTO_MAIL' => array(
            'id' => NULL,
            'nome' => 'inviare mail da API REST'
        )
	);

    // account di default della piattaforma
    // TODO è corretto che nome cognome e denominazione stiano allo stesso livello di id ecc? non crea confusione?
    // TODO gli oggetti mappati da database dovrebbero somigliare il più possibile alla corrispettiva riga di database!
	$cf['auth']['accounts'] = array(
	    'root' => array(
		'id' => NULL,
#		'nome' => NULL,
#		'cognome' => NULL,
#		'denominazione' => NULL,
		'username' => 'root',
		'password' => NULL,
		'gruppi' => array(
		    'roots'
		),
		'permissions' => array(),
		'privilegi' => array(
		    'EDIT_CONFIGURAZIONE',
            'INVIO_ANAGRAFICA_ARCHIVIUM'
		)
	    )
	);
/*
    // password di root da variabile d'ambiente
	if( ! empty( $_ENV['ROOT_PW'] ) ) {
	    $cf['auth']['accounts']['root']['password'] = md5( getenv('ROOT_PW') );
	}
*/

    // scadenza della chiave JWT
    $cf['auth']['jwt']['salt'] = 'Y-m-d';

    // configurazione extra
	if( isset( $cx['auth'] ) ) {
	    $cf['auth'] = array_replace_recursive( $cf['auth'], $cx['auth'] );
	}

    // debug
	// print_r( $cf['auth'] );

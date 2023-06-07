<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
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

    // tabella gestita
	$ct['form']['table'] = 'anagrafica';

    // tendina tipologie anagrafica
	$ct['etc']['select']['tipologie_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_anagrafica_view ORDER BY nome ASC'
	);

	// tendina tipologie indirizzi
	$ct['etc']['select']['tipologie_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_indirizzi_view ORDER BY nome ASC'
	);

    // tendina comuni
	$ct['etc']['select']['comuni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM comuni_view'
	);

	// preset post inserimento rapido 
	$ct['etc']['preset']['table'] = 'anagrafica';
	$ct['etc']['preset']['subtable'] = 'anagrafica_indirizzi';
	$ct['etc']['preset']['counter'] = isset( $_REQUEST['anagrafica']['anagrafica_indirizzi'] ) ? count( $_REQUEST['anagrafica']['anagrafica_indirizzi'] ) : 0;
	$ct['etc']['preset']['field'] = 'id_indirizzo';

    // tendina sesso
	$ct['etc']['select']['sesso'] = array( 
	    array( 'id' => '-', '__label__' => '-' ),
	    array( 'id' => 'M', '__label__' => 'uomo' ),
	    array( 'id' => 'F', '__label__' => 'donna' ),
	);

    // tendina notifiche
	$ct['etc']['select']['se_notifiche'] = array(
	    array( 'id' => NULL, '__label__' => 'no' ),
	    array( 'id' => 1, '__label__' => 'si' )
	);

    // tendina PEC
	$ct['etc']['select']['se_pec'] = array(
	    array( 'id' => NULL, '__label__' => 'mail' ),
	    array( 'id' => 1, '__label__' => 'pec' )
	);

    // tendina categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // tendina tipologie telefoni
	$ct['etc']['select']['tipologie_telefoni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_telefoni_view'
	);

    // tendina tipologie URL
	$ct['etc']['select']['tipologie_url'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_url_view'
	);

	// tendina ruoli indirizzi
	$ct['etc']['select']['ruoli_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_indirizzi_view'
	);
	
/*
    // tendina comuni
	$ct['etc']['select']['comuni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM comuni_view'
	);
*/

    // tendina indirizzi
	$ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM indirizzi_view'
	);

/*





















    // tendina regime fiscale
	$ct['etc']['select']['id_regime_fiscale'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM regimi_view' );

    // tendina tipologia crm
	$ct['etc']['select']['id_ranking'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM ranking_view ORDER BY ordine ASC' );

    // tendina tipologia indirizzo
	$ct['etc']['select']['id_tipologia_indirizzo'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_indirizzi_view' );

    // tendina settori
	$ct['etc']['select']['id_settore'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM settori_view' );

    // tendina orientamenti sessuali
	$ct['etc']['select']['id_orientamento'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM orientamenti_sessuali_view' );

    // tendina stati
	$ct['etc']['select']['id_stato'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM stati_view' );

    // tendina diritti
	$ct['etc']['select']['id_diritto'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM categorie_diritto_view WHERE id_genitore IS NULL' );

    // tendina diritti
	$ct['etc']['select']['diritti'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM categorie_diritto_view' );

    // tendina agenti
	$ct['etc']['select']['id_agente'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM anagrafica_view_static WHERE se_commerciale = 1' );

    // tendina mandanti/fornitori
	$ct['etc']['select']['id_mandante_fornitore'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM anagrafica_view_static WHERE se_mandante = 1 OR se_fornitore = 1' );

    // tendina categorie prodotti
	$ct['etc']['select']['id_categoria_prodotti'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM categorie_prodotti_view' );

    // tendina tipologia attivita
	$ct['etc']['select']['id_tipologia_attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_attivita_view' );

    // tendina ruoli
	$ct['etc']['select']['id_ruolo_immagine'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM ruoli_immagini_view' );

    // tendina ruoli
	$ct['etc']['select']['id_ruolo_anagrafica'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM ruoli_anagrafica_view' );

    // verifico le categorie dell'anagrafica corrente
	if( empty( $_REQUEST['anagrafica']['se_collaboratore'] ) ) {
	    $ct['page']['etc']['tabs'] = array_diff( $ct['page']['etc']['tabs'], ['anagrafica_gestione_collaboratori'] );
	}
	if( empty( $_REQUEST['anagrafica']['se_cliente'] ) && empty( $_REQUEST['anagrafica']['se_lead'] ) && empty( $_REQUEST['anagrafica']['se_prospect'] ) ) {
	    $ct['page']['etc']['tabs'] = array_diff( $ct['page']['etc']['tabs'], ['anagrafica_gestione_clienti','anagrafica_gestione_offerte'] );
	}
	if( empty( $_REQUEST['anagrafica']['se_fornitore'] ) ) {
	    $ct['page']['etc']['tabs'] = array_diff( $ct['page']['etc']['tabs'], ['anagrafica_gestione_fornitori'] );
	}

    // verifico se il soggetto è un autore 
    // individuo l'id della categoria autore(la categoria è stat inserita il 22/07 per cui ci potrebbero essere dati custom per cui la categoria autori ha un id differente da quello del db __glisweb__)
    // TODO: addiungere il campo se autore per evitare tutto il ragionamento sottostante
	$id_autore = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id  FROM categorie_anagrafica WHERE nome =\'autore\' ' );

	if( isset( $_REQUEST['anagrafica']['id'] ) ){
	    $flag = false;

	    // se il soggetto è associato ad una categoria
	    if( isset($_REQUEST['anagrafica']['anagrafica_categorie']) && !empty($_REQUEST['anagrafica']['anagrafica_categorie']) ){
		foreach($_REQUEST['anagrafica']['anagrafica_categorie'] as $categoria ){
		    if( $categoria['id_categoria'] == $id_autore ){ $flag = true;  }
		}
	    }
	    if(!$flag){
	    $ct['page']['etc']['tabs'] = array_diff( $ct['page']['etc']['tabs'], ['anagrafica_gestione_contenuti'] );
	    }
	}

    // gli agenti possono solo inserire le attività
#	if( isset( $_REQUEST['anagrafica']['id'] ) && isset( $_SESSION['account']['se_commerciale'] ) && ! empty( $_SESSION['account']['se_commerciale'] ) ) {
	if( isset( $_REQUEST['anagrafica']['id'] ) ) {
	    $ct['etc']['attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita_view_static WHERE id_cliente = ? ORDER BY data DESC', array( array( 's' => $_REQUEST['anagrafica']['id'] ) ) );
#	    $_REQUEST['anagrafica']['attivita'] = array();
	}

    // tendina PEC SDI
	if( isset( $_REQUEST['anagrafica']['id'] ) ) {
	    $ct['etc']['select']['id_pec_sdi'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ? AND se_pec = 1', array( array( 's' => $_REQUEST['anagrafica']['id'] ) ) );
	}
*/
/*
	$ct['page']['contents']['metro'][NULL][] = array(
		'modal' => array( 'id' => 'modal-inserimento-indirizzi', 'include' => 'inc/anagrafica.form.modal.aggiungi.indirizzo.html' )
	);
*/
    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

	require DIR_SRC_INC_MACRO . '_default.tools.php';

	// debug
	// print_r( $_REQUEST );

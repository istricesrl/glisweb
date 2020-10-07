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
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_anagrafica_view ORDER BY nome ASC'
	);

    // tendina sesso
	$ct['etc']['select']['sesso'] = array( 
	    array( 'id' => '-', '__label__' => '-' ),
	    array( 'id' => 'M', '__label__' => 'M' ),
	    array( 'id' => 'F', '__label__' => 'F' ),
	);

    // tendina notifiche
	$ct['etc']['select']['se_notifiche'] = array(
	    array( 'id' => NULL, '__label__' => '&#xf1f6;' ),
	    array( 'id' => 1, '__label__' => '&#xf0f3;' )
	);

    // tendina PEC
	$ct['etc']['select']['se_pec'] = array(
	    array( 'id' => NULL, '__label__' => '&#xf003; mail' ),
	    array( 'id' => 1, '__label__' => '&#xf0a3; PEC' )
	);

    // tendina categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // tendina tipologie telefoni
	$ct['etc']['select']['tipologie_telefoni'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_telefoni_view'
	);

    // tendina tipologie indirizzi
	$ct['etc']['select']['tipologie_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_indirizzi_view'
	);

    // tendina comuni
	$ct['etc']['select']['comuni'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM comuni_view'
	);





/*



















    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mese'][] = array( 'id' => $mese, '__label__' => int2month( $mese ) );
	}

    // tendina giorni
	foreach( range( 1, 31 ) as $giorno ) {
	    $ct['etc']['select']['giorno'][] = array( 'id' => $giorno.'', '__label__' =>  $giorno  );
	}

    // tendina regime fiscale
	$ct['etc']['select']['id_regime_fiscale'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM regimi_fiscali_view' );

    // tendina tipologia crm
	$ct['etc']['select']['id_tipologia_crm'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_crm_view ORDER BY ordine ASC' );

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
	$ct['etc']['select']['id_agente'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM anagrafica_view WHERE se_agente = 1' );

    // tendina mandanti/fornitori
	$ct['etc']['select']['id_mandante_fornitore'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM anagrafica_view WHERE se_mandante = 1 OR se_fornitore = 1' );

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
#	if( isset( $_REQUEST['anagrafica']['id'] ) && isset( $_SESSION['account']['se_agente'] ) && ! empty( $_SESSION['account']['se_agente'] ) ) {
	if( isset( $_REQUEST['anagrafica']['id'] ) ) {
	    $ct['etc']['attivita'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita_view WHERE id_cliente = ? ORDER BY data DESC', array( array( 's' => $_REQUEST['anagrafica']['id'] ) ) );
#	    $_REQUEST['anagrafica']['attivita'] = array();
	}

    // tendina PEC SDI
	if( isset( $_REQUEST['anagrafica']['id'] ) ) {
	    $ct['etc']['select']['id_pec_sdi'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ? AND se_pec = 1', array( array( 's' => $_REQUEST['anagrafica']['id'] ) ) );
	}
*/

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>

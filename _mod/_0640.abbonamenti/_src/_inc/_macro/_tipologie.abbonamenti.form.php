<?php

    /**
     * macro form categorie risorse
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'tipologie_contratti';

    // TODO il controllo per evitare la ricorsione andrebbe fatto su tutto il percorso non solo sull'ID
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
        $ct['etc']['select']['genitori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_contratti_view  WHERE id <> ? AND se_abbonamento IS NOT NULL',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );
    } else {
        $ct['etc']['select']['genitori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_abbonamento IS NOT NULL'
        );
    }

    // tendina categorie progetti
	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

    // tendina progetti
	$ct['etc']['select']['corsi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view '
    );

    // metadato di default per la durata in mesi dell'abbonamento
    $ct['etc']['sub']['durata_mesi'] = array(
        'idx' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) ? count( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) : 0 ),
        'nome' => 'durata_mesi'
    );

    // ricerca metadato per la durata in mesi dell'abbonamento
    if( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) {
        foreach( $_REQUEST[ $ct['form']['table'] ]['metadati'] as $k => $m ) {
            if( $m['nome'] == 'durata_mesi' ) {
                $ct['etc']['sub']['durata_mesi'] = $m;
                $ct['etc']['sub']['durata_mesi']['idx'] = $k;
            }
        }
    }

    // metadato di default per il numero di accessi dell'abbonamento
    $ct['etc']['sub']['numero_accessi'] = array(
        'idx' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) ? count( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) : 1 ),
        'nome' => 'numero_accessi'
    );

    // ricerca metadato per il numero di accessi dell'abbonamento
    if( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) {
        foreach( $_REQUEST[ $ct['form']['table'] ]['metadati'] as $k => $m ) {
            if( $m['nome'] == 'numero_accessi' ) {
                $ct['etc']['sub']['numero_accessi'] = $m;
                $ct['etc']['sub']['numero_accessi']['idx'] = $k;
            }
        }
    }

    // metadato di default per il numero di lezioni dell'abbonamento
    $ct['etc']['sub']['numero_lezioni'] = array(
        'idx' => ( ( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) ? count( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) : 2 ),
        'nome' => 'numero_lezioni'
    );

    // ricerca metadato per il numero di accessi dell'abbonamento
    if( isset( $_REQUEST[ $ct['form']['table'] ]['metadati'] ) ) {
        foreach( $_REQUEST[ $ct['form']['table'] ]['metadati'] as $k => $m ) {
            if( $m['nome'] == 'numero_lezioni' ) {
                $ct['etc']['sub']['numero_lezioni'] = $m;
                $ct['etc']['sub']['numero_lezioni']['idx'] = $k;
            }
        }
    }

    // debug
    // print_r( $ct['etc']['sub'] );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

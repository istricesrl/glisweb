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
	$ct['form']['table'] = 'controlli';


    // tabella della vista
	$ct['view']['table'] = 'risposte';

	$ct['view']['cols'] = array(
        'id' => '#',
		'domanda' => 'domanda',
        'id_tipologia_questionari_domande' => 'id tipologia',	
        'tipologia_questionari_domande' => 'tipologia',	
		'risposta' => 'risposta'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'domanda' => 'text-left',
        'id_tipologia_questionari_domande' => 'd-none',
        'tipologia_questionari_domande' => 'text-left',
        'tipologia' => 'text-left',
		'risposta' => 'text-left',
    );

    // set filtro per id_controllo
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
		$ct['view']['__restrict__']['id_controllo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
	}

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
            // sì/no
			if( $row['id_tipologia_questionari_domande'] == 1 ){ 
                if( $row['risposta'] == 1 ){ $row['risposta'] = 'sì'; }
                else{ $row['risposta'] = 'no'; }
            }
            // opzioni
			elseif( $row['id_tipologia_questionari_domande'] == 4 ) {
                $row['risposta'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT nome FROM opzioni WHERE id = ?',
                    array( array( 's' => $row['risposta'] ) )
                );
			}
        }
    }



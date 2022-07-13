<?php

    /**
     *
     *
     * @file
     *
     */

     // tabella gestita
    $ct['form']['table'] = 'righe_cartellini';

    // tipologia inps per le ore ordinarie
	$idT_inps_ordinario = mysqlSelectValue( 
		$cf['mysql']['connection'], 
		'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
		array( array( 's' => '01') )
	);

	// tipologia inps per le ore straordinarie
	$idT_inps_straordinario = mysqlSelectValue( 
		$cf['mysql']['connection'], 
		'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
		array( array( 's' => 'LS') )
	);

	// tipologia inps per le ore lavorate nei giorni festivi
	$idT_inps_festivo = mysqlSelectValue( 
		$cf['mysql']['connection'], 
		'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
		array( array( 's' => 'LF1') )
	);  

    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] )  && !empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia_inps'] ) ){
        $car = $_REQUEST[ $ct['form']['table'] ];

        $params[] = array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] );

        if( $_REQUEST[ $ct['form']['table'] ]['id_tipologia_inps'] == $idT_inps_ordinario || $_REQUEST[ $ct['form']['table'] ]['id_tipologia_inps'] == $idT_inps_straordinario || $_REQUEST[ $ct['form']['table'] ]['id_tipologia_inps'] == $idT_inps_festivo ){
            $params[] = array( 's' => $idT_inps_ordinario );
        }
        else{
            $params[] = array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_tipologia_inps'] );
        }

        // elenco delle attività legate alla riga di cartellino corrente
        $attivita = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT a.id, a.data_attivita, a.ora_inizio, a.ora_fine, a.ore, a.nome, p.nome as progetto, '
            .'coalesce(
                anagrafica.soprannome,
                anagrafica.denominazione,
                concat_ws(" ", coalesce(anagrafica.nome, ""),
                coalesce(anagrafica.cognome, "") ),
                ""
            ) AS anagrafica, t.nome as tipologia, ti.__label__ as tipologia_inps '
            .'FROM attivita as a '
            .'LEFT JOIN anagrafica ON a.id_anagrafica = anagrafica.id '
            .'LEFT JOIN progetti as p ON a.id_progetto = p.id '
            .'LEFT JOIN tipologie_attivita as t ON a.id_tipologia = t.id '
            .'LEFT JOIN tipologie_attivita_inps_view as ti ON a.id_tipologia_inps = ti.id '
            .'INNER JOIN righe_cartellini as r ON a.data_attivita = r.data_attivita AND a.id_anagrafica = r.id_anagrafica '
            .'WHERE r.id = ? and a.id_tipologia_inps = ?',
            $params
        );

    

        if( !empty( $attivita ) ){
            foreach( $attivita as $a ){
                $ct['etc']['attivita'][$a['id']] = $a;                
            }
        }

    }
    

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    
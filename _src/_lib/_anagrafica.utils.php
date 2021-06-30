<?php

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function anagraficaGetLogo( $id ) {

	// config globale
	    global $cf;

	// debug
	    // die( 'id -> ' . $id );

	// prelevo la riga
	    $r = mysqlSelectValue(
		$cf['mysql']['connection'],
		'SELECT path FROM immagini '.
		'INNER JOIN anagrafica ON immagini.id_anagrafica = anagrafica.id '.
		'WHERE immagini.id_ruolo = 18 '.
		'AND anagrafica.id = ? '.
		'LIMIT 1',
		array(
		    array( 's' => $id )
		)
	    );

	// full path
	    fullPath( $r );

	// debug
	    // die( 'risultato -> ' . $r );

	// valore di ritorno
	    return $r;

    }


    /**
     *
     * @todo documentare
     *
     */
    function anagraficaGetSedeLegale( $id ) {

	// config globale
	    global $cf;

	// debug
	    // die( 'id -> ' . $id );

	// prelevo la riga
	    $r = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT * FROM indirizzi_view '.
		'INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi_view.id '.
		'INNER JOIN tipologie_indirizzi ON tipologie_indirizzi.id = anagrafica_indirizzi.id_tipologia '.
		'WHERE tipologie_indirizzi.se_sede = 1 '.
		'AND anagrafica_indirizzi.id_anagrafica = ? '.
		'LIMIT 1',
		array(
		    array( 's' => $id )
		)
	    );


	// riassemblaggio dell'indirizzo per linee (ad es. per le buste)
	if( empty($r['indirizzo']) || empty($r['civico']) || empty($r['cap']) || empty($r['comune']) || empty($r['sigla']) ){
	    $r['linee'][0]='              ';
	    $r['linee'][1]='              ';
	}
	else{$r['linee'][0] = $r['indirizzo'] . ' ' . $r['civico'];
	    $r['linee'][1] = $r['cap'] . ' ' . $r['comune'] . ' ' . $r['sigla'];
}
	// debug
	    //die( 'risultato -> ' . print_r( $r, true ) );

	// valore di ritorno
	    return $r;

}

    /**
     *
     * @todo documentare
     *
     */
    function anagraficaGetPEC( $id ) {

	// config globale
	    global $cf;

	// debug
	    // die( 'id -> ' . $id );

	// prelevo la riga
	    $r = mysqlSelectValue(
		$cf['mysql']['connection'],
		'SELECT indirizzo FROM mail '.
		'INNER JOIN anagrafica ON mail.id_anagrafica = anagrafica.id '.
		'WHERE mail.se_pec = 1 '.
		'AND anagrafica.id = ? '.
		'LIMIT 1',
		array(
		    array( 's' => $id )
		)
	    );

	// debug
	    // die( 'risultato -> ' . $r );

	// valore di ritorno
	    return $r;

    }
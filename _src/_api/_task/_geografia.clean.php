<?php

    /**
     * elimina la geografia che nessuno usa
     *
     * Toglie i comuni che nessuna riga del database cita, poi le provincie, poi le regioni. Un luogo e' "usato" se lo
     * cita una qualunque colonna con chiave esterna verso la sua tabella ( information_schema.KEY_COLUMN_USAGE, come il
     * rimappaggio di `_geografia.importazione.php` ), piu' `anagrafica_indirizzi.id_comune`, che la chiave esterna non
     * ce l'ha, piu' la gerarchia ( `comuni.id_provincia`, `provincie.id_regione` ) anche dove la chiave manca.
     *
     * Contano anche i luoghi di nascita e i dati di destinatario e intestatario: le chiavi esterne verso la geografia
     * sono ON DELETE SET NULL, quindi cancellare un comune citato non da' errore, svuota il campo in silenzio.
     *
     * NOTA fino al 25/11/2026 guardava solo `indirizzi.id_comune`: dal 10/07/2026 la fonte degli indirizzi e'
     * `anagrafica_indirizzi`, e su utensilerialughese il task avrebbe cancellato 18.905 comuni su 20.130.
     *
     * E' distruttivo: un'importazione successiva deve rimettere quello che ha tolto. Operazione manuale.
     *
     * Uso:
     *   /task/geografia.clean                 cancella
     *   /task/geografia.clean?dryrun=1        anteprima, conta e non cancella
     *
     * @file
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
	$status = array();

    // se si cancella davvero
    $dryrun = ( ! empty( $_REQUEST['dryrun'] ) );

    // tabelle da pulire, nell'ordine, con la colonna gerarchica di quella sotto che le cita
    $geografia = array(
        'comuni' => array(),
        'provincie' => array( array( 'tabella' => 'comuni', 'colonna' => 'id_provincia' ) ),
        'regioni' => array( array( 'tabella' => 'provincie', 'colonna' => 'id_regione' ) )
    );

    // NOTA anagrafica_indirizzi.id_comune non ha la chiave esterna, quindi information_schema non la elenca
    if( mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT count( * ) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = database() AND TABLE_NAME = "anagrafica_indirizzi" AND COLUMN_NAME = "id_comune"'
    ) ) {
        $geografia['comuni'][] = array( 'tabella' => 'anagrafica_indirizzi', 'colonna' => 'id_comune' );
    }

    foreach( $geografia as $luogo => $riferimenti ) {

        // colonne che puntano alla tabella, escluse le viste statiche, che si rigenerano, e le tabelle di servizio
        $colonne = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT TABLE_NAME AS tabella, COLUMN_NAME AS colonna
            FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = database()
            AND REFERENCED_TABLE_NAME = "' . $luogo . '"
            AND TABLE_NAME NOT LIKE "%\\_view\\_static" AND TABLE_NAME NOT LIKE "\\_\\_%"'
        );

        // elenco senza doppioni
        $citazioni = array();
        foreach( array_merge( $riferimenti, (array) $colonne ) as $rif ) {
            $citazioni[ $rif['tabella'] . '.' . $rif['colonna'] ] = $rif;
        }

        $status['riferimenti'][ $luogo ] = array_keys( $citazioni );

        // NOTA la tabella derivata serve per le autocitazioni ( comuni.id_successore ): MySQL non lascia leggere
        // nella subquery la tabella da cui si cancella, se non attraverso una tabella materializzata
        $condizioni = array();
        foreach( $citazioni as $rif ) {
            $condizioni[] = 'g.id NOT IN ( SELECT r.id FROM ( SELECT DISTINCT ' . $rif['colonna'] . ' AS id FROM ' . $rif['tabella']
                . ' WHERE ' . $rif['colonna'] . ' IS NOT NULL ) AS r )';
        }

        $where = ( ( empty( $condizioni ) ) ? '' : ' WHERE ' . implode( ' AND ', $condizioni ) );

        if( $dryrun ) {
            $status['da cancellare'][ $luogo ] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT count( * ) FROM ' . $luogo . ' AS g' . $where
            );
            $status['esempi'][ $luogo ] = array_column( (array) mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT g.id FROM ' . $luogo . ' AS g' . $where . ' ORDER BY g.id LIMIT 5'
            ), 'id' );
        } else {
            $status['cancellati'][ $luogo ] = mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE g FROM ' . $luogo . ' AS g' . $where
            );
        }

    }

    // NOTA in anteprima provincie e regioni contano solo quelle gia' scoperte: cancellando i comuni se ne libererebbero altre

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

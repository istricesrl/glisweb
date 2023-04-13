<?php

    function generaInfoNumeroDocumento( $idTipologia, $sezionale, $idEmittente ) {

        global $cf;

        // seleziono l'ultimo progressivo utilizzato
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT documenti.id, documenti.sezionale, coalesce( cast( numero as unsigned ), 0 ) AS numero, numerazione FROM documenti '.
            'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
            'WHERE id_emittente = ? AND sezionale = ? '.
            'AND tipologie_documenti.numerazione = ( SELECT numerazione FROM tipologie_documenti AS t1 WHERE t1.id = ? ) '.
            'ORDER BY coalesce( cast( numero as unsigned ), 0 ) DESC LIMIT 1',
            array(
                array( 's' => $idEmittente ),
                array( 's' => $sezionale ),
                array( 's' => $idTipologia )
            )
        );

        if( ! isset( $status['current']['numero'] ) ) {
            $status['current']['numero'] = 0;
        }
    
        return $status['current'];

    }

    function generaProssimoNumeroDocumento( $idTipologia, $sezionale, $idEmittente ) {

        $row = generaInfoNumeroDocumento( $idTipologia, $sezionale, $idEmittente );

        return $row['numero'] + 1;

    }

    function trovaIdRepartoDaIdIva( $idIva ) {

        global $cf;

        return mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT reparti.id FROM reparti WHERE id_iva = ? LIMIT 1',
            array( array( 's' => $idIva ) )
        );

    }

    function generaInfoProgressivoInvio( $idAzienda ) {

        global $cf;

        // seleziono l'ultimo progressivo utilizzato
        $status['current'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT coalesce( max( progressivo_invio ), 0 ) FROM documenti WHERE id_emittente = ?',
#            'SELECT coalesce( max( progressivo_invio ), 0 ) FROM documenti WHERE id_emittente IN ( SELECT id FROM anagrafica WHERE codice_fiscale = ( SELECT codice_fiscale FROM anagrafica AS a1 WHERE a1.id = ? ) )',
            array(
                array( 's' => $idAzienda )
            )
        );

        return $status['current'];

    }

    function generaNumeroProgressivoInvio( $idAzienda ) {

        $status['current'] = generaInfoProgressivoInvio( $idAzienda );

        $status['new'] = base_convert( $status['current'], 36, 10 );
        $status['new']++;
        $status['new'] = base_convert( $status['new'], 10, 36 );

        $status['new'] = strtoupper( str_pad( $status['new'], 5, '0', STR_PAD_LEFT ) );

        return $status['new'];

    }

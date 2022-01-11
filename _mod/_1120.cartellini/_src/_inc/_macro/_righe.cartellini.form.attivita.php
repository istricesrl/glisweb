<?php

    /**
     *
     *
     * @file
     *
     */

     // tabella gestita
    $ct['form']['table'] = 'righe_cartellini';

    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $car = $_REQUEST[ $ct['form']['table'] ];

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
            .'WHERE r.id = ? and r.id_tipologia_inps = ?',
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_tipologia_inps'] )
            )
        );

        if( !empty( $attivita ) ){

            // ricavo l'id del contratto attivo alla data indicata
            $contratto = $car['id_contratto'];

            if( !empty(  $contratto ) ){
                // verifico se c'è un turno specificato nella tabella turni
                $turno = mysqlSelectValue(
                    $cf['mysql']['connection'], 
                    'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
                    array( 
                        array( 's' => $contratto ),
                        array( 's' => $car['data_attivita'] ),
                        array( 's' => $car['data_attivita'] )
                    )
                );

                // se non ci sono turni, di base è attivo il turno 1
                if( empty( $turno ) ){
                    $turno = 1;
                }

                $fasce = mysqlSelectRow(
                    $cf['mysql']['connection'],  
                    'SELECT * FROM fasce_orarie_contratti WHERE id_contratto = ? AND turno = ? AND id_giorno = ? LIMIT 1',
                    array(
                        array( 's' => $contratto ),
                        array( 's' => $turno ),
                        array( 's' => ( date( 'w', strtotime($car['data_attivita']) ) == 0 ) ? '7' : date( 'w', strtotime($car['data_attivita']) ) )
                    )
                );

                if( empty( $fasce ) ){
                    $fasce['ora_inizio'] = '06:00:00';
                    $fasce['ora_fine'] = '22:00:00';
                }

            } else {
                $fasce['ora_inizio'] = '00:00:01';
                $fasce['ora_fine'] = '23:59:59';
            }

            foreach( $attivita as $a ){
                $ct['etc']['attivita'][$a['id']] = $a;

                $ct['etc']['attivita'][$a['id']]['ore_ordinarie'] = mysqlSelectValue( 
                    $cf['mysql']['connection'], 
                    'SELECT sum( TIMEDIFF( LEAST( ?, ora_fine ),GREATEST( ora_inizio, ? )  ) ) AS tot_ore FROM attivita ' .
                    'WHERE attivita.id = ?',
                    array(
                        array( 's' => $fasce['ora_fine'] ),
                        array( 's' => $fasce['ora_inizio'] ),
                        array( 's' => $a['id'] )
                    )			
                ) / 10000 ;
        
                $ct['etc']['attivita'][$a['id']]['ore_straordinarie'] = mysqlSelectValue( 
                    $cf['mysql']['connection'], 
                    'SELECT ( sum( TIMEDIFF( ?, LEAST( ora_inizio, ? )  ) ) + sum( TIMEDIFF(  GREATEST( ora_fine, ? ), ?  )  )  ) as tot_ore FROM attivita ' .
                    'WHERE attivita.id = ?',
                    array(
                        array( 's' => $fasce['ora_inizio'] ),
                        array( 's' => $fasce['ora_inizio'] ),
                        array( 's' => $fasce['ora_fine'] ),
                        array( 's' => $fasce['ora_fine'] ),
                        array( 's' => $a['id'] )
                    )			
                ) / 10000 ;               
                
            }
        }

    }
    

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    
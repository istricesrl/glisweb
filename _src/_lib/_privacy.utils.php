<?php

    /**
     * 
     * 
     * TODO documentare
     * 
     */

    // debug
    // dieText( print_r( $_REQUEST, true ) );

    /**
     * TODO documentare
     * 
     */
    function associazioneConsensiContatto( $v ) {

        global $cf;

        if( isset( $v['__id_contatto__'] ) && isset( $v['__privacy__'] ) && is_array( $v['__privacy__'] ) ) {

            foreach( $v['__privacy__'] as $codiceConsenso => $valoreConsenso ) {

                if( $valoreConsenso == true ) {

                    $idConsenso = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM consensi WHERE codice = ?',
                        array(
                            array( 's' => $codiceConsenso ),
                        )
                    );

                    if( ! empty( $idConsenso ) ) {

                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'modulo' => $v['__modulo__'],
                                'id_contatto' => $v['__id_contatto__'],
                                'id_consenso' => $idConsenso,
                                'valore' => $valoreConsenso,
                                'timestamp_inserimento' => time(),
                            ),
                            'consensi_contatti'
                        );

                        if( ! empty( $v['__id_anagrafica__'] ) ) {

                            mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'modulo' => $v['__modulo__'],
                                    'id_anagrafica' => $v['__id_anagrafica__'],
                                    'id_consenso' => $idConsenso,
                                    'valore' => $valoreConsenso,
                                    'timestamp_inserimento' => time(),
                                ),
                                'consensi_anagrafica'
                            );

                        }

                    }

                }

            }

        }

    }

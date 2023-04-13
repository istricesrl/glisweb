<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'documenti';

    // percorsi
	$base = '/task/0400.documenti/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'amministrazione' => array(
		'label' => 'operazioni amministrative'
	    )
	);

        // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';

    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ) {

        // aggiorna data e ora
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . 'chiusura.documento?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-check-square-o',
            'title' => 'chiudi documento',
            'text' => 'chiudi con data e ora attuale il documento'
        );

        // aggrega righe
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . 'documenti.aggrega.righe?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-compress',
            'title' => 'aggrega righe',
            'text' => 'aggrega a questo documento le righe non associate'
        );

        // elimina documento
        if( in_array( 'CANCELLAZIONE_RICORSIVA', array_keys( $_SESSION['account']['privilegi'] ) ) ) {
            $ct['page']['contents']['metro']['amministrazione'][] = array(
                'host' => $ct['site']['url'],
                'ws' => $base . 'documenti.delete?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
                'confirm' => true,
                'callback' => 'function(){window.open(\''.$ct['page']['parent']['path'][ LINGUA_CORRENTE ].'\',\'_self\');}',
                'icon' => NULL,
                'fa' => 'fa-trash',
                'title' => 'elimina documento',
                'text' => 'elimina questo documento e tutte le righe associate'
            );
        }

    } else {

        // azioni possibili per proforma chiusa 
        if( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] == 5 ) {

            // creo la fattura dalla proforma
            $id_documento = mysqlSelectValue( 
                $cf['mysql']['connection'], 
                'SELECT id_documento_collegato FROM relazioni_documenti '.
                'LEFT JOIN documenti ON documenti.id = relazioni_documenti.id_documento_collegato '.
                'WHERE relazioni_documenti.id_documento = ? AND documenti.id_tipologia = 1',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
            );
    
            // creazione fattura da proforma
            if( ! empty( $id_documento ) ) {
            
                $ct['page']['contents']['metro']['amministrazione'][] = array(
                    'url' => $cf['contents']['pages']['documenti.form']['url'][ $cf['localization']['language']['ietf'] ].'?documenti[id]='.$id_documento.'&__backurl__='.$ct['page']['backurl'][ LINGUA_CORRENTE ],
                    'icon' => NULL,
                    'fa' => 'fa-external-link',
                    'title' => 'apri la fattura #'.$id_documento,
                    'text' => 'apri la fattura corrispondente a questa proforma'
                );
    
            } else {
    
                $ct['page']['contents']['metro']['amministrazione'][] = array(
                    'host' => $ct['site']['url'],
                    'ws' => $base . 'fattura.da.proforma?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'callback' => 'function(){location.reload();}',
                    'icon' => NULL,
                    'fa' => 'fa-eur',
                    'title' => 'crea fattura',
                    'text' => 'crea la fattura corrispondente a questa proforma'
                );

            }
    
        }

        // azioni possibili per fattura chiusa 
        if( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] == 1 ) {

            if( empty( $_REQUEST[ $ct['form']['table'] ]['codice_archivium'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['progressivo_invio'] ) ) {

                // invio a SDI
                $ct['page']['contents']['metro']['amministrazione'][] = array(
                    'host' => $ct['site']['url'],
                    'ws' => $base . '_fattura.invia.sdi.php?idFattura='.$_REQUEST[ $ct['form']['table'] ]['id'],
                    'callback' => 'function(){location.reload();}',
                    'icon' => NULL,
                    'fa' => 'fa-check-square-o',
                    'title' => 'invia fattura elettronica',
                    'text' => 'invia tramite archivum la fattura'
                );

            }
            
        }

    }

<?php

    /**
     * svuota il cestino dei file
     *
     * trashFile() di `_src/_lib/_filesystem.tools.php` non cancella i file: li sposta in `tmp/.garbage/AAAAMMGG/`, con il
     * loro percorso relativo, così un file tolto per sbaglio si recupera. Questo task cancella con emptyTrash() le cartelle
     * del giorno piu' vecchie di `$cf['common']['garbage']['giorni']` ( default 30, runlevel 030, si cambia da
     * `src/config.json` con la chiave `common.garbage.giorni` ).
     *
     * ⚠ VA PIANIFICATO, una volta al giorno basta: finche' non gira il cestino cresce e basta, e ci finiscono anche dati
     * che a termine vanno tolti davvero, come i certificati medici di `_mod/_6700.certificazioni`.
     *
     * I giorni non si passano dalla richiesta, a differenza di `_log.task.clean.php`: una chiamata con un termine piu'
     * corto svuoterebbe il cestino prima di quello promesso. Decide dal nome della cartella, non dalla data dei file.
     *
     * Uso:
     *   /task/garbage.clean                 il giro normale
     *   /task/garbage.clean?dryrun=1        anteprima, non cancella
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

    // quanto si tiene, e se si cancella davvero
    $giorni = ( ! empty( $cf['common']['garbage']['giorni'] ) ) ? intval( $cf['common']['garbage']['giorni'] ) : 30;
    $dryrun = ( ! empty( $_REQUEST['dryrun'] ) );

    // svuoto il cestino
    $cartelle = emptyTrash( $giorni, DIR_TMP_GARBAGE, $dryrun );

    $status['info'][] = ( ( $dryrun ) ? 'da cancellare' : 'cancellate' ) . ': ' . count( $cartelle )
        . ' cartelle del cestino oltre i ' . $giorni . ' giorni';

    $status['cartelle'] = array_map( 'getShortPath', $cartelle );

    // si scrive nel log solo quando c'e' stato qualcosa da fare, come in _log.task.clean.php
    if( count( $cartelle ) > 0 && ! $dryrun ) {
        logWrite( 'svuotate ' . count( $cartelle ) . ' cartelle del cestino oltre i ' . $giorni . ' giorni', 'filesystem' );
    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

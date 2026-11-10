<?php

    /**
     * file di esempio per la funzione ftpPutFile() in SFTP, con # e ? nei nomi
     *
     * il wrapper ssh2.sftp:// legge il percorso come un URL, e un # o un ? ne troncherebbero il resto: il file si carica,
     * si elenca e si riscarica uguale, e non restano i collegamenti di ftpSftpUrl()
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // percorso
    $f = 'tmp/example/' . microtime( true ) . '.txt';

    // contenuto
    $t = 'contenuto ' . time();
    writeToFile( $t, $f );

    // connessione al server SFTP ( durante i test e' quello di prova, test.sftp )
    $conn = ftpConnect( $cf['ftp']['servers']['test.sftp'] );

    // cartella e file con # e ?
    $dir = 'example/#cartella ' . time() . '?/';
    $nome = '#21OTT-S1?R2 ' . time() . '.txt';

    // caricamento
    echo 'caricato: ';
    var_dump( ftpPutFile( $conn, $f, $dir . $nome ) );

    // elenco della cartella
    echo 'elencato: ';
    var_dump( in_array( rtrim( $dir, '/' ) . '/' . $nome, ftpListFiles( $conn, $dir ) ) );

    // riscaricamento
    echo 'riscaricato uguale: ';
    $g = $f . '.indietro';
    ftpGetFile( $conn, $dir . $nome, $g );
    var_dump( trim( file_get_contents( getFullPath( $g ) ) ) === $t );

    // collegamenti rimasti, nella cartella che li ospita ( example/ ) e in quella di login
    echo 'collegamenti rimasti: ';
    var_dump( count( preg_grep( '/^\.glisweb\./', array_map( 'basename', array_merge( ftpListFiles( $conn, 'example/' ), ftpListFiles( $conn, $conn['home'] ) ) ) ) ) );

    // chiusura della connessione
    ftpClose( $conn );

<?php

// endpoint di tracciamento delle e-mail scartate dalla validazione Emailable.
// chiamato in POST (JSON) da _src/_twig/_inc/_emailable.close.twig quando una mail
// risulta 'undeliverable'. fire-and-forget: risponde sempre OK.
// ogni scarto viene accodato come riga JSON (JSONL) in var/spool/emailable/scarti/YYYYMM.jsonl

if( ! defined( 'INCLUDE_SUBDIR' ) ) {
    require '../_config.php';
} else {
    require INCLUDE_SUBDIR . '_config.php';
}

$data   = json_decode( file_get_contents( 'php://input' ), true );
$result = array( 'status' => 'OK' );

if( is_array( $data ) && isset( $data['email'] ) ) {

    // sanitizzazione: rimuove caratteri di controllo e taglia a 255 per campo
    $clean = function( $v ) {
        return trim( str_replace( array( "\r", "\n", "\t" ), ' ', substr( (string) $v, 0, 255 ) ) );
    };

    $record = array(
        'ts'           => date( 'Y-m-d H:i:s' ),
        'email'        => $clean( $data['email'] ),
        'stato'        => isset( $data['stato'] )        ? $clean( $data['stato'] )        : '',
        'motivo'       => isset( $data['motivo'] )       ? $clean( $data['motivo'] )       : '',
        'score'        => isset( $data['score'] )        ? $clean( $data['score'] )        : '',
        'suggerimento' => isset( $data['suggerimento'] ) ? $clean( $data['suggerimento'] ) : '',
        'form'         => isset( $data['form'] )         ? $clean( $data['form'] )         : '',
        'pagina'       => isset( $data['pagina'] )       ? $clean( $data['pagina'] )       : '',
        'ip'           => isset( $_SERVER['REMOTE_ADDR'] )     ? $_SERVER['REMOTE_ADDR'] : '',
        'ua'           => isset( $_SERVER['HTTP_USER_AGENT'] ) ? $clean( $_SERVER['HTTP_USER_AGENT'] ) : '',
    );

    // directory di spool dedicata (creata ricorsivamente se assente)
    $dir = DIR_VAR_SPOOL . 'emailable/scarti/';
    checkPath( $dir );

    // accodamento atomico di una riga JSON nel file mensile
    file_put_contents(
        $dir . date( 'Ym' ) . '.jsonl',
        json_encode( $record ) . PHP_EOL,
        FILE_APPEND | LOCK_EX
    );

} else {
    $result['status'] = 'KO';
}

buildJson( $result );

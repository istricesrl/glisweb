<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // costanti
	define( 'REPORT_WIDTH'			, 80 );

    /**
     *
     * @todo documentare
     *
     */
    function txtHeader( $t, $c = '=', $w = REPORT_WIDTH ) {

	$t = strtoupper( $t );

	$t .= PHP_EOL . txtDateTimeLine( $c );

	return $t;

    }

    function txtDateTime( $f = 'Y-m-d H:i:s', $d = NULL ) {

	return ( $d === NULL ) ? date( $f ) : date( $f, $d );

    }

    function txtLine( $c = '-', $w = REPORT_WIDTH ) {

	return str_repeat( $c, $w );

    }

    function txtFullLine( $c = '-', $w = REPORT_WIDTH ) {

	return txtLine( $c, $w ) . PHP_EOL;

    }

    function txtDateTimeLine( $c = '-', $d = NULL, $w = REPORT_WIDTH ) {

	$ts = '[ ' . txtDateTime() . ' ]';

	$w -= strlen( $ts );

	return txtLine( $c, $w ) . $ts . PHP_EOL;

    }

    function txtData( $l, $d, $c = ' ', $w = REPORT_WIDTH ) {

	$l .= ' ';
	$d = ' ' . $d;
	$m = $w - ( strlen( $d ) );

	if( strlen( $l ) > $m ) {
	    $l = riduciStringa( $l, $m );
	}

	$w -= strlen( $l ) + strlen( $d );

	return $l . txtLine( $c, $w ) . $d . PHP_EOL;

    }

    function txtTable( $h, $d, $l = NULL, $c = NULL, $s = NULL, $w = REPORT_WIDTH ) {

	$t = NULL;

	if( empty( $l ) ) { $l = array_keys( $h ); }

	array_unshift( $d, array_combine( array_keys( $h ), $l ) );

	foreach( $d as $n => $r ) {
	    foreach( $h as $k => $v ) {
		if( substr( $k, 0, 9 ) == 'timestamp' && is_numeric( trim( $r[ $k ] ) ) && ! empty( $r[ $k ] ) ) { $r[ $k ] = date( 'Y-m-d H:i:s', $r[ $k ] ); }
		if( empty( $r[ $k ] ) ) { $r[ $k ] = '-'; }
		echo txt2fixed( $r[ $k ], $v, ( ( isset( $c[ $k ] ) ) ? $c[ $k ] : ' ' ), ( ( isset( $s[ $k ] ) ) ? $s[ $k ] : STR_PAD_RIGHT ) );
	    }
	    echo PHP_EOL;
	    if( $n === array_key_first( $d ) ) { echo txtLine() . PHP_EOL; }
	}

    }

    function txtText( $t, $j = true, $w = REPORT_WIDTH ) {

	$t = wordwrap( $t, $w, "\n" );

    if( substr( $t, 0, 1 ) == '-' ) {
        $j = false;
    }

    if( $j === true ) {
	    $lines = explode( "\n", $t );
	    foreach( $lines as $key => &$line ) {
		if( substr( $line, -1 ) != '.' && $key !== array_key_last( $lines ) ) {
		    $line = justify( $line );
		}
	    }
	    return implode( "\n", $lines );
	} else {
	    return $t;
	}

    }

    function txtFullText( $t, $j = true, $w = REPORT_WIDTH ) {
        return txtText( $t, $j, $w ) . PHP_EOL;
    }

    function txtSubtitle( $t, $c = '-', $d = NULL, $w = REPORT_WIDTH ) {

        $t .= ' ';

        $w -= strlen( $t );
    
        return $t . txtLine( $c, $w ) . PHP_EOL;
    
    }
    

function justify( $str, $maxlen = REPORT_WIDTH) {

    $str = trim($str);

    $strlen = mb_strlen($str);

    if ($strlen >= $maxlen) {
        $str = wordwrap($str, $maxlen);
        $str = explode("\n", $str);
        $str = $str[0];
        $strlen = mb_strlen($str);
    }

    $space_count = mb_substr_count($str, ' ');
    if ($space_count === 0) {
        return str_pad($str, $maxlen, ' ', STR_PAD_BOTH);
    }

    $extra_spaces_needed = $maxlen - $strlen;
    $total_spaces = $extra_spaces_needed + $space_count;

    $space_string_avg_length = $total_spaces / $space_count;
    $short_string_multiplier = floor($space_string_avg_length);
    $long_string_multiplier = ceil($space_string_avg_length);

    $short_fill_string = str_repeat(' ', $short_string_multiplier);
    $long_fill_string = str_repeat(' ', $long_string_multiplier);

    $offset = $space_string_avg_length - $short_string_multiplier;
    $limit = ceil( $offset * $space_count );
    $explode_limit = $limit + 1;
#    echo gettype( $limit ) . PHP_EOL;
#    var_dump( $limit );

    // $words_split_by_long = mb_split("\s", $str, ($limit+1));
    $words_split_by_long = explode(' ', $str, $explode_limit );
#    $words_split_by_long = explode(' ', $str, 3);
    $words_split_by_short = $words_split_by_long[$limit];
    $words_split_by_short = str_replace(' ', $short_fill_string, $words_split_by_short);
    $words_split_by_long[$limit] = $words_split_by_short;

#    print_r( $words_split_by_long );

    $result = implode($long_fill_string, $words_split_by_long);
/*
    echo '--> ' . $str . PHP_EOL;
    echo 'stringa: ' . $strlen . PHP_EOL;
    echo 'spazi: ' . $space_count . PHP_EOL;
    echo 'spazi aggiuntivi richiesti: ' . $extra_spaces_needed . PHP_EOL;
    echo 'spaziatura media: ' . $space_string_avg_length . PHP_EOL;
    echo 'max: ' . $maxlen . PHP_EOL;
    echo 'fill piccolo: ' . $short_string_multiplier . PHP_EOL;
    echo 'fill grande: ' . $long_string_multiplier . PHP_EOL;
    echo 'fill grandi richiesti: ' . $limit . PHP_EOL;
    echo 'limite di explode: ' . $explode_limit . PHP_EOL;
    echo 'offset: ' . $offset . PHP_EOL;
    echo 'limite calcolato con: (' . $space_string_avg_length . ' - ' . $short_string_multiplier . ') * ' . $space_count . PHP_EOL;
    echo 'segmenti per il fill lungo: ' . implode( '|', $words_split_by_long ) . PHP_EOL;
    echo 'segmenti per il fill corto: ' . $words_split_by_short . PHP_EOL;
    echo PHP_EOL;
*/
    return $result;

}

    function txt2fixed( $t, $w, $c = ' ', $s = STR_PAD_RIGHT ) {

	if( strlen( $t ) >= $w ) {
	    $x = riduciStringa( $t, $w );
	} else {
	    $x = str_pad( $t, $w - 1, $c, $s );
	}

	return
        ( ( $s == STR_PAD_LEFT ) ? ' ' : NULL ) . 
        $x . 
        ( ( $s == STR_PAD_RIGHT ) ? ' ' : NULL );

    }

    function betterUrlEncode( $u ) {

        return implode('/', array_map('rawurlencode', explode('/', $u)));

    }

<?php

    /**
     * questo file contiene funzioni utili per l'url rewriting
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    /**
     * sostituisce i caratteri in modo da rendere una stringa utilizzabile in un url
     *
     * @param	string	$t	la stringa da modificare
     * @return	string		la stringa modificata
     *
     * @todo			commentare il codice
     * @todo			eliminare le sostituzioni rese inutili dall'introduzione di iconv
     *
     */
    function string2rewrite( $t ) {

	$t = trim( $t );

	if( function_exists( 'mb_strtolower' ) ) {
	    $t = mb_strtolower( $t, 'UTF8' );
	} else {
	    $t = strtolower( $t );
	}

	$t = html_entity_decode( $t );

	$t = str_replace( '€'		, 'EURO', $t );
	$t = str_replace( '@'		, 'AT', $t );
	$t = str_replace( '%'		, ' percento', $t );

	$t = str_replace( '®'		, '', $t );
	$t = str_replace( '™'		, '', $t );
	$t = str_replace( '"'		, '', $t );
	$t = str_replace( '°'		, '', $t );
	$t = str_replace( '^'		, '', $t );
	$t = str_replace( '«'		, '', $t );
	$t = str_replace( '»'		, '', $t );
	$t = str_replace( '<'		, '', $t );
	$t = str_replace( '>'		, '', $t );
	$t = str_replace( '?'		, '', $t );
	$t = str_replace( '!'		, '', $t );
	$t = str_replace( ','		, '', $t );
	$t = str_replace( ';'		, '', $t );
	$t = str_replace( '|'		, '', $t );
	$t = str_replace( '…'		, '', $t );
	$t = str_replace( '.'		, '', $t );
	$t = str_replace( ':'		, '', $t );
	$t = str_replace( '-'		, '', $t );
	$t = str_replace( '–'		, '', $t );
	$t = str_replace( '/'		, '', $t );
	$t = str_replace( '&'		, '', $t );
	$t = str_replace( '('		, '', $t );
	$t = str_replace( ')'		, '', $t );
	$t = str_replace( '['		, '', $t );
	$t = str_replace( ']'		, '', $t );
	$t = str_replace( '+'		, '', $t );

	$t = str_replace( 'à'		, 'a', $t );
	$t = str_replace( 'á'		, 'a', $t );
	$t = str_replace( 'è'		, 'e', $t );
	$t = str_replace( 'é'		, 'e', $t );
	$t = str_replace( 'ì'		, 'i', $t );
	$t = str_replace( 'í'		, 'i', $t );
	$t = str_replace( 'ò'		, 'o', $t );
	$t = str_replace( 'ó'		, 'o', $t );
	$t = str_replace( 'ö'		, 'o', $t );
	$t = str_replace( 'ù'		, 'u', $t );
	$t = str_replace( 'ú'		, 'u', $t );
	$t = str_replace( 'ü'		, 'u', $t );

	$t = str_replace( 'À'		, 'a', $t );
	$t = str_replace( 'Á'		, 'a', $t );
	$t = str_replace( 'È'		, 'e', $t );
	$t = str_replace( 'É'		, 'e', $t );
	$t = str_replace( 'Ì'		, 'i', $t );
	$t = str_replace( 'Í'		, 'i', $t );
	$t = str_replace( 'Ò'		, 'o', $t );
	$t = str_replace( 'Ó'		, 'o', $t );
	$t = str_replace( 'Ö'		, 'o', $t );
	$t = str_replace( 'Ù'		, 'u', $t );
	$t = str_replace( 'Ú'		, 'u', $t );
	$t = str_replace( 'Ü'		, 'u', $t );

	$t = str_replace( 'ț'		, 't', $t );

	$t = str_replace( 'Ț'		, 't', $t );

	$t = str_replace( '\''		, URL_WORD_SEPARATOR, $t );
	$t = str_replace( '’'		, URL_WORD_SEPARATOR, $t );
	$t = str_replace( ' '		, URL_WORD_SEPARATOR, $t );

	$t = iconv( 'UTF-8', 'ASCII//TRANSLIT//IGNORE', $t );

	$t = riduciCaratteriDoppi( $t, URL_WORD_SEPARATOR );

	$t = trim( $t, URL_WORD_SEPARATOR );

	return $t;

    }

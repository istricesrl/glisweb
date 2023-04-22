<?php

    /**
     * questo file contiene funzioni per la manipolazione degli array
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // costanti per la gestione dei files csv
	define( 'ARRAY_SORT_ASC'		, 'ASC' );
	define( 'ARRAY_SORT_DSC'		, 'DSC' );
	define( 'ARRAY_SEPARATOR'		, '|' );
	define( 'CHECK_BY_KEY'			, 'CBK' );
	define( 'CHECK_BY_VALUE'		, 'CBV' );

    /**
     *
     * @todo documentare
     *
     */
    function string2array( &$s, $c = ARRAY_SEPARATOR ) {
	if( empty( $s ) ) {
	    return array();
	} else {
	    $s = explode( $c, $s );
	}
    }

    /**
     *
     * @todo documentare
     *
     */
    function array2string( &$a, $c = ARRAY_SEPARATOR ) {
	if( empty( $a ) ) {
	    return NULL;
	} else {
	    $a = implode( $c, $a );
	}
    }

    /**
     *
     * @todo documentare
     *
     */
    function rksort( &$array ) {
	if( is_array( $array ) ) {
	    ksort( $array );
	    array_walk( $array, 'rksort' );
	}
    }

    /**
     *
     * @todo documentare
     *
     */
    function trimArray( &$ar, $limit = 0 ) {
        $ar = array_map('strval', $ar); #elimina i null
        $ar = array_map( 'trim', $ar );
        $ar = array_filter( $ar );

	return $ar;

    }

    /**
     *
     * @todo documentare
     *
     */
    function arrayTrim( $a ) {
        return trimArray( $a );
    }

    /**
     *
     * @todo documentare
     *
     */
    function removeFromArray( &$a, $e ) {

	if( ! is_array( $e ) ) { $e = array( $e ); }

	$a = array_diff( $a, $e );

    }

    /**
     *
     * @todo documentare
     *
     */
    function arrayLowercase( &$a ) {

	$a = array_map( 'strtolower', $a );

    }

    /**
     *
     * @todo documentare
     *
     */
    if( ! function_exists( 'array_key_first' ) ) {

	    function array_key_first( $a ) {
		reset( $a );
		return key( $a );
	    }

    }

    /**
     *
     * @todo documentare
     *
     */
    if( ! function_exists( 'array_column' ) ) {

	function array_column( $a, $k ) {

	    $r = array();

	    if( is_array( $a ) ) {
		foreach( $a as $v ) {
		    $r[] = $v[ $k ];
		}
	    }

	    return $r;

	}

    }

    /**
     *
     * @todo documentare
     *
     */
    function arraySortBy( $field, &$array, $direction = ARRAY_SORT_ASC ) {

	usort( $array,
	    function( $a, $b ) use ( $field, $direction ) {
            $direction = ( $direction == ARRAY_SORT_ASC ) ? -1 : 1;
            $a = $a[ $field ];
            $b = $b[ $field ];
            if ( $a == $b ) return 0;
            if ( $a > $b ) return -1 * $direction;
            if ( $a < $b ) return 1 * $direction;
        }
    );

	return true;

    }

    function removeColumnsFromArray( &$array, $keys ) {
        foreach( $keys as $key ) {
            removeColumnFromArray( $array, $key );
        }
    }

    function removeColumnFromArray( &$array, $key ) {
        return array_walk($array, function (&$v) use ($key) {
            unset($v[$key]);
        });
    }

    function renameColumnInArray( &$array, $oldKey, $newKey ) {
        return array_walk($array, function (&$v) use ($oldKey, $newKey) {
            $v[$newKey] = $v[$oldKey];
            unset($v[$oldKey]);
        });
    }

    function remapArray( &$array, $map ) {
        return array_walk($array, function (&$v) use ($map) {
            foreach( $map as $old => $new ) {
                $n[ $new ] = $v[ $old ];
            }
            $v = $n;
        });
    }

    /**
     *
     * @todo implementare
     * @todo documentare
     *
     */
    function arrayFilterBy( $field, $match, $array ) {

	return false;

    }

    /**
     *
     * @todo documentare
     *
     */
    function arrayKeyValuesImplode( $array, $tk1, $tk2, $empty = false ) {

	$t = array();

	foreach( $array as $k => $v ) {
	    if( ! empty( $v ) || $empty === true ) {
		$t[] = $k . $tk1 . $v;
	    }
	}

	return implode( $tk2, $t );

    }

    /**
     *
     * @todo documentare
     *
     */
    function arrayInsertAssoc( $ref, &$target, $add ) {

	$r = array();

	foreach( $target as $k => $v ) {

	    $r[ $k ] = $v;

	    if( $k == $ref ) {
		foreach( $add as $y => $j ) {
		    $r[ $y ] = $j;
		}
	    }

	}

    $target = $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function arrayInsertSeq( $ref, &$target, $add ) {

	array_splice( $target, ( array_search( $ref, $target ) + 1 ), 0, $add );

    }

    /**
     * 
     * funzione che inserisce un elemento in un array prima di un altro elemento specificato
     * - $target: array in cui inserire l'elemento
     * - $ref: elemento prima del quale inserire quello nuovo
     * - $add: il nuovo elemento da inserire
     * 
     */
    function arrayInsertBefore( $ref, &$target, $add ) {
        array_splice( $target, ( array_search( $ref, $target ) ), 0, $add );
    }

    /**
     *
     * @todo documentare
     *
     */
    function addStr2arrayElements( $a, $p = NULL, $s = NULL ) {

	return array_map(
	    function( $v ) use ( $p, $s ) {
		return $p . $v . $s;
	    },
	    $a
	);

    }

    /**
     *
     * @todo documentare
     *
     */
    function reindex_array_recursive($array) {
        if (is_array($array)) {
            if (array_keys($array) === range(0, count($array) - 1)) { // Indexed array
                return array_values(array_map('reindex_array_recursive', $array));
            } else { // Associative array
                foreach ($array as $value) {
                    $value = reindex_array_recursive($value);
                }
                return $array;
            }
        } else {
            return $array;
        }
    }

    /**
     *
     * @todo documentare
     *
     */
    function arrayReplaceRecursive( &$a1, $a2 ) {

        $a1 = ( is_array( $a1 ) ) ? $a1 : array();
        $a2 = ( is_array( $a2 ) ) ? $a2 : array();

        $a1 = array_replace_recursive( $a1, $a2 );

        return $a1;

    }

    /**
     *
     * @todo documentare
     *
     */
    function is_associative_array( array $a ) {
        return count( array_filter( array_keys( $a ), 'is_string' ) ) > 0;
    }

    /**
     *
     * @todo documentare
     *
     */
    function metadati2associativeArray( $r, &$a = array() ) {

        foreach( $r as $row ) {

            $dettagli = explode( '|', $row['nome'] );

            $lvl =& $a;

            foreach( $dettagli as $chiave ) {

                $lvl = array_replace_recursive(
                    $lvl,
                    array(
                        $chiave => array()
                    )
                );

                $lvl =& $lvl[ $chiave ];

            }

            if( empty( $row['ietf'] ) ) {
                $lvl = $row['testo'];
            } else {
                $lvl[ $row['ietf'] ] = $row['testo'];
            }

        }

        return( $a );

    }

    if( ! function_exists( 'array_key_last' ) ) {

        function array_key_last( $a ) {

            $ks = array_keys( $a );

            return $ks[ ( count( $ks ) - 1 ) ];

        }

    }

    function isEmptyArray($value)
    {
            if (is_array($value)) {
                    $empty = TRUE;
                    array_walk_recursive($value, function($item) use (&$empty) {
                            $empty = $empty && empty($item);
                    });
            } else {
                    $empty = empty($value);
            }
            return $empty;
    }

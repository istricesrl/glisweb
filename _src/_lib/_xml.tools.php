<?php

    /**
     * questo file contiene funzioni per la manipolazione dei file xml
     *
     *
     *
     * @todo implementare in array2xml gli attributi in forma di sottoarray 'attr'
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function array2xml( $data, $file = false, &$xml = NULL ) {

	// debug
	    // print_r( $data );

	// TODO questa funzione è da rifare con i seguenti obiettivi:
	// 1) gestire in maniera trasparente l'array generato da xml2array
	// 2) gestire correttamente i namespace senza l'accrocchio del pipe
	// 3) mantenere la compatibilità con gli script che usano attualmente questa funzione

	if( $xml === NULL ) {
	    $dtk = array_keys( $data );
	    $root = array_shift( $dtk );
	    $xml = new SimpleXMLElement( '<?xml version="1.0" encoding="utf-8"?><' . $root . '></' . $root . '>' );
#	    $xml->registerXPathNamespace( 'xhtml', 'http://www.w3.org/1999/xhtml' );
	    array2xml( array_shift( $data ), $file, $xml );
	}

	foreach( $data as $key => $value ) {

	    $key = str_replace( ':', '|', $key );

	    if( is_array( $value ) ) {

		$keys = array_keys( $value );

		if( $key === '@' ) {

		    foreach( $value as $attrName => $attrVal ) {
#			$xml[ $attrName ] = $attrVal;
#			if( strpos( $attrName, ':' ) ) {
#			$xml->addAttribute( $attrName, $attrVal, substr( $attrName, 0, strpos( $attrName, ':' ) ) );
#			} else {
			$attrName = str_replace( ':', '|', $attrName );
			$xml->addAttribute( $attrName, $attrVal );
#			}
		    }

		} elseif( array_shift( $keys ) === '#' ) {

		    $node = $xml->addChild( $key, $value['#'] );

		} elseif( is_numeric( array_shift( $keys ) ) ) {

		    foreach( $value as $item ) {

			if( strpos( $key, ':' ) ) {
			    $node = $xml->addChild( $key, NULL, substr( $key, 0, strpos( $key, ':' ) ) );
#			    $node = $xml->addChild( $key, NULL, 'http://www.w3.org/1999/xhtml' );
#			    $node = $xml->addChild( 'link', NULL, 'xhtml' );
#			    $node = $xml->addChild( 'link', NULL, 'http://www.w3.org/1999/xhtml' );
			} else {
			    $node = $xml->addChild( $key );
			}
			array2xml( $item, NULL, $node );
		    }

		} else {

			if( strpos( $key, ':' ) ) {
#			    $node = $xml->addChild( $key, NULL, 'http://www.w3.org/1999/xhtml' );
			} else {
			    $node = $xml->addChild( $key );
			}
#		    $node = $xml->addChild( $key );
		    array2xml( $value, NULL, $node );

		}

	    } else {

		if( substr( $key, 0, 1 ) == '@' ) {
		    $xml[ substr( $key, 1 ) ] = $value;
		} elseif( strpos( $key, ':' ) ) {
#		    $xml->addChild( $key, htmlspecialchars( $value ), substr( $key, strpos( $key, ':' ) + 1 ) );
		} else {
		    $xml->addChild( $key, htmlspecialchars( $value ) );
		}

	    }

	}

	if( $file !== NULL ) {

	    // echo str_replace('|',':',$xml->asXML());

	    $domxml = new DOMDocument('1.0');
	    $domxml->preserveWhiteSpace = false;
	    $domxml->formatOutput = true;
	    $domxml->loadXML( str_replace('|',':',$xml->asXML()) );

	    if( $file === false ) {
		return $domxml->saveXML();
	    } elseif( is_writeable( dirname( DIR_BASE . $file ) ) ) {
		return $domxml->save( DIR_BASE . $file );
	    } else {
		logWrite( 'impossibile scrivere il file xml, permessi insufficienti', 'filesystem', LOG_ERR );
	    }

	}

    }

    /**
     *
     * @todo documentare
     *
     */
//    function xml2array( $file, $get_attributes = true, $priority = 'tag' ) {
    function xml2array( $contents, $get_attributes = true, $priority = 'tag' ) {

	// TODO valutare se questa funzione va bene o se è da rifare in base a quanto
	// detto per array2xml()

	// $contents = readFromFile( $file, READ_FILE_AS_STRING );

	// logWrite( 'codifica contenuto: ' . mb_detect_encoding( $contenuto ), 'xml', LOG_DEBUG );

	if( ! $contents ) {
	    return array();
	}

	if( ! function_exists('xml_parser_create')) {
	    logWrite( 'la funzione xml_parser_create() non esiste', 'xml', LOG_CRIT );
	    return array();
	}

	$parser = xml_parser_create( '' );

	xml_parser_set_option( $parser, XML_OPTION_TARGET_ENCODING, 'UTF-8' );
	xml_parser_set_option( $parser, XML_OPTION_CASE_FOLDING, 0 );
	xml_parser_set_option( $parser, XML_OPTION_SKIP_WHITE, 1 );
	xml_parse_into_struct( $parser, trim( $contents ), $xml_values );

	$err = xml_get_error_code( $parser );

	xml_parser_free( $parser );

	if( ! empty( $err ) ) {
	    logWrite( 'errore #'.xml_get_error_code( $parser ).' ('.xml_error_string( $err ).')', 'xml', LOG_ERR );
	}

	if( ! $xml_values ) {
	    return array();
	} else {
	    logWrite( print_r( $xml_values, true ), 'xml', LOG_DEBUG );
	}

	$xml_array = array();
	$parents = array();
	$opened_tags = array();
	$arr = array();

	$current =& $xml_array;

	$repeated_tag_index = array();

	foreach( $xml_values as $data ) {

	    unset( $attributes, $value );
	    extract( $data );

	    $result = array();
	    $attributes_data = array();

	    if( isset( $value ) ) {
		if( $priority == 'tag' ) {
		    $result['#'] = $value;
		} else {
		    $result = $value;
		}
	    }

	    if( isset( $attributes ) and $get_attributes ) {
		foreach( $attributes as $attr => $val ) {
		    if( $priority == 'tag' ) {
			$result['@'][$attr] = $val;
		    } else {
			$attributes_data[$attr] = $val;
		    }
		}

	    }

	    if( $type == "open" ) {

		$parent[$level-1] =& $current;

		if( ! is_array( $current ) || ( ! in_array( $tag, array_keys( $current ) ) ) ) {

		    $current[$tag] = $result;

		    if( $attributes_data ) {
			$current[$tag. '_attr'] = $attributes_data;
		    }

		    $repeated_tag_index[$tag.'_'.$level] = 1;
		    $current =& $current[$tag];

		} else {

		    if( isset( $current[$tag][0] ) ) {

			$current[$tag][$repeated_tag_index[$tag.'_'.$level]] = $result;

			if($attributes_data) {
			    $current[$tag][$repeated_tag_index[$tag.'_'.$level].'_attr'] = $attributes_data;
			}

			$repeated_tag_index[$tag.'_'.$level]++;

		    } else {

			$current[$tag] = array( $current[$tag], $result );
			$repeated_tag_index[$tag.'_'.$level] = 2;

			if( isset( $current[$tag.'_attr'] ) ) {
			    $current[$tag]['0_attr'] = $current[$tag.'_attr'];
			    unset($current[$tag.'_attr']);
			}

			if($attributes_data) {
			    $current[$tag]['1_attr'] = $attributes_data;
			}

		    }

		    $last_item_index = $repeated_tag_index[$tag.'_'.$level]-1;
		    $current =& $current[$tag][$last_item_index];

		}

	    } elseif( $type == "complete" ) {

		if( ! isset( $current[$tag] ) ) {

		    $current[$tag] = $result;
		    $repeated_tag_index[$tag.'_'.$level] = 1;

		    if( $priority == 'attribute' && $attributes_data ) {
			$current[$tag. '_attr'] = $attributes_data;
		    }

		} else {

		    if( isset( $current[$tag][0] ) && is_array( $current[$tag] ) ) {

			$current[$tag][$repeated_tag_index[$tag.'_'.$level]] = $result;

			if( $priority == 'tag' && $get_attributes && $attributes_data) {
			    $current[$tag][$repeated_tag_index[$tag.'_'.$level] . '_attr'] = $attributes_data;
			}

			$repeated_tag_index[$tag.'_'.$level]++;

		    } else {

			$current[$tag] = array( $current[$tag], $result );
			$repeated_tag_index[$tag.'_'.$level] = 1;

			if($priority == 'tag' && $get_attributes) {

			    if( isset( $current[$tag.'_attr'] ) ) {
				$current[$tag]['0_attr'] = $current[$tag.'_attr'];
				unset($current[$tag.'_attr']);
			    }

			    if( $attributes_data ) {
				$current[$tag][$repeated_tag_index[$tag.'_'.$level] . '_attr'] = $attributes_data;
			    }

			}

			$repeated_tag_index[$tag.'_'.$level]++;

		    }

		}

	    } elseif( $type == 'close' ) {

		$current =& $parent[$level-1];

	    }

	}

	return( $xml_array );

    }

    /**
     *
     * @todo documentare
     *
     */
	if( ! function_exists( 'xmlEntities' ) ) {
	function xmlEntities( $t ) {
	    $t = iconv( 'UTF-8', 'ASCII//TRANSLIT//IGNORE', $t );
		$t = html_entity_decode( $t );
	    $t = str_replace( '€', 'EURO', $t );
//	    $t = str_replace( ',', '.', $t );
	    $t = str_replace( '&amp;', '&', $t );
	    $t = str_replace( '&', '&amp;', $t );
//	    $t = str_replace( 'ù', 'u', $t );
	    return $t;
	}
	}

    /**
     *
     * @todo documentare
     *
     */
	if( ! function_exists( 'xmlFloat' ) ) {
	function xmlFloat( $t ) {
	    $t = str_replace( ',', '.', sprintf( '%01.2f', $t ) );
	    return $t;
	}
	}

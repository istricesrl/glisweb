<?php

    /**
     * libreria per la manipolazione dei file xml
     * 
     * Questa libreria contiene funzioni per convertire documenti XML in array e viceversa, e per preparare testi e numeri
     * da inserire in un documento XML.
     * 
     * introduzione
     * ============
     * La funzione più usata della libreria è xml2array(), che trasforma un documento XML in un array annidato ed è usata ad
     * esempio da restCall() in _src/_lib/_rest.tools.php per decodificare le risposte XML; xmlEntities() e xmlFloat() sono
     * usate per la generazione delle fatture elettroniche in _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php.
     * La funzione inversa array2xml() al momento della stesura di questa documentazione non è usata da nessun file (in
     * _src/_config/_980.sitemap.php ne resta solo una chiamata commentata) e ha diversi limiti, descritti nel suo docblock.
     * 
     * formato degli array
     * -------------------
     * Nell'array prodotto da xml2array() con la priorità di default ('tag') ogni elemento diventa una chiave con il nome
     * del tag, il cui valore è un array con la chiave '#' per il testo e la chiave '@' per l'array degli attributi, più una
     * chiave per ogni elemento figlio; gli elementi con lo stesso nome ripetuti allo stesso livello diventano un array
     * numerico. Ad esempio:
     * 
     * ```
     * <r a="1"><x>1</x><x>2</x></r>
     * 
     * array( 'r' => array( '@' => array( 'a' => '1' ), 'x' => array( array( '#' => '1' ), array( '#' => '2' ) ) ) )
     * ```
     * 
     * TODO implementare in array2xml gli attributi in forma di sottoarray 'attr'
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di conversione
     * -----------------------
     * Le funzioni in questo gruppo servono per convertire documenti XML in array e viceversa.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * array2xml()                      | converte un array in un documento XML
     * xml2array()                      | converte un documento XML in un array
     * 
     * funzioni di formattazione
     * -------------------------
     * Le funzioni in questo gruppo servono per preparare i valori da inserire in un documento XML.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * xmlEntities()                    | prepara un testo per l'inserimento in un documento XML
     * xmlFloat()                       | formatta un numero con due decimali e il punto come separatore
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni, oltre alle estensioni SimpleXML, DOM e XML di PHP:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     * 
     */

    /**
     * FUNZIONI DI CONVERSIONE
     */

    /**
     * converte un array in un documento XML
     * 
     * Questa funzione costruisce con SimpleXML un documento XML a partire da un array; la prima chiave dell'array è il nome
     * dell'elemento radice e il suo valore il contenuto (le eventuali altre chiavi di primo livello finiscono anch'esse
     * dentro la radice). Per ogni chiave dell'array:
     * 
     * - un valore scalare diventa un elemento figlio con quel testo, oppure un attributo se la chiave comincia con @;
     * - un array con chiave '@' diventa l'insieme degli attributi dell'elemento corrente;
     * - un array la cui prima chiave è '#' diventa un elemento con il testo $value['#'];
     * - un array con chiavi numeriche diventa una serie di elementi con lo stesso nome;
     * - qualsiasi altro array diventa un elemento figlio, riempito ricorsivamente.
     * 
     * I due punti dei nomi con namespace vengono sostituiti temporaneamente da | e ripristinati alla fine sul testo XML
     * completo. Il documento viene riformattato con DOM e, se $file è false, restituito come stringa; se $file è un
     * percorso relativo a DIR_BASE viene salvato su file e la funzione restituisce il numero di byte scritti (false in
     * caso di errore), mentre se la cartella non è scrivibile scrive un errore nel log filesystem e restituisce NULL.
     * Con $file NULL (è il valore usato nelle chiamate ricorsive, con $xml valorizzato) non restituisce niente.
     * 
     * NOTA la funzione ha diversi limiti, verificati durante la stesura di questa documentazione:
     * - la sostituzione finale di | con : vale per tutto il testo, per cui un | contenuto in un valore diventa :;
     * - un array con chiave '#' perde tutte le altre chiavi, compresi gli attributi '@', per cui l'output di xml2array()
     *   non si riconverte fedelmente;
     * - il controllo sulle chiavi numeriche guarda la seconda chiave dell'array e non la prima, per cui una serie di un
     *   solo elemento genera un elemento chiamato 0, il documento non è valido e il risultato è un documento vuoto;
     * - dopo la sostituzione dei due punti i controlli strpos( $key, ':' ) non sono mai veri e i rami per i namespace non
     *   vengono mai eseguiti; gli elementi con prefisso vengono scritti senza dichiarare il namespace;
     * - la prima chiamata ricorsiva sulla radice riceve $file invece di NULL, per cui il documento viene formattato (ed
     *   eventualmente salvato) due volte.
     * TODO correggere il controllo sulle chiavi numeriche e il passaggio di $file nella chiamata ricorsiva sulla radice
     * 
     * @param       array       $data       l'array da convertire
     * @param       mixed       $file       false per ottenere il documento come stringa, un percorso relativo a DIR_BASE per
     *                                      salvarlo su file, NULL per non produrre output (default false)
     * @param       object      $xml        l'elemento SimpleXML a cui aggiungere i figli, usato nelle chiamate ricorsive
     *                                      (default NULL, cioè crea un nuovo documento); passato per riferimento
     * 
     * @return      mixed                   il documento XML come stringa, il risultato del salvataggio su file, oppure NULL
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
#        $xml->registerXPathNamespace( 'xhtml', 'http://www.w3.org/1999/xhtml' );
        array2xml( array_shift( $data ), $file, $xml );
    }

    foreach( $data as $key => $value ) {

        $key = str_replace( ':', '|', $key );

        if( is_array( $value ) ) {

        $keys = array_keys( $value );

        if( $key === '@' ) {

            foreach( $value as $attrName => $attrVal ) {
#            $xml[ $attrName ] = $attrVal;
#            if( strpos( $attrName, ':' ) ) {
#            $xml->addAttribute( $attrName, $attrVal, substr( $attrName, 0, strpos( $attrName, ':' ) ) );
#            } else {
            $attrName = str_replace( ':', '|', $attrName );
            $xml->addAttribute( $attrName, $attrVal );
#            }
            }

        } elseif( array_shift( $keys ) === '#' ) {

            $node = $xml->addChild( $key, $value['#'] );

        } elseif( is_numeric( array_shift( $keys ) ) ) {

            foreach( $value as $item ) {

            if( strpos( $key, ':' ) ) {
                $node = $xml->addChild( $key, NULL, substr( $key, 0, strpos( $key, ':' ) ) );
#                $node = $xml->addChild( $key, NULL, 'http://www.w3.org/1999/xhtml' );
#                $node = $xml->addChild( 'link', NULL, 'xhtml' );
#                $node = $xml->addChild( 'link', NULL, 'http://www.w3.org/1999/xhtml' );
            } else {
                $node = $xml->addChild( $key );
            }
            array2xml( $item, NULL, $node );
            }

        } else {

            if( strpos( $key, ':' ) ) {
#                $node = $xml->addChild( $key, NULL, 'http://www.w3.org/1999/xhtml' );
            } else {
                $node = $xml->addChild( $key );
            }
#            $node = $xml->addChild( $key );
            array2xml( $value, NULL, $node );

        }

        } else {

        if( substr( $key, 0, 1 ) == '@' ) {
            $xml[ substr( $key, 1 ) ] = $value;
        } elseif( strpos( $key, ':' ) ) {
#            $xml->addChild( $key, htmlspecialchars( $value ), substr( $key, strpos( $key, ':' ) + 1 ) );
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
        logger( 'impossibile scrivere il file xml, permessi insufficienti', 'filesystem', LOG_ERR );
        }

    }

    }

    /**
     * converte un documento XML in un array
     * 
     * Questa funzione analizza con il parser XML di PHP il documento passato come stringa (con encoding di destinazione
     * UTF-8, nomi dei tag con le maiuscole originali e spazi bianchi ignorati) e lo converte in un array annidato nel
     * formato descritto nell'introduzione della libreria. Con $priority 'tag' il testo di ogni elemento va nella chiave
     * '#' e gli attributi nella chiave '@'; con qualsiasi altro valore il testo diventa direttamente il valore
     * dell'elemento e gli attributi vanno in una chiave sorella con il nome del tag seguito da _attr.
     * 
     * Se il documento è vuoto, se l'estensione XML non è disponibile o se il parser non produce alcun valore la funzione
     * restituisce un array vuoto. Gli errori di parsing vengono scritti nel log xml ma non interrompono la conversione,
     * per cui un documento malformato produce un array parziale; la struttura letta viene scritta nel log xml con livello
     * LOG_DEBUG.
     * 
     * @param       string      $contents           il documento XML
     * @param       bool        $get_attributes     true per includere gli attributi (default true)
     * @param       string      $priority           'tag' per il formato con le chiavi '#' e '@' (default 'tag')
     * 
     * @return      array                           l'array ottenuto dalla conversione, vuoto in caso di errore
     * 
     */
//    function xml2array( $file, $get_attributes = true, $priority = 'tag' ) {
    function xml2array( $contents, $get_attributes = true, $priority = 'tag' ) {

    // TODO valutare se questa funzione va bene o se è da rifare in base a quanto
    // detto per array2xml()

    // $contents = readFromFile( $file, READ_FILE_AS_STRING );

    // logger( 'codifica contenuto: ' . mb_detect_encoding( $contenuto ), 'xml', LOG_DEBUG );

    if( ! $contents ) {
        return array();
    }

    if( ! function_exists('xml_parser_create')) {
        logger( 'la funzione xml_parser_create() non esiste', 'xml', LOG_CRIT );
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
        logger( 'errore #'.xml_get_error_code( $parser ).' ('.xml_error_string( $err ).')', 'xml', LOG_ERR );
    }

    if( ! $xml_values ) {
        return array();
    } else {
        logger( print_r( $xml_values, true ), 'xml', LOG_DEBUG );
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
     * FUNZIONI DI FORMATTAZIONE
     */

    /**
     * prepara un testo per l'inserimento in un documento XML
     * 
     * Questa funzione translittera il testo in ASCII con iconv() (le lettere accentate perdono l'accento, € diventa EUR
     * e i caratteri non convertibili vengono eliminati), decodifica le entità HTML e fa l'escape delle &, evitando di
     * raddoppiare quelle già scritte come &amp;. È definita solo se non esiste già, per cui un progetto può sostituirla
     * con una propria versione.
     * 
     * NOTA i caratteri < e > non vengono convertiti in entità, anzi &lt; e &gt; vengono decodificati: la funzione va
     * quindi usata su testi che non li contengono, oppure su frammenti di markup (come fa buildHTML() in
     * _src/_lib/_output.tools.php). Inoltre la decodifica delle entità avviene dopo la translitterazione, per cui
     * un'entità come &egrave; torna a essere un carattere non ASCII, e la sostituzione di € con EURO non ha effetto perché
     * iconv() lo ha già trasformato.
     * 
     * @param       string      $t      il testo da preparare
     * 
     * @return      string              il testo preparato
     * 
     */
    if( ! function_exists( 'xmlEntities' ) ) {
    function xmlEntities( $t ) {
        $t = iconv( 'UTF-8', 'ASCII//TRANSLIT//IGNORE', $t );
        $t = html_entity_decode( $t );
        $t = str_replace( '€', 'EURO', $t );
//        $t = str_replace( ',', '.', $t );
        $t = str_replace( '&amp;', '&', $t );
        $t = str_replace( '&', '&amp;', $t );
//        $t = str_replace( 'ù', 'u', $t );
        return $t;
    }
    }

    /**
     * formatta un numero con due decimali e il punto come separatore
     * 
     * Questa funzione formatta il numero con sprintf() a due decimali e sostituisce l'eventuale virgola con il punto,
     * come richiesto ad esempio dal tracciato della fattura elettronica. Un valore stringa con la virgola decimale (come
     * '2,5') non è numerico per PHP e viene troncato alla parte intera ('2.00'). È definita solo se non esiste già.
     * 
     * @param       float       $t      il numero da formattare
     * 
     * @return      string              il numero formattato, ad esempio '3.14'
     * 
     */
    if( ! function_exists( 'xmlFloat' ) ) {
    function xmlFloat( $t ) {
        $t = str_replace( ',', '.', sprintf( '%01.2f', $t ) );
        return $t;
    }
    }

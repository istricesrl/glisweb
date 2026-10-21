<?php

    /**
     * libreria per la manipolazione dei file xml
     * 
     * Questa libreria contiene funzioni per convertire documenti XML in array e viceversa, per validarli contro uno
     * schema XSD, per trasformarli con un foglio di stile XSL e per preparare testi e numeri da inserire in un documento XML.
     * 
     * introduzione
     * ============
     * La funzione più usata della libreria è xml2array(), che trasforma un documento XML in un array annidato ed è usata ad
     * esempio da restCall() in _src/_lib/_rest.tools.php per decodificare le risposte XML; xmlEntities() e xmlFloat() sono
     * usate per la generazione delle fatture elettroniche in _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php.
     * La funzione inversa array2xml() riconverte fedelmente l'array di xml2array(), namespace compresi, ed è usata per
     * scrivere la sitemap in _src/_config/_980.sitemap.php, il tracciato delle ore per Zucchetti in
     * _mod/_8100.cartellini/_src/_api/_print/_zucchetti.xml.php, la fattura elettronica in
     * _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php e il corpo delle chiamate di restCall() con $datatype
     * MIME_APPLICATION_XML.
     * 
     * validazione e trasformazione
     * ----------------------------
     * Schemi e fogli di stile servono a due cose diverse. Uno schema XSD descrive la struttura che un documento deve avere
     * ( elementi, ordine, valori ammessi ) e serve a VALIDARLO: è quello che fa xmlValidate(), ed è il controllo che per
     * esempio lo SDI fa per primo sulle fatture elettroniche. Un foglio di stile XSL non valida niente: TRASFORMA il
     * documento in un altro, di solito una pagina HTML leggibile, ed è quello che fa xmlTransform(). Gli schemi e i fogli
     * del framework stanno in _src/_xml/_xsd/ e _src/_xml/_xsl/ ( DIR_SRC_XML_XSD e DIR_SRC_XML_XSL ), quelli di un modulo
     * nelle cartelle omonime del modulo, per esempio _mod/_0400.documenti/_src/_xml/ per la fattura elettronica.
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
     * funzioni di validazione e trasformazione
     * ----------------------------------------
     * Le funzioni in questo gruppo servono per verificare un documento XML contro uno schema XSD e per trasformarlo con un
     * foglio di stile XSL.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * xmlValidate()                    | verifica un documento XML contro uno schema XSD
     * xmlTransform()                   | trasforma un documento XML con un foglio di stile XSL
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
     * sono richieste le seguenti funzioni, oltre alle estensioni SimpleXML, DOM e XML di PHP ( e all'estensione xsl per
     * xmlTransform() ):
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logger()                         | core
     * fullPath()                       | _filesystem.tools.php
     * 
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     * 2026-09-25       | Fabio Mosti          | array2xml() al posto di XMLWriter per sitemap e tracciato Zucchetti
     * 2026-09-25       | Fabio Mosti          | array2xml() al posto di XMLWriter per la fattura elettronica
     * 2026-09-29       | Fabio Mosti          | xmlValidate() e xmlTransform()
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
     * - la chiave '@' contiene gli attributi dell'elemento corrente, che vengono scritti prima dei figli;
     * - un valore scalare diventa un elemento figlio con quel testo, oppure un attributo se la chiave comincia con @;
     * - un array con la chiave '#' diventa un elemento con il testo $value['#'], più gli attributi e i figli descritti
     *   dalle altre chiavi;
     * - un array la cui prima chiave è numerica diventa una serie di elementi con lo stesso nome, ciascuno trattato come
     *   un elemento singolo ( anche una serie di un solo elemento );
     * - qualsiasi altro array diventa un elemento figlio, riempito ricorsivamente.
     *
     * I testi vengono passati per htmlspecialchars(), per cui l'array prodotto da xml2array(), che ha i testi già decodificati,
     * si riconverte fedelmente. I namespace si dichiarano come attributi xmlns o xmlns:prefisso nella chiave '@': quelli
     * della radice vengono scritti sulla radice, quelli degli altri elementi vengono registrati e SimpleXML li dichiara sugli
     * elementi che li usano. Un elemento o un attributo con prefisso viene scritto nel suo namespace; se il prefisso non è
     * stato dichiarato viene scritto senza prefisso e l'anomalia finisce nel log xml. La mappa dei namespace vale per tutto
     * il documento, non solo per il ramo in cui sono dichiarati.
     *
     * Il documento viene dichiarato in UTF-8 ( con la stessa grafia di XMLWriter::startDocument( '1.0', 'UTF-8' ), per cui
     * un file scritto prima con XMLWriter e poi con questa funzione non cambia per la dichiarazione ), viene riformattato con
     * DOM, con due spazi di indentazione, e, se $file è false, restituito come stringa; se $file è un percorso relativo
     * a DIR_BASE viene salvato su file e la funzione restituisce il numero di byte scritti (false in caso di errore),
     * mentre se la cartella non è scrivibile scrive un errore nel log filesystem e restituisce NULL. Con $file NULL (è il
     * valore usato nelle chiamate ricorsive, con $xml valorizzato) non restituisce niente.
     *
     * NB: fino al 2026-09-24 i due punti dei nomi venivano sostituiti con | e ripristinati alla fine su tutto il testo, per
     * cui un | nei valori diventava :, e i rami per i namespace non venivano mai eseguiti; un array con '#' perdeva gli
     * attributi '@'; il controllo sulle chiavi numeriche guardava la seconda chiave, per cui una serie di un elemento
     * produceva un documento vuoto ( e una serie di elementi con '#' pure ); la chiamata ricorsiva sulla radice riceveva
     * $file e il documento veniva formattato, ed eventualmente salvato, due volte.
     *
     * NOTA rispetto allo stesso documento scritto con XMLWriter restano tre differenze, tutte senza effetto sul significato
     * dell'XML ma visibili nel testo: le dichiarazioni xmlns della radice vengono scritte prima degli altri attributi ( è
     * libxml a serializzarle così ), le virgolette nel testo degli elementi restano " invece di &quot;, e un elemento con
     * testo vuoto diventa <x/> invece di <x></x>. Per la fattura elettronica
     * ( _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php ) si è verificato il 2026-09-25 che nessuna delle tre
     * conta: il documento resta valido contro lo schema FatturaPA 1.2.3 e identico per C14N a quello di XMLWriter, e gli
     * elementi vuoti la fattura non li scrive, perché lo schema non li accetta.
     *
     * NB: fino al 2026-09-25 un figlio senza prefisso di un elemento con prefisso, in un documento senza namespace di
     * default, veniva creato con SimpleXMLElement::addChild( ..., '' ), che gli scriveva un xmlns="" ridondante; xml2array()
     * lo rileggeva come attributo, per cui l'andata e ritorno di un soap:Envelope con il contenuto senza prefisso non tornava.
     *
     * @param       array       $data       l'array da convertire
     * @param       mixed       $file       false per ottenere il documento come stringa, un percorso relativo a DIR_BASE per
     *                                      salvarlo su file, NULL per non produrre output (default false)
     * @param       object      $xml        l'elemento SimpleXML a cui aggiungere i figli, usato nelle chiamate ricorsive
     *                                      (default NULL, cioè crea un nuovo documento); passato per riferimento
     * @param       array       $ns         la mappa prefisso => URI dei namespace dichiarati, usata nelle chiamate ricorsive
     *                                      (default array vuoto); passata per riferimento
     *
     * @return      mixed                   il documento XML come stringa, il risultato del salvataggio su file, oppure NULL
     * 
     */
    function array2xml( $data, $file = false, &$xml = NULL, &$ns = array() ) {

    // debug
        // print_r( $data );

    // NOTA questa funzione andava rifatta con i seguenti obiettivi:
    // 1) gestire in maniera trasparente l'array generato da xml2array
    // 2) gestire correttamente i namespace senza l'accrocchio del pipe
    // 3) mantenere la compatibilità con gli script che usano attualmente questa funzione
    // il 2026-09-24 sono stati raggiunti i primi due, e il terzo non pesava perché la funzione non aveva chiamanti

    if( $xml === NULL ) {
        $dtk = array_keys( $data );
        $root = array_shift( $dtk );
        $rootData = array_shift( $data );

        // il prefisso xml è predefinito e non si dichiara
        $ns['xml'] = 'http://www.w3.org/XML/1998/namespace';

        // le dichiarazioni dei namespace della radice vanno scritte nel testo con cui si crea il documento, perché
        // SimpleXML con addAttribute( 'xmlns:x', ... ) scriverebbe un attributo x senza prefisso
        $dcl = '';
        if( is_array( $rootData ) && isset( $rootData['@'] ) && is_array( $rootData['@'] ) ) {
            foreach( $rootData['@'] as $attrName => $attrVal ) {
                if( $attrName === 'xmlns' || strpos( $attrName, 'xmlns:' ) === 0 ) {
                    $dcl .= ' ' . $attrName . '="' . htmlspecialchars( $attrVal ) . '"';
                    $ns[ (string) substr( $attrName, 6 ) ] = $attrVal;
                    unset( $rootData['@'][ $attrName ] );
                }
            }
        }

        $xml = new SimpleXMLElement( '<?xml version="1.0" encoding="UTF-8"?><' . $root . $dcl . '></' . $root . '>' );

        // la chiamata sulla radice non produce output: la formattazione e il salvataggio si fanno una volta sola qui sotto
        if( is_array( $rootData ) ) {
            array2xml( $rootData, NULL, $xml, $ns );
        }
    }

    // gli attributi si elaborano per primi, così i namespace che dichiarano sono noti quando si scrivono i figli
    if( isset( $data['@'] ) && is_array( $data['@'] ) ) {

        foreach( $data['@'] as $attrName => $attrVal ) {
            if( $attrName === 'xmlns' || strpos( $attrName, 'xmlns:' ) === 0 ) {
                // il namespace si registra, e SimpleXML lo dichiara sugli elementi che lo usano
                $ns[ (string) substr( $attrName, 6 ) ] = $attrVal;
            } elseif( strpos( $attrName, ':' ) !== false ) {
                $xml->addAttribute( $attrName, $attrVal, $ns[ substr( $attrName, 0, strpos( $attrName, ':' ) ) ] ?? NULL );
            } else {
                $xml->addAttribute( $attrName, $attrVal );
            }
        }

        unset( $data['@'] );

    }

    // aggiunge a $parent il figlio $name con il testo $text nel namespace $uri; il figlio da mettere fuori da ogni namespace
    // ( $uri '' ) si crea con DOM, perché SimpleXMLElement::addChild() gli scriverebbe un xmlns="" ridondante
    $addChild = function( $parent, $name, $text, $uri ) {
        if( $uri === '' ) {
            $dom = dom_import_simplexml( $parent );
            $child = $dom->appendChild( $dom->ownerDocument->createElement( $name ) );
            if( $text !== NULL ) {
                $child->appendChild( $dom->ownerDocument->createTextNode( $text ) );
            }
            return simplexml_import_dom( $child );
        } else {
            return $parent->addChild( $name, ( $text === NULL ) ? NULL : htmlspecialchars( $text ), $uri );
        }
    };

    foreach( $data as $key => $value ) {

        // namespace dell'elemento: quello del prefisso, se il nome ne ha uno, altrimenti quello di default; NB senza
        // namespace SimpleXML fa ereditare al figlio quello del padre, per cui sotto un padre con prefisso un figlio senza
        // prefisso ( e senza namespace di default ) va messo esplicitamente fuori da ogni namespace, con ''
        if( strpos( $key, ':' ) !== false ) {
            $uri = $ns[ substr( $key, 0, strpos( $key, ':' ) ) ] ?? NULL;
            if( $uri === NULL ) {
                logger( 'namespace non dichiarato per l\'elemento ' . $key . ', il prefisso viene perso', 'xml', LOG_WARNING );
            }
        } else {
            $uri = $ns[''] ?? ( ( dom_import_simplexml( $xml )->namespaceURI !== NULL ) ? '' : NULL );
        }

        if( is_array( $value ) ) {

        $keys = array_keys( $value );

        if( array_key_exists( '#', $value ) ) {

            // elemento con testo, più eventuali attributi e figli
            $node = $addChild( $xml, $key, (string) $value['#'], $uri );
            unset( $value['#'] );
            array2xml( $value, NULL, $node, $ns );

        } elseif( is_int( reset( $keys ) ) ) {

            // serie di elementi con lo stesso nome: ogni elemento si scrive come se fosse l'unico, così vale per lui
            // tutto quello che vale per un elemento singolo ( testo in '#', attributi in '@', figli, valore scalare )
            foreach( $value as $item ) {
                array2xml( array( $key => $item ), NULL, $xml, $ns );
            }

        } else {

            $node = $addChild( $xml, $key, NULL, $uri );
            array2xml( $value, NULL, $node, $ns );

        }

        } else {

        if( substr( $key, 0, 1 ) == '@' ) {
            $xml[ substr( $key, 1 ) ] = $value;
        } else {
            $addChild( $xml, $key, (string) $value, $uri );
        }

        }

    }

    if( $file !== NULL ) {

        $domxml = new DOMDocument('1.0');
        $domxml->preserveWhiteSpace = false;
        $domxml->formatOutput = true;
        $domxml->loadXML( $xml->asXML() );

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
     * FUNZIONI DI VALIDAZIONE E TRASFORMAZIONE
     */

    /**
     * verifica un documento XML contro uno schema XSD
     * 
     * Questa funzione carica con DOM il documento passato come stringa e lo valida con DOMDocument::schemaValidate()
     * contro lo schema XSD $xsd, un percorso assoluto o relativo a DIR_BASE. Restituisce true se il documento è valido,
     * false se non lo è ( o se non è nemmeno XML ben formato ), NULL se lo schema non si trova; gli errori di libxml,
     * nella forma "riga N: messaggio", vengono aggiunti a $errors e scritti nel log xml.
     * 
     * La validazione dice se un documento rispetta la STRUTTURA descritta dallo schema ( quali elementi, in che ordine,
     * con quali valori ammessi ), ed è quella che per esempio lo SDI fa per prima su una fattura elettronica: un file
     * che non la supera viene scartato. Un foglio XSL invece non valida niente, trasforma il documento in un altro
     * ( di solito HTML da leggere ): per quello c'è xmlTransform().
     * 
     * Gli schemi ufficiali importano spesso altri schemi con un URL assoluto ( quello della fattura elettronica importa
     * lo schema delle firme XML dal sito del W3C ): per non dipendere dalla rete, e dalla sua lentezza, durante la
     * validazione ogni file richiesto da libxml si cerca per nome prima nella cartella di $xsd e poi in
     * DIR_SRC_XML_XSD, dove il framework tiene gli schemi di uso generale; solo se non c'è in nessuna delle due viene
     * caricato dall'indirizzo originale. Il gestore delle entità esterne di libxml viene ripristinato alla fine.
     * 
     * @param       string      $xml        il documento XML
     * @param       string      $xsd        il percorso dello schema XSD, assoluto o relativo a DIR_BASE
     * @param       array       $errors     l'array a cui aggiungere gli errori (default array vuoto); passato per
     *                                      riferimento
     * 
     * @return      mixed                   true se il documento è valido, false se non lo è, NULL se manca lo schema
     * 
     */
    function xmlValidate( $xml, $xsd, &$errors = array() ) {

    // percorso completo dello schema
        fullPath( $xsd );

    // se lo schema non c'è non si può dire niente del documento
        if( ! is_readable( $xsd ) ) {
        logger( 'schema XSD non trovato: ' . $xsd, 'xml', LOG_ERR );
        return NULL;
        }

    // cartelle in cui cercare i file richiesti da libxml
        $dirs = array( dirname( $xsd ) . '/', DIR_SRC_XML_XSD );

    // i file richiesti si cercano per nome nelle cartelle locali, e solo in mancanza all'indirizzo originale
        libxml_set_external_entity_loader( function( $public, $system, $context ) use ( $dirs ) {
        if( is_file( $system ) ) {
            return $system;
        }
        $name = basename( (string) parse_url( $system, PHP_URL_PATH ) );
        foreach( $dirs as $dir ) {
            if( ! empty( $name ) && is_file( $dir . $name ) ) {
            return $dir . $name;
            }
        }
        return $system;
        } );

    // gli errori di libxml si raccolgono invece di emettere warning
        $internal = libxml_use_internal_errors( true );
        libxml_clear_errors();

    // caricamento e validazione
        $dom = new DOMDocument( '1.0', 'UTF-8' );
        $valid = ( $dom->loadXML( $xml ) && $dom->schemaValidate( $xsd ) );

    // raccolta degli errori
        foreach( libxml_get_errors() as $error ) {
        $errors[] = 'riga ' . $error->line . ': ' . trim( $error->message );
        logger( 'riga ' . $error->line . ': ' . trim( $error->message ) . ' ( schema ' . basename( $xsd ) . ' )', 'xml', LOG_ERR );
        }

    // ripristino dello stato di libxml
        libxml_clear_errors();
        libxml_use_internal_errors( $internal );
        libxml_set_external_entity_loader( NULL );

        return $valid;

    }

    /**
     * trasforma un documento XML con un foglio di stile XSL
     * 
     * Questa funzione applica con XSLTProcessor il foglio di stile $xsl, un percorso assoluto o relativo a DIR_BASE, al
     * documento XML passato come stringa, e restituisce il risultato come stringa ( per i fogli della fattura
     * elettronica, una pagina HTML ); restituisce false se il documento, il foglio o la trasformazione non vanno a buon
     * fine, e in quel caso scrive l'errore nel log xml. Richiede l'estensione xsl di PHP: se manca, la funzione lo
     * scrive nel log e restituisce false, e il chiamante può ripiegare sulla trasformazione nel browser.
     * 
     * NOTA la trasformazione si fa sul server perché i browser la stanno abbandonando: Chrome ha deprecato XSLT e
     * annunciato che l'istruzione <?xml-stylesheet?> smetterà di funzionare nelle versioni stabili dal novembre 2026.
     * 
     * @param       string      $xml        il documento XML
     * @param       string      $xsl        il percorso del foglio di stile XSL, assoluto o relativo a DIR_BASE
     * 
     * @return      mixed                   il documento trasformato, oppure false in caso di errore
     * 
     */
    function xmlTransform( $xml, $xsl ) {

    // l'estensione xsl non è sempre installata
        if( ! class_exists( 'XSLTProcessor' ) ) {
        logger( 'la classe XSLTProcessor non esiste, manca l\'estensione xsl', 'xml', LOG_CRIT );
        return false;
        }

    // percorso completo del foglio di stile
        fullPath( $xsl );

    // gli errori di libxml si raccolgono invece di emettere warning
        $internal = libxml_use_internal_errors( true );
        libxml_clear_errors();

    // caricamento del documento e del foglio di stile, e trasformazione
        $dom = new DOMDocument( '1.0', 'UTF-8' );
        $sheet = new DOMDocument( '1.0', 'UTF-8' );
        $result = false;
        if( $dom->loadXML( $xml ) && is_readable( $xsl ) && $sheet->load( $xsl ) ) {
        $processor = new XSLTProcessor();
        if( $processor->importStylesheet( $sheet ) ) {
            $result = $processor->transformToXml( $dom );
        }
        }

    // log degli errori
        if( $result === false ) {
        logger( 'impossibile trasformare il documento con ' . $xsl, 'xml', LOG_ERR );
        }
        foreach( libxml_get_errors() as $error ) {
        logger( 'riga ' . $error->line . ': ' . trim( $error->message ) . ' ( foglio ' . basename( $xsl ) . ' )', 'xml', LOG_ERR );
        }

    // ripristino dello stato di libxml
        libxml_clear_errors();
        libxml_use_internal_errors( $internal );

        return $result;

    }

    /**
     * FUNZIONI DI FORMATTAZIONE
     */

    /**
     * prepara un testo per l'inserimento in un documento XML
     * 
     * Questa funzione decodifica le entità HTML, translittera il testo in ASCII con iconv() (le lettere accentate perdono
     * l'accento, € diventa EUR e i caratteri non convertibili vengono eliminati) e fa l'escape delle &, evitando di
     * raddoppiare quelle già scritte come &amp;. Poiché la decodifica viene prima, anche un'entità come &egrave; finisce
     * translitterata ( "e" ). È definita solo se non esiste già, per cui un progetto può sostituirla con una propria
     * versione.
     *
     * NB: fino al 2026-09-24 la decodifica delle entità avveniva dopo la translitterazione, per cui &egrave; tornava a
     * essere un carattere non ASCII.
     *
     * NOTA i caratteri < e > non vengono convertiti in entità, anzi &lt; e &gt; vengono decodificati: la funzione va
     * quindi usata su testi che non li contengono, oppure su frammenti di markup (come fa buildHTML() in
     * _src/_lib/_output.tools.php). Non si corregge perché _mod/_0400.documenti/_src/_api/_print/_fattura.xml.php passa il
     * risultato a array2xml(), che fa l'escape da sé: un "&lt;" lasciato com'è finirebbe nella fattura come
     * testo "&amp;lt;". Per la stessa ragione la fattura toglie l'escape delle & fatto qui prima di passare il testo a
     * array2xml(): fino al 2026-09-25 non lo faceva, e "Rossi & Figli" arrivava come "Rossi &amp;amp; Figli" ( issue 591 ).
     * TODO la sostituzione di € con EURO non ha effetto perché iconv() lo ha già trasformato in EUR
     *
     * @param       string      $t      il testo da preparare
     * 
     * @return      string              il testo preparato
     * 
     */
    if( ! function_exists( 'xmlEntities' ) ) {
    function xmlEntities( $t ) {
        $t = html_entity_decode( $t );
        $t = iconv( 'UTF-8', 'ASCII//TRANSLIT//IGNORE', $t );
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

<?php

    /**
     * libreria per l'url rewriting
     * 
     * Questa libreria contiene le funzioni che trasformano un testo qualsiasi in una stringa utilizzabile come parte
     * di un URL leggibile.
     * 
     * introduzione
     * ============
     * Il framework costruisce gli URL delle pagine e dei contenuti a partire dai loro titoli o nomi, e usa la stessa
     * trasformazione anche per ricavare nomi di file sicuri a partire da stringhe arbitrarie (ad esempio i file di log
     * di _src/_lib/_mapquest.tools.php). La trasformazione produce una stringa in minuscolo, senza accenti né
     * punteggiatura, con le parole separate da URL_WORD_SEPARATOR.
     * 
     * costanti
     * ========
     * Questa libreria non definisce costanti; usa URL_WORD_SEPARATOR, il separatore delle parole negli URL, definito
     * in _src/_config/_025.site.php (default '-').
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni di conversione
     * -----------------------
     * Le funzioni in questo gruppo servono per convertire le stringhe in forma utilizzabile negli URL.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * string2rewrite()                 | sostituisce i caratteri in modo da rendere una stringa utilizzabile in un url
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * riduciCaratteriDoppi()           | _src/_lib/_string.tools.php
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
     * sostituisce i caratteri in modo da rendere una stringa utilizzabile in un url
     * 
     * Questa funzione toglie gli spazi ai bordi della stringa, la porta in minuscolo (con mb_strtolower() se
     * disponibile), decodifica le entità HTML, sostituisce € con EURO, @ con AT e % con " percento", elimina la
     * punteggiatura e i simboli più comuni, toglie gli accenti dalle vocali, trasforma spazi e apostrofi in
     * URL_WORD_SEPARATOR, translittera in ASCII con iconv() eliminando i caratteri non convertibili, riduce i separatori
     * consecutivi a uno solo e li toglie dai bordi. Ad esempio "Caffè & Tè: 10% più" diventa "caffe-te-10-percento-piu".
     * Se la stringa è vuota (compresi NULL e '0') viene restituita così com'è.
     * 
     * NOTA i trattini presenti nella stringa originale vengono eliminati e non trasformati in separatori, per cui
     * "albero-di Natale" diventa "alberodi-natale".
     * TODO EURO e AT sono sostituiti dopo il passaggio in minuscolo e restano quindi in maiuscolo nell'URL
     * ("5 €" diventa "5-EURO"): verificare se è voluto
     * TODO commentare il codice
     * TODO eliminare le sostituzioni rese inutili dall'introduzione di iconv
     * 
     * @param       string      $t      la stringa da modificare
     * 
     * @return      string              la stringa modificata
     * 
     */
    function string2rewrite( $t ) {

        if( ! empty( $t ) ) {

            // echo 'string2rewrite input: ' . $t . PHP_EOL;

            $t = trim( $t );

            if( function_exists( 'mb_strtolower' ) ) {
                $t = mb_strtolower( $t, 'UTF8' );
            } else {
                $t = strtolower( $t );
            }

            $t = html_entity_decode( $t );

            $t = str_replace( '€'        , 'EURO', $t );
            $t = str_replace( '@'        , 'AT', $t );
            $t = str_replace( '%'        , ' percento', $t );

            $t = str_replace( '®'        , '', $t );
            $t = str_replace( '™'        , '', $t );
            $t = str_replace( '"'        , '', $t );
            $t = str_replace( '°'        , '', $t );
            $t = str_replace( '^'        , '', $t );
            $t = str_replace( '«'        , '', $t );
            $t = str_replace( '»'        , '', $t );
            $t = str_replace( '<'        , '', $t );
            $t = str_replace( '>'        , '', $t );
            $t = str_replace( '?'        , '', $t );
            $t = str_replace( '!'        , '', $t );
            $t = str_replace( ','        , '', $t );
            $t = str_replace( ';'        , '', $t );
            $t = str_replace( '|'        , '', $t );
            $t = str_replace( '…'        , '', $t );
            $t = str_replace( '.'        , '', $t );
            $t = str_replace( ':'        , '', $t );
            $t = str_replace( '-'        , '', $t );
            $t = str_replace( '–'        , '', $t );
            $t = str_replace( '/'        , '', $t );
            $t = str_replace( '&'        , '', $t );
            $t = str_replace( '('        , '', $t );
            $t = str_replace( ')'        , '', $t );
            $t = str_replace( '['        , '', $t );
            $t = str_replace( ']'        , '', $t );
            $t = str_replace( '+'        , '', $t );

            $t = str_replace( 'à'        , 'a', $t );
            $t = str_replace( 'á'        , 'a', $t );
            $t = str_replace( 'è'        , 'e', $t );
            $t = str_replace( 'é'        , 'e', $t );
            $t = str_replace( 'ì'        , 'i', $t );
            $t = str_replace( 'í'        , 'i', $t );
            $t = str_replace( 'ò'        , 'o', $t );
            $t = str_replace( 'ó'        , 'o', $t );
            $t = str_replace( 'ö'        , 'o', $t );
            $t = str_replace( 'ù'        , 'u', $t );
            $t = str_replace( 'ú'        , 'u', $t );
            $t = str_replace( 'ü'        , 'u', $t );

            $t = str_replace( 'À'        , 'a', $t );
            $t = str_replace( 'Á'        , 'a', $t );
            $t = str_replace( 'È'        , 'e', $t );
            $t = str_replace( 'É'        , 'e', $t );
            $t = str_replace( 'Ì'        , 'i', $t );
            $t = str_replace( 'Í'        , 'i', $t );
            $t = str_replace( 'Ò'        , 'o', $t );
            $t = str_replace( 'Ó'        , 'o', $t );
            $t = str_replace( 'Ö'        , 'o', $t );
            $t = str_replace( 'Ù'        , 'u', $t );
            $t = str_replace( 'Ú'        , 'u', $t );
            $t = str_replace( 'Ü'        , 'u', $t );

            $t = str_replace( 'ț'        , 't', $t );

            $t = str_replace( 'Ț'        , 't', $t );

            $t = str_replace( '\''        , URL_WORD_SEPARATOR, $t );
            $t = str_replace( '’'        , URL_WORD_SEPARATOR, $t );
            $t = str_replace( ' '        , URL_WORD_SEPARATOR, $t );

            $t = iconv( 'UTF-8', 'ASCII//TRANSLIT//IGNORE', $t );

            $t = riduciCaratteriDoppi( $t, URL_WORD_SEPARATOR );

            $t = trim( $t, URL_WORD_SEPARATOR );

        } else {

            // echo 'string2rewrite input vuoto' . PHP_EOL;

        }

        return $t;

    }

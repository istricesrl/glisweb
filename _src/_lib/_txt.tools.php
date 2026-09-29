<?php

    /**
     * libreria per la generazione di report in testo semplice
     * 
     * Questa libreria contiene funzioni per comporre report in testo semplice a larghezza fissa: intestazioni, righe di
     * separazione, coppie etichetta/valore, tabelle e paragrafi giustificati.
     * 
     * introduzione
     * ============
     * Alcune API di stato e di report del framework e dei moduli (ad esempio _src/_api/_status/_images.resize.status.php
     * e _mod/_1200.todo/_src/_api/_report/_progetti.todo.php) restituiscono il loro output come testo semplice da
     * leggere nel browser o nel terminale; le funzioni di questa libreria servono a impaginarlo in colonne di larghezza
     * REPORT_WIDTH caratteri. Quasi tutte restituiscono una stringa, che il chiamante stampa con echo; fa eccezione
     * txtTable(), che stampa direttamente.
     * 
     * Le larghezze sono calcolate in byte con strlen(), per cui le stringhe che contengono caratteri multibyte (ad
     * esempio le lettere accentate in UTF-8) risultano più corte del previsto e disallineano le colonne; fa eccezione
     * justify(), che usa le funzioni mb_*.
     * 
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella.
     *
     * costante                     | spiegazione
     * -----------------------------|--------------------------------------------------------------
     * REPORT_WIDTH                 | larghezza di default dei report in caratteri (80)
     * 
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     * 
     * funzioni per titoli e separatori
     * --------------------------------
     * Le funzioni in questo gruppo servono per generare le intestazioni e le righe di separazione dei report.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * txtHeader()                      | genera l'intestazione di un report
     * txtDateTime()                    | restituisce data e ora formattate
     * txtLine()                        | genera una riga composta da un carattere ripetuto
     * txtFullLine()                    | genera una riga composta da un carattere ripetuto, con il fine riga
     * txtDateTimeLine()                | genera una riga di separazione che termina con data e ora correnti
     * txtSubtitle()                    | genera un sottotitolo seguito da una riga di riempimento
     * 
     * funzioni per dati e tabelle
     * ---------------------------
     * Le funzioni in questo gruppo servono per impaginare i dati.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * txtData()                        | genera una riga con un'etichetta a sinistra e un valore a destra
     * txtTable()                       | stampa una tabella a colonne di larghezza fissa
     * txt2fixed()                      | porta una stringa a una larghezza fissa
     * 
     * funzioni per il testo
     * ---------------------
     * Le funzioni in questo gruppo servono per impaginare i paragrafi di testo.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * txtText()                        | impagina un testo alla larghezza data, giustificandolo
     * txtFullText()                    | impagina un testo alla larghezza data, con il fine riga
     * justify()                        | giustifica una riga di testo alla larghezza data
     * 
     * funzioni varie
     * --------------
     * Le funzioni in questo gruppo non riguardano i report ma sono state raccolte qui.
     * 
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * betterUrlEncode()                | codifica un percorso per l'uso in un URL lasciando intatte le barre
     * 
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     * 
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * riduciStringa()                  | _src/_lib/_string.tools.php
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

    // costanti
	define( 'REPORT_WIDTH'			, 80 );

    /**
     * FUNZIONI PER TITOLI E SEPARATORI
     */

    /**
     * genera l'intestazione di un report
     * 
     * Questa funzione restituisce il titolo in maiuscolo seguito da un fine riga e da una riga di separazione
     * composta dal carattere $c che termina con data e ora correnti (si veda txtDateTimeLine()).
     * 
     * NOTA il parametro $w non viene usato: la riga di separazione è sempre larga REPORT_WIDTH caratteri.
     * 
     * @param       string      $t      il titolo del report
     * @param       string      $c      il carattere della riga di separazione (default '=')
     * @param       int         $w      la larghezza del report (default REPORT_WIDTH, attualmente ignorata)
     * 
     * @return      string              l'intestazione, terminata da un fine riga
     * 
     */
    function txtHeader( $t, $c = '=', $w = REPORT_WIDTH ) {

	$t = strtoupper( $t );

	$t .= PHP_EOL . txtDateTimeLine( $c );

	return $t;

    }

    /**
     * restituisce data e ora formattate
     * 
     * Questa funzione è un sottile involucro attorno a date(): restituisce la data $d, o quella corrente se $d è NULL,
     * nel formato $f.
     * 
     * @param       string      $f      il formato per date() (default 'Y-m-d H:i:s')
     * @param       int         $d      la timestamp da formattare (default NULL, cioè adesso)
     * 
     * @return      string              la data formattata
     * 
     */
    function txtDateTime( $f = 'Y-m-d H:i:s', $d = NULL ) {

	return ( $d === NULL ) ? date( $f ) : date( $f, $d );

    }

    /**
     * genera una riga composta da un carattere ripetuto
     * 
     * Questa funzione restituisce il carattere $c ripetuto $w volte, senza fine riga. Se $w è negativo str_repeat()
     * lancia un errore, per cui i chiamanti devono evitare di calcolare larghezze negative.
     * 
     * @param       string      $c      il carattere da ripetere (default '-')
     * @param       int         $w      la lunghezza della riga (default REPORT_WIDTH)
     * 
     * @return      string              la riga
     * 
     */
    function txtLine( $c = '-', $w = REPORT_WIDTH ) {

	return str_repeat( $c, $w );

    }

    /**
     * genera una riga composta da un carattere ripetuto, con il fine riga
     * 
     * Questa funzione restituisce la stessa riga di txtLine() seguita da un fine riga.
     * 
     * @param       string      $c      il carattere da ripetere (default '-')
     * @param       int         $w      la lunghezza della riga (default REPORT_WIDTH)
     * 
     * @return      string              la riga, terminata da un fine riga
     * 
     */
    function txtFullLine( $c = '-', $w = REPORT_WIDTH ) {

	return txtLine( $c, $w ) . PHP_EOL;

    }

    /**
     * genera una riga di separazione che termina con data e ora correnti
     * 
     * Questa funzione restituisce una riga lunga $w caratteri composta dal carattere $c e chiusa da data e ora
     * correnti fra parentesi quadre, seguita da un fine riga; si usa per aprire e chiudere i report.
     * 
     * NOTA il parametro $d non viene usato: la data è sempre quella corrente.
     * 
     * @param       string      $c      il carattere della riga (default '-')
     * @param       int         $d      la timestamp da mostrare (default NULL, attualmente ignorata)
     * @param       int         $w      la lunghezza della riga (default REPORT_WIDTH)
     * 
     * @return      string              la riga, terminata da un fine riga
     * 
     */
    function txtDateTimeLine( $c = '-', $d = NULL, $w = REPORT_WIDTH ) {

	$ts = '[ ' . txtDateTime() . ' ]';

	$w -= strlen( $ts );

	return txtLine( $c, $w ) . $ts . PHP_EOL;

    }

    /**
     * FUNZIONI PER DATI E TABELLE
     */

    /**
     * genera una riga con un'etichetta a sinistra e un valore a destra
     * 
     * Questa funzione restituisce una riga lunga $w caratteri con l'etichetta allineata a sinistra, il valore
     * allineato a destra e lo spazio fra i due riempito con il carattere $c, seguita da un fine riga. Se l'etichetta
     * è troppo lunga per stare accanto al valore viene accorciata al centro con riduciStringa(). Il valore non viene
     * mai accorciato: se è più lungo della riga i calcoli portano a larghezze negative e la funzione va in errore.
     * 
     * @param       string      $l      l'etichetta
     * @param       string      $d      il valore
     * @param       string      $c      il carattere di riempimento (default spazio)
     * @param       int         $w      la lunghezza della riga (default REPORT_WIDTH)
     * 
     * @return      string              la riga, terminata da un fine riga
     * 
     */
    function txtData( $l, $d, $c = ' ', $w = REPORT_WIDTH ) {

	$l .= ' ';
	$d = ' ' . $d;
	$m = $w - ( strlen( $d ) );

	if( strlen( $l ) > $m ) {
	    $l = riduciStringa( $l, $m - 1 );
	}

	$w -= strlen( $l ) + strlen( $d );

	return $l . txtLine( $c, $w ) . $d . PHP_EOL;

    }

    /**
     * stampa una tabella a colonne di larghezza fissa
     * 
     * Questa funzione stampa direttamente (con echo) una tabella: la prima riga contiene le intestazioni, seguita da una
     * riga di separazione, poi una riga per ogni elemento di $d. Le colonne sono quelle di $h, un array che associa la
     * chiave del campo alla larghezza della colonna; ogni valore è portato alla larghezza della colonna con
     * txt2fixed(). I valori vuoti (compresi 0 e '0') vengono sostituiti da '-', e i valori numerici dei campi il cui nome
     * comincia per timestamp vengono formattati come data e ora.
     * 
     * La funzione non restituisce niente: i chiamanti che la usano con echo txtTable() stampano quindi la tabella
     * durante la chiamata e poi una stringa vuota. Le righe di $d devono contenere tutte le chiavi di $h, altrimenti PHP
     * emette dei warning.
     * 
     * @param       array       $h      le colonne, nella forma chiave del campo => larghezza
     * @param       array       $d      le righe della tabella, array associativi con le chiavi di $h
     * @param       array       $l      le intestazioni delle colonne, nello stesso ordine di $h (default NULL, cioè le
     *                                  chiavi di $h)
     * @param       array       $c      i caratteri di riempimento per colonna, per chiave (default NULL, cioè spazio)
     * @param       array       $s      il lato di riempimento per colonna, per chiave, una delle costanti STR_PAD_*
     *                                  (default NULL, cioè STR_PAD_RIGHT)
     * @param       int         $w      la larghezza della tabella (default REPORT_WIDTH, attualmente ignorata)
     * 
     * @return      void
     * 
     */
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

    /**
     * FUNZIONI PER IL TESTO
     */

    /**
     * impagina un testo alla larghezza data, giustificandolo
     * 
     * Questa funzione manda a capo il testo alla larghezza $w con wordwrap() e, se $j è true, giustifica con justify()
     * tutte le righe tranne l'ultima e quelle che finiscono con un punto (cioè le ultime righe dei paragrafi). Se il testo
     * comincia con un trattino è considerato un elemento di elenco e non viene giustificato. Il risultato non termina con
     * un fine riga.
     * 
     * NB: fino al 2026-09-24 justify() veniva chiamata senza passare $w, per cui le righe venivano giustificate sempre a
     * REPORT_WIDTH caratteri anche quando $w era diverso.
     *
     * @param       string      $t      il testo da impaginare
     * @param       bool        $j      true per giustificare il testo (default true)
     * @param       int         $w      la larghezza del testo (default REPORT_WIDTH)
     * 
     * @return      string              il testo impaginato
     * 
     */
    function txtText( $t, $j = true, $w = REPORT_WIDTH ) {

	$t = wordwrap( $t, $w, "\n" );

    if( substr( $t, 0, 1 ) == '-' ) {
        $j = false;
    }

    if( $j === true ) {
	    $lines = explode( "\n", $t );
	    foreach( $lines as $key => &$line ) {
		if( substr( $line, -1 ) != '.' && $key !== array_key_last( $lines ) ) {
		    $line = justify( $line, $w );
		}
	    }
	    return implode( "\n", $lines );
	} else {
	    return $t;
	}

    }

    /**
     * impagina un testo alla larghezza data, con il fine riga
     * 
     * Questa funzione restituisce il testo impaginato da txtText() seguito da un fine riga.
     * 
     * @param       string      $t      il testo da impaginare
     * @param       bool        $j      true per giustificare il testo (default true)
     * @param       int         $w      la larghezza del testo (default REPORT_WIDTH)
     * 
     * @return      string              il testo impaginato, terminato da un fine riga
     * 
     */
    function txtFullText( $t, $j = true, $w = REPORT_WIDTH ) {
        return txtText( $t, $j, $w ) . PHP_EOL;
    }

    /**
     * genera un sottotitolo seguito da una riga di riempimento
     * 
     * Questa funzione restituisce il sottotitolo seguito da uno spazio e dal carattere $c ripetuto fino alla larghezza
     * $w, e da un fine riga. Il sottotitolo non viene accorciato, per cui se è più lungo della riga la funzione va in
     * errore.
     * 
     * NOTA il parametro $d non viene usato.
     * 
     * @param       string      $t      il sottotitolo
     * @param       string      $c      il carattere di riempimento (default '-')
     * @param       mixed       $d      non usato (default NULL)
     * @param       int         $w      la lunghezza della riga (default REPORT_WIDTH)
     * 
     * @return      string              la riga del sottotitolo, terminata da un fine riga
     * 
     */
    function txtSubtitle( $t, $c = '-', $d = NULL, $w = REPORT_WIDTH ) {

        $t .= ' ';

        $w -= strlen( $t );
    
        return $t . txtLine( $c, $w ) . PHP_EOL;
    
    }
    

    /**
     * giustifica una riga di testo alla larghezza data
     * 
     * Questa funzione distribuisce gli spazi fra le parole della riga in modo che la riga sia lunga esattamente $maxlen
     * caratteri, mettendo gli spazi più larghi all'inizio; se la riga non contiene spazi viene centrata. Le lunghezze
     * sono calcolate con le funzioni mb_*.
     * 
     * NOTA se la riga è lunga almeno $maxlen caratteri viene mandata a capo con wordwrap() e la funzione tiene soltanto
     * la prima parte, per cui il resto del testo va perso: va chiamata su righe già spezzate alla larghezza giusta, come
     * fa txtText().
     * 
     * @param       string      $str        la riga da giustificare
     * @param       int         $maxlen     la larghezza da ottenere (default REPORT_WIDTH)
     * 
     * @return      string                  la riga giustificata
     * 
     */
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

    /**
     * porta una stringa a una larghezza fissa
     * 
     * Questa funzione restituisce la stringa portata a $w caratteri, compreso uno spazio di separazione dalla colonna
     * accanto: se è più lunga viene accorciata al centro con riduciStringa(), se è più corta viene riempita con il
     * carattere $c dal lato indicato da $s. Lo spazio di separazione viene messo a destra con STR_PAD_RIGHT e a sinistra
     * con STR_PAD_LEFT; con STR_PAD_BOTH non viene aggiunto e la stringa risulta lunga $w - 1 caratteri.
     * 
     * @param       string      $t      la stringa
     * @param       int         $w      la larghezza da ottenere
     * @param       string      $c      il carattere di riempimento (default spazio)
     * @param       int         $s      il lato di riempimento, una delle costanti STR_PAD_* (default STR_PAD_RIGHT)
     * 
     * @return      string              la stringa a larghezza fissa
     * 
     */
    function txt2fixed( $t, $w, $c = ' ', $s = STR_PAD_RIGHT ) {

	if( strlen( $t ) >= $w ) {
	    $x = riduciStringa( $t, $w - 1 );
	} else {
	    $x = str_pad( $t, $w - 1, $c, $s );
	}

	return
        ( ( $s == STR_PAD_LEFT ) ? ' ' : NULL ) . 
        $x . 
        ( ( $s == STR_PAD_RIGHT ) ? ' ' : NULL );

    }

    /**
     * FUNZIONI VARIE
     */

    /**
     * codifica un percorso per l'uso in un URL lasciando intatte le barre
     * 
     * Questa funzione divide il percorso sulle barre, codifica ogni parte con rawurlencode() (gli spazi diventano %20)
     * e la ricompone, in modo che le barre che separano le directory non vengano codificate.
     * 
     * @param       string      $u      il percorso da codificare
     * 
     * @return      string              il percorso codificato
     * 
     */
    function betterUrlEncode( $u ) {

        return implode('/', array_map('rawurlencode', explode('/', $u)));

    }

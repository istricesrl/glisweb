<?php

    /**
     * controller di append di default
     *
     * I controller di append sono l'ultimo passaggio prima che la query venga eseguita, e vedono
     * quindi il blocco dati nella sua versione definitiva.
     *
     * NORMALIZZAZIONE DEI NUMERI
     * --------------------------
     * La sostituzione della virgola con il punto c'è anche in _default.before.php, e qui viene
     * rifatta apposta: non è una svista. L'ordine di inclusione dei controller è
     *
     *     default/before  ->  <entità>/before  ->  append  ->  QUERY
     *
     * per cui la normalizzazione fatta in before vede solo i dati in ingresso, e NON quelli che un
     * controller di before successivo calcola e scrive dopo di lei. Un valore nato lì arriva alla
     * query così com'è.
     *
     * Non è un caso di scuola. Il runlevel _195.localization.php applica la locale del sito
     * ( per un sito italiano compone "it_IT.UTF8" ), e fino a PHP 7.4 incluso la conversione
     * implicita di un float in stringa segue LC_NUMERIC: il prezzo 4082.5 diventa la stringa
     * "4082,5", MySQL la rifiuta e la scrittura fallisce. In silenzio, perché mysqlPreparedQuery()
     * non controlla l'esito di mysqli_stmt_execute(): logga "-> OK" lo stesso e restituisce un
     * insert_id che vale 0. Il risultato è una pagina che risponde 200, un log che dice "record
     * INSERITO" e nessuna riga in archivio. Da PHP 8.0 la conversione non è più localizzata e il
     * problema non si presenta, ma i deploy su PHP 7 sono ancora parecchi.
     *
     * Il testo libero non viene toccato: la condizione chiede che il valore resti un numero anche
     * togliendo le virgole, quindi una nota tipo "macchina 12,5 tonnellate" passa intatta.
     *
     * La regola applicata è la stessa di _default.before.php, copiata identica: si tocca solo ciò
     * che resta un numero anche togliendo le virgole, e ci si limita a sostituire la virgola con il
     * punto. Essendo idempotente, rifarla su valori già normalizzati non ha alcun effetto.
     *
     * TODO come agire nei controller append
     * TODO documentare
     *
     * 
     *
     */

    // log
	logWrite( "controller default/append per $t/$a", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

		// elaboro l'array dei valori
            foreach( $vs as $vKey => $vVal ) {

                // nei numeri sostituisco la , con il .
                    if(( ! empty( $vVal['s'] ) && is_numeric( str_replace( ',', '', $vVal['s'] ) ) ) ) {
                        $vs[ $vKey ]['s'] = str_replace(',','.',$vs[ $vKey ]['s']);
                    }
		    }

	    break;

	}

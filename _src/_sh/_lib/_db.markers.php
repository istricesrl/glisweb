<?php

    /**
     * Logica di derivazione dei marcatori di STRUTTURA dello schema.
     *
     * La struttura di una tabella non e' un'opinione: si legge dalla tabella stessa. Questo file
     * la deriva e riscrive i marcatori `-- struttura:` nei sorgenti dello schema, cosi' marcatore
     * e realta' non possono divergere per costruzione.
     *
     * Le tre strutture, in ordine di precedenza:
     *
     *   ricorsiva      la tabella ha `id_genitore`, cioe' fa riferimento a se stessa. Si porta
     *                  dietro tre funzioni SQL ( <tabella>_path, _path_check, _ancestor ).
     *   di relazione   la tabella ha un indice UNIQUE su due o tre colonne `id_*`, che sono i capi
     *                  della relazione. E' il pattern del molti-a-molti.
     *   base           tutto il resto.
     *
     * PERCHE' `ricorsiva` VINCE sulla sovrapposizione. `organizzazioni` ha sia `id_genitore` sia
     * l'UNIQUE, ed e' l'unico caso. Vince `ricorsiva` perche' e' l'unica struttura con conseguenze
     * operative: porta con se' una corte di funzioni, mentre `di relazione` oggi non porta niente.
     * Decisione del 15/09/2026.
     *
     * PERCHE' DUE O TRE COLONNE E NON "DUE O PIU'". Una relazione lega due entita', a volte con un
     * qualificatore ( `contratti_anagrafica` e' contratto + anagrafica + ruolo ). Oltre le tre,
     * l'UNIQUE non descrive piu' una relazione ma una chiave di business: `corrispondenza` ne ha
     * sei — tipologia, peso, formato, mittente, organizzazione, commesso — ed e' una tabella
     * principale con molti attributi, non un legame. Quei casi NON si indovinano: si segnalano e
     * li guarda una persona.
     *
     * @file
     *
     */

    /**
     * legge i sorgenti dello schema e ne ricava, per ogni tabella, struttura dichiarata e derivata
     *
     * @param   array   $sorgenti   percorsi dei file .sql delle tabelle
     * @param   array   $indici     percorsi dei file .sql degli indici
     *
     * @return  array               una voce per tabella: dichiarata, derivata, riga, file, dubbia
     */
    function dbMarkersAnalizza( $sorgenti, $indici ) {

        // gli UNIQUE su sole colonne id_*, per tabella
        $unici = array();

        foreach( $indici as $f ) {

            $t = file_get_contents( $f );

            if( ! preg_match_all( '/ALTER TABLE `([a-z_0-9]+)`(.*?);/s', $t, $mm, PREG_SET_ORDER ) ) {
                continue;
            }

            foreach( $mm as $m ) {

                if( ! preg_match_all( '/UNIQUE KEY `[a-z_0-9]+` \(([^)]*)\)/', $m[2], $uu ) ) {
                    continue;
                }

                foreach( $uu[1] as $u ) {

                    $cols = array_map( function( $c ) { return trim( $c, " `\t" ); }, explode( ',', $u ) );

                    // solo chiavi esterne: un UNIQUE che comprende una colonna non id_* e' una
                    // chiave di business, non i capi di una relazione
                    foreach( $cols as $c ) {
                        if( strpos( $c, 'id_' ) !== 0 ) { continue 2; }
                    }

                    if( count( $cols ) < 2 ) { continue; }

                    $unici[ $m[1] ][] = $cols;

                }

            }

        }

        // le tabelle, con la struttura dichiarata e la riga in cui e' scritta
        $out = array();

        foreach( $sorgenti as $f ) {

            $righe = explode( "\n", file_get_contents( $f ) );

            $nome = NULL;
            $rigaStruttura = NULL;
            $dichiarata = NULL;

            foreach( $righe as $i => $r ) {

                if( preg_match( '/^-- ([a-z_][a-z_0-9]*)$/', $r, $m ) ) {
                    $nome = $m[1];
                    $rigaStruttura = NULL;
                    $dichiarata = NULL;
                    continue;
                }

                if( preg_match( '/^-- struttura: (.+)$/', $r, $m ) ) {
                    $rigaStruttura = $i;
                    $dichiarata = trim( $m[1] );
                    continue;
                }

                if( ! preg_match( '/^CREATE TABLE (?:IF NOT EXISTS )?`([a-z_0-9]+)`/', $r, $m ) ) {
                    continue;
                }

                $tabella = $m[1];

                // il corpo della CREATE, per cercarci id_genitore
                $corpo = '';
                for( $j = $i; $j < count( $righe ); $j++ ) {
                    $corpo .= $righe[ $j ] . "\n";
                    if( preg_match( '/^\) ENGINE/', $righe[ $j ] ) ) { break; }
                }

                $ricorsiva = (bool) preg_match( '/^\s+`id_genitore`/m', $corpo );

                // l'UNIQUE di relazione: da due a tre colonne, tutte chiavi esterne
                $relazione = false;
                $dubbia = NULL;

                if( isset( $unici[ $tabella ] ) ) {
                    foreach( $unici[ $tabella ] as $cols ) {
                        if( count( $cols ) <= 3 ) { $relazione = true; }
                        else { $dubbia = count( $cols ); }
                    }
                }

                // precedenza: ricorsiva vince
                if( $ricorsiva )      { $derivata = 'tabella ricorsiva'; }
                elseif( $relazione )  { $derivata = 'tabella di relazione'; }
                else                  { $derivata = 'tabella base'; }

                $out[] = array(
                    'tabella'     => $tabella,
                    'intestazione'=> $nome,
                    'file'        => $f,
                    'riga'        => $rigaStruttura,
                    'dichiarata'  => $dichiarata,
                    'derivata'    => $derivata,
                    'ricorsiva'   => $ricorsiva,
                    'dubbia'      => $dubbia
                );

                $nome = NULL;
                $rigaStruttura = NULL;
                $dichiarata = NULL;

            }

        }

        return $out;

    }

    /**
     * riscrive i marcatori `-- struttura:` che non corrispondono alla struttura derivata
     *
     * Chi non ha il marcatore non lo riceve da qui: aggiungerlo vorrebbe dire indovinare dove
     * inserirlo nel blocco di commento, e un blocco di commento non ha una forma garantita. Le
     * tabelle senza marcatore si segnalano e le scrive una persona, una volta sola.
     *
     * @param   array   $voci   l'esito di dbMarkersAnalizza()
     * @param   bool    $secco  true = non scrive, elenca soltanto
     *
     * @return  array           conteggi: corretti, gia_giusti, senza_marcatore, dubbie
     */
    function dbMarkersRiscrivi( $voci, $secco = false ) {

        $esito = array( 'corretti' => 0, 'gia_giusti' => 0, 'senza_marcatore' => 0, 'dubbie' => 0 );

        // si raggruppa per file: si legge e si riscrive una volta sola, cosi' l'inode non balla
        $perFile = array();

        foreach( $voci as $v ) {

            if( $v['dubbia'] !== NULL ) {
                echo sprintf( "  ? %-32s UNIQUE su %d colonne: non si indovina, guardala\n", $v['tabella'], $v['dubbia'] );
                $esito['dubbie']++;
            }

            if( $v['riga'] === NULL ) {
                echo sprintf( "  - %-32s nessun marcatore: andrebbe %s\n", $v['tabella'], $v['derivata'] );
                $esito['senza_marcatore']++;
                continue;
            }

            if( $v['dichiarata'] === $v['derivata'] ) {
                $esito['gia_giusti']++;
                continue;
            }

            echo sprintf( "  ~ %-32s %s -> %s\n", $v['tabella'], $v['dichiarata'], $v['derivata'] );
            $esito['corretti']++;

            $perFile[ $v['file'] ][ $v['riga'] ] = '-- struttura: ' . $v['derivata'];

        }

        if( $secco ) {
            return $esito;
        }

        foreach( $perFile as $f => $sostituzioni ) {

            $righe = explode( "\n", file_get_contents( $f ) );

            foreach( $sostituzioni as $i => $nuova ) {
                $righe[ $i ] = $nuova;
            }

            // file_put_contents scrive sul posto e non tocca l'inode: gli hard link con l'altro
            // deploy di sviluppo reggono. Vale la pena ricordarlo qui perche' la tentazione di
            // usare un temporaneo piu' un rename, che sembra piu' prudente, li spezzerebbe tutti.
            file_put_contents( $f, implode( "\n", $righe ) );

        }

        return $esito;

    }

    /**
     * controlla i marcatori di patch `-- |` dei file dello schema
     *
     * Il task _mysql.patch.php accumula le righe e ESEGUE la patch quando incontra il marcatore
     * SUCCESSIVO. Da qui tre modi di perdere SQL senza un errore e senza una riga di log:
     *
     *  - SQL dopo l'ultimo marcatore: non lo esegue nessuno. E' il motivo per cui ogni file
     *    finisce con la sentinella `-- | FINE FILE`, che serve solo a scaricare l'ultima patch;
     *  - marcatori non crescenti: il patch level del database e' l'id piu' alto gia' applicato, e
     *    il confronto e' fra STRINGHE. Un marcatore piu' basso di uno precedente non gira mai;
     *  - marcatori duplicati: il secondo viene saltato per lo stesso motivo.
     *
     * Il caso peggiore e' `FINE FILE` in mezzo al file: 'F' viene dopo '9', quindi se qualcuno ci
     * infila dell'SQL sotto, quella patch viene registrata con id "FINE FILE" e da quel momento
     * OGNI patch successiva risulta gia' applicata.
     *
     * @param   array   $file   percorsi dei .sql da controllare
     *
     * @return  array           un rilievo per riga, vuoto se e' tutto a posto
     */
    function dbMarkersPatch( $file ) {

        $rilievi = array();

        foreach( $file as $f ) {

            $righe = explode( "\n", file_get_contents( $f ) );
            $nome  = basename( $f );

            $marc = array();
            foreach( $righe as $i => $r ) {
                if( strpos( trim( $r ), '-- |' ) === 0 ) {
                    $marc[] = array( $i, trim( substr( trim( $r ), 4 ) ) );
                }
            }

            if( ! $marc ) {
                $rilievi[] = sprintf( '%-46s nessun marcatore di patch', $nome );
                continue;
            }

            $ids = array_column( $marc, 1 );

            foreach( array_count_values( $ids ) as $id => $n ) {
                if( $n > 1 ) {
                    $rilievi[] = sprintf( '%-46s marcatore duplicato: %s', $nome, $id );
                }
            }

            for( $i = 1; $i < count( $ids ); $i++ ) {
                if( ! ( $ids[ $i - 1 ] < $ids[ $i ] ) ) {
                    $rilievi[] = sprintf( '%-46s marcatori non crescenti: %s -> %s', $nome, $ids[ $i - 1 ], $ids[ $i ] );
                }
            }

            $coda = 0;
            for( $i = end( $marc )[0] + 1; $i < count( $righe ); $i++ ) {
                if( preg_match( '/^\s*[A-Za-z]/', $righe[ $i ] ) ) { $coda++; }
            }

            if( $coda ) {
                $rilievi[] = sprintf( '%-46s %d righe di SQL dopo l\'ultimo marcatore: non le esegue nessuno', $nome, $coda );
            }

        }

        return $rilievi;

    }

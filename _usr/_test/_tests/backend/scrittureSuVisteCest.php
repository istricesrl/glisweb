<?php

    /**
     * test delle scritture del codice: si scrive nelle tabelle, mai nelle viste
     *
     * che una vista accetti le scritture dipende dalla sua definizione, che cambia coi riallineamenti dello schema: il
     * 05/11/2026 su utensilerialughese caratteristiche_prodotti, vista dal 01/10 con una colonna derivata, e' diventata
     * non inseribile, due importazioni di progetto ci scrivevano dentro e hanno preso l'errore 1471 su 11.481 scritture;
     * oggi la vista e' di nuovo inseribile, e un test che guardasse solo il risultato passerebbe anche sul codice di allora
     *
     * quindi la regola si controlla sul sorgente: per ogni file PHP di _src/ e src/, e di _mod/ e mod/ dei moduli attivi,
     * si raccolgono le tabelle di destinazione - il terzo argomento di mysqlInsertRow() quando e' una stringa, e le
     * tabelle delle INSERT, REPLACE, UPDATE e DELETE scritte nelle stringhe - e si chiede a information_schema che
     * nel database del deploy non siano VIEW; le librerie esterne non si leggono
     *
     * le destinazioni in variabile non si possono risolvere qui e si saltano; una tabella che nel database non c'e'
     * non e' una vista, e non si segnala
     *
     */

    class scrittureSuVisteCest {

        // nessun sorgente del deploy scrive in una vista
        public function nienteScrittureSulleViste( BackendTester $I ) {

            global $cf;

            $cartelle = array( DIR_BASE . '_src/', DIR_BASE . 'src/' );

            foreach( $cf['mods']['active']['array'] as $modulo ) {
                $cartelle[] = DIR_BASE . '_mod/_' . $modulo . '/';
                $cartelle[] = DIR_BASE . 'mod/' . $modulo . '/';
            }

            // tabella => elenco dei punti in cui la si scrive
            $scritture = array();

            foreach( $cartelle as $cartella ) {

                if( ! is_dir( $cartella ) ) {
                    continue;
                }

                $file = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $cartella, FilesystemIterator::SKIP_DOTS ) );

                foreach( $file as $f ) {

                    if( substr( $f, -4 ) !== '.php' || preg_match( '/\/_?ext\//', $f ) ) {
                        continue;
                    }

                    foreach( $this->destinazioni( file_get_contents( $f ) ) as $tabella => $righe ) {
                        foreach( $righe as $riga ) {
                            $scritture[ $tabella ][] = str_replace( DIR_BASE, '', $f ) . ':' . $riga;
                        }
                    }

                }

            }

            $I->assertNotEmpty( $scritture, 'nessuna scrittura riconosciuta: il riconoscimento delle destinazioni non funziona' );

            $viste = array();

            foreach( $scritture as $tabella => $punti ) {

                $tipo = $I->grabFromDatabase(
                    'SELECT table_type FROM information_schema.tables WHERE table_schema = database() AND table_name = ?',
                    array( $tabella )
                );

                if( $tipo === 'VIEW' ) {
                    foreach( $punti as $punto ) {
                        $viste[] = $punto . ' scrive nella vista ' . $tabella;
                    }
                }

            }

            $I->assertEmpty( $viste, implode( "\n", $viste ) );

        }

        /**
         * le tabelle in cui scrive un sorgente PHP
         *
         * @param       string      $sorgente       il codice
         *
         * @return      array                       tabella => righe del sorgente in cui la si scrive
         *
         */
        protected function destinazioni( $sorgente ) {

            $tabelle = array();
            $token = token_get_all( $sorgente );
            $n = count( $token );

            foreach( $token as $i => $t ) {

                // il terzo argomento di mysqlInsertRow(), se e' una stringa
                if( is_array( $t ) && $t[0] === T_STRING && strtolower( $t[1] ) === 'mysqlinsertrow' ) {

                    $profondita = 0;
                    $argomento = 0;

                    for( $j = $i + 1; $j < $n; $j++ ) {

                        $c = $token[ $j ];

                        if( $c === '(' || $c === '[' ) {
                            $profondita++;
                        } elseif( $c === ')' || $c === ']' ) {
                            if( --$profondita <= 0 ) {
                                break;
                            }
                        } elseif( $c === ',' && $profondita === 1 ) {
                            $argomento++;
                        } elseif( $argomento === 2 && $profondita === 1 && is_array( $c ) && $c[0] === T_CONSTANT_ENCAPSED_STRING ) {
                            $tabelle[ trim( $c[1], '\'"' ) ][] = $c[2];
                        } elseif( $profondita === 0 && $c === ';' ) {
                            break;
                        }

                    }

                }

                // le tabelle scritte nelle query; ON DUPLICATE KEY UPDATE e' seguito da una colonna, non da una tabella
                if( is_array( $t ) && $t[0] === T_CONSTANT_ENCAPSED_STRING ) {
                    if( preg_match_all( '/\b(?:INSERT(?:\s+IGNORE)?\s+INTO|REPLACE\s+INTO|(?<!KEY\s)UPDATE|DELETE\s+FROM)\s+`?([a-z_][a-z0-9_]*)`?/i', $t[1], $m ) ) {
                        foreach( $m[1] as $tabella ) {
                            $tabelle[ $tabella ][] = $t[2];
                        }
                    }
                }

            }

            return $tabelle;

        }

    }

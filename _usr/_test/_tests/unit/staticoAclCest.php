<?php

    /**
     * test statico delle chiavi di $cf['auth']['permissions']
     *
     * in _src/_config/_250.auth.php l'array dei permessi per tabella e' scritto a mano, e una tabella dichiarata due
     * volte non da' errore: PHP tiene l'ultima e la prima resta li', codice morto che chi legge prende per buono;
     * fino al 2026-11-10 'valutazioni' compariva due volte, la prima con il solo roots e la seconda con lo staff
     * ( punto 6 dello schema canonico, riga 232 )
     *
     * il test legge il sorgente e non lo esegue, perche' a runtime le doppie non si vedono; le doppie che c'erano gia'
     * il 2026-11-10 sono nell'elenco $note, che si puo' solo accorciare: una doppia nuova fa fallire il test, e cosi'
     * una doppia dell'elenco che e' stata sistemata, finche' non la si toglie dall'elenco
     *
     */

    class staticoAclCest {

        // le doppie trovate il 2026-11-10, da sistemare una per una ( tabella => volte )
        protected $note = array(
            'audio' => 2,
            'campagne' => 2,
            'contatti' => 2,
            'listini' => 4,
            'listini_clienti' => 3,
            'listini_gruppi' => 4,
            'listini_zone' => 3,
            'macro' => 2,
            'matricole' => 2,
            'menu' => 2,
            'sconti' => 2,
            'sconti_articoli' => 2,
            'sconti_listini' => 2,
            'tipologie_sconti' => 2,
            'todo' => 2,
            'video' => 2
        );

        // conta le chiavi di primo livello dell'array dei permessi, leggendo i token del sorgente
        protected function chiavi() {

            $token = token_get_all( file_get_contents( DIR_BASE . '_src/_config/_250.auth.php' ) );

            $dentro = false;
            $livello = 0;
            $chiavi = array();

            foreach( $token as $i => $t ) {

                $testo = is_array( $t ) ? $t[1] : $t;

                // l'array comincia dopo la chiave 'permissions'
                if( ! $dentro ) {
                    if( is_array( $t ) && $t[0] == T_CONSTANT_ENCAPSED_STRING && $testo == "'permissions'" ) {
                        $dentro = true;
                    }
                    continue;
                }

                if( $testo == '(' ) { $livello++; continue; }
                if( $testo == ')' ) { $livello--; if( $livello == 0 ) { break; } continue; }

                // una stringa al primo livello seguita da => e' una chiave
                if( $livello == 1 && is_array( $t ) && $t[0] == T_CONSTANT_ENCAPSED_STRING ) {
                    $j = $i + 1;
                    while( isset( $token[ $j ] ) && is_array( $token[ $j ] ) && $token[ $j ][0] == T_WHITESPACE ) { $j++; }
                    if( isset( $token[ $j ] ) && is_array( $token[ $j ] ) && $token[ $j ][0] == T_DOUBLE_ARROW ) {
                        $chiave = trim( $testo, "'\"" );
                        $chiavi[ $chiave ] = ( $chiavi[ $chiave ] ?? 0 ) + 1;
                    }
                }

            }

            return $chiavi;

        }

        // nessuna tabella dichiarata due volte, salvo le doppie note
        public function nessunaDoppiaNuova( UnitTester $I ) {

            $chiavi = $this->chiavi();

            $I->assertGreaterThan( 100, count( $chiavi ), 'trovate meno di cento tabelle: il test non legge l\'array giusto' );

            $doppie = array_filter( $chiavi, function( $n ) { return $n > 1; } );

            foreach( $doppie as $tabella => $n ) {
                $I->assertSame( $this->note[ $tabella ] ?? 1, $n, $tabella . ' e\' dichiarata ' . $n . ' volte in $cf[\'auth\'][\'permissions\']' );
            }

            foreach( $this->note as $tabella => $n ) {
                $I->assertSame( $n, $chiavi[ $tabella ] ?? 0, $tabella . ' non e\' piu\' doppia come prima: toglila da $note' );
            }

        }

        // valutazioni una volta sola, con lo staff, e la sua tabella delle caratteristiche
        public function valutazioni( UnitTester $I ) {

            global $cf;

            $chiavi = $this->chiavi();

            $I->assertSame( 1, $chiavi['valutazioni'] ?? 0, 'valutazioni deve essere dichiarata una volta sola' );
            $I->assertSame( 1, $chiavi['valutazioni_caratteristiche'] ?? 0, 'manca valutazioni_caratteristiche' );
            $I->assertSame( array( 'staff' ), $cf['auth']['permissions']['valutazioni'][ CONTROL_FILTERED ] ?? NULL, 'lo staff deve gestire le sue valutazioni' );
            $I->assertSame( array( 'roots' ), $cf['auth']['permissions']['valutazioni_caratteristiche'][ CONTROL_FULL ] ?? NULL, 'valutazioni_caratteristiche come immobili_caratteristiche' );

        }

        // valute come le altre tabelle standard di consultazione: le gestisce solo roots, lo staff le legge
        // ( fino al 2026-11-10 non aveva una voce; punto 6 dello schema canonico, riga 234 )
        public function valute( UnitTester $I ) {

            global $cf;

            $chiavi = $this->chiavi();

            $I->assertSame( 1, $chiavi['valute'] ?? 0, 'valute deve essere dichiarata una volta sola' );
            $I->assertSame( $cf['auth']['permissions']['udm'], $cf['auth']['permissions']['valute'] ?? NULL, 'valute come udm' );

        }

        // taglie come le altre tabelle assistite: le gestisce solo roots, lo staff le legge
        // ( fino al 2026-11-10 non aveva una voce; punto 6 dello schema canonico, riga 235 )
        public function taglie( UnitTester $I ) {

            global $cf;

            $chiavi = $this->chiavi();

            $I->assertSame( 1, $chiavi['taglie'] ?? 0, 'taglie deve essere dichiarata una volta sola' );
            $I->assertSame( $cf['auth']['permissions']['udm'], $cf['auth']['permissions']['taglie'] ?? NULL, 'taglie come udm' );

        }

    }

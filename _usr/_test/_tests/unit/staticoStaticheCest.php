<?php

    /**
     * test statico delle viste statiche del canone
     *
     * la forma della famiglia ( decisione di Fabio del 12/11/2026, schema canonico punto 6 righe 251-255 ): una
     * <t>_view_static di _080000999999.static.sql e' la sua <t>_view di _090000999999.views.sql colonna per colonna, e
     * sta nel canone solo con la sua corte di task ( popolazione, pulizia, svuotamento ), perche' getStaticViewExtension()
     * la legge appena esiste; il 11/11/2026 documenti_view_static, nata senza corte, ha svuotato gli elenchi dei
     * documenti di polmasi PROD
     *
     * il test legge i sorgenti e non li esegue
     *
     */

    class staticoStaticheCest {

        // statiche ancora senza corte in latest: l'elenco si accorcia, non si allunga ( TODO di glisdev, corti delle statiche )
        private $senzaCorte = array( 'offerte', 'todo' );

        // le statiche attive del file base, senza le CREATE commentate
        private function statiche() {

            $sql = file_get_contents( DIR_BASE . '_usr/_database/_patch/_080000999999.static.sql' );

            preg_match_all( '/^CREATE TABLE IF NOT EXISTS `([a-z0-9_]+)_view_static` \((.*?)\n\) ENGINE/ms', $sql, $m, PREG_SET_ORDER );

            $r = array();
            foreach( $m as $s ) {
                preg_match_all( '/^\s*`([a-z0-9_]+)`\s/m', $s[2], $c );
                $r[ $s[1] ] = $c[1];
            }

            return $r;

        }

        // ogni statica ha popolazione, pulizia e svuotamento, nel nucleo o in un modulo
        public function staticheConCorte( UnitTester $I ) {

            $statiche = $this->statiche();
            $I->assertNotEmpty( $statiche, 'nessuna statica trovata nel 080: il test non prova niente' );

            $senza = array();
            foreach( array_keys( $statiche ) as $t ) {
                foreach( array( 'popolazione', 'pulizia', 'svuotamento' ) as $task ) {
                    $file = array_merge(
                        (array) glob( DIR_BASE . '_src/_api/_task/_' . $t . '.view.static.' . $task . '.php' ),
                        (array) glob( DIR_BASE . '_mod/*/_src/_api/_task/_' . $t . '.view.static.' . $task . '.php' )
                    );
                    if( empty( $file ) && ! in_array( $t, $this->senzaCorte ) ) {
                        $senza[] = $t . '.view.static.' . $task;
                    }
                }
            }

            $I->assertEmpty( $senza, 'statiche senza la loro corte di task: ' . implode( ', ', $senza ) );

        }

        // una statica che ha avuto la sua corte esce dall'elenco delle eccezioni
        public function eccezioniAncoraSenzaCorte( UnitTester $I ) {

            foreach( $this->senzaCorte as $t ) {
                $I->assertEmpty(
                    glob( DIR_BASE . '{_src,_mod/*/_src}/_api/_task/_' . $t . '.view.static.popolazione.php', GLOB_BRACE ),
                    $t . '_view_static ha il task di popolazione: va tolta da $senzaCorte'
                );
            }

        }

        // la statica ha le stesse colonne della sua vista, senza colonne proprie
        public function staticheUgualiAllaVista( UnitTester $I ) {

            $viste = file_get_contents( DIR_BASE . '_usr/_database/_patch/_090000999999.views.sql' );

            $diverse = array();
            foreach( $this->statiche() as $t => $colonne ) {

                // la vista, fino alla vista successiva ( un punto e virgola puo' stare dentro un separatore o un commento )
                $I->assertMatchesRegularExpression( '/CREATE OR REPLACE VIEW `' . $t . '_view` AS/', $viste, 'manca ' . $t . '_view nel 090' );
                $da = strpos( $viste, 'CREATE OR REPLACE VIEW `' . $t . '_view` AS' );
                $a = strpos( $viste, 'CREATE OR REPLACE VIEW', $da + 1 );
                $vista = ( $a === false ) ? substr( $viste, $da ) : substr( $viste, $da, $a - $da );
                $vista = preg_replace( '/--[^\n]*/', '', $vista );

                // le colonne della vista sono gli alias, o il nome della colonna se non c'e' alias
                foreach( $colonne as $col ) {
                    if( ! preg_match( '/(\bAS\s+`?' . $col . '`?|[.`]' . $col . '`?)\s*(,|\bFROM\b)/i', $vista ) ) {
                        $diverse[] = $t . '_view_static.' . $col;
                    }
                }

            }

            $I->assertEmpty( $diverse, 'colonne della statica che la vista non espone: ' . implode( ', ', $diverse ) );

        }

    }

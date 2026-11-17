<?php

    /**
     * test statico delle patch datate di _usr/_database/_patch/
     *
     * mysqlPatchApply() esegue ogni blocco ( da un marcatore -- | <livello> al successivo ) con una sola mysqli_query(),
     * quindi un blocco con due istruzioni fallisce con 1064 e ferma la coda di tutti i deploy: dal 07 al 10/11/2026
     * tutti i database sono rimasti a 202611061211, perche' il blocco 202611061212 aveva nove UPDATE; e quello che sta
     * dopo l'ultimo marcatore senza -- | FINE non si applica affatto
     *
     * il test legge le patch con mysqlPatchRead(), la stessa funzione del notturno, e non tocca nessun database
     *
     */

    class staticoPatchCest {

        // conta le istruzioni di un blocco: i ; fuori da stringhe e commenti, piu' l'eventuale coda senza ;
        private function istruzioni( $q ) {

            $n = 0; $dentro = NULL; $resto = false; $l = strlen( $q );

            for( $i = 0; $i < $l; $i++ ) {
                $c = $q[ $i ];
                if( $dentro ) {
                    if( $c === '\\' && $dentro !== '`' ) { $i++; continue; }
                    if( $c === $dentro ) { $dentro = NULL; }
                    continue;
                }
                if( ( $c === '-' && substr( $q, $i, 3 ) === '-- ' ) || $c === '#' ) { $e = strpos( $q, "\n", $i ); $i = ( $e === false ) ? $l : $e; continue; }
                if( $c === '/' && substr( $q, $i, 2 ) === '/*' ) { $e = strpos( $q, '*/', $i ); $i = ( $e === false ) ? $l : $e + 1; continue; }
                if( $c === "'" || $c === '"' || $c === '`' ) { $dentro = $c; $resto = true; continue; }
                if( $c === ';' ) { if( $resto ) { $n++; } $resto = false; continue; }
                if( ! ctype_space( $c ) ) { $resto = true; }
            }

            return $n + ( $resto ? 1 : 0 );

        }

        // i blocchi delle patch datate ( non dei file base, che si ricaricano con mysqlPatchReload() )
        private function blocchi( &$segnalazioni = array() ) {

            require_once DIR_BASE . '_src/_lib/_mysql.tools.php';

            $file = array_filter( mysqlPatchFiles( DIR_BASE ), function( $f ) { return preg_match( '/\/_?2\d{11}\.[^\/]+\.sql$/', $f ); } );

            return mysqlPatchRead( array_values( $file ), '0', $segnalazioni );

        }

        // una istruzione per blocco, salvo procedure, funzioni, trigger ed eventi, che hanno i ; nel corpo
        public function unaIstruzionePerBlocco( UnitTester $I ) {

            $blocchi = $this->blocchi();
            $I->assertNotEmpty( $blocchi, 'nessuna patch letta: il test non prova niente' );

            $multiple = array();
            foreach( $blocchi as $p ) {
                if( preg_match( '/CREATE\s+(OR\s+REPLACE\s+)?(DEFINER\s*=\s*\S+\s+)?(PROCEDURE|FUNCTION|TRIGGER|EVENT)\b/i', $p['query'] ) ) {
                    continue;
                }
                if( $this->istruzioni( $p['query'] ) > 1 ) {
                    $multiple[] = $p['id'] . ' ' . basename( $p['file'] );
                }
            }

            $I->assertEmpty( $multiple, 'blocchi con piu\' istruzioni, si fermano con 1064: ' . implode( ', ', $multiple ) );

        }

        // niente SQL dopo l'ultimo marcatore senza -- | FINE, niente id fuori ordine
        public function nienteSegnalazioni( UnitTester $I ) {

            $segnalazioni = array();
            $this->blocchi( $segnalazioni );

            $I->assertEmpty( $segnalazioni, implode( PHP_EOL, $segnalazioni ) );

        }

        // MariaDB 10.3 vuole ADD CONSTRAINT `x` FOREIGN KEY IF NOT EXISTS, e ADD CONSTRAINT IF NOT EXISTS lo rifiuta con 1064
        public function chiaviEsterneIfNotExists( UnitTester $I ) {

            $sbagliate = array();
            foreach( $this->blocchi() as $p ) {
                if( preg_match( '/ADD\s+CONSTRAINT\s+IF\s+NOT\s+EXISTS\s+\S+\s+FOREIGN\s+KEY/i', $p['query'] ) ) {
                    $sbagliate[] = $p['id'] . ' ' . basename( $p['file'] );
                }
            }

            $I->assertEmpty( $sbagliate, 'ADD CONSTRAINT IF NOT EXISTS ... FOREIGN KEY: ' . implode( ', ', $sbagliate ) );

        }

        // MySQL ammette al massimo 16 colonne per indice ( 1070 ), MariaDB 32: nelle patch e nel file base degli indici
        public function indiciAlMassimoSedici( UnitTester $I ) {

            $query = array();
            foreach( $this->blocchi() as $p ) {
                $query[ $p['id'] . ' ' . basename( $p['file'] ) ] = $p['query'];
            }
            $query['_030000999999.indexes.sql'] = file_get_contents( DIR_BASE . '_usr/_database/_patch/_030000999999.indexes.sql' );

            $lunghi = array();
            foreach( $query as $dove => $q ) {
                preg_match_all( '/\bKEY\s+(IF\s+NOT\s+EXISTS\s+)?`?([a-z0-9_]+)`?\s*\(([^)]*)\)/i', $q, $m, PREG_SET_ORDER );
                foreach( $m as $k ) {
                    if( count( explode( ',', $k[3] ) ) > 16 ) {
                        $lunghi[] = $dove . ' ' . $k[2];
                    }
                }
            }

            $I->assertEmpty( $lunghi, 'indici con piu\' di 16 colonne, MySQL li rifiuta con 1070: ' . implode( ', ', $lunghi ) );

        }

        // le viste del file base citano solo colonne che il CREATE TABLE del canone ha: su un database costruito da zero
        // una colonna rimasta solo sui deploy vecchi ferma la coda con 1054 ( carrelli.id_documento, 17/11/2026 )
        public function vistaColonneDelCanone( UnitTester $I ) {

            $d = DIR_BASE . '_usr/_database/_patch/';

            $colonne = array();
            preg_match_all( '/CREATE TABLE IF NOT EXISTS `([a-z0-9_]+)` \((.*?)\n\)/s', file_get_contents( $d . '_010000999999.tables.sql' ), $t, PREG_SET_ORDER );
            foreach( $t as $x ) {
                preg_match_all( '/^\s*`([a-z0-9_]+)`/m', $x[2], $c );
                $colonne[ $x[1] ] = array_flip( $c[1] );
            }
            $I->assertNotEmpty( $colonne, 'nessuna tabella letta: il test non prova niente' );

            $mancanti = array();
            $viste = preg_split( '/CREATE\s+OR\s+REPLACE\s+VIEW/i', preg_replace( '/--[^\n]*/', '', file_get_contents( $d . '_090000999999.views.sql' ) ) );
            foreach( $viste as $v ) {
                if( ! preg_match( '/^\s*`?([a-z0-9_]+)`?/', $v, $n ) ) { continue; }
                preg_match_all( '/\b([a-z_][a-z0-9_]*)\.`?([a-z_][a-z0-9_]*)`?/i', $v, $r, PREG_SET_ORDER );
                foreach( $r as $y ) {
                    if( isset( $colonne[ $y[1] ] ) && ! isset( $colonne[ $y[1] ][ $y[2] ] ) ) {
                        $mancanti[ $n[1] . ': ' . $y[1] . '.' . $y[2] ] = true;
                    }
                }
            }

            $I->assertEmpty( $mancanti, 'colonne che il canone non ha, 1054 su un database nuovo: ' . implode( ', ', array_keys( $mancanti ) ) );

        }

    }

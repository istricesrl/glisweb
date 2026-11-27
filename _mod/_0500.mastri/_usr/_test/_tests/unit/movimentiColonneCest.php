<?php

    /**
     * test statico delle colonne delle viste movimenti di _0500.mastri
     *
     * _default.view.php fa la SELECT di tutte le chiavi di $ct['view']['cols'], quindi una colonna che il report non ha
     * ferma la pagina con un errore SQL: fino al 24/11/2026 _mastri.form.movimenti.php ( magazzino ) e
     * _articoli.form.movimenti.php selezionavano e aprivano __report_movimenti_magazzini__.id_riga, che nel CREATE non
     * c'e' ( l'id del report e' gia' quello di documenti_articoli ), segnalato da bernispa
     *
     * il test confronta le chiavi attive ( non commentate con # ) delle colonne e il campo di apertura delle macro con il
     * CREATE del report in _usr/_database/_patch/_100000999999.reports.sql, e non tocca nessun database
     *
     */

    class movimentiColonneCest {

        // colonne del CREATE di una tabella in un file di patch
        private function colonne( $file, $tabella ) {

            $sql = file_get_contents( $file );
            if( ! preg_match( '/CREATE TABLE `' . preg_quote( $tabella, '/' ) . '` \((.*?)\n\) ENGINE/s', $sql, $m ) ) {
                return array();
            }

            preg_match_all( '/^\s*`([a-z0-9_]+)`/m', $m[1], $c );

            return $c[1];

        }

        // chiavi attive delle colonne e campo di apertura, dal punto in cui la macro sceglie la tabella
        private function vista( $file, $tabella ) {

            $php = file_get_contents( $file );
            $da = strpos( $php, "\$ct['view']['table'] = '" . $tabella . "';" );
            if( $da === false ) {
                return NULL;
            }

            $resto = substr( $php, $da );
            preg_match( "/\\\$ct\['view'\]\['open'\]\['field'\] = '([a-z0-9_]+)';/", $resto, $o );
            preg_match( "/\\\$ct\['view'\]\['cols'\] = array\((.*?)\n\s*\);/s", $resto, $a );

            $cols = array();
            foreach( explode( "\n", isset( $a[1] ) ? $a[1] : '' ) as $riga ) {
                if( preg_match( "/^\s*'([a-z0-9_]+)'\s*=>/", $riga, $k ) ) {
                    $cols[] = $k[1];
                }
            }

            return array( 'open' => isset( $o[1] ) ? $o[1] : NULL, 'cols' => $cols );

        }

        // le macro movimenti di _0500.mastri usano solo colonne che __report_movimenti_magazzini__ ha
        public function colonneNelReport( UnitTester $I ) {

            $tabella = '__report_movimenti_magazzini__';
            $report = $this->colonne( DIR_BASE . '_usr/_database/_patch/_100000999999.reports.sql', $tabella );
            $I->assertContains( 'id_mastro_provenienza', $report, 'CREATE di ' . $tabella . ' non letto: il test non prova niente' );

            foreach( array( '_mastri.form.movimenti.php', '_articoli.form.movimenti.php' ) as $macro ) {

                $v = $this->vista( DIR_BASE . '_mod/_0500.mastri/_src/_inc/_macro/' . $macro, $tabella );
                $I->assertNotNull( $v, $macro . ' non usa piu\' ' . $tabella . ': aggiornare il test' );
                $I->assertNotEmpty( $v['cols'], $macro . ': colonne non lette, il test non prova niente' );

                $mancanti = array_diff( array_merge( $v['cols'], array( $v['open'] ) ), $report );
                $I->assertEmpty( $mancanti, $macro . ': colonne assenti da ' . $tabella . ': ' . implode( ', ', $mancanti ) );

            }

        }

    }

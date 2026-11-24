<?php

    /**
     * test statico dei report di giacenza e movimenti dei magazzini
     *
     * updateReportGiacenzaMagazzini() e updateReportMovimentiMagazzini() ( _mod/_0500.mastri/_src/_lib/_mysql.utils.add.php )
     * scrivono la riga del report con mysqlInsertRow(), che fallisce se una colonna non esiste: dal 02/03/2026
     * ( d975b4a15 ) i CREATE delle due tabelle erano spariti dallo schema standard, e dal 24/11/2026 i popolatori
     * scrivono anche codice_articolo e codice_prodotto ( bernispa, voce 22 )
     *
     * il test confronta le colonne assegnate dai popolatori con quelle dei CREATE di _100000999999.reports.sql e della
     * patch datata che le porta sui deploy esistenti, e non tocca nessun database
     *
     */

    class staticoReportMagazziniCest {

        // le tabelle e la funzione che le popola
        private $report = array(
            '__report_giacenza_magazzini__' => 'updateReportGiacenzaMagazzini',
            '__report_movimenti_magazzini__' => 'updateReportMovimentiMagazzini'
        );

        // le colonne del CREATE di una tabella in un file SQL
        private function colonne( $file, $tabella ) {

            $sql = file_get_contents( DIR_BASE . $file );

            if( ! preg_match( '/CREATE TABLE (IF NOT EXISTS )?`' . preg_quote( $tabella, '/' ) . '` \((.*?)\n\) ENGINE/s', $sql, $m ) ) {
                return array();
            }

            preg_match_all( '/^\s*`(\w+)`/m', $m[2], $c );

            return $c[1];

        }

        // le chiavi di $riga assegnate dal corpo di una funzione dei popolatori
        private function assegnate( $funzione ) {

            $php = file_get_contents( DIR_BASE . '_mod/_0500.mastri/_src/_lib/_mysql.utils.add.php' );

            $inizio = strpos( $php, 'function ' . $funzione . '(' );
            $fine = strpos( $php, "\n    function ", $inizio + 1 );
            $corpo = substr( $php, $inizio, ( $fine === false ) ? NULL : $fine - $inizio );

            preg_match_all( '/\$riga\[\s*\'(\w+)\'\s*\]\s*=[^=]/', $corpo, $k );

            return array_unique( $k[1] );

        }

        // ogni colonna scritta dai popolatori esiste nello schema standard
        public function colonneNelloSchema( UnitTester $I ) {

            foreach( $this->report as $tabella => $funzione ) {
                $colonne = $this->colonne( '_usr/_database/_patch/_100000999999.reports.sql', $tabella );
                $I->assertNotEmpty( $colonne, 'CREATE di ' . $tabella . ' assente da _100000999999.reports.sql' );
                $I->assertEquals( array(), array_values( array_diff( $this->assegnate( $funzione ), $colonne ) ), $funzione . ' scrive colonne che ' . $tabella . ' non ha' );
            }

        }

        // la patch datata crea le stesse tabelle dello schema standard
        public function patchComeLoSchema( UnitTester $I ) {

            foreach( $this->report as $tabella => $funzione ) {
                $I->assertEquals(
                    $this->colonne( '_usr/_database/_patch/_100000999999.reports.sql', $tabella ),
                    $this->colonne( '_usr/_database/_patch/_202611241700.report.magazzini.codice.sql', $tabella ),
                    'la patch 202611241700 e lo schema standard non coincidono per ' . $tabella
                );
            }

        }

        // i codici ci sono, accanto agli id
        public function codiciAccantoAgliId( UnitTester $I ) {

            foreach( $this->report as $tabella => $funzione ) {
                $assegnate = $this->assegnate( $funzione );
                $I->assertContains( 'codice_articolo', $assegnate, $funzione . ' non scrive codice_articolo' );
                $I->assertContains( 'codice_prodotto', $assegnate, $funzione . ' non scrive codice_prodotto' );
            }

        }

    }

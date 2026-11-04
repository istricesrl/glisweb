<?php

/**
 * test del ricaricamento dei file base ( mysqlPatchReload...() di _src/_lib/_mysql.tools.php )
 *
 * il ricaricamento riesegue procedure, viste, statiche e report dopo le patch, saltando gli oggetti che il progetto
 * ridefinisce in usr/database/patch/; qui si provano le parti che decidono cosa eseguire e cosa saltare, senza
 * toccare il database: l'ordine dei file, il nome dell'oggetto di una query e l'elenco degli oggetti del progetto,
 * questo su una document root temporanea
 *
 */

class patchRicaricaCest
{

    // document root temporanea
    private $base;

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->base = sys_get_temp_dir() . '/glisweb-test-ricarica-' . getmypid() . '/';
        exec( 'rm -rf ' . escapeshellarg( $this->base ) );
        mkdir( $this->base . 'usr/database/patch', 0777, true );
    }

    // pulizia post test
    public function _after(UnitTester $I)
    {
        exec( 'rm -rf ' . escapeshellarg( $this->base ) );
    }

    // i file base nell'ordine: procedure, viste, statiche, report
    public function ordineDeiFile(UnitTester $I)
    {
        $I->assertEquals(
            array( '_070000999999.procedures.sql', '_090000999999.views.sql', '_080000999999.static.sql', '_100000999999.reports.sql' ),
            array_map( 'basename', mysqlPatchReloadFiles( DIR_BASE ) )
        );
    }

    // il nome dell'oggetto, con e senza backtick, in minuscolo
    public function oggettoDellaQuery(UnitTester $I)
    {
        $I->assertEquals( 'articoli_view', mysqlPatchReloadObject( "CREATE OR REPLACE VIEW articoli_view AS\nSELECT 1" ) );
        $I->assertEquals( 'campagne_path', mysqlPatchReloadObject( "DROP FUNCTION IF EXISTS `campagne_path`" ) );
        $I->assertEquals( 'campagne_path', mysqlPatchReloadObject( "CREATE\n\tDEFINER = CURRENT_USER()\n\tFUNCTION `campagne_path`( `p1` BIGINT( 20 ) ) RETURNS TEXT" ) );
        $I->assertEquals( 'attivita_view_static', mysqlPatchReloadObject( "-- attivita_view_static\nCREATE TABLE IF NOT EXISTS `attivita_view_static` ( `id` bigint(20) )" ) );
        $I->assertEquals( '__report_corsi__', mysqlPatchReloadObject( "CREATE TABLE IF NOT EXISTS `__REPORT_CORSI__` ( `id` int )" ) );
        $I->assertFalse( mysqlPatchReloadObject( "UPDATE articoli SET nome = 'x'" ) );
    }

    // gli oggetti del progetto, coi commenti ignorati
    public function oggettiDelProgetto(UnitTester $I)
    {
        file_put_contents( $this->base . 'usr/database/patch/202611040000.prova.sql',
            "-- | 202611040000\n-- CREATE OR REPLACE VIEW commentata_view AS SELECT 1\nCREATE OR REPLACE VIEW `prezzi_view` AS SELECT 1;\n" .
            "-- | 202611040001\nALTER TABLE articoli ADD COLUMN x int;\n-- | FINE\n" );
        file_put_contents( $this->base . 'usr/database/patch/202611040100.funzione.sql',
            "-- | 202611040100\nCREATE DEFINER = CURRENT_USER() FUNCTION mia_funzione() RETURNS int RETURN 1;\n-- | FINE\n" );
        $I->assertEquals(
            array( 'prezzi_view' => '202611040000.prova.sql', 'mia_funzione' => '202611040100.funzione.sql' ),
            mysqlPatchReloadOwned( $this->base )
        );
    }

    // un progetto senza patch non possiede niente
    public function progettoSenzaPatch(UnitTester $I)
    {
        $I->assertEquals( array(), mysqlPatchReloadOwned( $this->base ) );
    }

}

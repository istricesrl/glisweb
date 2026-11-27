<?php

/**
 * test del giro di sorveglianza dello smoke test ( _src/_sh/_smoke.curl.sh sorveglianza )
 *
 * lo script deve fermarsi senza URL di base invece di ricadere su un sito cablato, leggere l'account
 * di prova dalla configurazione del deploy rifiutando una password in config, entrare, controllare
 * il contenuto della pagina e non stampare mai le credenziali; qui lo si prova su un deploy finto
 * temporaneo, con un sito finto servito dal server interno di PHP che accetta solo quell'account;
 * il comando login deve inoltre dare KO se la pagina di login non risponde 200 o se la pagina
 * dopo il login non ha il marcatore dell'area autenticata ( fino al 24/11/2026 un 404 dava OK )
 *
 */

class smokeCurlCest
{

    // deploy finto temporaneo
    private $deploy;

    // server del sito finto
    private $server;

    // porta del sito finto
    private $porta;

    // credenziali dell'account di prova, con i caratteri che rompono un quoting ingenuo
    const UTENTE = 'smoke-utente';
    const PASSWORD = 'pa"ss w\\rd';

    // settaggi pre test
    public function _before(UnitTester $I)
    {
        $this->deploy = sys_get_temp_dir() . '/glisweb-test-smoke-curl-' . getmypid();
        exec( 'rm -rf ' . escapeshellarg( $this->deploy ) );
        $radice = realpath( __DIR__ . '/../../../..' );
        foreach( array( '_src/_sh', 'src', 'sito', 'var/tmp' ) as $dir ) {
            mkdir( $this->deploy . '/' . $dir, 0777, true );
        }
        copy( $radice . '/_src/_sh/_smoke.curl.sh', $this->deploy . '/_src/_sh/_smoke.curl.sh' );
        file_put_contents( $this->deploy . '/sito/router.php',
            '<?php if( isset( $_POST["__login__"] ) ) {'
            . ' if( $_SERVER["REQUEST_URI"] === "/manca.html" ) { http_response_code( 404 ); echo "pagina non trovata"; }'
            . ' elseif( ( $_POST["__login__"]["user"] ?? "" ) !== ' . var_export( self::UTENTE, true )
            . ' || ( $_POST["__login__"]["pasw"] ?? "" ) !== ' . var_export( self::PASSWORD, true ) . ' ) { echo "<form><input name=\"__login__[pasw]\"></form>"; }'
            . ' elseif( $_SERVER["REQUEST_URI"] === "/nuda.html" ) { echo "<p>pagina senza logout</p>"; }'
            . ' else { echo "<form><input type=\"hidden\" name=\"__logout__\" value=\"1\"></form>"; }'
            . ' exit; }'
            . ' if( ( $_SERVER["PHP_AUTH_USER"] ?? "" ) === ' . var_export( self::UTENTE, true )
            . ' && ( $_SERVER["PHP_AUTH_PW"] ?? "" ) === ' . var_export( self::PASSWORD, true ) . ' ) {'
            . ' echo "<table><tr><td>riga-dal-database</td></tr></table>"; } else {'
            . ' echo "<form><input name=\"__login__[pasw]\"></form>"; }' );
        $this->porta = 20000 + ( getmypid() % 20000 );
        $this->server = proc_open(
            // stringa e non array, che PHP 7.3 non accetta; exec perche' proc_terminate fermi il server e non la shell
            'exec ' . escapeshellarg( PHP_BINARY ) . ' -S 127.0.0.1:' . $this->porta . ' ' . escapeshellarg( $this->deploy . '/sito/router.php' ),
            array( 0 => array( 'file', '/dev/null', 'r' ), 1 => array( 'file', '/dev/null', 'w' ), 2 => array( 'file', '/dev/null', 'w' ) ),
            $pipes
        );
        for( $i = 0; $i < 30; $i++ ) {
            $s = @fsockopen( '127.0.0.1', $this->porta );
            if( $s ) { fclose( $s ); break; }
            usleep( 100000 );
        }
    }

    // pulizia post test
    public function _after(UnitTester $I)
    {
        if( is_resource( $this->server ) ) {
            proc_terminate( $this->server );
            proc_close( $this->server );
        }
        exec( 'rm -rf ' . escapeshellarg( $this->deploy ) );
    }

    // scrive la configurazione smoke nel file dato
    private function configura( $file, $smoke )
    {
        file_put_contents( $this->deploy . '/src/' . $file, json_encode( array( 'smoke' => $smoke ) ) );
    }

    // la configurazione completa, con la password data
    private function completa( $password = self::PASSWORD, $pattern = 'riga-dal-database' )
    {
        $this->configura( 'shadow.json', array(
            'account' => array( 'username' => self::UTENTE, 'password' => $password ),
            'page' => '/admin/elenco.html',
            'pattern' => $pattern
        ) );
    }

    // lancia il giro, con l'URL di base come argomento ( NULL = nessuno ), restituendo exit code e output
    private function giro( $base )
    {
        $cmd = 'env -u SMOKE_BASE_URL bash ' . escapeshellarg( $this->deploy . '/_src/_sh/_smoke.curl.sh' ) . ' sorveglianza'
             . ( ( $base === NULL ) ? '' : ' ' . escapeshellarg( $base ) ) . ' 2>&1';
        exec( $cmd, $out, $rc );
        return array( $rc, implode( "\n", $out ) );
    }

    // indirizzo del sito finto
    private function sito()
    {
        return 'http://127.0.0.1:' . $this->porta;
    }

    // lancia il comando login sul percorso dato, restituendo exit code e output
    private function login( $percorso, $password = self::PASSWORD )
    {
        $cmd = 'cd ' . escapeshellarg( $this->deploy ) . ' && env SMOKE_BASE_URL=' . escapeshellarg( $this->sito() )
             . ' SMOKE_LOGIN_PATH=' . escapeshellarg( $percorso ) . ' TEST_USER=' . escapeshellarg( self::UTENTE )
             . ' TEST_PASS=' . escapeshellarg( $password ) . ' bash _src/_sh/_smoke.curl.sh login 2>&1';
        exec( $cmd, $out, $rc );
        return array( $rc, implode( "\n", $out ) );
    }

    // login riuscita: 200 e marcatore dell'area autenticata
    public function loginRiuscita(UnitTester $I)
    {
        list( $rc, $out ) = $this->login( '/login.it-IT.html' );
        $I->assertEquals( 0, $rc, $out );
        $I->assertStringContainsString( 'login OK', $out );
    }

    // pagina di login in 404: prima dava OK perche' il campo password mancava
    public function login404(UnitTester $I)
    {
        list( $rc, $out ) = $this->login( '/manca.html' );
        $I->assertEquals( 2, $rc, $out );
        $I->assertStringContainsString( 'HTTP 404', $out );
    }

    // 200 ma senza marcatore: non e' l'area autenticata
    public function loginSenzaMarcatore(UnitTester $I)
    {
        list( $rc, $out ) = $this->login( '/nuda.html' );
        $I->assertEquals( 2, $rc, $out );
        $I->assertStringContainsString( 'SMOKE_LOGIN_MARKER', $out );
    }

    // password sbagliata: torna il form di login
    public function loginPasswordSbagliata(UnitTester $I)
    {
        list( $rc, $out ) = $this->login( '/login.it-IT.html', 'sbagliata' );
        $I->assertEquals( 2, $rc, $out );
        $I->assertStringContainsString( 'login FAILED', $out );
    }

    // senza URL di base si ferma, e non ricade su nessun sito cablato
    public function senzaBase(UnitTester $I)
    {
        list( $rc, $out ) = $this->giro( NULL );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'KO   base       URL di base mancante', $out );
        $I->assertStringNotContainsString( 'glisdev', $out );
    }

    // anche gli altri comandi, senza base, si fermano
    public function statusSenzaBase(UnitTester $I)
    {
        exec( 'env -u SMOKE_BASE_URL bash ' . escapeshellarg( $this->deploy . '/_src/_sh/_smoke.curl.sh' ) . ' status / 2>&1', $out, $rc );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'SMOKE_BASE_URL non valorizzata', implode( "\n", $out ) );
    }

    // senza configurazione smoke dice cosa manca
    public function configurazioneMancante(UnitTester $I)
    {
        list( $rc, $out ) = $this->giro( $this->sito() );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'KO   config     mancano: smoke.account.username smoke.account.password smoke.page smoke.pattern', $out );
    }

    // la password in config, che si versiona, viene rifiutata anche se lo shadow e' completo
    public function passwordInConfig(UnitTester $I)
    {
        $this->completa();
        $this->configura( 'config.json', array( 'account' => array( 'password' => 'in-chiaro' ) ) );
        list( $rc, $out ) = $this->giro( $this->sito() );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'va spostata in src/shadow', $out );
        $I->assertStringNotContainsString( 'in-chiaro', $out );
    }

    // giro completo: cinque righe OK, exit 0, nessuna credenziale nell'output
    public function giroCompleto(UnitTester $I)
    {
        $this->completa();
        list( $rc, $out ) = $this->giro( $this->sito() );
        $I->assertEquals( 0, $rc, $out );
        $I->assertEquals( 5, substr_count( $out, 'OK   ' ), $out );
        $I->assertStringNotContainsString( 'KO', $out );
        $I->assertStringNotContainsString( self::PASSWORD, $out );
        $I->assertStringNotContainsString( self::UTENTE, $out );
    }

    // password sbagliata: il sito torna il form di login, KO sul login
    public function passwordSbagliata(UnitTester $I)
    {
        $this->completa( 'sbagliata' );
        list( $rc, $out ) = $this->giro( $this->sito() );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'KO   login', $out );
        $I->assertStringNotContainsString( 'sbagliata', $out );
    }

    // la pagina risponde ma non contiene quello che deve: non basta il 200
    public function contenutoAssente(UnitTester $I)
    {
        $this->completa( self::PASSWORD, 'riga-che-non-esiste' );
        list( $rc, $out ) = $this->giro( $this->sito() );
        $I->assertEquals( 1, $rc );
        $I->assertStringContainsString( 'OK   pagina', $out );
        $I->assertStringContainsString( 'KO   contenuto', $out );
    }

}

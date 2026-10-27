<?php

    /**
     * test del firewall applicativo del nucleo
     *
     * verifica il firewall di _src/_inc/_macro/_security.php: la richiesta malevola bloccata, quella innocua che
     * passa, la regola in osservazione che registra senza bloccare, il bando a gradini in var/spool/security/ban/,
     * gli indirizzi da non bandire ( la macchina stessa, allowed.hosts.conf, i crawler verificati col DNS ) e la
     * pagina di sblocco, l'unica che un IP bandito riesce ad aprire; il 403 di Apache che passa dal firewall con
     * l'ErrorDocument, e la lista globale dei bandi letta dalla copia locale
     *
     * le richieste partono dalla macchina stessa, che il firewall non bandisce mai: le prove sul bando quindi non
     * passano da HTTP, ma chiamano securityBan() e securitySpared() con un REMOTE_ADDR finto preso da 192.0.2.0/24
     * ( TEST-NET-1, RFC 5737, che non esiste in rete ); l'accesso sospeso si prova scrivendo a mano il file del bando
     * per l'indirizzo della macchina, perche' e' Apache che lo legge
     *
     * gli status HTTP il browser non li espone, quindi le richieste passano da restCall(); davanti al firewall applicativo
     * c'e' ModSecurity col Core Rule Set, che respinge con 403 gran parte degli attacchi prima che arrivino a PHP, quindi
     * le richieste di prova usano quello che il CRS lascia passare e il firewall applicativo no ( /wp-login.php, lo user
     * agent di feroxbuster )
     *
     */

    class securityCest {

        // rete finta per le prove sul bando
        const RETE = '192.0.2.';

        // pulizia prima e dopo ogni test
        public function _before( FrontendTester $I ) {
            $this->pulisci( $I );
        }

        public function _after( FrontendTester $I ) {
            $this->pulisci( $I );
        }

        // una richiesta malevola viene bloccata, e la macchina che l'ha fatta non viene bandita
        public function richiestaMalevola( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            $I->assertEquals( 400, $this->scarica( '/wp-login.php?' . $marcatore . '=1', $raw ) );
            $I->assertStringContainsString( 'richiesta bloccata', $raw );

            // il registro dice perche' la macchina non e' stata bandita, e il file del bando non c'e'
            $ip = $this->sorgente( $marcatore, $riga );
            $I->assertNotEmpty( $ip, 'la richiesta bloccata non e\' nel registro del firewall' );
            $I->assertStringContainsString( 'match per la regola', $riga );
            $I->assertStringContainsString( 'non bandito: indirizzo ammesso', $riga );
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_SECURITY_BAN . $ip );

        }

        // una richiesta innocua passa
        public function richiestaInnocua( FrontendTester $I ) {

            $I->assertTrue( $this->passa( $this->scarica( '/?' . \Helper\Glisweb::RECORD_PREFIX . uniqid() . '=1', $raw ) ) );

        }

        // una regola in osservazione registra la richiesta ma non la blocca
        public function regolaInOsservazione( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            $I->assertTrue( $this->passa( $this->scarica( '/?' . $marcatore . '=1', $raw, array( 'User-Agent' => 'feroxbuster/2.10' ) ) ) );

            $this->sorgente( $marcatore, $riga );
            $I->assertStringContainsString( 'osservazione per la regola', $riga );

        }

        // il bando sale di gradino alla recidiva, e sotto la soglia non scatta
        public function bandoAGradini( FrontendTester $I ) {

            $_SERVER['REMOTE_ADDR'] = self::RETE . '1';

            $I->assertEquals( 'bandito per ' . SECURITY_BAN_STEPS[0] . ' secondi', securityBan( SECURITY_SCORE_LIMIT, 'TEST-E2E' ) );
            $I->assertFileExists( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );
            $I->assertEqualsWithDelta( time() + SECURITY_BAN_STEPS[0], filemtime( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] ), 5 );

            $I->assertEquals( 'bandito per ' . SECURITY_BAN_STEPS[1] . ' secondi', securityBan( SECURITY_SCORE_LIMIT, 'TEST-E2E' ) );
            clearstatcache();
            $I->assertEqualsWithDelta( time() + SECURITY_BAN_STEPS[1], filemtime( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] ), 5 );

            $_SERVER['REMOTE_ADDR'] = self::RETE . '2';

            $I->assertEquals( '', securityBan( 1, 'TEST-E2E' ) );
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );

        }

        // il 403 di Apache passa dal firewall attraverso l'ErrorDocument, che risponde 403 con la sua pagina
        public function erroreDocument403( FrontendTester $I ) {

            $I->assertEquals( 403, $this->scarica( '/composer.json?' . \Helper\Glisweb::RECORD_PREFIX . uniqid() . '=1', $raw ) );
            $I->assertStringContainsString( 'accesso negato', $raw );

        }

        // il 403 di Apache dà punti, tre sui percorsi da scanner, e nessuno col referer dello stesso sito
        public function punti403( FrontendTester $I ) {

            $_SERVER['REMOTE_ADDR'] = self::RETE . '3';
            $_SERVER['REDIRECT_STATUS'] = '403';
            $_SERVER['HTTP_HOST'] = 'example.com';
            $_SERVER['HTTP_REFERER'] = 'https://example.com/admin/';
            $_SERVER['REQUEST_URI'] = '/.env';
            http_response_code( 403 );

            // col referer interno niente punti, anche dopo molti 403
            for( $i = 0; $i < SECURITY_SCORE_LIMIT; $i++ ) {
                securityOutcome();
            }
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );

            // senza referer bastano quattro 403 su un percorso da scanner
            unset( $_SERVER['HTTP_REFERER'] );
            for( $i = 0; $i < 4; $i++ ) {
                securityOutcome();
            }
            $I->assertFileExists( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );
            $I->assertStringContainsString( '403 su percorsi da scanner', file_get_contents( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] ) );

            unset( $_SERVER['REDIRECT_STATUS'], $_SERVER['HTTP_HOST'], $_SERVER['REQUEST_URI'] );
            http_response_code( 200 );

        }

        // la source map di una libreria in cache la chiede il browser da solo, senza referer: il 403 non da' punti
        // ( il 27/10/2026 una decina di queste in un minuto hanno bandito la segreteria di polmasi )
        public function punti403SourceMap( FrontendTester $I ) {

            $_SERVER['REMOTE_ADDR'] = self::RETE . '9';
            $_SERVER['REDIRECT_STATUS'] = '403';
            $_SERVER['HTTP_HOST'] = 'example.com';
            $_SERVER['REQUEST_URI'] = '/var/cache/js/cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js.map';
            http_response_code( 403 );

            for( $i = 0; $i < SECURITY_SCORE_LIMIT; $i++ ) {
                securityOutcome();
            }
            $I->assertFileDoesNotExist( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );

            // un .map fuori dalla cache resta un 403 qualsiasi
            $_SERVER['REQUEST_URI'] = '/mapserver/mappa.map';
            for( $i = 0; $i < SECURITY_SCORE_LIMIT; $i++ ) {
                securityOutcome();
            }
            $I->assertFileExists( DIR_VAR_SPOOL_SECURITY_BAN . $_SERVER['REMOTE_ADDR'] );

            unset( $_SERVER['REDIRECT_STATUS'], $_SERVER['HTTP_HOST'], $_SERVER['REQUEST_URI'] );
            http_response_code( 200 );

        }

        // alla lista globale si segnalano solo gli IP pubblici: i privati, i riservati e le reti di documentazione dei
        // test il dataserver li rifiuta con 400 ( 27/10/2026, quattro segnalazioni da una suite su glisdev )
        public function segnalazioneSoloIpPubblici( FrontendTester $I ) {

            $I->assertTrue( securityPublicIp( '8.8.8.8' ) );
            $I->assertTrue( securityPublicIp( '2001:4860:4860::8888' ) );
            $I->assertFalse( securityPublicIp( '127.0.0.1' ) );
            $I->assertFalse( securityPublicIp( '10.132.0.7' ) );
            $I->assertFalse( securityPublicIp( '192.168.1.1' ) );
            $I->assertFalse( securityPublicIp( self::RETE . '9' ) );
            $I->assertFalse( securityPublicIp( '198.51.100.1' ) );
            $I->assertFalse( securityPublicIp( 'non un ip' ) );

        }

        // l'IP della lista globale e' bandito finche' la riga non scade, o finche' non si sblocca
        public function listaGlobale( FrontendTester $I ) {

            // copia locale finta, che non va riscaricata durante il test; quella vera si rimette a posto alla fine
            checkPath( DIR_VAR_SPOOL_SECURITY_GLOBAL );
            $copia = ( file_exists( FILE_SECURITY_GLOBAL_BANS ) ) ? array( file_get_contents( FILE_SECURITY_GLOBAL_BANS ), filemtime( FILE_SECURITY_GLOBAL_BANS ) ) : NULL;
            $lock = ( file_exists( FILE_SECURITY_GLOBAL_BANS_LOCK ) ) ? array( file_get_contents( FILE_SECURITY_GLOBAL_BANS_LOCK ), filemtime( FILE_SECURITY_GLOBAL_BANS_LOCK ) ) : NULL;
            file_put_contents( FILE_SECURITY_GLOBAL_BANS_LOCK, 'TEST-E2E' . PHP_EOL );
            file_put_contents( FILE_SECURITY_GLOBAL_BANS,
                '# lista di prova' . PHP_EOL .
                self::RETE . '4 ' . ( time() + 3600 ) . ' 2 TEST-E2E' . PHP_EOL .
                self::RETE . '5 ' . ( time() - 60 ) . ' 2 TEST-E2E' . PHP_EOL
            );

            $_SERVER['REMOTE_ADDR'] = self::RETE . '4';
            $I->assertEqualsWithDelta( 3600, securityGlobalBan(), 5 );

            // un prefisso dell'indirizzo non e' l'indirizzo
            $_SERVER['REMOTE_ADDR'] = self::RETE . '40';
            $I->assertEquals( 0, securityGlobalBan() );

            // la riga scaduta non conta
            $_SERVER['REMOTE_ADDR'] = self::RETE . '5';
            $I->assertEquals( 0, securityGlobalBan() );

            // lo sblocco con la verifica umana vale fino alla scadenza del bando globale
            $_SERVER['REMOTE_ADDR'] = self::RETE . '4';
            checkPath( DIR_VAR_SPOOL_SECURITY_GLOBAL_UNBAN );
            touch( DIR_VAR_SPOOL_SECURITY_GLOBAL_UNBAN . self::RETE . '4', time() + 3600 );
            $I->assertEquals( 0, securityGlobalBan() );

            // copia locale e lock com'erano
            foreach( array( FILE_SECURITY_GLOBAL_BANS => $copia, FILE_SECURITY_GLOBAL_BANS_LOCK => $lock ) as $f => $c ) {
                if( $c === NULL ) {
                    unlink( $f );
                } else {
                    file_put_contents( $f, $c[0] );
                    touch( $f, $c[1] );
                }
            }

        }

        // la macchina stessa e gli indirizzi di allowed.hosts.conf non si bandiscono, gli altri si'
        public function indirizziAmmessi( FrontendTester $I ) {

            foreach( array( '127.0.0.1', '::1' ) as $ip ) {
                $_SERVER['REMOTE_ADDR'] = $ip;
                $I->assertStringStartsWith( 'indirizzo ammesso', securitySpared(), $ip . ' non e\' risparmiato' );
            }

            $_SERVER['REMOTE_ADDR'] = self::RETE . '1';
            $I->assertEquals( '', securitySpared() );

            // le righe del deploy, se ce ne sono: allowed.hosts.conf e' del deploy e il test non lo scrive
            foreach( ( file_exists( FILE_ALLOWED_HOSTS ) ) ? file( FILE_ALLOWED_HOSTS, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES ) : array() as $riga ) {
                $net = explode( '/', trim( $riga ) );
                if( @inet_pton( $net[0] ) !== false ) {
                    $_SERVER['REMOTE_ADDR'] = $net[0];
                    $I->assertStringStartsWith( 'indirizzo ammesso', securitySpared(), $net[0] . ' e\' in allowed.hosts.conf ma non e\' risparmiato' );
                }
            }

        }

        // un crawler verificato col DNS inverso e diretto non si bandisce
        public function crawlerVerificato( FrontendTester $I ) {

            $ip = '66.249.66.1';

            if( @gethostbyaddr( $ip ) == $ip ) {
                $I->markTestSkipped( 'il DNS inverso non risponde' );
            }

            $_SERVER['REMOTE_ADDR'] = $ip;
            $I->assertStringStartsWith( 'crawler ', securitySpared() );

        }

        // un IP bandito riceve 429 dappertutto tranne che sulla pagina di sblocco
        public function accessoSospesoESblocco( FrontendTester $I ) {

            $marcatore = \Helper\Glisweb::RECORD_PREFIX . uniqid();

            // l'indirizzo con cui la macchina arriva al sito lo dice il registro del firewall
            $this->scarica( '/wp-login.php?' . $marcatore . '=1', $raw );
            $ip = $this->sorgente( $marcatore, $riga );
            $I->assertNotEmpty( $ip, 'la richiesta bloccata non e\' nel registro del firewall' );

            checkPath( DIR_VAR_SPOOL_SECURITY_BAN );
            file_put_contents( DIR_VAR_SPOOL_SECURITY_BAN . $ip, 'TEST-E2E' . PHP_EOL );
            touch( DIR_VAR_SPOOL_SECURITY_BAN . $ip, time() + 120 );

            try {
                $I->assertEquals( 429, $this->scarica( '/', $raw ) );
                $I->assertEquals( 200, $this->scarica( '/sblocco-accesso.it-IT.html', $raw ) );
            } finally {
                @unlink( DIR_VAR_SPOOL_SECURITY_BAN . $ip );
            }

            $I->assertTrue( $this->passa( $this->scarica( '/', $raw ) ) );

        }

        /**
         * dice se una richiesta e' passata dal firewall
         *
         * la home di un deploy non risponde per forza 200: dove / e' rediretta ( p.es. verso /admin ) arriva un 3xx, e
         * anche quello vuol dire che il firewall ha lasciato passare la richiesta; il firewall blocca con 400, 403 e 429
         *
         * @param       int         $status         lo status HTTP della risposta
         *
         * @return      bool                        true se la richiesta e' passata
         *
         */
        protected function passa( $status ) {

            return $status >= 200 && $status < 400;

        }

        /**
         * scarica una pagina senza browser, per averne lo status HTTP
         *
         * @return      int                         lo status HTTP della risposta
         *
         */
        protected function scarica( $pagina, &$raw, $headers = array() ) {

            global $cf;

            $raw = NULL;
            $status = NULL;

            restCall( rtrim( $cf['site']['url'], '/' ) . $pagina, METHOD_GET, NULL, MIME_APPLICATION_JSON, MIME_TEXT_PLAIN, $status, $headers, NULL, NULL, $error, NULL, CURLAUTH_BASIC, $raw );

            return (int) $status;

        }

        /**
         * cerca nel registro del firewall la richiesta col marcatore indicato
         *
         * una richiesta puo' lasciare piu' voci ( il match della regola, il limite superato del canale firewall ), quindi
         * i messaggi si restituiscono tutti
         *
         * @param       string      $marcatore      il marcatore messo nella query string della richiesta
         * @param       string      $riga           i messaggi del registro per quella richiesta, uno per riga
         *
         * @return      string                      l'indirizzo da cui e' arrivata la richiesta, vuoto se non c'e'
         *
         */
        protected function sorgente( $marcatore, &$riga ) {

            $riga = '';
            $ip = '';

            foreach( glob( DIR_VAR_SPOOL_SECURITY . '*.log' ) as $file ) {
                if( preg_match_all( '/^(.*)\nsorgente: (\S+)\nurl: [^\n]*' . preg_quote( $marcatore, '/' ) . '/m', file_get_contents( $file ), $m ) ) {
                    $riga = implode( PHP_EOL, $m[1] );
                    $ip = $m[2][0];
                }
            }

            return $ip;

        }

        /**
         * toglie i file della rete finta, i bandi e le voci di registro dei test e riporta l'indirizzo a quello della macchina
         *
         */
        protected function pulisci( FrontendTester $I ) {

            foreach( glob( DIR_VAR_SPOOL_SECURITY . '*.log' ) as $file ) {
                $registro = file_get_contents( $file );
                if( strpos( $registro, \Helper\Glisweb::RECORD_PREFIX ) !== false ) {
                    file_put_contents( $file, preg_replace( '/^[^\n]*\nsorgente: [^\n]*\nurl: [^\n]*' . preg_quote( \Helper\Glisweb::RECORD_PREFIX, '/' ) . '[^\n]*\n(indizi: [^\n]*\n)?\n/m', '', $registro ), LOCK_EX );
                }
            }

            foreach( array_merge(
                glob( DIR_VAR_SPOOL_SECURITY . self::RETE . '*.log' ),
                glob( DIR_VAR_SPOOL_SECURITY_BAN . self::RETE . '*' ),
                glob( DIR_VAR_SPOOL_SECURITY . 'limiti/*/' . self::RETE . '*.log' ),
                glob( DIR_VAR_SPOOL_SECURITY_GLOBAL_UNBAN . self::RETE . '*' )
            ) as $file ) {
                unlink( $file );
            }

            foreach( glob( DIR_VAR_SPOOL_SECURITY_BAN . '*' ) as $file ) {
                if( trim( file_get_contents( $file ) ) == 'TEST-E2E' ) {
                    unlink( $file );
                }
            }

            $_SERVER['REMOTE_ADDR'] = '127.0.0.1';

        }

    }

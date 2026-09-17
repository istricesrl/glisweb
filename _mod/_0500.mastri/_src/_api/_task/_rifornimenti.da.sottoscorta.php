<?php

    /**
     * segnala le ubicazioni sotto scorta minima e ne genera la missione di rifornimento
     *
     * Gira a mezzogiorno e a mezzanotte ( due righe in tabella task: minuto 0, ora 0 e ora 12 -
     * le colonne di task sono int e non conoscono la sintassi di crontab, quindi "due volte al
     * giorno" sono per forza due righe ). Per ogni ubicazione di prelievo che ha una scorta
     * minima impostata e una giacenza sotto quella soglia:
     *
     *   - scrive la segnalazione in __report_sottoscorta__, che e' cio' che alimenta la scheda
     *     "sottoscorta" della sezione logistica;
     *   - se trova da dove rifornirla, la mette in una missione di rifornimento.
     *
     * i due documenti
     * ---------------
     * Il rifornimento ricalca il modello che il magazzino gia' conosce, lista di prelievo ->
     * missione: si crea prima un documento di RICHIESTA ( tipologia 7, "ordine" ) con le righe
     * da prelevare, e da quello la MISSIONE ( tipologia 36, "missione di movimentazione", che era
     * gia' a catalogo e mai usata: cosi' i rifornimenti restano distinguibili con una WHERE dalle
     * missioni di prelievo, che sono di tipologia 34 ).
     *
     * Il documento di richiesta non e' un orpello burocratico: la maschera /prelievi legge le
     * righe di una missione con INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento
     * ( src/inc/macro/missione.php ), quindi una riga senza documento non comparirebbe MAI
     * all'operatore. E le righe devono essere di tipologia 7 con id_genitore NULL, che e' quello
     * che la stessa macro cerca come "riga da prelevare".
     *
     * ATTENZIONE al sezionale della richiesta, che si lascia NULL di proposito: il task
     * missioni.da.liste.prelievo.php gira OGNI MINUTO e cerca i documenti di tipologia 7 con un
     * dato sezionale. Con un sezionale valorizzato scambierebbe la richiesta di rifornimento per
     * una lista di prelievo e le genererebbe sopra una seconda missione, di tipologia 34.
     *
     * i mastri stanno sulla TESTATA, non sulle righe
     * ----------------------------------------------
     * In questo sistema i due mastri su una riga di documenti_articoli NON sono un'intenzione:
     * sono un movimento gia' avvenuto. updateReportGiacenzaMagazzini() calcola carico e scarico
     * sommando TUTTE le righe che hanno quei mastri, senza guardare tipologia, missione o
     * genitore ( _mod/_0500.mastri/_src/_lib/_mysql.utils.add.php ). Scriverli su una riga "da
     * fare" sposterebbe la merce sulla carta nell'istante in cui si crea la missione: l'articolo
     * risulterebbe subito rifornito, non verrebbe piu' segnalato, e al prelievo vero si
     * muoverebbe una seconda volta. E' esattamente il motivo per cui le righe delle liste di
     * prelievo che arrivano da SAM non hanno mastri, e li scrivono solo le righe di evasione
     * prodotte dalle maschere.
     *
     * Quindi le righe di rifornimento nascono SENZA mastri, e la coppia bulk -> ubicazione da
     * rifornire sta su documenti.id_mastro_provenienza / id_mastro_destinazione della missione.
     * Ne discende che serve UNA MISSIONE PER UBICAZIONE DI DESTINAZIONE ( una testata porta una
     * destinazione sola ), il che per l'operatore e' anche piu' sensato: una missione, un viaggio.
     * La maschera /prelievi legge la destinazione dalla testata e ci scrive sopra la riga di
     * evasione, che e' il movimento vero.
     *
     * idempotenza
     * -----------
     * Un documento di richiesta per magazzino per giro, con codice deterministico
     * RIF-<sigla>-<Ymd>-<turno> ( turno N a mezzanotte, G a mezzogiorno ). documenti.codice e'
     * UNIQUE, quindi se il documento c'e' gia' il giro per quel magazzino si salta: rilanciare il
     * task a mano nello stesso mezzogiorno non crea niente di nuovo.
     *
     * configurazione: $cf['automazioni']['profile']['sottoscorta'], cioe' il ramo dell'ambiente
     * corrente. Default in src/config/700.automazioni.php, interruttori per ambiente in
     * src/config.json sotto "automazioni.profiles", cutoff_id in
     * var/spool/automazioni/sottoscorta.cutoff.id ( non si deploya ).
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();
    $status['info'] = array();
    $status['err'] = array();
    $status['creati'] = array();
    $status['saltati'] = array();
    $status['conteggi'] = array( 'sottoscorta' => 0, 'sorvegliate' => 0, 'rifornibili' => 0, 'creati' => 0, 'saltati' => 0, 'errori' => 0 );

    // tutte le ubicazioni con una soglia valutabile, in allarme o no: e' quello che la scheda
    // mostra, e le segnalazioni ne sono il sottoinsieme
    $sorvegliate = array();

    // interruttore generale
    if( empty( $cf['automazioni']['profile']['sottoscorta']['attivo'] ) ) {

        // status
        $status['info'][] = 'automazione disattivata: nulla da fare';

    } elseif( ! isset( $cf['automazioni']['profile']['sottoscorta']['cutoff_id'] ) || ! is_numeric( $cf['automazioni']['profile']['sottoscorta']['cutoff_id'] ) ) {

        // qui il cutoff non delimita nulla ( il task parte dalle giacenze, non dai documenti ):
        // e' il secondo gradino fail-closed, quello che permette di spegnere il task sul posto
        // con un rm del file di spool, senza deploy
        $status['err'][] = 'cutoff_id non impostato: task fermo';

    } else {

        // il batch e' un intero di configurazione e non un input utente, ma lo si castiga
        // comunque prima di interpolarlo
        $batch = ( ! empty( $cf['automazioni']['profile']['sottoscorta']['batch'] ) ) ? intval( $cf['automazioni']['profile']['sottoscorta']['batch'] ) : 500;

        // i sezionali sono un CSV: array_replace_recursive non saprebbe accorciare un array
        $sezionali = array_filter( array_map( 'trim', explode( ',', $cf['automazioni']['profile']['sottoscorta']['sezionali'] ) ) );

        // i mastri di transito da cui non ci si rifornisce mai, per codice ( gli id non
        // coincidono fra ambienti ). Si risolvono una volta sola, non una per articolo.
        $esclusi = array();
        $codiciEsclusi = array_filter( array_map( 'trim', explode( ',', $cf['automazioni']['profile']['sottoscorta']['esclusi'] ) ) );
        foreach( $codiciEsclusi as $codiceEscluso ) {
            $idEscluso = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM mastri WHERE codice = ? LIMIT 1',
                array(
                    array( 's' => $codiceEscluso )
                )
            );
            if( ! empty( $idEscluso ) ) { $esclusi[] = $idEscluso; }
        }

        // il turno serve solo a distinguere il giro di mezzogiorno da quello di mezzanotte nel
        // codice del documento: due giri al giorno, due documenti diversi
        $turno = ( intval( date( 'G' ) ) < 12 ) ? 'N' : 'G';

        // le segnalazioni raccolte in tutto il giro, che alla fine diventano il report
        $segnalazioni = array();

        // ATTENZIONE, limite noto: l'albero dei mastri ha una sola radice ( BOLOGNA, 2.127 figli
        // diretti ), quindi oggi NON c'e' modo di dire a quale magazzino appartenga un'ubicazione.
        // Con piu' di un sezionale configurato le stesse righe sottoscorta verrebbero lavorate
        // una volta per sezionale, e la seconda troverebbe la richiesta gia' fatta: si lavora
        // percio' il solo primo sezionale. Quando i mastri saranno alberati per magazzino, qui
        // va rimesso il ciclo e aggiunto il filtro sulla radice nella query delle ubicazioni.
        if( count( $sezionali ) > 1 ) {
            $status['info'][] = 'configurati piu\' sezionali ma i mastri hanno una sola radice: lavoro il solo ' . reset( $sezionali );
        }
        $sezionali = array_slice( $sezionali, 0, 1 );

        // per ogni magazzino in perimetro...
        foreach( $sezionali as $sezionale ) {

            // il magazzino deve essere mappato
            if( empty( $cf['automazioni']['profile']['sottoscorta']['magazzini'][ $sezionale ]['denominazione'] ) ) {
                $status['err'][] = 'il sezionale ' . $sezionale . ' non e\' mappato su un magazzino: saltato';
                $status['conteggi']['errori']++;
                continue;
            }

            // risolvo il magazzino per denominazione e non per id: gli id degli indirizzi non
            // coincidono fra DEV, TEST e PROD, mentre le denominazioni arrivano tutte da SAM
            $magazzino = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT anagrafica.id AS id_anagrafica, anagrafica_indirizzi.id AS id_indirizzo
                FROM anagrafica
                INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_anagrafica = anagrafica.id
                WHERE anagrafica.denominazione = ? LIMIT 1',
                array(
                    array( 's' => $cf['automazioni']['profile']['sottoscorta']['magazzini'][ $sezionale ]['denominazione'] )
                )
            );

            if( empty( $magazzino['id_anagrafica'] ) ) {
                $status['err'][] = 'il magazzino "' . $cf['automazioni']['profile']['sottoscorta']['magazzini'][ $sezionale ]['denominazione'] . '" del sezionale ' . $sezionale . ' non e\' stato trovato: sezionale saltato';
                $status['conteggi']['errori']++;
                continue;
            }

            /**
             * LE UBICAZIONI SOTTO SCORTA MINIMA, CON LA SOGLIA RIPORTATA NELL'UNITA' DELLA
             * GIACENZA ( 16/09/2026 )
             *
             * Il LEFT JOIN sulle giacenze e' voluto: un'ubicazione che nel report non compare
             * affatto ha giacenza zero, ed e' il caso piu' grave di sottoscorta, non uno da
             * ignorare. scorta_minima NULL invece significa "nessuna soglia" e resta fuori.
             *
             * La giacenza e' sempre nell'unita' INVENTARIALE dell'articolo, la soglia no: il
             * magazzino la dichiara in quello che ha in mano ( "12 scatole" ), e da qui
             * `mastri_articoli.id_udm`. Il `fattore` e' quanti pezzi inventariali vale una
             * unita' della soglia:
             *   - id_udm NULL                         -> 1, la soglia e' gia' inventariale
             *                                            ( comportamento storico )
             *   - la sigla dell'udm e' l'unita' inventariale dell'articolo ( metadato `umi` )
             *                                         -> 1
             *   - la sigla e' la confezione dichiarata ( `um_movimentazione` ) e `conf_qta`
             *     e' utile                            -> conf_qta
             *   - altrimenti                          -> NULL, e la riga NON viene segnalata
             *
             * L'ultimo caso e' voluto ed e' fail-closed: una soglia che non si sa convertire
             * non deve produrre un allarme a caso ne' una missione di rifornimento a caso.
             * Le righe che ci finiscono vengono contate e loggate subito sotto, perche' una
             * soglia impostata che non fa niente, se non lo si dice, sembra un guasto.
             *
             * I metadati si leggono con sottoquery scalari e non con dei JOIN: `metadati_articoli`
             * non ha un UNIQUE che protegga le due convenzioni di scrittura ( id_lingua NULL e
             * id_lingua 1 ), e un doppione moltiplicherebbe le righe della vista. E' la stessa
             * cautela di confezioniArticolo() in _mod/_0500.mastri/_src/_lib/_mysql.utils.add.php, che di questi tre
             * metadati e' la lettrice principale.
             */
            $righe = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT soglie.id_articolo,
                        soglie.id_mastro,
                        soglie.collocazione,
                        soglie.articolo,
                        soglie.giacenza,
                        soglie.scorta_minima_dichiarata,
                        soglie.scorta_massima_dichiarata,
                        soglie.udm,
                        soglie.scorta_minima_dichiarata * soglie.fattore AS scorta_minima,
                        soglie.scorta_massima_dichiarata * soglie.fattore AS scorta_massima,
                        ( soglie.giacenza < soglie.scorta_minima_dichiarata * soglie.fattore ) AS se_allarme
                    FROM (
                        SELECT mastri_articoli.id_articolo,
                               mastri_articoli.id_mastro,
                               mastri.codice AS collocazione,
                               articoli.nome AS articolo,
                               mastri_articoli.scorta_minima AS scorta_minima_dichiarata,
                               mastri_articoli.scorta_massima AS scorta_massima_dichiarata,
                               udm.nome AS udm,
                               coalesce( giacenza.totale_proprio, 0 ) AS giacenza,
                               case
                                   when mastri_articoli.id_udm IS NULL then 1
                                   when upper( udm.sigla ) = upper( ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "umi" ) ) then 1
                                   when upper( udm.sigla ) = upper( ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "um_movimentazione" ) )
                                        and ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "conf_qta" ) + 0 > 0
                                        then ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "conf_qta" ) + 0
                                   else NULL
                               end AS fattore
                            FROM mastri_articoli
                            INNER JOIN mastri ON mastri.id = mastri_articoli.id_mastro
                            INNER JOIN articoli ON articoli.id = mastri_articoli.id_articolo
                            LEFT JOIN udm ON udm.id = mastri_articoli.id_udm
                            LEFT JOIN __report_giacenza_magazzini__ AS giacenza
                                ON giacenza.id_mastro = mastri_articoli.id_mastro
                                AND giacenza.id_articolo = mastri_articoli.id_articolo
                            WHERE mastri_articoli.scorta_minima IS NOT NULL
                    ) AS soglie
                    WHERE soglie.fattore IS NOT NULL
                    ORDER BY soglie.collocazione ASC
                    LIMIT ' . $batch,
                array()
            );

            /**
             * SORVEGLIATE E IN ALLARME SONO DUE COSE DIVERSE ( 16/09/2026 )
             *
             * La query porta tutte le ubicazioni con una soglia valutabile, non solo quelle
             * sotto: la scheda le mostra tutte e ha un filtro per restringersi all'allarme.
             * "sorvegliata e a posto" e' un'informazione - dice che la soglia c'e' e sta
             * reggendo - e senza di essa non si distingue un'ubicazione coperta da una per cui
             * nessuno ha mai impostato niente.
             *
             * Il resto del task lavora invece sulle sole righe in allarme: sono quelle, e solo
             * quelle, che generano una missione di rifornimento.
             */
            foreach( $righe as $riga ) {
                $sorvegliate[ $riga['id_mastro'] . '|' . $riga['id_articolo'] ] = $riga;
            }

            $righe = array_values( array_filter( $righe, function( $r ) { return ! empty( $r['se_allarme'] ); } ) );

            if( empty( $righe ) ) {
                $status['info'][] = 'sezionale ' . $sezionale . ': nessuna ubicazione sotto scorta minima';
                continue;
            }

            // status
            $status['conteggi']['sottoscorta'] += count( $righe );

            // il codice del documento di richiesta. documenti.codice e' char(32): oltre i 32
            // caratteri MySQL troncherebbe in silenzio, facendo collidere sull'indice UNIQUE due
            // richieste diverse.
            $sigla = ( ! empty( $cf['automazioni']['profile']['sottoscorta']['sigle'][ $sezionale ] ) ) ? $cf['automazioni']['profile']['sottoscorta']['sigle'][ $sezionale ] : $sezionale;
            $codiceRichiesta = 'RIF-' . $sigla . '-' . date( 'Ymd' ) . '-' . $turno;

            if( strlen( $codiceRichiesta ) > 32 ) {
                $status['err'][] = 'il codice ' . $codiceRichiesta . ' supera i 32 caratteri: sezionale ' . $sezionale . ' saltato';
                $status['conteggi']['errori']++;
                continue;
            }

            // decido riga per riga da dove rifornire, PRIMA di creare qualunque documento: se
            // non c'e' niente da rifornire non si crea nemmeno la richiesta
            $daRifornire = array();

            foreach( $righe as $riga ) {

                // il verdetto su questa riga, che finisce nel report e quindi sotto gli occhi di
                // chi guarda la scheda. La stessa funzione la usa la generazione a mano dalla
                // scheda sottoscorta: due copie divergerebbero al primo ritocco, e divergendo
                // darebbero all'operatore due risposte diverse sulla stessa riga
                $riga = valutaRigaRifornimento(
                    $cf['mysql']['connection'],
                    $riga,
                    $esclusi,
                    $cf['automazioni']['profile']['sottoscorta']['prefisso_stoccaggio']
                );

                $mancante = $riga['mancante'];

                if( $riga['esito'] == 'rifornibile' ) {

                    $daRifornire[] = $riga;
                    $status['conteggi']['rifornibili']++;

                }

                // la segnalazione si scrive SEMPRE, rifornibile o no: il motivo per cui non si e'
                // potuto rifornire e' esattamente cio' che il magazzino deve vedere
                $riga['id_missione'] = NULL;
                $riga['missione'] = NULL;
                $segnalazioni[ $riga['id_mastro'] . '|' . $riga['id_articolo'] ] = $riga;

            }

            // se non c'e' niente da rifornire ci si ferma qui: le segnalazioni sono gia' state
            // raccolte e verranno comunque scritte nel report
            if( empty( $daRifornire ) ) {
                $status['info'][] = 'sezionale ' . $sezionale . ': ' . count( $righe ) . ' ubicazioni sotto scorta minima, nessuna rifornibile';
                continue;
            }

            // raggruppo per ubicazione da rifornire: una missione per destinazione
            $perDestinazione = array();
            foreach( $daRifornire as $riga ) {
                $perDestinazione[ $riga['id_mastro'] ][] = $riga;
            }

            // ...
            mysqlQuery( $cf['mysql']['connection'], 'START TRANSACTION' );

            // creo il documento di richiesta. INSERT IGNORE e non upsert: sul duplicato il
            // default di mysqlInsertRow riscriverebbe una richiesta magari gia' lavorata.
            // NOTA sui campi lasciati a NULL: sezionale perche' altrimenti il task delle missioni
            // dalle liste di prelievo scambierebbe questa richiesta per una lista ( vedi la nota
            // in testa al file ); numero per l'UNIQUE( id_tipologia, numero, sezionale );
            // id_referente_emittente perche' e' l'operatore, e qui non c'e';
            // id_account_inserimento perche' il cron non ha sessione.
            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'codice' => $codiceRichiesta,
                    'id_tipologia' => 7,
                    'id_emittente' => $magazzino['id_anagrafica'],
                    'id_sede_emittente' => $magazzino['id_indirizzo'],
                    'data' => date( 'Y-m-d' ),
                    'nome' => 'richiesta ' . $codiceRichiesta . ' generata automaticamente da sottoscorta',
                    'timestamp_inserimento' => time(),
                ),
                'documenti',
                false
            );

            // rileggo per codice: su duplicato la INSERT IGNORE restituisce insert_id = 0
            $idRichiesta = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM documenti WHERE codice = ? AND id_tipologia = 7 LIMIT 1',
                array(
                    array( 's' => $codiceRichiesta )
                )
            );

            if( empty( $idRichiesta ) ) {
                mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );
                $status['err'][] = 'la richiesta ' . $codiceRichiesta . ' non e\' stata creata ne\' ritrovata: sezionale ' . $sezionale . ' saltato';
                $status['conteggi']['errori']++;
                continue;
            }

            // se la richiesta ha gia' delle righe, il giro di questo turno e' gia' stato fatto:
            // non se ne aggiungono altre, altrimenti un rilancio a mano raddoppierebbe le
            // quantita' da prelevare
            $righeGiaFatte = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT count(*) FROM documenti_articoli WHERE id_documento = ?',
                array(
                    array( 's' => $idRichiesta )
                )
            );

            if( ! empty( $righeGiaFatte ) ) {

                mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

                // il turno e' gia' stato lavorato, quindi non nasce nessuna missione nuova. Ma
                // una missione per questa destinazione puo' esistere gia' - creata dal giro
                // precedente - e allora e' quella che va mostrata: dire "nascera' al giro
                // successivo" quando la missione c'e' gia' sarebbe falso quanto dire "rifornita"
                // quando non c'e'. La riga resta segnalata perche' la merce non si e' ancora
                // mossa: sparira' quando l'operatore avra' fatto il prelievo.
                foreach( $daRifornire as $riga ) {

                    $chiave = $riga['id_mastro'] . '|' . $riga['id_articolo'];
                    $codiceEsistente = 'M' . $codiceRichiesta . '-' . $riga['id_mastro'];

                    $idEsistente = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM documenti WHERE codice = ? AND id_tipologia = 36 LIMIT 1',
                        array(
                            array( 's' => $codiceEsistente )
                        )
                    );

                    if( ! empty( $idEsistente ) ) {
                        $segnalazioni[ $chiave ]['id_missione'] = $idEsistente;
                        $segnalazioni[ $chiave ]['missione'] = $codiceEsistente;
                        $segnalazioni[ $chiave ]['esito'] = 'rifornita';
                        $segnalazioni[ $chiave ]['motivo'] = 'missione gia\' generata in questo turno, in attesa di prelievo'
                            . ( ( $riga['quantita_richiesta'] < $riga['mancante'] ) ? ' ( rifornimento parziale )' : '' );
                    } else {
                        $segnalazioni[ $chiave ]['motivo'] =
                            'la richiesta ' . $codiceRichiesta . ' di questo turno e\' gia\' stata lavorata: la missione nascera\' al giro successivo';
                    }

                }

                $status['info'][] = 'la richiesta ' . $codiceRichiesta . ' esiste gia\' con ' . $righeGiaFatte . ' righe: sezionale ' . $sezionale . ' gia\' lavorato in questo turno';
                $status['saltati'][] = $codiceRichiesta;
                $status['conteggi']['saltati']++;
                continue;

            }

            // una missione per ubicazione da rifornire
            foreach( $perDestinazione as $idDestinazione => $righeDestinazione ) {

                // la missione con le sue righe. La funzione e' condivisa con la generazione a
                // mano dalla scheda sottoscorta: la forma dei documenti di rifornimento e' un
                // modello, non un dettaglio di chi la invoca ( _mod/_0500.mastri/_src/_lib/_mysql.utils.add.php )
                $missione = creaMissioneRifornimento(
                    $cf['mysql']['connection'],
                    $idRichiesta,
                    $codiceRichiesta,
                    $magazzino,
                    $idDestinazione,
                    $righeDestinazione
                );

                $codiceMissione = $missione['codice'];
                $idMissione = $missione['id'];

                if( ! empty( $missione['errore'] ) ) {
                    $status['err'][] = $missione['errore'] . ': ubicazione ' . $idDestinazione . ' saltata';
                    $status['conteggi']['errori']++;
                    continue;
                }

                // ora, e solo ora, le righe sono davvero rifornite
                foreach( $righeDestinazione as $riga ) {
                    $segnalazioni[ $riga['id_mastro'] . '|' . $riga['id_articolo'] ]['id_missione'] = $idMissione;
                    $segnalazioni[ $riga['id_mastro'] . '|' . $riga['id_articolo'] ]['missione'] = $codiceMissione;
                    $segnalazioni[ $riga['id_mastro'] . '|' . $riga['id_articolo'] ]['esito'] = 'rifornita';
                }

                // status
                $status['info'][] = 'creata la missione di rifornimento ' . $codiceMissione . ' (#' . $idMissione . ') con ' . count( $righeDestinazione ) . ' righe verso ' . $righeDestinazione[0]['collocazione'];
                $status['creati'][] = $codiceMissione;
                $status['conteggi']['creati']++;

            }

            // ...
            mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

        }

        /**
         * LE SOGLIE CHE NON SI SANNO CONVERTIRE
         *
         * Non entrano nelle segnalazioni - una soglia che non si sa valutare non deve produrre
         * un allarme a caso - ma non devono nemmeno sparire: al 16/09/2026 sono la maggioranza
         * ( 108 su 183 ), e chi guarda la scheda deve sapere che quelle ubicazioni non sono
         * coperte. Vanno in un report loro, non in una riga a parte del report delle
         * segnalazioni: non hanno giacenza ne' mancante ne' esito, e mescolarle gonfierebbe il
         * conteggio dei sottoscorta.
         *
         * Sta fuori dal ciclo dei sezionali perche' la domanda non e' per magazzino: una soglia
         * o si sa convertire o no, e questo dipende dall'articolo.
         */
        $nonValutabili = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT mastri_articoli.id_mastro,
                    mastri.codice AS collocazione,
                    mastri_articoli.id_articolo,
                    articoli.nome AS articolo,
                    mastri_articoli.scorta_minima,
                    mastri_articoli.scorta_massima,
                    udm.nome AS udm
                FROM mastri_articoli
                INNER JOIN mastri ON mastri.id = mastri_articoli.id_mastro
                INNER JOIN articoli ON articoli.id = mastri_articoli.id_articolo
                LEFT JOIN udm ON udm.id = mastri_articoli.id_udm
                WHERE mastri_articoli.scorta_minima IS NOT NULL
                  AND mastri_articoli.id_udm IS NOT NULL
                  AND upper( udm.sigla ) <> upper( coalesce( ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "umi" ), "" ) )
                  AND NOT (
                        upper( udm.sigla ) = upper( coalesce( ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "um_movimentazione" ), "" ) )
                        AND ( SELECT max( testo ) FROM metadati_articoli WHERE id_articolo = mastri_articoli.id_articolo AND nome = "conf_qta" ) + 0 > 0
                    )
                ORDER BY mastri.codice ASC',
            array()
        );

        // stesso criterio del report delle segnalazioni: si azzera e si riscrive per intero,
        // cosi' una soglia diventata valutabile ( il cliente ha dichiarato la confezione )
        // sparisce da qui da sola, senza che nessuno debba cancellarla
        mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM __report_scorte_non_valutabili__', array() );

        $status['conteggi']['soglie_non_valutabili'] = ( ! empty( $nonValutabili ) ) ? count( $nonValutabili ) : 0;

        if( ! empty( $nonValutabili ) ) {

            $status['info'][] = count( $nonValutabili ) . ' soglie dichiarate in un\'unita\' che per quell\'articolo non si sa convertire: non vengono valutate ( manca la confezione dichiarata in SAM )';

            foreach( $nonValutabili as $nv ) {

                $motivo = 'la soglia e\' in "' . $nv['udm'] . '" ma per questo articolo la confezione non e\' dichiarata in SAM ( manca um_movimentazione o conf_qta ): non si sa quanti pezzi faccia';

                mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => $nv['id_mastro'] . '|' . $nv['id_articolo'],
                        'id_articolo' => $nv['id_articolo'],
                        'articolo' => $nv['articolo'],
                        'id_mastro' => $nv['id_mastro'],
                        'collocazione' => $nv['collocazione'],
                        'scorta_minima' => $nv['scorta_minima'],
                        'scorta_massima' => $nv['scorta_massima'],
                        'udm' => $nv['udm'],
                        'motivo' => $motivo,
                        'timestamp_aggiornamento' => time(),
                        '__label__' => $nv['id_articolo'] . ' in ' . $nv['collocazione'],
                    ),
                    '__report_scorte_non_valutabili__',
                    false,
                    true
                );

                logWrite(
                    'sottoscorta: soglia di ' . $nv['scorta_minima'] . ' "' . $nv['udm'] . '" non convertibile per l\'articolo ' . $nv['id_articolo'] . ' in ' . $nv['collocazione'] . ': manca um_movimentazione o conf_qta, riga non valutata',
                    'sottoscorta',
                    LOG_WARNING
                );

            }

        }

        // riscrivo il report che alimenta la scheda "sottoscorta".
        // Si azzera e si riscrive per intero: le righe rientrate sopra la scorta minima devono
        // sparire, non restare li' a segnalare un problema che non c'e' piu'.
        mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM __report_sottoscorta__', array() );

        foreach( ( isset( $segnalazioni ) ? $segnalazioni : array() ) as $chiave => $segnalazione ) {

            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => $chiave,
                    'id_articolo' => $segnalazione['id_articolo'],
                    'articolo' => $segnalazione['articolo'],
                    'id_mastro' => $segnalazione['id_mastro'],
                    'collocazione' => $segnalazione['collocazione'],
                    'giacenza' => $segnalazione['giacenza'],
                    'scorta_minima' => $segnalazione['scorta_minima'],
                    'scorta_massima' => $segnalazione['scorta_massima'],
                    // la soglia com'e' stata dichiarata, accanto a quella convertita: chi ha
                    // scritto "12 scatole" deve ritrovare il suo 12, e chi confronta con la
                    // giacenza deve avere il numero nell'unita' della giacenza. Servono
                    // tutt'e due, e la seconda da sola non si spiega
                    'scorta_minima_dichiarata' => $segnalazione['scorta_minima_dichiarata'],
                    'scorta_massima_dichiarata' => $segnalazione['scorta_massima_dichiarata'],
                    'udm' => $segnalazione['udm'],
                    'mancante' => $segnalazione['mancante'],
                    'id_mastro_bulk' => $segnalazione['id_mastro_bulk'],
                    'bulk' => $segnalazione['bulk'],
                    'giacenza_bulk' => $segnalazione['giacenza_bulk'],
                    'quantita_richiesta' => $segnalazione['quantita_richiesta'],
                    'id_missione' => $segnalazione['id_missione'],
                    'missione' => $segnalazione['missione'],
                    'esito' => $segnalazione['esito'],
                    'motivo' => $segnalazione['motivo'],
                    'se_allarme' => 1,
                    'timestamp_aggiornamento' => time(),
                    '__label__' => $segnalazione['id_articolo'] . ' in ' . $segnalazione['collocazione'],
                ),
                '__report_sottoscorta__',
                false,
                true
            );

            // il canale di log dedicato: serve a poter ricostruire a posteriori cosa il task ha
            // visto a ogni giro, che il report da solo non dice ( viene riscritto ogni volta )
            logger(
                $segnalazione['id_articolo'] . ' in ' . $segnalazione['collocazione'] . ': giacenza ' . $segnalazione['giacenza'] . ' sotto la scorta minima ' . $segnalazione['scorta_minima'] . ' -> ' . $segnalazione['esito'] . ( ! empty( $segnalazione['motivo'] ) ? ' ( ' . $segnalazione['motivo'] . ' )' : '' ),
                'sottoscorta',
                LOG_INFO
            );

        }

        // le ubicazioni sorvegliate che NON sono in allarme: stessa tabella, se_allarme a zero.
        // Non si loggano una per una - sono la maggioranza e non e' successo niente - ma nel
        // report ci vanno, perche' la scheda si apre sull'allarme e si allarga a tutte con un
        // filtro, e senza queste righe "tutte" mostrerebbe le stesse dell'allarme.
        foreach( $sorvegliate as $chiave => $sorvegliata ) {

            if( isset( $segnalazioni[ $chiave ] ) ) { continue; }

            $status['conteggi']['sorvegliate']++;

            mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id' => $chiave,
                    'id_articolo' => $sorvegliata['id_articolo'],
                    'articolo' => $sorvegliata['articolo'],
                    'id_mastro' => $sorvegliata['id_mastro'],
                    'collocazione' => $sorvegliata['collocazione'],
                    'giacenza' => $sorvegliata['giacenza'],
                    'scorta_minima' => $sorvegliata['scorta_minima'],
                    'scorta_massima' => $sorvegliata['scorta_massima'],
                    'scorta_minima_dichiarata' => $sorvegliata['scorta_minima_dichiarata'],
                    'scorta_massima_dichiarata' => $sorvegliata['scorta_massima_dichiarata'],
                    'udm' => $sorvegliata['udm'],
                    'esito' => 'a posto',
                    'se_allarme' => 0,
                    'timestamp_aggiornamento' => time(),
                    '__label__' => $sorvegliata['id_articolo'] . ' in ' . $sorvegliata['collocazione'],
                ),
                '__report_sottoscorta__',
                false,
                true
            );

        }

        // la mail di segnalazione, sulla coda standard del framework ( mail_out, evasa dal task
        // _mail.queue.send.php ). Destinatari o mittente vuoti = nessuna mail: e' il default,
        // cosi' su un ambiente nuovo non parte niente finche' non lo si decide.
        // NB: su DEV la coda mail e' spenta di proposito ( task.minuto = 99, il trucco di casa
        // per non spedire mail vere ), quindi qui la mail si accoda e resta li'.
        $destinatari = array_filter( array_map( 'trim', explode( ',', $cf['automazioni']['profile']['sottoscorta']['destinatari'] ) ) );
        $mittente = trim( $cf['automazioni']['profile']['sottoscorta']['mittente'] );

        if( ! empty( $destinatari ) && ! empty( $mittente ) && ! empty( $segnalazioni ) ) {

            $corpo = array();
            foreach( $segnalazioni as $segnalazione ) {
                $corpo[] = $segnalazione['id_articolo'] . ' ' . $segnalazione['articolo']
                    . ' in ' . $segnalazione['collocazione']
                    . ': giacenza ' . $segnalazione['giacenza'] . ', scorta minima ' . $segnalazione['scorta_minima']
                    . ' -> ' . $segnalazione['esito']
                    . ( ! empty( $segnalazione['missione'] ) ? ' con la missione ' . $segnalazione['missione'] : '' )
                    . ( ! empty( $segnalazione['motivo'] ) ? ' ( ' . $segnalazione['motivo'] . ' )' : '' );
            }

            // queueMail vuole mittente e destinatari come array nome => indirizzo
            $a = array();
            foreach( $destinatari as $destinatario ) { $a[ $destinatario ] = $destinatario; }

            queueMail(
                $cf['mysql']['connection'],
                time(),
                array( $cf['site']['name'][ LINGUA_CORRENTE ] => $mittente ),
                $a,
                count( $segnalazioni ) . ' ubicazioni sotto scorta minima',
                implode( PHP_EOL, $corpo )
            );

            $status['info'][] = 'accodata la mail di segnalazione a ' . count( $destinatari ) . ' destinatari';

        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}

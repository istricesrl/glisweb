<?php

    /**
     * libreria per la generazione degli oggetti pianificati
     *
     * Questa libreria contiene le funzioni con cui il modulo _PI000.pianificazioni trasforma una riga della tabella
     * pianificazioni negli oggetti che descrive: documenti con le loro righe e i loro pagamenti, todo, attività, rinnovi,
     * righe di documento e pagamenti autonomi.
     *
     * introduzione
     * ============
     * Una pianificazione dice QUANDO creare un oggetto ( periodicità, cadenza, giorni della settimana, date di inizio e
     * di fine ) e COME farlo: le colonne model_* sono il modello dell'oggetto, e la colonna model_X finisce nella colonna
     * X della tabella che la colonna entita indica. Le righe figlie ( id_genitore ) di una pianificazione di documenti
     * sono il modello delle righe e dei pagamenti di ciascun documento. Le stringhe dei modelli possono contenere Twig,
     * con a disposizione la data dell'oggetto:
     *
     * variabile                | contenuto
     * -------------------------|--------------------------------------------------------------------------------------
     * dt.now.giorno            | il giorno della data dell'oggetto, a due cifre
     * dt.now.nome_giorno       | il nome del giorno della settimana, in italiano
     * dt.now.mese              | il mese, a due cifre
     * dt.now.nome_mese         | il nome del mese, in italiano
     * dt.now.anno              | l'anno, a quattro cifre
     * dt.articoli.totale       | solo nei pagamenti figli di un documento: il totale ivato delle righe appena create
     *
     * Le date si calcolano con creazionePianificazione() di _src/_lib/_cron.utils.php, che è la sola fonte per il
     * calendario delle ripetizioni: questa libreria decide solo QUALI di quelle date vanno ancora create.
     *
     * idempotenza
     * -----------
     * Ogni oggetto nasce in una transazione insieme alle sue righe figlie e all'aggiornamento di data_ultimo_oggetto
     * della pianificazione, così che un giro interrotto a metà non lasci un documento senza righe né una data saltata.
     * Prima di creare un oggetto si controlla che non ne esista già uno della stessa pianificazione per la stessa data,
     * e le date da creare partono dal giorno dopo data_ultimo_oggetto ( o, se manca, dopo l'ultimo oggetto esistente
     * della pianificazione, per le pianificazioni che hanno già generato oggetti prima che la colonna fosse tenuta ).
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in due gruppi.
     *
     * funzioni di supporto
     * --------------------
     * Le funzioni in questo gruppo preparano i dati per la generazione.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pianificazioniEntita()           | restituisce la tabella, il campo data e i moduli di un'entità pianificabile
     * pianificazioniEntitaAttiva()     | verifica se è attivo un modulo che gestisce un'entità pianificabile
     * pianificazioniDatiData()         | prepara le variabili Twig relative alla data di un oggetto
     * pianificazioniRiga()             | costruisce la riga di un oggetto a partire dal modello
     * pianificazioniScadenza()         | calcola la scadenza di un pagamento pianificato
     * pianificazioniDate()             | calcola le date degli oggetti ancora da creare
     * pianificazioniUltimaRipetizione()| restituisce l'ultima ripetizione il cui oggetto non viene dopo una data
     *
     * funzioni di generazione
     * -----------------------
     * Le funzioni in questo gruppo creano gli oggetti.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pianificazioniElabora()          | crea gli oggetti di una pianificazione fino alla data di lavoro
     * pianificazioniDaOggetto()        | crea una pianificazione che ha per modello un oggetto esistente
     *
     * dipendenze
     * ==========
     * Questa libreria richiede le seguenti funzioni esterne.
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * creazionePianificazione()        | _src/_lib/_cron.utils.php
     * twigRenderText()                 | _src/_lib/_twig.tools.php
     * int2month(), int2day()           | _src/_lib/_string.tools.php
     * mysqlQuery(), mysqlInsertRow()   | _src/_lib/_mysql.tools.php
     * generaProssimoNumeroDocumento()  | _mod/_DO000.documenti/_src/_lib/_mysql.utils.add.php, o quella di _0400.documenti
     *
     * changelog
     * =========
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-25       | Fabio Mosti          | prima versione, dal task populate di _0100.pianificazioni
     * 2026-09-25       | Fabio Mosti          | entità disponibili secondo i moduli attivi
     * 2026-09-25       | Fabio Mosti          | ultima ripetizione per la ripianificazione
     * 2026-09-25       | Fabio Mosti          | pianificazione da un oggetto esistente
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI SUPPORTO
     */

    /**
     * restituisce la tabella, il campo data e i moduli di un'entità pianificabile
     *
     * Questa funzione restituisce, per uno dei valori dell'enum pianificazioni.entita, un array con la tabella in cui
     * vanno creati gli oggetti ( chiave tabella ), la colonna che riceve la data dell'oggetto ( chiave data ) e i moduli
     * che gestiscono l'entità ( chiave moduli, ne basta uno attivo, vedi pianificazioniEntitaAttiva() ); per un valore
     * sconosciuto restituisce NULL.
     *
     * Per le tre entità dei documenti basta uno dei due moduli dei documenti, _0400.documenti o _DO000.documenti ( che
     * non si attivano mai insieme ): un documento pianificato nasce numerato, e generaProssimoNumeroDocumento() sta in
     * tutti e due; _DO010.fatture da solo non basta, perché la numerazione è di _DO000.
     *
     * @param       string      $e      l'entità ( todo, attivita, rinnovi, documenti, documenti_articoli, pagamenti )
     *
     * @return      mixed               l'array con tabella, campo data e moduli, oppure NULL
     *
     */
    function pianificazioniEntita( $e ) {

        // campo data di ciascuna entità
        $campi = array(
            'todo'                  => 'data_programmazione',
            'attivita'              => 'data_programmazione',
            'rinnovi'               => 'data_inizio',
            'documenti'             => 'data',
            'documenti_articoli'    => 'data',
            'pagamenti'             => 'data_scadenza'
        );

        // moduli che gestiscono ciascuna entità
        $moduli = array(
            'todo'                  => array( '1200.todo' ),
            'attivita'              => array( '0200.attivita', 'AT000.attivita' ),
            'rinnovi'               => array( '0600.contratti' ),
            'documenti'             => array( '0400.documenti', 'DO000.documenti' ),
            'documenti_articoli'    => array( '0400.documenti', 'DO000.documenti' ),
            'pagamenti'             => array( '0400.documenti', 'DO000.documenti' )
        );

        // entità sconosciuta
        if( empty( $e ) || ! isset( $campi[ $e ] ) ) {
            return NULL;
        }

        return array( 'tabella' => $e, 'data' => $campi[ $e ], 'moduli' => $moduli[ $e ] );

    }

    /**
     * verifica se è attivo un modulo che gestisce un'entità pianificabile
     *
     * Questa funzione restituisce true se fra i moduli attivi c'è almeno uno di quelli che pianificazioniEntita()
     * indica per l'entità $e, false se non ce n'è nessuno o se l'entità è sconosciuta. Con questa funzione il form
     * delle pianificazioni propone solo le entità disponibili e pianificazioniElabora() salta le pianificazioni di
     * un'entità il cui modulo non è ( più ) attivo.
     *
     * @param       string      $e      l'entità ( todo, attivita, rinnovi, documenti, documenti_articoli, pagamenti )
     *
     * @return      bool                true se un modulo che gestisce l'entità è attivo, false altrimenti
     *
     */
    function pianificazioniEntitaAttiva( $e ) {

        global $cf;

        // entità
        $e = pianificazioniEntita( $e );

        // entità sconosciuta
        if( empty( $e ) ) {
            return false;
        }

        // moduli attivi fra quelli dell'entità
        return ( count( array_intersect( $e['moduli'], $cf['mods']['active']['array'] ) ) > 0 );

    }

    /**
     * prepara le variabili Twig relative alla data di un oggetto
     *
     * Questa funzione restituisce l'array delle variabili con cui si rendono le stringhe dei modelli ( vedi la testata
     * della libreria ). I nomi di giorno e mese vengono da int2day() e int2month() e non da strftime(), che è deprecata
     * da PHP 8.1 ( il task della fase precedente la usava ).
     *
     * @param       string      $data   la data dell'oggetto, nel formato Y-m-d
     *
     * @return      array               le variabili per il rendering
     *
     */
    function pianificazioniDatiData( $data ) {

        // timestamp della data
        $t = strtotime( $data );

        return array(
            'dt' => array(
                'now' => array(
                    'giorno'        => date( 'd', $t ),
                    'nome_giorno'   => int2day( date( 'w', $t ) ),
                    'mese'          => date( 'm', $t ),
                    'nome_mese'     => int2month( date( 'n', $t ) ),
                    'anno'          => date( 'Y', $t )
                )
            )
        );

    }

    /**
     * costruisce la riga di un oggetto a partire dal modello
     *
     * Questa funzione restituisce la riga da inserire nella tabella $t per la pianificazione $p: per ogni colonna della
     * tabella che ha un model_<colonna> valorizzato prende quel valore, reso con Twig se contiene un'espressione, e per
     * id_contratto, id_progetto, id_todo e id_attivita, se il modello non li dice, prende il collegamento della
     * pianificazione stessa. Aggiunge id_pianificazione e timestamp_inserimento; la colonna data e le colonne che
     * dipendono dall'entità ( numero, scadenze ) le aggiunge il chiamante.
     *
     * NOTA fino al 2026-09-25 il rendering usava come loader Twig l'intera riga della pianificazione, e una colonna
     * NULL faceva fallire il costruttore dell'ArrayLoader con un TypeError: adesso si rendono solo le stringhe che
     * contengono un'espressione Twig.
     *
     * @param       array       $p      la riga della pianificazione ( o della pianificazione figlia )
     * @param       string      $t      la tabella in cui verrà inserita la riga
     * @param       array       $d      le variabili per il rendering ( vedi pianificazioniDatiData() )
     *
     * @return      array               la riga dell'oggetto
     *
     */
    function pianificazioniRiga( $p, $t, $d ) {

        global $cf;

        // colonne delle tabelle già lette
        static $colonne = array();

        // colonne della tabella
        if( ! isset( $colonne[ $t ] ) ) {
            $colonne[ $t ] = mysqlSelectColumn(
                'COLUMN_NAME',
                $cf['mysql']['connection'],
                'SELECT COLUMN_NAME FROM information_schema.columns WHERE table_schema = database() AND table_name = ?',
                array( array( 's' => $t ) )
            );
        }

        // stringhe del modello da rendere
        $tpls = array();
        foreach( $p as $k => $v ) {
            if( substr( $k, 0, 6 ) == 'model_' && is_string( $v ) && ( strpos( $v, '{{' ) !== false || strpos( $v, '{%' ) !== false ) ) {
                $tpls[ $k ] = $v;
            }
        }

        // rendering
        if( ! empty( $tpls ) ) {
            twigRenderText( $tpls, $d );
            $p = array_replace( $p, $tpls );
        }

        // riga dell'oggetto
        $r = array();

        // valori dal modello e dai collegamenti della pianificazione
        foreach( (array) $colonne[ $t ] as $c ) {
            if( isset( $p[ 'model_' . $c ] ) && $p[ 'model_' . $c ] !== '' ) {
                $r[ $c ] = $p[ 'model_' . $c ];
            } elseif( in_array( $c, array( 'id_contratto', 'id_progetto', 'id_todo', 'id_attivita' ) ) && ! empty( $p[ $c ] ) ) {
                $r[ $c ] = $p[ $c ];
            }
        }

        // collegamento alla pianificazione
        $r['id_pianificazione'] = $p['id'];

        // inserimento
        $r['timestamp_inserimento'] = time();

        return $r;

    }

    /**
     * calcola la scadenza di un pagamento pianificato
     *
     * Questa funzione restituisce la scadenza di un pagamento che nasce alla data $data secondo i differimenti della
     * pianificazione $p: offset_giorni giorni, contati come mesi interi ( ogni trenta giorni ) più i giorni che restano,
     * e offset_fine_mese per spostare la scadenza all'ultimo giorno del mese. I mesi si aggiungono con
     * creazionePianificazione(), che si ferma all'ultimo giorno dei mesi più corti ( 31/01 a 30 giorni dà 28/02 ).
     *
     * NOTA fino al 2026-09-25 i mesi si aggiungevano con strtotime( '+1 months' ), e un pagamento a 30 giorni di una
     * fattura del 31/01 scadeva il 03/03.
     *
     * @param       string      $data   la data del documento o del pagamento
     * @param       array       $p      la riga della pianificazione del pagamento
     *
     * @return      string              la scadenza, nel formato Y-m-d
     *
     */
    function pianificazioniScadenza( $data, $p ) {

        // scadenza di partenza
        $scadenza = $data;

        // differimento in giorni
        if( ! empty( $p['offset_giorni'] ) ) {
            $mesi = floor( $p['offset_giorni'] / 30 );
            $giorni = $p['offset_giorni'] - ( $mesi * 30 );
            if( $mesi > 0 ) {
                $date = creazionePianificazione( $scadenza, 3, $mesi, NULL, 2 );
                $scadenza = end( $date );
            }
            $scadenza = date( 'Y-m-d', strtotime( $scadenza . ' +' . $giorni . ' days' ) );
        }

        // differimento a fine mese
        if( ! empty( $p['offset_fine_mese'] ) ) {
            $scadenza = date( 'Y-m-t', strtotime( $scadenza ) );
        }

        return $scadenza;

    }

    /**
     * calcola le date degli oggetti ancora da creare
     *
     * Questa funzione restituisce, ordinate, le date in cui la pianificazione $p deve ancora creare un oggetto,
     * lavorando alla data $data:
     *
     * -# la ripetizione parte da data_inizio ( o da data_avvio se data_inizio è vuota );
     * -# la finestra di lavoro arriva a $data più giorni_elaborazione giorni;
     * -# se data_fine è vuota viene ricavata dall'oggetto collegato ( ultima data_fine dei rinnovi del contratto,
     *    data_chiusura del progetto, data_scadenza della todo ), altrimenti la ripetizione non ha fine;
     * -# se la finestra supera data_fine e la pianificazione ha giorni_estensione, data_fine viene allungata di
     *    giorni_estensione giorni finché non copre la finestra, e scritta nella pianificazione; altrimenti la finestra
     *    si ferma a data_fine;
     * -# dalle date di creazionePianificazione() si tolgono quelle fino a data_ultimo_oggetto compresa ( o, se manca,
     *    fino alla data dell'ultimo oggetto esistente della pianificazione ).
     *
     * NOTA fino al 2026-09-25 la finestra si calcolava sempre da oggi anche quando si simulava un'altra data con il
     * parametro d, e l'estensione scriveva in data_fine, che è una colonna DATE, un timestamp unix.
     *
     * @param       array       $p      la riga della pianificazione
     * @param       string      $data   la data di lavoro, nel formato Y-m-d
     * @param       array       $status l'array di stato, a cui la funzione aggiunge le sue informazioni
     *
     * @return      array               le date degli oggetti da creare
     *
     */
    function pianificazioniDate( $p, $data, &$status = array() ) {

        global $cf;

        // entità
        $e = pianificazioniEntita( $p['entita'] );

        // data di inizio della ripetizione
        $inizio = ( ! empty( $p['data_inizio'] ) ) ? $p['data_inizio'] : $p['data_avvio'];

        // senza data di inizio non si può fare niente
        if( empty( $inizio ) || empty( $e ) ) {
            $status['err'][] = 'la pianificazione #' . $p['id'] . ' non ha data di inizio o entità';
            return array();
        }

        // fine della finestra di lavoro
        $stop = date( 'Y-m-d', strtotime( $data . ' +' . intval( $p['giorni_elaborazione'] ) . ' days' ) );

        // data di fine della pianificazione
        $fine = $p['data_fine'];

        // data di fine ricavata dall'oggetto collegato
        if( empty( $fine ) ) {
            if( ! empty( $p['id_contratto'] ) ) {
                $fine = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT max( data_fine ) FROM rinnovi WHERE id_contratto = ?', array( array( 's' => $p['id_contratto'] ) ) );
            } elseif( ! empty( $p['id_progetto'] ) ) {
                $fine = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT data_chiusura FROM progetti WHERE id = ?', array( array( 's' => $p['id_progetto'] ) ) );
            } elseif( ! empty( $p['id_todo'] ) ) {
                $fine = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT data_scadenza FROM todo WHERE id = ?', array( array( 's' => $p['id_todo'] ) ) );
            }
            if( ! empty( $fine ) ) {
                $status['info'][] = 'data di fine ricavata dall\'oggetto collegato: ' . $fine;
            }
        }

        // estensione o limite della finestra
        if( ! empty( $fine ) && $stop > $fine ) {
            if( ! empty( $p['data_fine'] ) && ! empty( $p['giorni_estensione'] ) && $p['giorni_estensione'] > 0 ) {
                while( $fine < $stop ) {
                    $fine = date( 'Y-m-d', strtotime( $fine . ' +' . $p['giorni_estensione'] . ' days' ) );
                }
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_fine = ? WHERE id = ?',
                    array(
                        array( 's' => $fine ),
                        array( 's' => $p['id'] )
                    )
                );
                $status['info'][] = 'data di fine estesa al ' . $fine;
            } else {
                $stop = $fine;
            }
        }

        // giorni della settimana ( 0 lunedì ... 6 domenica )
        $giorni = array();
        foreach( array( 'se_lunedi', 'se_martedi', 'se_mercoledi', 'se_giovedi', 'se_venerdi', 'se_sabato', 'se_domenica' ) as $g => $k ) {
            if( ! empty( $p[ $k ] ) ) { $giorni[] = $g; }
        }

        // schema di ripetizione ( 1 stesso giorno, 2 stesso giorno della settimana nella stessa posizione )
        $schema = ( empty( $p['schema_ripetizione'] ) ) ? 1 : $p['schema_ripetizione'];

        // date della ripetizione fino alla fine della finestra
        $date = creazionePianificazione( $inizio, $p['id_periodicita'], $p['cadenza'], $stop, 1, $giorni, $schema, $schema );

        // data dell'ultimo oggetto creato
        $ultimo = $p['data_ultimo_oggetto'];
        if( empty( $ultimo ) ) {
            $ultimo = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT max( ' . $e['data'] . ' ) FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ?',
                array( array( 's' => $p['id'] ) )
            );
        }

        // tolgo le date già lavorate
        if( ! empty( $ultimo ) ) {
            $date = array_values( array_filter( $date, function( $d ) use ( $ultimo ) { return $d > $ultimo; } ) );
            $status['info'][] = 'ultimo oggetto creato il ' . $ultimo;
        }

        // status
        $status['info'][] = 'finestra di lavoro dal ' . $inizio . ' al ' . $stop . ', date da creare: ' . count( $date );

        return $date;

    }

    /**
     * restituisce l'ultima ripetizione il cui oggetto non viene dopo una data
     *
     * Questa funzione restituisce la più recente fra le date di ripetizione della pianificazione $p ( quelle di
     * creazionePianificazione(), con i parametri attuali ) il cui oggetto ha una data non successiva a $d. Per tutte le
     * entità tranne i pagamenti la data dell'oggetto è quella della ripetizione; per i pagamenti è la scadenza calcolata
     * da pianificazioniScadenza(), che con un differimento cade dopo la ripetizione. Se nessuna ripetizione ha l'oggetto
     * entro $d restituisce il giorno prima della prima ripetizione. È il valore da scrivere in data_ultimo_oggetto, che
     * contiene sempre una data di ripetizione, quando si cancellano gli oggetti dopo una data e se ne vuole ripartire.
     *
     * NOTA la scadenza di un pagamento già creato si confronta con le ripetizioni calcolate con i parametri attuali: se
     * nel frattempo è cambiato il differimento, la ripetizione ricavata è quella dei parametri nuovi.
     *
     * @param       array       $p      la riga della pianificazione
     * @param       string      $d      la data dell'oggetto, nel formato Y-m-d
     *
     * @return      string              la data della ripetizione, nel formato Y-m-d
     *
     */
    function pianificazioniUltimaRipetizione( $p, $d ) {

        // entità
        $e = pianificazioniEntita( $p['entita'] );

        // data di inizio della ripetizione
        $inizio = ( ! empty( $p['data_inizio'] ) ) ? $p['data_inizio'] : $p['data_avvio'];

        // giorni della settimana ( 0 lunedì ... 6 domenica )
        $giorni = array();
        foreach( array( 'se_lunedi', 'se_martedi', 'se_mercoledi', 'se_giovedi', 'se_venerdi', 'se_sabato', 'se_domenica' ) as $g => $k ) {
            if( ! empty( $p[ $k ] ) ) { $giorni[] = $g; }
        }

        // schema di ripetizione
        $schema = ( empty( $p['schema_ripetizione'] ) ) ? 1 : $p['schema_ripetizione'];

        // ripetizioni fino alla data, perché l'oggetto non viene mai prima della sua ripetizione
        $date = ( $inizio > $d ) ? array() : creazionePianificazione( $inizio, $p['id_periodicita'], $p['cadenza'], $d, 1, $giorni, $schema, $schema );

        // ultima ripetizione con l'oggetto entro la data
        $ultima = date( 'Y-m-d', strtotime( $inizio . ' -1 day' ) );
        foreach( (array) $date as $r ) {
            if( ( ( $e['tabella'] == 'pagamenti' ) ? pianificazioniScadenza( $r, $p ) : $r ) <= $d ) {
                $ultima = $r;
            }
        }

        return $ultima;

    }

    /**
     * FUNZIONI DI GENERAZIONE
     */

    /**
     * crea gli oggetti di una pianificazione fino alla data di lavoro
     *
     * Questa funzione crea gli oggetti della pianificazione $p per le date restituite da pianificazioniDate(), uno per
     * data, ciascuno in una transazione insieme alle sue righe figlie e all'aggiornamento di data_ultimo_oggetto. Per i
     * documenti:
     *
     * -# si crea UN SOLO documento per chiamata, il più vecchio fra quelli da creare: i documenti sono numerati, e il
     *    blocco delle pianificazioni di _src/_api/_cron.php elabora le pianificazioni in ordine di data del prossimo
     *    oggetto, quindi un documento per giro tiene la numerazione in ordine cronologico anche fra pianificazioni
     *    diverse ( è la scelta del commit 34b8b3f31, che con le date settimanali disordinate numerava fuori ordine );
     * -# il numero viene da generaProssimoNumeroDocumento(), e l'inserimento è un INSERT IGNORE: se il numero è già
     *    preso il documento non viene creato e la transazione si annulla, invece di aggiornare il documento esistente;
     * -# le pianificazioni figlie di entità documenti_articoli diventano le righe del documento, quelle di entità
     *    pagamenti i suoi pagamenti, con la scadenza calcolata da pianificazioniScadenza() e dt.articoli.totale
     *    disponibile nel modello dell'importo.
     *
     * Tutti gli inserimenti sono INSERT IGNORE ( mysqlInsertRow() con $d a false ) e non INSERT ... ON DUPLICATE KEY
     * UPDATE, il default: un oggetto che collide con una chiave unica ( il numero di un documento, un codice fisso nel
     * modello ) non viene creato e la transazione si annulla, invece di riscrivere l'oggetto che c'era già. NOTA con
     * INSERT IGNORE MariaDB tronca in silenzio un valore troppo lungo invece di rifiutarlo.
     *
     * Una pianificazione di un'entità che nessun modulo attivo gestisce ( vedi pianificazioniEntitaAttiva() ) viene
     * saltata: la funzione lo scrive nello stato, la segna come elaborata alla data di lavoro e restituisce zero.
     *
     * Per le altre entità si creano tutti gli oggetti della finestra; le pianificazioni figlie vengono ignorate. Se
     * dopo il giro non restano date da creare, la funzione scrive $data in data_elaborazione, che è ciò che dice al cron
     * che la pianificazione è a posto per quel giorno; se un oggetto fallisce la transazione si annulla, la funzione si
     * ferma e la data resta da creare per il giro successivo.
     *
     * @param       array       $p      la riga della pianificazione ( non figlia )
     * @param       string      $data   la data di lavoro, nel formato Y-m-d
     * @param       array       $status l'array di stato, a cui la funzione aggiunge le sue informazioni
     *
     * @return      int                 il numero di oggetti creati, o false in caso di errore
     *
     */
    function pianificazioniElabora( $p, $data, &$status = array() ) {

        global $cf;

        // entità
        $e = pianificazioniEntita( $p['entita'] );

        // controlli
        if( empty( $e ) ) {
            $status['err'][] = 'la pianificazione #' . $p['id'] . ' non ha un\'entità valida';
            return false;
        } elseif( ! empty( $p['id_genitore'] ) ) {
            $status['err'][] = 'la pianificazione #' . $p['id'] . ' è figlia della #' . $p['id_genitore'] . ' e si elabora con lei';
            return false;
        }

        // entità il cui modulo non è attivo
        // NOTA la pianificazione si segna come elaborata alla data di lavoro, perché altrimenti il cron la riprenderebbe
        // a ogni passata per saltarla di nuovo; riprende da sola il giorno dopo l'attivazione del modulo ( 2026-09-25 )
        if( ! pianificazioniEntitaAttiva( $p['entita'] ) ) {
            $status['info'][] = 'la pianificazione #' . $p['id'] . ' crea ' . $p['entita'] . ' ma nessuno dei moduli che la gestiscono ( ' . implode( ', ', $e['moduli'] ) . ' ) è attivo: la salto';
            mysqlQuery( $cf['mysql']['connection'], 'UPDATE pianificazioni SET data_elaborazione = ? WHERE id = ?', array( array( 's' => $data ), array( 's' => $p['id'] ) ) );
            return 0;
        }

        // date da creare
        $date = pianificazioniDate( $p, $data, $status );

        // i documenti si creano uno alla volta
        if( $e['tabella'] == 'documenti' && count( $date ) > 1 ) {
            $status['info'][] = 'i documenti si creano uno per giro: restano ' . ( count( $date ) - 1 ) . ' date';
            $daFare = array_slice( $date, 0, 1 );
        } else {
            $daFare = $date;
        }

        // pianificazioni figlie
        $figlie = array();
        if( $e['tabella'] == 'documenti' ) {
            $figlie = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM pianificazioni WHERE id_genitore = ? ORDER BY id',
                array( array( 's' => $p['id'] ) )
            );
        }

        // oggetti creati
        $creati = 0;

        // esito
        $ok = true;

        // un oggetto per ogni data
        foreach( $daFare as $d ) {

            // variabili per il rendering
            $dati = pianificazioniDatiData( $d );

            // riga dell'oggetto
            $riga = pianificazioniRiga( $p, $e['tabella'], $dati );

            // data dell'oggetto
            $riga[ $e['data'] ] = ( $e['tabella'] == 'pagamenti' ) ? pianificazioniScadenza( $d, $p ) : $d;

            // controllo dei doppioni
            $esistente = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM ' . $e['tabella'] . ' WHERE id_pianificazione = ? AND ' . $e['data'] . ' = ? LIMIT 1',
                array(
                    array( 's' => $p['id'] ),
                    array( 's' => $riga[ $e['data'] ] )
                )
            );

            // se l'oggetto esiste già vado avanti
            if( ! empty( $esistente ) ) {
                $status['dettagli'][ $d ][] = 'oggetto già presente: #' . $esistente;
                mysqlQuery( $cf['mysql']['connection'], 'UPDATE pianificazioni SET data_ultimo_oggetto = ? WHERE id = ?', array( array( 's' => $d ), array( 's' => $p['id'] ) ) );
                continue;
            }

            // apertura della transazione
            mysqlQuery( $cf['mysql']['connection'], 'START TRANSACTION' );

            // particolarità delle entità
            if( $e['tabella'] == 'documenti' ) {

                // numero del documento
                if( ! function_exists( 'generaProssimoNumeroDocumento' ) ) {
                    $status['err'][] = 'per numerare i documenti serve generaProssimoNumeroDocumento() del modulo _DO000.documenti o _0400.documenti';
                    $ok = false;
                } elseif( empty( $riga['id_tipologia'] ) || empty( $riga['id_emittente'] ) ) {
                    $status['err'][] = 'il modello del documento non ha tipologia o emittente';
                    $ok = false;
                } else {
                    $riga['numero'] = generaProssimoNumeroDocumento( $riga['id_tipologia'], $riga['sezionale'] ?? NULL, $riga['id_emittente'] );
                }

            } elseif( $e['tabella'] == 'rinnovi' ) {

                // il rinnovo copre il periodo fino al giorno prima della ripetizione successiva
                $prossime = creazionePianificazione( $d, $p['id_periodicita'], $p['cadenza'], NULL, 2 );
                if( isset( $prossime[1] ) ) {
                    $riga['data_fine'] = date( 'Y-m-d', strtotime( $prossime[1] . ' -1 day' ) );
                }

            }

            // creazione dell'oggetto
            $id = ( $ok ) ? mysqlInsertRow( $cf['mysql']['connection'], $riga, $e['tabella'], false ) : false;

            // controllo
            if( empty( $id ) ) {
                $ok = false;
                $status['err'][] = 'impossibile creare l\'oggetto del ' . $d . ' in ' . $e['tabella'];
            }

            // totale delle righe del documento
            $dati['dt']['articoli']['totale'] = 0;

            // righe e pagamenti del documento
            foreach( ( ( $ok && is_array( $figlie ) ) ? $figlie : array() ) as $f ) {

                // righe
                if( $f['entita'] == 'documenti_articoli' ) {

                    // riga
                    $r = pianificazioniRiga( $f, 'documenti_articoli', $dati );
                    $r['id_documento'] = $id;
                    $r['data'] = $d;
                    $r['id_pianificazione'] = $p['id'];

                    // creazione
                    if( empty( mysqlInsertRow( $cf['mysql']['connection'], $r, 'documenti_articoli', false ) ) ) {
                        $status['err'][] = 'impossibile creare la riga del modello #' . $f['id'];
                        $ok = false;
                    }

                    // aliquota del reparto
                    $aliquota = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT aliquota FROM iva INNER JOIN reparti ON reparti.id_iva = iva.id WHERE reparti.id = ?',
                        array( array( 's' => $f['model_id_reparto'] ) )
                    );

                    // totale ivato
                    $dati['dt']['articoli']['totale'] += floatval( str_replace( ',', '.', $r['importo_netto_totale'] ?? 0 ) ) * ( 1 + ( floatval( $aliquota ) / 100 ) );

                }

            }

            // totale arrotondato al centesimo
            $dati['dt']['articoli']['totale'] = number_format( $dati['dt']['articoli']['totale'], 2, '.', '' );

            // pagamenti
            foreach( ( ( $ok && is_array( $figlie ) ) ? $figlie : array() ) as $f ) {
                if( $f['entita'] == 'pagamenti' ) {

                    // pagamento
                    $r = pianificazioniRiga( $f, 'pagamenti', $dati );
                    $r['id_documento'] = $id;
                    $r['data_scadenza'] = pianificazioniScadenza( $d, $f );
                    $r['id_pianificazione'] = $p['id'];

                    // creazione
                    if( empty( mysqlInsertRow( $cf['mysql']['connection'], $r, 'pagamenti', false ) ) ) {
                        $status['err'][] = 'impossibile creare il pagamento del modello #' . $f['id'];
                        $ok = false;
                    }

                }
            }

            // chiusura della transazione
            if( $ok ) {

                // data dell'ultimo oggetto, dentro la transazione
                mysqlQuery( $cf['mysql']['connection'], 'UPDATE pianificazioni SET data_ultimo_oggetto = ? WHERE id = ?', array( array( 's' => $d ), array( 's' => $p['id'] ) ) );

                // conferma
                mysqlQuery( $cf['mysql']['connection'], 'COMMIT' );

                // status
                $status['dettagli'][ $d ][] = 'creato ' . $e['tabella'] . ' #' . $id . ( ( isset( $riga['numero'] ) ) ? ' numero ' . $riga['numero'] : '' ) . ( ( isset( $riga['nome'] ) ) ? ' ' . $riga['nome'] : '' );
                $creati++;

            } else {

                // annullamento
                mysqlQuery( $cf['mysql']['connection'], 'ROLLBACK' );

                // status
                $status['err'][] = 'creazione del ' . $d . ' annullata: la data resta da creare';

                // mi fermo
                break;

            }

        }

        // se non resta niente da fare la pianificazione è a posto per la data di lavoro
        if( $ok && count( $daFare ) == count( $date ) ) {
            mysqlQuery( $cf['mysql']['connection'], 'UPDATE pianificazioni SET data_elaborazione = ? WHERE id = ?', array( array( 's' => $data ), array( 's' => $p['id'] ) ) );
        }

        // status
        $status['info'][] = 'oggetti creati: ' . $creati;

        return ( $ok ) ? $creati : false;

    }

    /**
     * crea una pianificazione che ha per modello un oggetto esistente
     *
     * Questa funzione crea una pianificazione dell'entità $e il cui modello è l'oggetto $id di quell'entità: ogni colonna
     * X dell'oggetto finisce nella colonna model_X della pianificazione, se c'è, cioè l'inverso di pianificazioniRiga().
     * Non si copiano le colonne che ogni oggetto deve avere diverse ( numero e codice, che hanno chiavi uniche, e le date,
     * che vengono dal calendario ). Per un documento si creano anche le pianificazioni figlie, una per riga e una per
     * pagamento, con il differimento del pagamento ricavato dalla distanza fra la sua scadenza e la data del documento.
     *
     * È il modo "ripeti questo oggetto" della pianificazione per modello, al posto della duplicazione ricorsiva della fase
     * precedente di _0100.pianificazioni. La pianificazione nasce senza periodicità e senza data_avvio, quindi il cron
     * non la elabora finché non la si completa nel suo form.
     *
     * @param       string      $e      l'entità dell'oggetto ( todo, attivita, rinnovi, documenti, documenti_articoli, pagamenti )
     * @param       int         $id     l'id dell'oggetto
     *
     * @return      mixed               l'id della pianificazione creata, o false se l'entità o l'oggetto non esistono
     *
     */
    function pianificazioniDaOggetto( $e, $id ) {

        global $cf;

        // entità
        $e = pianificazioniEntita( $e );

        // oggetto
        $o = ( empty( $e ) ) ? NULL : mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM ' . $e['tabella'] . ' WHERE id = ?',
            array( array( 's' => $id ) )
        );

        // controlli
        if( empty( $o ) ) {
            return false;
        }

        // colonne della tabella pianificazioni
        $colonne = mysqlSelectColumn(
            'COLUMN_NAME',
            $cf['mysql']['connection'],
            'SELECT COLUMN_NAME FROM information_schema.columns WHERE table_schema = database() AND table_name = ?',
            array( array( 's' => 'pianificazioni' ) )
        );

        // colonne che non si copiano
        $escluse = array( 'id', 'numero', 'codice', 'data', 'data_programmazione', 'data_inizio', 'data_fine', 'data_scadenza',
            'timestamp_scadenza', 'anno_programmazione', 'settimana_programmazione', 'id_pianificazione' );

        // modello di un oggetto
        $modello = function( $r ) use ( $colonne, $escluse ) {
            $m = array();
            foreach( $r as $k => $v ) {
                if( $v !== NULL && ! in_array( $k, $escluse ) && in_array( 'model_' . $k, $colonne ) ) {
                    $m[ 'model_' . $k ] = $v;
                }
            }
            return $m;
        };

        // pianificazione
        $p = array_merge(
            $modello( $o ),
            array(
                'entita' => $e['tabella'],
                'nome' => ( ( ! empty( $o['nome'] ) ) ? $o['nome'] : $e['tabella'] . ' #' . $o['id'] ),
                'cadenza' => 1,
                'timestamp_inserimento' => time()
            )
        );

        // creazione
        $idPianificazione = mysqlInsertRow( $cf['mysql']['connection'], $p, 'pianificazioni', false );

        // righe e pagamenti del documento
        if( ! empty( $idPianificazione ) && $e['tabella'] == 'documenti' ) {

            // righe
            foreach( (array) mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli WHERE id_documento = ? ORDER BY id', array( array( 's' => $o['id'] ) ) ) as $r ) {
                $f = array_merge( $modello( $r ), array( 'id_genitore' => $idPianificazione, 'entita' => 'documenti_articoli', 'timestamp_inserimento' => time() ) );
                unset( $f['model_id_documento'] );
                mysqlInsertRow( $cf['mysql']['connection'], $f, 'pianificazioni', false );
            }

            // pagamenti
            foreach( (array) mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM pagamenti WHERE id_documento = ? ORDER BY id', array( array( 's' => $o['id'] ) ) ) as $r ) {
                $f = array_merge( $modello( $r ), array( 'id_genitore' => $idPianificazione, 'entita' => 'pagamenti', 'timestamp_inserimento' => time() ) );
                unset( $f['model_id_documento'] );
                if( ! empty( $r['data_scadenza'] ) && ! empty( $o['data'] ) && $r['data_scadenza'] > $o['data'] ) {
                    $f['offset_giorni'] = intval( round( ( strtotime( $r['data_scadenza'] ) - strtotime( $o['data'] ) ) / 86400 ) );
                }
                mysqlInsertRow( $cf['mysql']['connection'], $f, 'pianificazioni', false );
            }

        }

        return $idPianificazione;

    }

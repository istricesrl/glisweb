<?php

    /**
     * elenco delle ubicazioni sorvegliate, e di quelle in allarme
     *
     * Macro sottile sopra la vista di default: dice quale tabella leggere e con che colonne, il
     * resto lo fa _default.view.php. La tabella e' __report_sottoscorta__, che il task del
     * sottoscorta riscrive per intero a ogni giro - quindi qui non c'e' niente da calcolare, si
     * mostra il verdetto dell'ultimo giro.
     *
     * Non si dichiara view.open: e' una lista di consultazione, non c'e' una scheda da aprire.
     * Le colonne si nascondono con d-none invece di toglierle, come fanno le altre viste del
     * progetto: restano disponibili all'esportazione e ai filtri.
     *
     * SORVEGLIATE E IN ALLARME
     * Il report contiene tutte le ubicazioni con una soglia, non solo quelle sotto: la vista si
     * apre sulle sole in allarme ( il filtro presettato qui sotto ) e la tendina "stato" la
     * allarga a tutte. Un'ubicazione sorvegliata e a posto e' un'informazione: distinguerla da
     * una per cui nessuno ha mai impostato niente e' il primo controllo che fa chi va a vedere
     * perche' qualcosa non e' stato segnalato.
     *
     * I NUMERI SI LEGGONO NELL'UNITA' IN CUI SONO STATI CHIESTI
     * Una soglia si dichiara nell'unita' del magazzino ( "12 scatole" ) e il task la converte
     * nell'unita' inventariale per confrontarla con la giacenza. In tabella si mostrano tutt'e
     * due - "12 scatole ( 2.400 )" - perche' chi ha scritto 12 deve ritrovare il suo 12 e chi
     * confronta con la giacenza ha bisogno del numero nell'unita' della giacenza. Quando le due
     * unita' coincidono ( per questi articoli la scatola E' l'unita' inventariale ) la parentesi
     * non si stampa: sarebbe lo stesso numero due volte.
     *
     * @file
     *
     */

    // modalita' report: senza questa il controller cercherebbe una vista __report_sottoscorta___view
    // ( getStaticViewExtension() appende _view al nome della tabella ) e la pagina risponderebbe
    // "nessun dato trovato" senza dire perche'. Le tabelle __report_*__ si leggono cosi', come fa
    // gia' mod/4100.prodotti/src/inc/macro/articoli.form.giacenze.php sulle giacenze.
    $ct['view']['data']['__report_mode__'] = 1;

    // tabella della vista
    $ct['view']['table'] = '__report_sottoscorta__';

    // la vista si apre sulle sole ubicazioni in allarme. Come tutti i preset di
    // $ct['view']['__filters__'] vale finche' l'utente non sceglie il suo ( _default.view.php ),
    // e la scelta gli resta in sessione: chi passa a "tutte" se la ritrova al giro dopo.
    $ct['view']['__filters__'] = array(
        'se_allarme' => array( 'EQ' => '1' )
    );

    // il riquadro dei filtri di questa vista
    $ct['etc']['include']['filters'] = 'inc/logistica.sottoscorta.view.filters.html';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'id_articolo' => 'articolo',
        'articolo' => 'descrizione',
        'collocazione' => 'ubicazione',
        'giacenza' => 'giacenza',
        'scorta_minima' => 'scorta minima',
        'scorta_minima_dichiarata' => 'soglia dichiarata',
        'scorta_massima' => 'scorta massima',
        'scorta_massima_dichiarata' => 'massima dichiarata',
        'udm' => 'unita\'',
        'mancante' => 'mancante',
        'bulk' => 'da rifornire da',
        'giacenza_bulk' => 'giacenza bulk',
        'quantita_richiesta' => 'richiesti',
        'missione' => 'missione',
        'se_allarme' => 'in allarme',
        'esito' => 'esito',
        'motivo' => 'motivo',
        // colonna delle azioni di riga. La chiave NULL e' la convenzione del framework per una
        // colonna che non viene da un campo della tabella ( il controller la salta nella SELECT )
        // e il contenuto lo compone la macro riga per riga, piu' sotto.
        NULL => 'azioni'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'id_articolo' => 'text-left',
        'articolo' => 'text-left d-none d-md-table-cell',
        'collocazione' => 'text-left',
        'giacenza' => 'text-right',
        'scorta_minima' => 'text-right',
        'scorta_minima_dichiarata' => 'd-none',
        'scorta_massima' => 'text-right d-none d-md-table-cell',
        'scorta_massima_dichiarata' => 'd-none',
        'udm' => 'd-none',
        'mancante' => 'text-right',
        'bulk' => 'text-left',
        'giacenza_bulk' => 'text-right d-none d-md-table-cell',
        'quantita_richiesta' => 'text-right',
        'missione' => 'text-left',
        'se_allarme' => 'd-none',
        'esito' => 'text-center',
        'motivo' => 'text-left',
        NULL => 'text-center'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    /**
     * le quantita' nell'unita' in cui sono state dichiarate
     *
     * Si riscrivono i valori delle colonne gia' presenti invece di aggiungerne di nuove: una
     * colonna che non esiste su __report_sottoscorta__ farebbe fallire la SELECT del controller,
     * che legge i campi dalle chiavi di view.cols.
     */
    if( ! empty( $ct['view']['data'] ) && is_array( $ct['view']['data'] ) ) {

        // il numero come si scrive qui: separatore di migliaia, decimali solo se ci sono
        $numero = function( $n ) {
            $n = (float) $n;
            return number_format( $n, ( $n == floor( $n ) ) ? 0 : 2, ',', '.' );
        };

        foreach( $ct['view']['data'] as &$row ) {

            if( ! is_array( $row ) || ! isset( $row['scorta_minima'] ) ) { continue; }

            /**
             * AZIONI DI RIGA: SEGNA L'UBICAZIONE DA RIFORNIRE ( BOOKMARKS )
             *
             * La selezione delle righe da riassortire usa la memoria di lavoro del framework -
             * i bookmarks: $_SESSION['__work__'], API /api/bookmarks, task bookmark.add e
             * bookmark.del, widget in testa a ogni pagina di athena. Il gruppo e'
             * 'riassortimento', dichiarato in _mod/_5000.logistica/_src/_config/_770.bookmarks.php.
             *
             * E' il meccanismo canonico per "prendo delle righe qui e me le porto dietro fino
             * all'azione che le consuma", ed e' gia' usato cosi' altrove ( _corsi.view.php segna
             * i corsi da duplicare, _mail.out.form.php si prende i documenti segnati e li allega
             * a una mail ). Tre cose che ci vengono gratis e che una selezione fatta in casa
             * dovrebbe rifare: sopravvive a paginazione, filtri e cambio di pagina; si vede
             * sempre, perche' il widget e' in testa a ogni schermata; e si svuota da sola a fine
             * sessione, cosi' nessuno genera una missione su righe segnate ieri.
             *
             * L'icona e' un interruttore: piena se la riga e' gia' segnata ( e allora chiama
             * bookmark.del ), vuota se no ( e allora chiama bookmark.add ). La chiave dell'item
             * e' l'id della riga del report, cioe' la coppia mastro/articolo.
             *
             * I valori passano da rawurlencode(): la chiave contiene una barra verticale e il
             * nome dell'articolo contiene spazi, virgole e apostrofi, che nell'URL dentro un
             * attributo onclick romperebbero la chiamata o l'HTML.
             */
            $chiave = rawurlencode( $row['id'] );
            $etichetta = rawurlencode( $row['id_articolo'] . ' in ' . $row['collocazione'] );

            if( isset( $cf['session']['__work__']['riassortimento']['items'] ) && array_key_exists( $row['id'], $cf['session']['__work__']['riassortimento']['items'] ) ) {

                $azione = "$(this).metroWs('/task/bookmark.del?__key__=riassortimento&__item__=" . $chiave . "', aggiornaBookmarks );";
                $icona = 'fa-bookmark';

            } else {

                $azione = "$(this).metroWs('/task/bookmark.add?__work__[riassortimento][items][" . $chiave . "][id]=" . $chiave
                    . "&__work__[riassortimento][items][" . $chiave . "][label]=" . $etichetta . "', aggiornaBookmarks );";
                $icona = 'fa-bookmark-o';

            }

            $row[ NULL ] = '<a href="#" title="segna da rifornire" onclick="' . $azione . '"><span class="media-left"><i class="fa ' . $icona . '"></i></span></a>';

            // quanti pezzi inventariali vale una unita' della soglia. Si ricava dalle due
            // colonne invece di rileggere i metadati: il task ha gia' fatto quel lavoro, e
            // rifarlo qui vorrebbe dire poter dare una risposta diversa dalla sua
            $fattore = ( ! empty( $row['scorta_minima_dichiarata'] ) && $row['scorta_minima_dichiarata'] > 0 )
                ? $row['scorta_minima'] / $row['scorta_minima_dichiarata']
                : 1;

            $udm = ( ! empty( $row['udm'] ) ) ? ' ' . $row['udm'] : '';

            if( $fattore > 1 ) {

                $row['scorta_minima'] = $numero( $row['scorta_minima_dichiarata'] ) . $udm . ' ( ' . $numero( $row['scorta_minima'] ) . ' )';

                if( ! empty( $row['scorta_massima_dichiarata'] ) ) {
                    $row['scorta_massima'] = $numero( $row['scorta_massima_dichiarata'] ) . $udm . ' ( ' . $numero( $row['scorta_massima'] ) . ' )';
                }

                // la giacenza e il mancante partono dall'unita' inventariale, che e' quella in
                // cui sono misurati: la conversione va fra parentesi, non al posto loro
                $row['giacenza'] = $numero( $row['giacenza'] ) . ' ( ' . $numero( $row['giacenza'] / $fattore ) . $udm . ' )';

                if( isset( $row['mancante'] ) && $row['mancante'] !== '' ) {
                    $row['mancante'] = $numero( $row['mancante'] ) . ' ( ' . $numero( $row['mancante'] / $fattore ) . $udm . ' )';
                }

            } else {

                // stessa unita': un numero solo, col suo nome
                $row['scorta_minima'] = $numero( $row['scorta_minima'] ) . $udm;
                if( ! empty( $row['scorta_massima'] ) ) { $row['scorta_massima'] = $numero( $row['scorta_massima'] ) . $udm; }
                $row['giacenza'] = $numero( $row['giacenza'] ) . $udm;
                if( isset( $row['mancante'] ) && $row['mancante'] !== '' ) { $row['mancante'] = $numero( $row['mancante'] ) . $udm; }

            }

        }

        // il riferimento dell'ultimo giro del foreach resta appeso all'ultimo elemento: senza
        // unset, chiunque piu' avanti riusi $row lo sovrascriverebbe
        unset( $row );

    }

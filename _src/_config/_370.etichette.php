<?php

    /**
     * dichiarazione dei formati delle etichette
     *
     * a cosa serve questo runlevel
     * ============================
     * Le API di stampa che producono un'etichetta ( una pagina PDF grande quanto il supporto fisico montato
     * sulla stampante ) hanno storicamente il formato cablato nel codice, quando non addirittura nel nome del
     * file ( _etichette.articoli.57x32.pdf.php ). Questo obbliga a toccare il codice standard, o a duplicarlo,
     * ogni volta che un cliente cambia rotolo di etichette.
     *
     * Qui viene dichiarato il ramo $cf['etichette'], sotto il quale ogni etichetta ha una propria chiave con
     * il formato in uso e le misure del suo contenuto; il progetto ridefinisce nel proprio config.json il solo
     * formato, e il contenuto viene riscalato di conseguenza da scalaEtichetta() ( _src/_lib/_pdf.tools.php ).
     *
     * struttura di un'etichetta
     * =========================
     * Ogni etichetta è un array con due chiavi:
     *
     * chiave        | descrizione
     * --------------|-----------------------------------------------------------------------------------------
     * formato       | il formato del supporto in uso, array( larghezza, altezza ) in millimetri
     * riferimento   | il formato su cui sono calibrate le misure del contenuto, e le misure stesse
     *
     * Le misure di riferimento sono raggruppate per il modo in cui scalano, che è l'unica informazione che il
     * codice non può dedurre da solo:
     *
     * gruppo        | scala con             | contiene
     * --------------|-----------------------|-------------------------------------------------------------
     * verticali     | l'altezza del formato | margini, interlinee, altezze di barcode e riquadri
     * orizzontali   | la larghezza          | larghezze
     * caratteri     | la larghezza          | corpi dei caratteri ( il testo si sviluppa in orizzontale )
     *
     * Finché formato e riferimento coincidono i fattori di scala valgono 1 e la stampa è identica a prima:
     * un progetto che non tocca niente non vede alcuna differenza.
     *
     * Accanto a formato e riferimento un'etichetta può portare chiavi che misure non sono, e che scalaEtichetta()
     * si limita a riportare in uscita; la sola prevista dal framework è allineamento:
     *
     * allineamento  | il contenuto parte dal margine superiore ( 'alto', default ) oppure è centrato
     *               | sull'etichetta ( 'centrato' ), in verticale e in orizzontale, che è quello che si
     *               | vuole quando il supporto è più grande di quanto serva al contenuto
     *
     * NB: il centraggio orizzontale di un barcode non è automatico. Con 'fitwidth' TCPDF restringe la
     * larghezza a quella effettiva del codice ma lascia la x dov'era, quindi senza 'cellfitalign' => 'C'
     * nello stile il barcode resta appeso al bordo sinistro dell'etichetta anche se lo spazio avanza.
     *
     * dove si dichiara un'etichetta
     * =============================
     * In questo file per le etichette del framework base, nel gemello di modulo per quelle di un modulo
     * ( es. _mod/_5600.colli/_src/_config/_370.etichette.php ), nella controparte custom per quelle di
     * progetto ( src/config/370.etichette.php ). L'ordine del loop dei runlevel garantisce che tutte le
     * dichiarazioni siano fatte prima che _375.etichette.php recepisca il config.json.
     *
     * @file
     *
     */

    // ramo delle etichette, popolato dai moduli e dal progetto
    if( ! isset( $cf['etichette'] ) ) {
        $cf['etichette'] = array();
    }

    // debug
    // dieText( print_r( $cf['etichette'], true ) );

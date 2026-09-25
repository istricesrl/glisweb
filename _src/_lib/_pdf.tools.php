<?php

    /**
     * libreria per la generazione di documenti PDF tramite TCPDF
     *
     * Questa libreria contiene una collezione di funzioni che semplificano la composizione di documenti PDF con TCPDF, in particolare
     * dei moduli cartacei a griglia ( rapporti di assistenza, moduli di consegna e ritiro dell'hardware, etichette ) che il framework
     * stampa dalle API in _src/_api/_print/ e _mod/<modulo>/_src/_api/_print/.
     *
     * introduzione
     * ============
     * Le funzioni della libreria lavorano tutte su due oggetti: l'oggetto TCPDF restituito da pdfInit() e l'array $info, che il
     * chiamante prepara prima di creare il PDF e che contiene la configurazione tipografica del documento; pdfInit() lo completa
     * con le misure derivate, e le altre funzioni lo leggono per sapere quanto sono larghe le colonne e alte le righe.
     *
     * La pagina viene divisa orizzontalmente in $info['form']['columns'] colonne di uguale larghezza, e tutte le larghezze che le
     * funzioni del gruppo form ricevono ( il parametro $width ) sono espresse in numero di colonne e non in millimetri; allo stesso
     * modo le altezze sono espresse in numero di barre ( la parte della riga destinata al contenuto, alta il 60% della riga ).
     *
     * la struttura dell'array $info
     * -----------------------------
     * Le chiavi che il chiamante deve impostare prima di chiamare pdfInit() sono le seguenti.
     *
     * chiave                           | dettagli
     * ---------------------------------|-----------------------------------------------------------------------------------------
     * doc/title                        | il titolo del documento
     * style/page/w                     | la larghezza della pagina in millimetri ( 210 per l'A4 verticale )
     * style/page/ml, mr, mt            | i margini sinistro, destro e superiore in millimetri
     * style/page/orentation            | l'orientamento della pagina, P o L ( default P; la chiave si scrive proprio così )
     * style/text/\<stile\>             | gli stili del testo, array con le chiavi font, size e weight ( es. title, label, small )
     * style/header, style/footer       | se non sono impostate header e footer di TCPDF vengono disattivati
     * form/columns                     | il numero di colonne in cui è divisa la pagina
     * form/row/height                  | l'altezza di una riga del modulo in millimetri
     *
     * Le chiavi che pdfInit() calcola o sovrascrive sono invece queste.
     *
     * chiave                           | dettagli
     * ---------------------------------|-----------------------------------------------------------------------------------------
     * style/text/default               | lo stile di default, helvetica 10 ( sovrascritto sempre )
     * style/page/viewport              | la larghezza utile della pagina, al netto dei margini
     * style/barcode                    | lo stile dei codici a barre
     * form/column/width                | la larghezza di una colonna ( solo se form/columns è impostata )
     * form/label/height                | l'altezza dell'etichetta, il 40% della riga
     * form/bar/height                  | l'altezza della barra, il 60% della riga
     * form/row/spacing                 | la spaziatura fra le righe, il 20% della riga
     * colors, lines, cell              | colori, stili delle linee e bordi delle celle ( sovrascritti sempre )
     * cache                            | coordinate e interlinee salvate da pdfFormSaveXY() e pdfFormSaveLineHeightRatio()
     *
     * costanti
     * ========
     * Questa libreria non definisce costanti proprie, ma utilizza le costanti di TCPDF PDF_FONT_MONOSPACED e PDF_IMAGE_SCALE_RATIO.
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le analizzeremo nel dettaglio.
     *
     * funzioni di inizializzazione
     * ----------------------------
     * Le funzioni in questo gruppo servono per creare il documento.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pdfInit()                        | crea e inizializza un documento PDF a partire dalla configurazione
     *
     * funzioni di stile
     * -----------------
     * Le funzioni in questo gruppo servono per impostare gli stili del testo e delle linee.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pdfSetFontStyle()                | imposta il carattere corrente a partire da uno stile
     * pdfSetLineStyle()                | imposta lo stile delle linee a partire da uno stile
     *
     * funzioni per la composizione dei moduli
     * ---------------------------------------
     * Le funzioni in questo gruppo servono per disegnare gli elementi dei moduli a griglia.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pdfFormBarcode()                 | disegna un codice a barre in una cella del modulo
     * pdfFormCellBar()                 | disegna una barra a caselle con un carattere per casella
     * pdfFormCellRow()                 | disegna una riga del modulo composta da più celle
     * pdfFormCellLabel()               | scrive un'etichetta alta quanto l'etichetta del modulo
     * pdfFormInlineCellLabel()         | scrive un'etichetta alta quanto la barra del modulo
     * pdfFormCellTitle()               | scrive un titolo alto quanto la barra del modulo
     * pdfFormCellPdfTitle()            | scrive un titolo con un corpo del carattere a scelta
     * pdfFormLineRow()                 | scrive un testo su un blocco di righe da compilare a mano
     * pdfFormBox()                     | disegna un riquadro con un'intestazione in una posizione assoluta
     * pdfHtmlColumns()                 | scrive un testo HTML su più colonne
     *
     * funzioni di posizionamento
     * --------------------------
     * Le funzioni in questo gruppo servono per spostare il cursore di TCPDF e per salvarne e ripristinarne lo stato.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pdfFormSaveLineHeightRatio()     | salva l'interlinea corrente
     * pdfFormLoadLineHeightRatio()     | ripristina un'interlinea salvata
     * pdfFormSaveXY()                  | salva la posizione corrente del cursore
     * pdfFormLoadXY()                  | ripristina una posizione salvata del cursore
     * pdfSetRelativeX()                | sposta il cursore in orizzontale
     * pdfSetRelativeY()                | sposta il cursore in verticale
     * pdfSetRelativeXY()               | sposta il cursore in orizzontale e in verticale
     * pdfFormCalcX()                   | calcola l'ascissa di una colonna del modulo
     *
     * funzioni di output
     * ------------------
     * Le funzioni in questo gruppo servono per inviare il documento al browser o per salvarlo.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * pdfOutput()                      | invia il PDF al browser o lo salva su file
     *
     * funzioni per le etichette
     * -------------------------
     * Le funzioni in questo gruppo servono per la stampa delle etichette dichiarate in $cf['etichette'].
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * scalaEtichetta()                 | risolve le misure di un'etichetta scalandole sul formato in uso
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti classi:
     *
     * classe                           | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * TCPDF                            | tecnickcom/tcpdf ( Composer )
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    /**
     * FUNZIONI DI INIZIALIZZAZIONE
     */

    /**
     * crea e inizializza un documento PDF a partire dalla configurazione
     *
     * Questa funzione crea un oggetto TCPDF in formato A4 con le misure in millimetri, completa l'array $info con le misure
     * derivate ( si veda la tabella nella testata della libreria ), imposta titolo, margini, header, footer, stile di default e
     * interruzione automatica di pagina, e aggiunge la prima pagina. Le misure del modulo ( form/column/width eccetera ) vengono
     * calcolate solo se $info['form']['columns'] è impostata; in quel caso anche $info['form']['row']['height'] è obbligatoria.
     *
     * NOTA la funzione sovrascrive sempre style/text/default, colors, lines e cell: uno stile di default diverso va impostato
     * dopo la chiamata ( come fa _mod/_1200.todo/_src/_api/_print/_modulo.assistenza.php ).
     *
     * TODO le chiavi lines e colors vengono sovrascritte anche se il chiamante le ha impostate prima della chiamata, come fanno
     * _modulo.assistenza.php e _ritiro.hardware.pdf.php ( lines/thick a .3 diventa .2 ): o si rispettano i valori del chiamante
     * o si tolgono dai chiamanti le impostazioni che non hanno effetto.
     *
     * @param       array       $info       la configurazione del documento, completata sul posto con le misure derivate
     *
     * @return      object                  l'oggetto TCPDF inizializzato, con la prima pagina già aggiunta
     *
     */
    function pdfInit( &$info ) {

        // impostazione stili
        $info['style']['text']['default'] = array( 'font' => 'helvetica', 'size' => 10, 'weight' => '' );

        if( !isset( $info['style']['page']['orentation'] ) ){
            $info['style']['page']['orentation'] = 'P';
        }
        // creo il PDF (portrait, millimetri, A4 x->210 y->297)
        $pdf = new TCPDF( $info['style']['page']['orentation'], 'mm', 'A4' );

        // tipografia derivata
        $info['style']['page']['viewport'] = $info['style']['page']['w'] - ( $info['style']['page']['ml'] + $info['style']['page']['mr'] );

        $info['style']['barcode'] = array(
            'position' => '',
            'align' => 'L',
            'stretch' => false,
            'fitwidth' => false,
            'border' => false,
            'hpadding' => 'auto',
            'vpadding' => 'auto',
            'fgcolor' => array(0,0,0),
            'bgcolor' => false, //array(255,255,255),
            'text' => true,
            'font' => 'helvetica',
            'fontsize' => 10,
            'stretchtext' => 0
        );

        // form
        if( isset( $info['form']['columns'] ) ) {
            $info['form']['column']['width'] = $info['style']['page']['viewport'] / $info['form']['columns'];
            $info['form']['label']['height'] = $info['form']['row']['height'] * 0.4;
            $info['form']['bar']['height'] = $info['form']['row']['height'] * 0.6;
            $info['form']['row']['spacing'] = $info['form']['row']['height'] * 0.2;
        }

        // definizione colori
        $info['colors']['nero']                     = array( 0, 0, 0 );
        $info['colors']['grigio']                   = array( 128, 128, 128 );
        $info['colors']['bianco']                   = array( 255, 255, 255 );

        // impostazione linee
        $info['lines']['thick']                     = array( 'thickness' => .2, 'color' => $info['colors']['nero'] );
        $info['lines']['thin']                      = array( 'thickness' => .12, 'color' => $info['colors']['grigio'] );

            // bordi delle celle
        $info['cell']['thick'] 		                = array( 'B' => array( 'width' => .2, 'color' => $info['colors']['nero']  ) );
        $info['cell']['thin']		                = array( 'B' => array( 'width' => .12, 'color' => $info['colors']['grigio']  )	);

        // imposto il titolo del documento
        $pdf->SetTitle( $info['doc']['title'] );

        // imposto i margini (left, top, right)
        $pdf->SetMargins( $info['style']['page']['ml'], $info['style']['page']['mt'], $info['style']['page']['mr'] );

        // imposto il padding
        $pdf->SetCellPadding( 0 );

        // imposto l'header
        if( ! isset( $info['style']['header'] ) ) {
            $pdf->SetPrintHeader( false );
            $pdf->SetHeaderMargin( 0 );
        }

        // imposto il footer
        if( ! isset( $info['style']['footer'] ) ) {
            $pdf->SetPrintFooter( false );
            $pdf->SetFooterMargin( 0 );
        }

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont( PDF_FONT_MONOSPACED );

        // set auto page breaks
        $pdf->SetAutoPageBreak( true );

        // set image scale factor (fattore di conversione da pixel a millimetri)
        $pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );

        // imposto lo stile di default
        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

        // aggiungo la prima pagina
        $pdf->AddPage();

        // restituisco il PDF inizializzato
        return $pdf;

    }

    /**
     * FUNZIONI DI STILE
     */

    /**
     * imposta il carattere corrente a partire da uno stile
     * 
     * Questa funzione imposta il carattere corrente del documento a partire da uno degli stili di testo dichiarati in
     * $info['style']['text'], cioè da un array con le chiavi font, weight e size; le funzioni del gruppo form la usano per
     * passare allo stile richiesto e per tornare poi allo stile default.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $style      lo stile da applicare ( chiavi font, weight e size )
     * 
     * @return      void
     * 
     */
    function pdfSetFontStyle( $pdf, $style ) {

        $pdf->SetFont( $style['font'], $style['weight'], $style['size'] );

    }

    /**
     * imposta lo stile delle linee a partire da uno stile
     * 
     * Questa funzione imposta lo spessore e il colore delle linee e dei bordi disegnati da qui in avanti a partire da uno degli
     * stili dichiarati in $info['lines'], cioè da un array con le chiavi thickness ( in millimetri ) e color ( array RGB ).
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $style      lo stile da applicare ( chiavi thickness e color )
     * 
     * @return      void
     * 
     */
    function pdfSetLineStyle( $pdf, $style ) {

        $pdf->SetLineStyle( array( 'width' => $style['thickness'], 'color' => $style['color'] ) );

    }

    /**
     * FUNZIONI PER LA COMPOSIZIONE DEI MODULI
     */

    /**
     * disegna un codice a barre in una cella del modulo
     * 
     * Questa funzione disegna un codice a barre monodimensionale a partire dalla posizione corrente del cursore, con lo stile
     * $info['style']['barcode'] impostato da pdfInit() e un modulo di 0,35 mm; dopodiché riporta il cursore al punto di partenza
     * ( salvato nella cache di $info con la chiave bc ) e lo sposta a destra di $width colonne, come se il codice avesse occupato
     * una cella di quella larghezza. La larghezza effettiva del codice non dipende da $width ma dal testo e dal modulo, quindi
     * un testo lungo in una cella stretta sconfina nelle celle successive.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare, passato per riferimento
     * @param       array       $info       la configurazione del documento, passata per riferimento ( ne viene scritta la cache )
     * @param       string      $text       il testo da codificare
     * @param       int         $width      la larghezza della cella in colonne ( default 0, il cursore non si sposta )
     * @param       float       $height     l'altezza del codice a barre in millimetri ( default 15 )
     * @param       string      $code       la simbologia del codice secondo TCPDF ( default C128 )
     * 
     * @return      void
     * 
     */
    function pdfFormBarcode( &$pdf, &$info, $text, $width = 0, $height = 15, $code = 'C128' ){
 
        
        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height'];

        pdfFormSaveXY( $pdf, $info, 'bc' );

        $pdf->write1DBarcode( $text, $code, '', '', '', $height, 0.35, $info['style']['barcode'] );
        
        pdfFormLoadXY( $pdf, $info, 'bc' );
        pdfSetRelativeX( $pdf, ( $cellWidth * $width ) );

    }

    /**
     * disegna una barra a caselle con un carattere per casella
     * 
     * Questa funzione disegna, a partire dalla posizione corrente, la barra a caselle tipica dei moduli cartacei: una casella
     * larga una colonna per ogni carattere del testo, con il bordo esterno spesso ( stile lines/thick ) e le separazioni fra le
     * caselle sottili ( stile lines/thin ). Se il testo è più corto di $width viene completato con spazi fino a $width caselle,
     * in modo da ottenere una barra vuota da compilare a mano; se è più lungo non viene troncato e la barra supera $width
     * colonne. Alla fine il cursore resta a destra dell'ultima casella.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo da scrivere nelle caselle, un carattere per casella
     * @param       int         $width      il numero minimo di caselle ( default 0, tante caselle quanti i caratteri )
     * 
     * @return      void
     * 
     */
    function pdfFormCellBar( $pdf, $info, $text, $width = 0 ) {

        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height'];

        if( $width > strlen( $text ) ) {
            $text = str_pad( $text, $width );
        }

        $str = str_split( $text );

        for( $i = 0; $i < count( $str ); $i++ ) {

            $border = 'TB';

            if( $i == 0 ) {
                $border .= 'L';
            } else {
                pdfSetLineStyle( $pdf, $info['lines']['thin'] );
                $pdf->Cell( $cellWidth, $barHeight, '', 'L', 0 );
                pdfSetRelativeX( $pdf, $cellWidth * -1 );
            }
            
            if( $i == ( count( $str ) - 1 ) ) {
                $border .= 'R';
            }

            pdfSetLineStyle( $pdf, $info['lines']['thick'] );
            $pdf->Cell( $cellWidth, $barHeight, $str[ $i ], $border, 0, 'C' );

        }

    }

    /**
     * disegna una riga del modulo composta da più celle
     * 
     * Questa funzione disegna una riga del modulo composta dalle celle descritte in $items, lasciando una colonna vuota fra una
     * cella e l'altra, e al termine porta il cursore all'inizio della riga successiva ( margine sinistro, un'altezza di riga più
     * la spaziatura più in basso ). Ogni cella è un array con le seguenti chiavi:
     * 
     * chiave           | dettagli
     * -----------------|-----------------------------------------------------------------------
     * width            | la larghezza della cella in colonne ( obbligatoria )
     * label/text       | l'etichetta scritta sopra la cella; se è vuota la cella non ha etichetta
     * label/style      | lo stile dell'etichetta ( default label ) e del testo inline ( default default )
     * bar/text         | il testo da scrivere in una barra a caselle, vedi pdfFormCellBar()
     * inline/text      | il testo da scrivere direttamente nella cella, vedi pdfFormInlineCellLabel()
     * bar/barcode      | il testo da scrivere come codice a barre, vedi pdfFormBarcode()
     * 
     * Le chiavi bar/text, inline e bar/barcode sono valutate in quest'ordine e ne viene usata solo la prima presente; se non ce
     * n'è nessuna la cella resta vuota.
     * 
     * TODO la chiave bar/style viene passata a pdfFormCellBar() come quinto argomento, ma pdfFormCellBar() ne accetta quattro e
     * lo ignora: lo stile della barra non è di fatto personalizzabile.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       array       $items      l'elenco delle celle della riga
     * 
     * @return      void
     * 
     */
    function pdfFormCellRow( $pdf, $info, $items ) {

        $cellWidth = $info['form']['column']['width'];
        $lblHeight = $info['form']['label']['height'];

        $current = 0;
        $total = count( $items );

        foreach( $items as $item ) {

            $current++;

            if( isset( $item['label']['text'] ) && ! empty( $item['label']['text'] ) ) {
                $labels = 1;
                pdfFormCellLabel( $pdf, $info, $item['label']['text'], $item['width'], ( ( isset( $item['label']['style'] ) ) ? $item['label']['style'] : 'label' ) );
            } else {
                $labels = 0;
                pdfSetRelativeX( $pdf, $item['width'] * $cellWidth );
            }

            pdfSetRelativeXY( $pdf, $item['width'] * $cellWidth * -1, $lblHeight * $labels );

            if( isset( $item['bar']['text'] ) ) {
                pdfFormCellBar( $pdf, $info, $item['bar']['text'], $item['width'], ( ( isset( $item['bar']['style'] ) ) ? $item['bar']['style'] : 'default' ) );
            } elseif( isset( $item['inline'] ) ) {
                pdfFormInlineCellLabel( $pdf, $info, $item['inline']['text'], $item['width'], ( ( isset( $item['label']['style'] ) ) ? $item['label']['style'] : 'default' ) );
            } elseif( isset( $item['bar']['barcode'] ) ){
                pdfFormBarcode( $pdf, $info, $item['bar']['barcode'], $item['width'] );
            } else {
                pdfSetRelativeX( $pdf, $item['width'] * $cellWidth );
            }

            if( $current < $total ) {
                pdfFormCellLabel( $pdf, $info, '', 1 );
            }

            pdfSetRelativeXY( $pdf, 0, $lblHeight * $labels * -1 );

        }

        pdfSetRelativeY( $pdf, $info['form']['row']['height'] + $info['form']['row']['spacing'] );

    }

    /**
     * scrive un'etichetta alta quanto l'etichetta del modulo
     * 
     * Questa funzione scrive un testo senza bordo in una cella larga $width colonne e alta quanto l'etichetta del modulo
     * ( form/label/height ), con lo stile richiesto, e poi torna allo stile default. Con $width a zero la cella si estende
     * fino al margine destro; chiamata con testo vuoto serve a lasciare uno spazio ( così la usa pdfFormCellRow() fra le celle ).
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo da scrivere
     * @param       int         $width      la larghezza della cella in colonne ( default 0, fino al margine destro )
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default default )
     * @param       int         $newline    dove va il cursore dopo la cella, come il parametro ln di TCPDF::Cell() ( default 0, a destra )
     * 
     * @return      void
     * 
     */
    function pdfFormCellLabel( $pdf, $info, $text, $width = 0, $style = 'default', $newline = 0 ) {

        $cellWidth = $info['form']['column']['width'];
        $lblHeight = $info['form']['label']['height'];

        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );

        $pdf->Cell( ( $width * $cellWidth ), $lblHeight, $text, 0, $newline );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

    }

    /**
     * scrive un'etichetta alta quanto la barra del modulo
     * 
     * Questa funzione è identica a pdfFormCellLabel() ma la cella è alta quanto la barra del modulo ( form/bar/height ) e non
     * quanto l'etichetta; serve a scrivere un testo al posto della barra a caselle in una cella di pdfFormCellRow().
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo da scrivere
     * @param       int         $width      la larghezza della cella in colonne ( default 0, fino al margine destro )
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default default )
     * @param       int         $newline    dove va il cursore dopo la cella, come il parametro ln di TCPDF::Cell() ( default 0, a destra )
     * 
     * @return      void
     * 
     */
    function pdfFormInlineCellLabel( $pdf, $info, $text, $width = 0, $style = 'default', $newline = 0 ) {

        $cellWidth = $info['form']['column']['width'];
        $lblHeight = $info['form']['label']['height'];
        $barHeight = $info['form']['bar']['height'];

        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );

        $pdf->Cell( ( $width * $cellWidth ), $barHeight, $text, 0, $newline );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

    }

    /**
     * scrive un titolo alto quanto la barra del modulo
     * 
     * Questa funzione scrive un testo senza bordo in una cella alta quanto la barra del modulo, per default con lo stile title
     * e andando a capo dopo la cella, e poi torna allo stile default; si usa per i titoli delle sezioni dei moduli.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo del titolo
     * @param       int         $width      la larghezza della cella in colonne ( default 0, fino al margine destro )
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default title )
     * @param       int         $newline    dove va il cursore dopo la cella, come il parametro ln di TCPDF::Cell() ( default 1, a capo )
     * 
     * @return      void
     * 
     */
    function pdfFormCellTitle( $pdf, $info, $text, $width = 0, $style = 'title', $newline = 1 ) {

        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height'];

        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );

        $pdf->Cell( ( $width * $cellWidth ), $barHeight, $text, 0, $newline );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

    }

    /**
     * scrive un titolo con un corpo del carattere a scelta
     * 
     * Questa funzione è identica a pdfFormCellTitle() ma permette di indicare il corpo del carattere; si usa per il titolo
     * principale del documento. Se $size vale zero si usa il corpo dello stile; la modifica del corpo vale solo per questa
     * chiamata, perché $info è passato per valore e lo stile dichiarato dal chiamante non cambia.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo del titolo
     * @param       float       $size       il corpo del carattere ( default 0, quello dello stile )
     * @param       int         $width      la larghezza della cella in colonne ( default 0, fino al margine destro )
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default title )
     * @param       int         $newline    dove va il cursore dopo la cella, come il parametro ln di TCPDF::Cell() ( default 1, a capo )
     * 
     * @return      void
     * 
     */
    function pdfFormCellPdfTitle( $pdf, $info, $text, $size = 0, $width = 0, $style = 'title', $newline = 1 ) {

        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height']; 
        
        if( $size != 0 ){   $info['style']['text'][ $style ]['size'] = $size;
         }
        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );

        $pdf->Cell( ( $width * $cellWidth ), $barHeight, $text, 0, $newline );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

    }

    /**
     * scrive un testo su un blocco di righe da compilare a mano
     * 
     * Questa funzione disegna, a partire dalla posizione corrente, $height linee orizzontali larghe $width colonne e distanti fra
     * loro l'altezza di una barra, e ci scrive sopra il testo con un'interlinea di 1,7 in modo che le righe di testo cadano
     * sulle linee; se il testo è vuoto resta un blocco di righe da compilare a mano. Il testo non viene troncato: se è più lungo
     * delle righe disponibili prosegue sotto l'ultima linea. Alla fine il cursore va al margine sinistro, sotto l'ultima linea
     * più la spaziatura fra le righe, e l'interlinea torna quella di prima.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo da scrivere sulle righe
     * @param       int         $width      la larghezza del blocco in colonne
     * @param       int         $height     il numero di righe
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default default )
     * 
     * @return      void
     * 
     */
    function pdfFormLineRow( $pdf, $info, $text, $width, $height, $style = 'default' ) {

        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height'];
        $blockWidth = ( $width * $cellWidth );

        pdfFormSaveXY( $pdf, $info );
        pdfFormSaveLineHeightRatio( $pdf, $info );

        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );
        $pdf->setCellHeightRatio(1.7);

        $pdf->MultiCell( $blockWidth, 0, $text, 0, 'L' );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
        pdfFormLoadLineHeightRatio( $pdf, $info );

        pdfFormLoadXY( $pdf, $info );

        $x1 = $pdf->GetX();
        $x2 = $x1 + $blockWidth;
        $y = $pdf->GetY();

        for( $i = 0; $i < $height; $i++ ) {
            $y += $barHeight;
            $pdf->Line( $x1, $y, $x2, $y );
        }

        $pdf->SetY( $y + $info['form']['row']['spacing'] );

    }

    /**
     * disegna un riquadro con un'intestazione in una posizione assoluta
     * 
     * Questa funzione disegna un riquadro bordato largo $width colonne e alto $height barre ( meno la spaziatura fra le righe ),
     * con l'angolo superiore sinistro in $x e $y più la spaziatura, e scrive il testo in alto a sinistra con un margine interno
     * di 3 mm; si usa per gli spazi destinati a firme, timbri, luogo e data, di solito affiancati calcolando $x con pdfFormCalcX().
     * Alla fine il cursore va al margine sinistro, sotto il riquadro più la spaziatura, e interlinea e margine interno tornano
     * quelli di default.
     * 
     * NOTA la posizione del cursore viene salvata all'inizio ma non viene ripristinata: per affiancare più riquadri alla stessa
     * altezza il chiamante deve passare a tutti la stessa $y.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       string      $text       il testo dell'intestazione del riquadro
     * @param       int         $width      la larghezza del riquadro in colonne
     * @param       int         $height     l'altezza del riquadro in barre
     * @param       float       $x          l'ascissa dell'angolo superiore sinistro in millimetri
     * @param       float       $y          l'ordinata dell'angolo superiore sinistro in millimetri
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default label )
     * 
     * @return      void
     * 
     */
    function pdfFormBox( $pdf, $info, $text, $width, $height, $x, $y, $style = 'label' ) {

        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height'];
        $blockWidth = ( $width * $cellWidth );
        $blockHeight = ( $height * $barHeight ) - $info['form']['row']['spacing'];

        pdfFormSaveXY( $pdf, $info );
        pdfFormSaveLineHeightRatio( $pdf, $info );

        $pdf->SetXY( $x, $y + $info['form']['row']['spacing'] );
        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );
        $pdf->setCellHeightRatio(1);
        $pdf->SetCellPadding( 3 );

        $pdf->MultiCell( $blockWidth, $blockHeight, $text, 1, 'L', 0, 0, '', '', true, 0, false, true, 0, 'T' );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
        pdfFormLoadLineHeightRatio( $pdf, $info );
        $pdf->SetCellPadding( 0 );

        pdfSetRelativeY( $pdf, $blockHeight + $info['form']['row']['spacing'] );

    }

    /**
     * scrive un testo HTML su più colonne
     * 
     * Questa funzione scrive un testo HTML giustificato su $cols colonne affiancate, alla stessa altezza e separate da una colonna
     * del modulo; la larghezza di ogni colonna è la larghezza utile della pagina, meno le separazioni, divisa per $cols. Il testo
     * viene diviso in colonne sul carattere §: ogni pezzo va in una colonna. Se il testo non contiene § la funzione lo divide da
     * sola in $cols parti con un numero di caratteri simile ( tag compresi ), andando a capo sugli spazi che non stanno dentro un
     * tag; le parti non hanno per forza la stessa altezza, e un elemento aperto in una colonna ( per esempio un <b> ) non prosegue
     * nella successiva. Alla fine il cursore resta dove lo lascia TCPDF, cioè in alto a destra dell'ultima colonna, e va
     * riposizionato dal chiamante.
     *
     * NOTA le condizioni di servizio di _mod/_1200.todo/_src/_api/_print/_modulo.assistenza.php contengono un § scritto a mano e
     * sono sempre state divise in due colonne; fino al 2026-09-24 la divisione automatica non avveniva mai ( strpos() aveva gli
     * argomenti invertiti ) e un testo senza § finiva tutto nella prima colonna.
     *
     * TODO l'ascissa delle colonne si accumula ( $x = $x + ... * $current ), quindi dalla terza colonna in poi la posizione è
     * sbagliata; con due colonne il risultato è corretto.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento
     * @param       int         $cols       il numero di colonne
     * @param       string      $text       il testo HTML da scrivere, con le colonne separate da §
     * @param       string      $style      il nome dello stile in $info['style']['text'] ( default default )
     * 
     * @return      void
     * 
     */
    function pdfHtmlColumns( $pdf, $info, $cols, $text, $style = 'default') {

        $x = $info['style']['page']['ml'];
        $y = $pdf->GetY();
        $current = 0;

        $textLength = mb_strlen( $text );
        $colLength = $textLength / $cols;
        $colWidth = ( $info['style']['page']['viewport'] - ( $info['form']['column']['width'] * ( $cols - 1 ) ) ) / $cols;

        // se il testo non contiene separatori lo divido in $cols parti di lunghezza simile, andando a capo sugli spazi che non
        // stanno dentro un tag; wordwrap(), usata fino al 2026-09-24 ( ma mai eseguita, perché strpos() aveva gli argomenti
        // invertiti ), conta i byte e non i caratteri, di solito lascia un avanzo in una colonna in più e spezza i tag
        if( strpos( $text, '§' ) === false ) {
            $splitText = '';
            $splitLength = 0;
            $splitCount = 1;
            foreach( preg_split( '/\s+(?![^<]*>)/u', trim( $text ) ) as $word ) {
                if( $splitLength >= $colLength * $splitCount && $splitCount < $cols ) {
                    $splitText .= '§';
                    $splitCount++;
                } elseif( $splitLength > 0 ) {
                    $splitText .= ' ';
                }
                $splitText .= $word;
                $splitLength += mb_strlen( $word ) + 1;
            }
        } else {
            $splitText = $text;
        }
        $colText = explode( '§', $splitText );

        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );

        foreach( $colText as $col ) {
            $x = $x + ( $colWidth + $info['form']['column']['width'] ) * $current;
            $pdf->writeHTMLCell( $colWidth, 0, $x, $y, $col, 0, 0, 0, true, 'J', true );
            $current++;

        }
        // $pdf->writeHTML( $text, true, 0, false, false, 'J' );
        // $pdf->writeHTML( $text );
        // $pdf->writeHTML( $text, true, 0, true, false, 'J' );

        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

    }

    /**
     * FUNZIONI DI POSIZIONAMENTO
     */

    /**
     * salva l'interlinea corrente
     * 
     * Questa funzione salva l'interlinea corrente di TCPDF nella cache di $info, con la chiave indicata, in modo da poterla
     * ripristinare con pdfFormLoadLineHeightRatio() dopo averla cambiata.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento, passata per riferimento ( ne viene scritta la cache )
     * @param       string      $key        la chiave con cui salvare l'interlinea ( default 0 )
     * 
     * @return      void
     * 
     */
    function pdfFormSaveLineHeightRatio( $pdf, &$info, $key = '0' ) {

        $info['cache']['ratio']['lineheight'][ $key ] = $pdf->getCellHeightRatio();

    }

    /**
     * ripristina un'interlinea salvata
     * 
     * Questa funzione ripristina l'interlinea salvata con pdfFormSaveLineHeightRatio() con la chiave indicata; se per quella
     * chiave non è stato salvato niente PHP segnala un indice mancante e a TCPDF arriva NULL.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare
     * @param       array       $info       la configurazione del documento, passata per riferimento
     * @param       string      $key        la chiave con cui è stata salvata l'interlinea ( default 0 )
     * 
     * @return      void
     * 
     */
    function pdfFormLoadLineHeightRatio( $pdf, &$info, $key = '0' ) {

        $pdf->setCellHeightRatio( $info['cache']['ratio']['lineheight'][ $key ] );

    }

    /**
     * salva la posizione corrente del cursore
     * 
     * Questa funzione salva le coordinate correnti del cursore nella cache di $info, con la chiave indicata, in modo da poterle
     * ripristinare con pdfFormLoadXY(). Chiavi diverse permettono di salvare più posizioni ( pdfFormBarcode() usa bc ).
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare, passato per riferimento
     * @param       array       $info       la configurazione del documento, passata per riferimento ( ne viene scritta la cache )
     * @param       string      $key        la chiave con cui salvare la posizione ( default 0 )
     * 
     * @return      void
     * 
     */
    function pdfFormSaveXY( &$pdf, &$info, $key = '0' ) {

        $info['cache']['coords'][ $key ]['x'] = $pdf->GetX();
        $info['cache']['coords'][ $key ]['y'] = $pdf->GetY();

    }

    /**
     * ripristina una posizione salvata del cursore
     * 
     * Questa funzione riporta il cursore alle coordinate salvate con pdfFormSaveXY() con la chiave indicata; se per quella chiave
     * non è stato salvato niente PHP segnala un indice mancante.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare, passato per riferimento
     * @param       array       $info       la configurazione del documento, passata per riferimento
     * @param       string      $key        la chiave con cui è stata salvata la posizione ( default 0 )
     * 
     * @return      void
     * 
     */
    function pdfFormLoadXY( &$pdf, &$info, $key = '0' ) {

        $pdf->SetXY(
            $info['cache']['coords'][ $key ]['x'],
            $info['cache']['coords'][ $key ]['y']
        );

    }

    /**
     * sposta il cursore in orizzontale
     * 
     * Questa funzione sposta il cursore in orizzontale di $offset millimetri rispetto alla posizione corrente; un valore negativo
     * lo sposta a sinistra.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare, passato per riferimento
     * @param       float       $offset     lo spostamento in millimetri
     * 
     * @return      void
     * 
     */
    function pdfSetRelativeX( &$pdf, $offset ) {
        $pdf->SetX( $pdf->GetX() + $offset );
    }

    /**
     * sposta il cursore in verticale
     * 
     * Questa funzione sposta il cursore in verticale di $offset millimetri rispetto alla posizione corrente; un valore negativo
     * lo sposta in alto.
     * 
     * NOTA TCPDF::SetY() riporta anche l'ascissa al margine sinistro: dopo questa funzione il cursore è sempre a inizio riga,
     * ed è su questo che contano pdfFormCellRow() e pdfFormLineRow() per andare a capo. Per spostarsi in verticale senza perdere
     * l'ascissa si usa pdfSetRelativeXY() con uno spostamento orizzontale nullo.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare, passato per riferimento
     * @param       float       $offset     lo spostamento in millimetri
     * 
     * @return      void
     * 
     */
    function pdfSetRelativeY( &$pdf, $offset ) {
        $pdf->SetY( $pdf->GetY() + $offset );
    }

    /**
     * sposta il cursore in orizzontale e in verticale
     * 
     * Questa funzione sposta il cursore di $offsetx millimetri in orizzontale e di $offsety millimetri in verticale rispetto alla
     * posizione corrente; i valori negativi spostano a sinistra e in alto.
     * 
     * @param       object      $pdf        l'oggetto TCPDF su cui lavorare, passato per riferimento
     * @param       float       $offsetx    lo spostamento orizzontale in millimetri
     * @param       float       $offsety    lo spostamento verticale in millimetri
     * 
     * @return      void
     * 
     */
    function pdfSetRelativeXY( &$pdf, $offsetx, $offsety ) {
        $pdf->SetXY( $pdf->GetX() + $offsetx, $pdf->GetY() + $offsety );
    }

    /**
     * calcola l'ascissa di una colonna del modulo
     * 
     * Questa funzione restituisce l'ascissa in millimetri del bordo sinistro della colonna $cols del modulo, contando da zero a
     * partire dal margine sinistro; si usa per posizionare i riquadri di pdfFormBox().
     * 
     * @param       array       $info       la configurazione del documento
     * @param       int         $cols       il numero della colonna, a partire da zero
     * 
     * @return      float                   l'ascissa della colonna in millimetri
     * 
     */
    function pdfFormCalcX( $info, $cols ) {
        return $info['style']['page']['ml'] + ( $info['form']['column']['width'] * $cols );
    }

    /**
     * FUNZIONI DI OUTPUT
     */

    /**
     * invia il PDF al browser o lo salva su file
     * 
     * Questa funzione chiude il documento e lo invia in base ai parametri della richiesta: con $_REQUEST['d'] lo invia al browser
     * come download, con $_REQUEST['f'] lo salva su file senza inviare niente, con $_REQUEST['fi'] lo salva e lo invia al browser,
     * altrimenti lo invia al browser per la visualizzazione in linea. Il nome del file è $dobj con l'estensione .pdf; salvando,
     * un percorso relativo viene risolto da TCPDF rispetto alla directory corrente dello script.
     * 
     * @param       object      $pdf        l'oggetto TCPDF da inviare
     * @param       string      $dobj       il nome del file, senza estensione
     * 
     * @return      void
     * 
     */
    function pdfOutput( $pdf, $dobj ) {

        // output
        if( isset( $_REQUEST['d'] ) ) {
            $pdf->Output($dobj.'.pdf' , 'D' );					// invia l'output al browser per il download diretto
        } elseif( isset( $_REQUEST['f'] ) ) {
            $pdf->Output( $dobj.'.pdf','F' );				// salva il file localmente
        } elseif( isset( $_REQUEST['fi'] ) ) {
            $pdf->Output( $dobj.'.pdf', 'FI' );				// salva il file localmente e invia l'output al browser
        } else {
            $pdf->Output($dobj.'.pdf');								// invia l'output al browser
        }

    }

    /**
     * FUNZIONI PER LE ETICHETTE
     */

    /**
     * risolve le misure di un'etichetta scalandole sul formato in uso
     *
     * Le API di stampa delle etichette dichiarano le misure del proprio contenuto ( margini, altezze, corpi
     * dei caratteri ) calibrate su un formato di riferimento, e ricevono da $cf['etichette'][ \<etichetta\> ]
     * il formato del supporto effettivamente montato sulla stampante; questa funzione applica al contenuto
     * i fattori di scala fra i due formati, in modo che cambiare il formato in configurazione basti a
     * riproporzionare la stampa senza toccare il codice.
     *
     * Le misure verticali scalano con l'altezza, quelle orizzontali e i corpi dei caratteri con la larghezza
     * ( il testo si sviluppa in orizzontale, quindi è la larghezza a dire quanto può essere grande ).
     * Se formato e riferimento coincidono i fattori valgono 1 e le misure tornano identiche a quelle dichiarate.
     *
     * L'array in ingresso ha la forma dichiarata nel runlevel 370:
     *
     *     array(
     *         'formato'     => array( 65, 56 ),
     *         'riferimento' => array(
     *             'formato'     => array( 57, 32 ),
     *             'verticali'   => array( 'margine' => 2, 'barcode' => 18 ),
     *             'orizzontali' => array(),
     *             'caratteri'   => array( 'testo' => 10 )
     *         )
     *     )
     *
     * Una misura dichiarata accanto al formato, nel gruppo in cui compare nel riferimento, viene presa come
     * valore assoluto e non viene scalata: è la via per forzare una singola misura da configurazione.
     *
     * La chiave riferimento è di fatto obbligatoria: se manca, PHP segnala gli indici mancanti, i fattori di scala valgono 1 e
     * i gruppi contengono solo le misure forzate da configurazione.
     *
     * @param       array       $etichetta      la configurazione dell'etichetta
     *
     * @return      array                       le misure risolte, nella stessa struttura a gruppi ( formato, verticali, orizzontali, caratteri )
     *
     */
    function scalaEtichetta( $etichetta ) {

        // gruppi di misure e dimensione del formato con cui scalano ( 0 = larghezza, 1 = altezza )
        $gruppi = array( 'verticali' => 1, 'orizzontali' => 0, 'caratteri' => 0 );

        // riferimento su cui sono calibrate le misure
        $riferimento = ( isset( $etichetta['riferimento'] ) ) ? $etichetta['riferimento'] : array();

        // formato del supporto in uso, che in assenza di indicazioni è quello di riferimento
        $formato = ( isset( $etichetta['formato'] ) ) ? $etichetta['formato'] : $riferimento['formato'];

        // fattori di scala
        $k = array(
            0 => ( $riferimento['formato'][0] > 0 ) ? $formato[0] / $riferimento['formato'][0] : 1,
            1 => ( $riferimento['formato'][1] > 0 ) ? $formato[1] / $riferimento['formato'][1] : 1
        );

        // misure risolte, che conservano le chiavi dell'etichetta che non sono misure ( es. l'allineamento )
        $misure = $etichetta;
        unset( $misure['riferimento'] );
        $misure['formato'] = $formato;

        // per ogni gruppo di misure
        foreach( $gruppi as $gruppo => $dimensione ) {

            // misure del gruppo
            $misure[ $gruppo ] = array();

            // scala delle misure di riferimento
            if( isset( $riferimento[ $gruppo ] ) ) {
                foreach( $riferimento[ $gruppo ] as $chiave => $valore ) {
                    $misure[ $gruppo ][ $chiave ] = $valore * $k[ $dimensione ];
                }
            }

            // misure forzate da configurazione, che valgono così come sono
            if( isset( $etichetta[ $gruppo ] ) ) {
                $misure[ $gruppo ] = array_replace( $misure[ $gruppo ], $etichetta[ $gruppo ] );
            }

        }

        // ...
        return $misure;

    }

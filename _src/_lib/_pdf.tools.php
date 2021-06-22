<?php

    /**
     * 
     * @todo documentare
     * 
     */


    /**
     * 
     * @todo documentare
     * 
     */
    function pdfInit( &$info ) {

        // creo il PDF (portrait, millimetri, A4 x->210 y->297)
        $pdf = new TCPDF( 'P', 'mm', 'A4' );						

        // tipografia derivata
        $info['style']['page']['viewport'] = $info['style']['page']['w'] - ( $info['style']['page']['ml'] + $info['style']['page']['mr'] );

        // imposto il titolo del documento
        $pdf->SetTitle( $info['doc']['title'] );

        // imposto i margini (left, top, right)
        $pdf->SetMargins( $info['style']['page']['ml'], $info['style']['page']['mt'], $info['style']['page']['mr'] );

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
        pdfSetStyle( $pdf, $info['style']['default'] );

        // aggiungo la prima pagina
        $pdf->AddPage();

        // restituisco il PDF inizializzato
        return $pdf;

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetStyle( $pdf, $style ) {

        $pdf->SetFont( $style['font'], $style['weight'], $style['size'] );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormCellBar( $pdf, $text, $width = 0, $cellWidth = 4, $rowHeight = 6 ) {

        if( $width > strlen( $text ) ) {
            $text = str_pad( $text, $width );
        }

        $str = str_split( $text );

        for( $i = 0; $i < count( $str ); $i++ ) {

            $border = 'TB';

            if( $i == 0 ) {
                $border .= 'L';
            } else {
                $pdf->Cell( $cellWidth, $rowHeight, $str[ $i ], 'L', 0 );
                pdfSetRelativeX( $pdf, $cellWidth * -1 );
            }
            
            if( $i == ( count( $str ) - 1 ) ) {
                $border .= 'R';
            }

            $pdf->Cell( $cellWidth, $rowHeight, $str[ $i ], $border, 0 );

        }

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormCellRow( $pdf, $items, $cellWidth = 4, $rowHeight = 6 ) {

        $current = 0;
        $total = count( $items );

        foreach( $items as $item ) {

            $current++;

            if( isset( $item['label']['text'] ) ) {
                pdfFormCellLabel( $pdf, $item['label']['text'], $item['width'] );
            } else {
                pdfSetRelativeX( $pdf, $item['width'] * $cellWidth );
            }

            pdfSetRelativeXY( $pdf, $item['width'] * $cellWidth * -1, $rowHeight );

            if( isset( $item['bar']['text'] ) ) {
                pdfFormCellBar( $pdf, $item['bar']['text'], $item['width'] );
            } else {
                pdfSetRelativeX( $pdf, $item['width'] * $cellWidth );
            }

            if( $current < $total ) {
                pdfFormCellLabel( $pdf, '', 1 );
            }

            pdfSetRelativeXY( $pdf, 0, $rowHeight * -1 );

        }

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormCellLabel( $pdf, $text, $width = 0, $cellWidth = 4, $rowHeight = 6, $newline = 0 ) {
        $pdf->Cell( ( $width * $cellWidth ), $rowHeight, $text, 0, $newline );
    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetRelativeX( $pdf, $offset ) {
        $pdf->SetX( $pdf->GetX() + $offset );
    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetRelativeY( $pdf, $offset ) {
        $pdf->SetY( $pdf->GetY() + $offset );
    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetRelativeXY( $pdf, $offsetx, $offsety ) {
        $pdf->SetXY( $pdf->GetX() + $offsetx, $pdf->GetY() + $offsety );
    }
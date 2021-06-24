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

        // impostazione stili
        $info['style']['text']['default'] = array( 'font' => 'helvetica', 'size' => 10, 'weight' => '' );

        // creo il PDF (portrait, millimetri, A4 x->210 y->297)
        $pdf = new TCPDF( 'P', 'mm', 'A4' );						

        // tipografia derivata
        $info['style']['page']['viewport'] = $info['style']['page']['w'] - ( $info['style']['page']['ml'] + $info['style']['page']['mr'] );

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
     * 
     * @todo documentare
     * 
     */
    function pdfSetFontStyle( $pdf, $style ) {

        $pdf->SetFont( $style['font'], $style['weight'], $style['size'] );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetLineStyle( $pdf, $style ) {

        $pdf->SetLineStyle( array( 'width' => $style['thickness'], 'color' => $style['color'] ) );

    }

    /**
     * 
     * @todo documentare
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
                pdfSetLineStyle( $pdf, $info['lines']['thick'] );
            }
            
            if( $i == ( count( $str ) - 1 ) ) {
                $border .= 'R';
            }

            $pdf->Cell( $cellWidth, $barHeight, $str[ $i ], $border, 0, 'C' );

        }

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormCellRow( $pdf, $info, $items ) {

        $cellWidth = $info['form']['column']['width'];
        $lblHeight = $info['form']['label']['height'];

        $current = 0;
        $total = count( $items );

        foreach( $items as $item ) {

            $current++;

            if( isset( $item['label']['text'] ) ) {
                pdfFormCellLabel( $pdf, $info, $item['label']['text'], $item['width'], ( ( isset( $item['label']['style'] ) ) ? $item['label']['style'] : 'label' ) );
            } else {
                pdfSetRelativeX( $pdf, $item['width'] * $cellWidth );
            }

            pdfSetRelativeXY( $pdf, $item['width'] * $cellWidth * -1, $lblHeight );

            if( isset( $item['bar']['text'] ) ) {
                pdfFormCellBar( $pdf, $info, $item['bar']['text'], $item['width'], ( ( isset( $item['bar']['style'] ) ) ? $item['bar']['style'] : 'default' ) );
            } else {
                pdfSetRelativeX( $pdf, $item['width'] * $cellWidth );
            }

            if( $current < $total ) {
                pdfFormCellLabel( $pdf, $info, '', 1 );
            }

            pdfSetRelativeXY( $pdf, 0, $lblHeight * -1 );

        }

        pdfSetRelativeY( $pdf, $info['form']['row']['height'] + $info['form']['row']['spacing'] );

    }

    /**
     * 
     * @todo documentare
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
     * 
     * @todo documentare
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
     * 
     * @todo documentare
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
     * 
     * @todo documentare
     * 
     */
    function pdfHtmlColumns( $pdf, $info, $cols, $text, $style = 'default') {

        $pdf->resetColumns();
        $pdf->setEqualColumns( $cols, ( $info['style']['page']['viewport'] / $cols ) );
        pdfSetFontStyle( $pdf, $info['style']['text'][ $style ] );

        $pdf->selectColumn();
        $pdf->SetAutoPageBreak( true, 250 );

        // $pdf->writeHTML( $text, true, 0, false, false, 'J' );
        // $pdf->writeHTML( $text );
        $pdf->writeHTML( $text, true, 0, true, false, 'J' );

        $pdf->resetColumns();
        $pdf->SetAutoPageBreak( true, 20 );
        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormSaveLineHeightRatio( $pdf, &$info, $key = '0' ) {

        $info['cache']['ratio']['lineheight'][ $key ] = $pdf->getCellHeightRatio();

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormLoadLineHeightRatio( $pdf, &$info, $key = '0' ) {

        $pdf->setCellHeightRatio( $info['cache']['ratio']['lineheight'][ $key ] );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormSaveXY( $pdf, &$info, $key = '0' ) {

        $info['cache']['coords'][ $key ]['x'] = $pdf->getX();
        $info['cache']['coords'][ $key ]['y'] = $pdf->getY();

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormLoadXY( $pdf, &$info, $key = '0' ) {

        $pdf->SetX( $info['cache']['coords'][ $key ]['x'] );
        $pdf->SetY( $info['cache']['coords'][ $key ]['y'] );

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

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormCalcX( $info, $cols ) {
        return $info['style']['page']['ml'] + ( $info['form']['column']['width'] * $cols );
    }

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
    function pdfFormBarcode( &$pdf, &$info, $text, $width = 0, $height = 15, $code = 'C128' ){
 
        
        $cellWidth = $info['form']['column']['width'];
        $barHeight = $info['form']['bar']['height'];

        pdfFormSaveXY( $pdf, $info, 'bc' );

        $pdf->write1DBarcode( $text, $code, '', '', '', $height, 0.35, $info['style']['barcode'] );
        
        pdfFormLoadXY( $pdf, $info, 'bc' );
        pdfSetRelativeX( $pdf, ( $cellWidth * $width ) );

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
            }
            
            if( $i == ( count( $str ) - 1 ) ) {
                $border .= 'R';
            }

            pdfSetLineStyle( $pdf, $info['lines']['thick'] );
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
    function pdfFormInlineCellLabel( $pdf, $info, $text, $width = 0, $style = 'default', $newline = 0 ) {

        $cellWidth = $info['form']['column']['width'];
        $lblHeight = $info['form']['label']['height'];
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

        $x = $info['style']['page']['ml'];
        $y = $pdf->GetY();
        $current = 0;

        $textLength = mb_strlen( $text );
        $colLength = $textLength / $cols;
        $colWidth = ( $info['style']['page']['viewport'] - ( $info['form']['column']['width'] * ( $cols - 1 ) ) ) / $cols;

        if( strpos( '§', $text ) !== false ) { $splitText = wordwrap( $text, $colLength, '§' ); } else { $splitText = $text; }
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
    function pdfFormSaveXY( &$pdf, &$info, $key = '0' ) {

        $info['cache']['coords'][ $key ]['x'] = $pdf->GetX();
        $info['cache']['coords'][ $key ]['y'] = $pdf->GetY();

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfFormLoadXY( &$pdf, &$info, $key = '0' ) {

        $pdf->SetXY(
            $info['cache']['coords'][ $key ]['x'],
            $info['cache']['coords'][ $key ]['y']
        );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetRelativeX( &$pdf, $offset ) {
        $pdf->SetX( $pdf->GetX() + $offset );
    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetRelativeY( &$pdf, $offset ) {
        $pdf->SetY( $pdf->GetY() + $offset );
    }

    /**
     * 
     * @todo documentare
     * 
     */
    function pdfSetRelativeXY( &$pdf, $offsetx, $offsety ) {
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

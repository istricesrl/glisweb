<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // impostazione documento
    $info['doc']['title']                       = 'PDF di prova';

    // definizione colori
    $info['colors']['nero']                     = array( 0, 0, 0 );
    $info['colors']['grigio']                   = array( 128, 128, 128 );
    $info['colors']['bianco']                   = array( 255, 255, 255 );

    // impostazione stili
    $info['style']['page']                      = array( 'w' => 210, 'h' => 297, 'mt' => 15, 'ml' => 15, 'mr' => 15 );
    $info['style']['text']['title']             = array( 'font' => 'helvetica', 'size' => 10, 'weight' => 'B' );
    $info['style']['text']['label']             = array( 'font' => 'helvetica', 'size' => 8, 'weight' => '' );

    // impostazione linee
    $info['lines']['thick']                     = array( 'thickness' => .3, 'color' => $info['colors']['nero'] );
    $info['lines']['thin']                      = array( 'thickness' => .15, 'color' => $info['colors']['grigio'] );

    // impostazione form
    $info['form']['columns']                    = 45;
    $info['form']['row']['height']              = 10;

    // prelievo dati dal database

    // creazione del PDF
	$pdf = pdfInit( $info );


  
    pdfFormCellTitle( $pdf, $info, 'rapporto di intervento di assistenza tecnica' );
    pdfFormCellLabel( $pdf, $info, 'modulo per assistenza tecnica a chiamata');
    pdfSetRelativeY( $pdf, 10 );

    pdfFormCellRow( $pdf, $info, array(
        array(
            'width' => 28,
            'label' => array( 'text' => 'richiesta ricevuta da' ),
            'bar' => array( 'text' => '' )
        ),
        array(
            'width' => 10,
            'label' => array( 'text' => 'in data' ),
            'bar' => array( 'text' => '' )
        ),
            array(
                'width' => 5,
                'label' => array( 'text' => 'alle ore' ),
                'bar' => array( 'text' => '' )
                )
            ));
            
            
            pdfFormCellTitle( $pdf, $info, '1. dati del cliente' );
            pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 45,
                    'label' => array( 'text' => 'nome e cognome o denominazione' ),
                    'bar' => array( 'text' => '' )
                )
                )
            );
            pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 45,
                    'label' => array( 'text' => 'indirizzo sede intervento' ),
                    'bar' => array( 'text' => '' )
                )
                )
            );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 36,
                    'label' => array( 'text' => 'città' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 2,
                    'label' => array( 'text' => 'prov' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'CAP' ),
                    'bar' => array( 'text' => '' )
                ) 

                )
            );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 15,
                    'label' => array( 'text' => 'codice fiscale' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 10,
                    'label' => array( 'text' => 'partita IVA' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 16,
                    'label' => array( 'text' => 'codice SDI' ),
                    'bar' => array( 'text' => '' )
                ) 

                )
            );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 13,
                    'label' => array( 'text' => 'telefono' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 31,
                    'label' => array( 'text' => 'email o PEC' ),
                    'bar' => array( 'text' => '' )
                )

                )
            );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 12,
                    'label' => array( 'text' => 'codice contratto' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 23
                ),
                array(
                    'width' => 8,
                    'label' => array( 'text' => 'ore residue' ),
                    'bar' => array( 'text' => '' )
                )

                )
            );
        pdfFormCellTitle( $pdf, $info, '2. descrizione del problema' );
        pdfFormLineRow( $pdf, $info, '', 26, 4);
        //rettangolo
        $pdf->Cell(30, 30, '', 1, 1);
        pdfFormCellTitle( $pdf, $info, '3. appuntamento' );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 28,
                    'label' => array( 'text' => 'appuntamento fissato per il tecnico' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 10,
                    'label' => array( 'text' => 'in data' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'alle ore' ),
                    'bar' => array( 'text' => '' )
                )

                )
            );
        pdfFormCellTitle( $pdf, $info, '4. viaggio di andata' );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 10,
                    'label' => array( 'text' => 'in data' ),
                    'bar' => array( 'text' => '  /  /' )
                ),

                array(
                    'width' => 15
                ),

                array(
                    'width' => 5,
                    'label' => array( 'text' => 'partenza' ),
                    'bar' => array( 'text' => '  :  ' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'arrivo' ),
                    'bar' => array( 'text' => '  :  ' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'totale' ),
                    'bar' => array( 'text' => '  h  m' )
                )

                )
            );
        pdfFormCellTitle( $pdf, $info, '5. diagnosi' );
        pdfFormLineRow( $pdf, $info, '', 45, 4 );
        pdfFormCellTitle( $pdf, $info, '6. soluzione proposta' );
        pdfFormLineRow( $pdf, $info, '', 25, 4 );
        $pdf->Cell(60, 30, '', 1, 1);
        pdfSetRelativeY( $pdf, 20 );
        pdfFormCellTitle( $pdf, $info, '7. esito intervento' );
        pdfFormLineRow( $pdf, $info, '', 45, 4 );
        pdfSetRelativeY( $pdf, 10 );
        pdfFormCellTitle( $pdf, $info, '7.1. tempo di intervento' );
        pdfFormCellRow( $pdf, $info, array(

                array(
                    'width' => 27, 
                ),


                array(
                    'width' => 5,
                    'label' => array( 'text' => 'inizio' ),
                    'bar' => array( 'text' => '  :  ' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'fine' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'totale' ),
                    'bar' => array( 'text' => '  h  m' )
                )


                )
                );
            pdfFormCellTitle( $pdf, $info, '8. chiusura intervento' );
            pdfFormLineRow( $pdf, $info, 'Io sottoscritto _______________________ dichiaro di aver letto, compreso e approvato il contenuto del presente rapporto di assistenza tecnica, che corrisponde a verità; dichiaro di aver verificato l\'n esito dell\'intervento e confermo la sua conformità a quanto indicato nel presente rapporto; autorizzo altresì a procedere con la fatturazione di quanto dovuto.', 45, 0);
                

                //spazio per spazio precompilato
            pdfSetRelativeY( $pdf, 20 );
            pdfFormCellTitle( $pdf, $info, '' );
            pdfFormLineRow( $pdf, $info,'Luogo e data ____________________ timbro e firma per accettazione delle condizioni di servizio _________________', 45, 0);
            pdfSetRelativeY( $pdf, 10 );
            pdfFormCellTitle( $pdf, $info, '' );
            pdfFormLineRow( $pdf, $info,'Il cliente accetta il trattamento dei propri dati personali', 45, 0);

            //problema celline dentro le linee



            pdfSetRelativeY( $pdf, 10 );
            pdfFormCellTitle( $pdf, $info, 'spazio riservato a Istrice srl');
            pdfFormCellLabel( $pdf, $info, 'per note di amministrazione e customer care');
            pdfSetRelativeY( $pdf, 10 );
            pdfFormCellTitle( $pdf, $info, '9.fatturazione' );
            pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 9,
                    'label' => array( 'text' => 'fattura/scontrino n.' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 10,
                    'label' => array( 'text' => 'del' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 24,
                    'label' => array( 'text' => 'responsabile amministrativo' ),
                    'bar' => array( 'text' => '' )
                )

                )
            );
            pdfFormCellTitle( $pdf, $info, '10. customer care' );
            pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 28,
                    'label' => array( 'text' => 'chiamata di customer care effettuata da' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 10,
                    'label' => array( 'text' => 'in data' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 5,
                    'label' => array( 'text' => 'alle ore' ),
                    'bar' => array( 'text' => '  :  ' )
                )

                )
            );
            pdfFormCellTitle( $pdf, $info, '10.1 feedback del cliente, richieste successive, osservazioni' );
            pdfFormLineRow( $pdf, $info, '', 45, 3);
            pdfFormCellTitle( $pdf, $info, '10.2 soddisfazione e referral' );



    






            


    // aggiunta di una pagina
	$pdf->AddPage();

     // output
     $pdf->Output( 'prova.pdf' );								// invia l'output al browser
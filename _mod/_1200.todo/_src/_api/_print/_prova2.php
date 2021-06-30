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

    // DATI
    if( isset( $_REQUEST['todo'] ) ){

        // dati todo
        $todo = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT todo_view.*, account_view.utente FROM todo_view LEFT JOIN account_view ON account_view.id = todo_view.id_account_inserimento WHERE todo_view.id = ? ',
            array( array( 's' => $_REQUEST['todo'] ) )
        );

        if( $todo ){
            // anagrafica cliente
            $cliente =  mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $todo['id_cliente'] ) ));
        
            // attività di diagnosi
            $attivita = mysqlSelectRow( $cf['mysql']['connection'],'SELECT attivita.* FROM attivita LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia WHERE attivita.id_todo = ? AND tipologie_attivita.nome = ? ORDER BY attivita.timestamp_inserimento LIMIT 1', array( array( 's' => $todo['id'] ), array( 's' => 'diagnosi') ));
        } else {

            die( print_r('dati todo assenti', true) );
        }
    }

    // impostazione documento
    $info['doc']['title']                       = 'PDF di prova';

    // definizione colori
    $info['colors']['nero']                     = array( 0, 0, 0 );
    $info['colors']['grigio']                   = array( 128, 128, 128 );
    $info['colors']['bianco']                   = array( 255, 255, 255 );

    // impostazione stili
    $info['style']['page']                      = array( 'w' => 210, 'h' => 297, 'mt' => 10, 'ml' => 15, 'mr' => 15 );
    $info['style']['text']['title']             = array( 'font' => 'helvetica', 'size' => 9, 'weight' => 'B' );
    $info['style']['text']['label']             = array( 'font' => 'helvetica', 'size' => 7, 'weight' => '' );
    $info['style']['text']['small']             = array( 'font' => 'helvetica', 'size' => 6, 'weight' => '' );

    // impostazione linee
    $info['lines']['thick']                     = array( 'thickness' => .3, 'color' => $info['colors']['nero'] );
    $info['lines']['thin']                      = array( 'thickness' => .15, 'color' => $info['colors']['grigio'] );

    // impostazione form
    $info['form']['columns']                    = 45;
    $info['form']['row']['height']              = 9;

    // prelievo dati dal database

    // creazione del PDF
	$pdf = pdfInit( $info );

    // impostazione stili
    $info['style']['text']['default']           = array( 'font' => 'helvetica', 'size' => 8, 'weight' => '' );
  
    pdfFormCellTitle( $pdf, $info, 'rapporto di intervento di assistenza tecnica' );
    pdfFormCellLabel( $pdf, $info, 'modulo per assistenza tecnica a chiamata');
    pdfSetRelativeY( $pdf, 5 );

    pdfFormCellRow( $pdf, $info, array(
        array(
            'width' => 28,
            'label' => array( 'text' => 'richiesta ricevuta da' ),
            'bar' => array( 'text' => ( isset( $todo ) ? $todo['utente'] : '' ) )
        ),
        array(
            'width' => 10,
            'label' => array( 'text' => 'in data' ),
            'bar' => array( 'text' => ( isset( $todo ) ? date( 'd/m/Y',$todo['timestamp_inserimento']) : '' ) )
        ),
            array(
                'width' => 5,
                'label' => array( 'text' => 'alle ore' ),
                'bar' => array( 'text' => ( isset( $todo ) ? date( 'H:i',$todo['timestamp_inserimento']) : '' ) )
                )
            ));
            
            pdfFormCellTitle( $pdf, $info, '1. dati del cliente' );
            pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 45,
                    'label' => array( 'text' => 'nome e cognome o denominazione' ),
                    'bar' => array( 'text' => ( isset( $cliente ) ? $cliente['__label__'] : '' ) )
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
                    'bar' => array( 'text' => ( isset( $cliente ) && ! empty( $cliente['codice_fiscale'] ) ? $cliente['codice_fiscale'] : '' ) )
                ),
                array(
                    'width' => 10,
                    'label' => array( 'text' => 'partita IVA' ),
                    'bar' => array( 'text' => ( isset( $cliente ) && ! empty( $cliente['partita_iva'] ) ? $cliente['partita_iva'] : '' ) )
                ),
                array(
                    'width' => 16,
                    'label' => array( 'text' => 'codice SDI' ),
                    'bar' => array( 'text' => ( isset( $cliente ) && ! empty( $cliente['codice_sdi'] ) ? $cliente['codice_sdi'] : '' ) )
                ) 

                )
            );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 13,
                    'label' => array( 'text' => 'telefono' ),
                    'bar' => array( 'text' => ( isset( $cliente ) ? $cliente['telefoni'] : '' ) )
                ),
                array(
                    'width' => 31,
                    'label' => array( 'text' => 'email o PEC' ),
                    'bar' => array( 'text' => ( isset( $cliente ) && ! empty( $cliente['mail'] ) ? $cliente['mail'] : '' ) )
                )

                )
            );
        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 12,
                    'label' => array( 'text' => 'codice contratto' ),
                    'bar' => array( 'text' => ( isset( $todo ) ? $todo['id_progetto'] : '' ) )
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

        $boxY = $pdf->GetY();

        pdfFormCellTitle( $pdf, $info, '2. descrizione del problema' );
        pdfFormLineRow( $pdf, $info, ( isset( $todo ) ? $todo['testo'] : '' ), 32, 3);

//        pdfFormBox( $pdf, $info, 'firma del cliente\nper accettazione', 8, 4, $boxX, pdfFormCalcY( $info, 27 ) );
//            pdfFormBox( $pdf, $info, "firma del cliente\nper accettazione", 8, 4, 130, 130 );
        pdfFormBox( $pdf, $info, "firma del cliente per autorizzazione a procedere con le attività di diagnosi", 12, 4, pdfFormCalcX( $info, 33 ), $boxY );

        //rettangolo
        //$pdf->Cell(30, 30, '', 1, 1);
        //pdfFormCellTitle( $pdf, $info, '3. appuntamento' );

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

        $boxY = $pdf->GetY();

        pdfFormCellTitle( $pdf, $info, '6. soluzione proposta' );
        pdfFormLineRow( $pdf, $info, '', 32, 3 );

//        $pdf->Cell(60, 30, '', 1, 1);
//        pdfSetRelativeY( $pdf, 20 );

        pdfFormBox( $pdf, $info, "firma del cliente per autorizzazione a procedere con la soluzione proposta", 12, 4, pdfFormCalcX( $info, 33 ), $boxY );

        pdfFormCellTitle( $pdf, $info, '7. esito e tempo di intervento' );
        pdfFormLineRow( $pdf, $info, '', 45, 4 );

        pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 26, 
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
                    'width' => 6,
                    'label' => array( 'text' => 'totale' ),
                    'bar' => array( 'text' => '  h  m' )
                )
            )
        );
            pdfFormCellTitle( $pdf, $info, '8. chiusura intervento' );
            pdfFormLineRow( $pdf, $info, 'Io sottoscritto _______________________ dichiaro di aver letto, compreso e approvato il contenuto del presente rapporto di assistenza tecnica, che corrisponde a verità; dichiaro di aver verificato l\'esito dell\'intervento e confermo la sua conformità a quanto indicato nel presente rapporto; autorizzo altresì a procedere con la fatturazione di quanto dovuto.', 45, 0);
            pdfSetRelativeY( $pdf, 10 );

            pdfSetRelativeY( $pdf, $info['form']['row']['spacing'] );
            $boxY = $pdf->GetY();

            pdfFormBox( $pdf, $info, "luogo e data", 12, 3, pdfFormCalcX( $info, 0 ), $boxY );
            pdfFormBox( $pdf, $info, "timbro e firma accettazione intervento", 21, 3, pdfFormCalcX( $info, 12), $boxY );
            pdfFormBox( $pdf, $info, "firma del tecnico", 12, 3, pdfFormCalcX( $info, 33 ), $boxY );

            $pdf->AddPage();
            pdfFormCellTitle( $pdf, $info, 'condizioni di servizio' );
            pdfFormCellLabel( $pdf, $info, 'condizioni del servizio di assistenza tecnica');
            pdfSetRelativeY( $pdf, 5 );
            pdfHtmlColumns( $pdf, $info, 2,
                'tra XXXXX, con sede in XXXXXXXXXXXXXXXXXXXXXX, C.F. e P.IVA XXXXXXXXXXXX, d\'ora in avanti Fornitore da una parte;
                e
                il soggetto identificato al quadro 1, d\'ora in avanti Cliente, dall\'altra parte;
                si conviene e si stipula quanto segue
                1. oggetto del contratto
                il Fornitore si obbliga col presente contratto a fornire le prestazioni di assistenza opportune per le problematiche specificate al quadro 2.
                2. tempo e luogo delle attività di assistenza
                l\'assistenza è fornita dal Fornitore, oltre a quanto stabilito dal presente contratto, anche secondo i propri livelli di servizio generali e nei tempi da essi previsti, visionabili anche sul sito www.pcstop.eu che il Cliente dichiara di conoscere, di aver compreso, e di accettare nella loro interezza.
                3. modalità di espletamento dell\'assistenza
                il Fornitore assiste solo hardware e software originale corredato dai necessari certificati di autenticità del relativo produttore. Nell\'esecuzione delle prestazioni a suo carico, il Fornitore opererà con autonoma organizzazione di personale e mezzi. Tra il Cliente e i dipendenti o collaboratori del Fornitore non potrà sussistere alcun rapporto di lavoro né subordinato né autonomo. Qualora in fase di analisi il Fornitore riscontri situazioni in cui non vengono rispettati i canoni di stabilità, affidabilità e sicurezza del sistema informativo del Cliente, ne darà tempestiva segnalazione, in forma libera, al Cliente stesso precisando inoltre gli interventi e le procedure necessarie per porvi rimedio. Se il Cliente rifiuta di adeguarsi alle richieste del Fornitore, questo sarà esonerato da qualsiasi responsabilità riguardo a eventuali danni che dovessero derivare da guasto o malfunzionamento dei sistemi informativi oggetto della segnalazione. Il Cliente ha facoltà, entro trenta giorni dal termine del singolo intervento, di segnalare per iscritto al Fornitore eventuali contestazioni, decorsi i quali il risultato dell\'intervento si intende accettato. In caso di contestazione il Fornitore, se ritiene fondate le richieste del Cliente, provvederà ad un ulteriore intervento per rettificare il risultato di quello contestato senza ulteriori costi per il Cliente. Qualora una delle prestazioni previste dal presente contratto debba essere effettuata tramite la connessione internet del cliente (assistenza remota) e tale connessione non sia disponibile, il Fornitore avrà facoltà di posticipare la prestazione fino al momento in cui gli sia nuovamente possibile effettuarla ovvero, a sua discrezione, potrà effettuarla presso la sede del cliente aggiungendo in tal caso i costi di spostamento a quelli di intervento in accordo con le tariffe vigenti al momento della prestazione.
                4. durata del contratto
                il presente contratto si esaurisce dopo trenta giorni dall\'accettazione da parte del Cliente delle prestazioni ricevute, manifestata per iscritto firmando il presente modulo.
                5. corrispettivo e condizioni di pagamento
                il corrispettivo per le prestazioni di cui sopra è determinato dalle tariffe del Fornitore vigenti al momento dell\'intervento, che il Cliente dichiara di conoscere e accettare. La regolarità dei pagamenti è presupposto necessario per l\'attivazione della garanzia sugli interventi.
                6. garanzia
                l\'esito dell\'intervento è coperto da garanzia per trenta giorni dalla data di accettazione da parte del Cliente dell\'esito dell\'intervento; entro tale periodo il Fornitore si impegna, senza ulteriori costi per il Cliente, a rettificare la soluzione applicata nel caso questa presenti dei problemi, o non si riveli definitiva.
                Il Fornitore si impegna ad intervenire con la diligenza dovuta e nei tempi concordati. Se non espressamente previsto il contrario, le obbligazioni del fornitore sono di mezzi e non di risultato; il Fornitore è tenuto soltanto a ripetere tempestivamente le eventuali operazioni non svolte con la dovuta competenza e diligenza. In nessun caso è previsto il rimborso degli interventi accettati tramite firma da parte del Cliente, e il Fornitore non è tenuto a rispondere di danni ai dati, al software e all\'hardware e in generale ai beni del Cliente salvo casi di dolo o colpa grave nell\'esecuzione dell\'intervento.
                7. altri contratti
                Il servizio non comprende il costo di eventuali ricambi, parti aggiuntive, licenze, e qualsiasi altro costo vivo che dovesse rendersi necessario per il completamente dell\'assistenza; il Fornitore si impegna ad avvisare tempestivamente il Cliente di qualsiasi costo dovesse rendersi necessario, procedendo con il lavoro solo previa autorizzazione data in forma libera dal Cliente.
                Ulteriori prestazioni, quali lo sviluppo di software, l\'erogazione di corsi di formazione, le prestazioni di consulenza, la vendita di hardware e software, formeranno eventuale oggetto di separati contratti.
                8. subappalto
                il Fornitore ha facoltà di subappaltare a terzi l\'attività dandone comunicazione al Cliente nel solo caso in cui i subappaltatori abbiano necessità di accedere ai locali di quest\'ultimo, ferma la responsabilità esclusiva del Fornitore per l\'operato dei subappaltatori nonché i necessari adempimenti in materia di protezione dei dati personali.
                9. riservatezza
                il Fornitore si impegna a mantenere riservate le password di accesso ricevute o comunque in suo possesso relative ai sistemi informativi del Cliente, nonché le notizie relative agli affari, ai piani, ai processi produttivi del Cliente, ai clienti e fornitori di quest\'ultimo e ai suoi sistemi di elaborazione dati di cui sia venuto a conoscenza durante o in occasione della conclusione del contratto, Il Cliente a sua volta si impegna a mantenere riservate le notizie relative agli affari, alle tecniche, ai programmi e metodologie del Fornitore di cui sia venuto a conoscenza durante o in occasione della conclusione del contratto. Le parti adotteranno tutte le misure di prevenzione necessarie per evitare la diffusione e l\'utilizzo delle informazioni ritenute riservate. Qualora la diffusione presso terzi di materiale o di informazioni ritenuti riservati sia stato causato da atti o fatti direttamente imputabili alle parti o ai loro dipendenti o fornitori, il responsabile sarà tenuto a risarcire all\'altra parte gli eventuali danni connessi alla violazione dell\'obbligo di riservatezza. Non rientrano negli obblighi di riservatezza di cui al presente articolo le informazioni delle quali una delle parti possa dimostrare che a) era già a conoscenza prima dell\'acquisizione delle stesse in virtù del presente contratto ovvero b) le informazioni e le documentazioni relative o connesse, direttamente o indirettamente, alla esecuzione degli obblighi derivanti dal presente contratto ovvero c) siano già di pubblico dominio, indipendentemente da un\'azione omissiva degli obblighi contrattuali contemplati nel presente articolo. Il vincolo di riservatezza di cui al presente articolo continuerà ad avere valore per cinque anni dopo la conclusione del presente contratto o finché le informazioni riservate non diventino di pubblico dominio.
                10.  privacy
                Le parti dichiarano di essere state informate di quanto previsto dal d.lgs. n. 196 del 30 giugno 2003 aggiornato secondo il Regolamento UE 679/2016 (GDPR) e di acconsentire al trattamento dei propri dati personali per le finalità indicate nel presente contratto. Con la sottoscrizione del presente contratto le parti, ai sensi del d.lgs. n. 196/2003 e successive modifiche e integrazioni, prestano il loro consenso espresso ed informato a che i dati che le riguardano ed indicati nel presente contratto siano oggetto di tutte operazioni di trattamento elencate alla citata norma. In particolare, le parti dichiarano che a) I dati forniti sono necessari per ogni adempimento del presente contratto e delle norme di legge, civili e fiscali; b) il rifiuto di fornirli di una delle parti comporterebbe la mancata stipulazione del contratto; c) le parti, in ogni momento, potranno esercitare I propri diritti. Resta infine espressamente inteso che il Cliente rimane esclusivo titolare del trattamento dei dati personali che vengano a trovarsi sulle apparecchiature oggetto del presente contratto e assicura e garantisce al Fornitore di essere in possesso di tutti i necessari consensi e di aver espletato tutti gli adempimenti necessari per assicurare la regolarità del trattamento manlevando in proposito il Fornitore.
                11. clausola risolutiva espressa
                il contratto può essere risolto di pieno diritto da ciascuna delle parti in caso di violazione da parte dell\'altra degli obblighi stabiliti dal presente contratto.
                12. obblighi del Cliente
                il Cliente fornirà tempestivamente l\'accesso logico e fisico ai suoi ambienti informatici necessario per l\'esecuzione delle operazioni di assistenza richieste. Il Cliente comunicherà inoltre con la massima celerità possibile le eventuali modifiche apportate al proprio sistema informatico al fine di consentire l\'efficace svolgimento delle operazioni. Il Fornitore non è responsabile in alcun caso dei danni eventualmente causati da una mancata o errata comunicazione di dati o informazioni da parte del Cliente. Il Cliente è responsabile della conservazione dei programmi originali, dei dati aziendali e del loro salvataggio, nonché della corretta comunicazione di tali informazioni al Fornitore.
                13. esclusioni
                Sono esclusi dalla garanzia del presente contratto di assistenza, e sollevano il Fornitore da ogni responsabilità, i problemi causati da utilizzo improprio di hardware e software, utilizzo di prodotti non originali, mancato rispetto delle norme ambientali, violazione delle normative vigenti, incuria dell\'utente, virus, manomissioni non autorizzate, incuria da trasporto interno ed esterno, fulmini, sbalzi di tensione, interventi di terze parti, e quant\'altro sia al di fuori del ragionevole controllo del Fornitore.
                14. risoluzione delle controversie
                il presente contratto è regolato dalle leggi della Repubblica Italiana e ogni eventuale controversia sarà esclusivamente devoluta al foro di Bologna.
                15. comunicazioni
                il Cliente si impegna a monitorare l\'indirizzo mail o PEC specificato al quadro 1, che il Fornitore utilizzerà per tutte le comunicazioni relative all\'intervento in corso; il Cliente accetta inoltre che le comunicazioni scritte avvenute tramite questo indirizzo abbiano valore legale in merito alle autorizzazioni a procedere eventualmente richieste dal Fornitore.
                16. clausole finali
                I quadri compilati sul presente rapporto di assistenza sono parte integrante ed essenziale del contratto stesso. Il presente contratto non potrà essere modificato o integrato se non tramite atto scritto.',
                'small'
            );


            pdfSetRelativeY( $pdf, 150 );
            pdfFormCellTitle( $pdf, $info, '' );
            pdfFormLineRow( $pdf, $info,'Luogo e data ____________________ timbro e firma per accettazione delle condizioni di servizio _______________________', 45, 0);
            pdfSetRelativeY( $pdf, 10 );
            pdfFormLineRow( $pdf, $info,'Ai sensi dell\'art. 1341 c.c. il Cliente approva specificamente gli artt. 3 (modalità di espletamento), 4 (durata del contratto), 5 (corrispettivo e condizioni di pagamento), 6 (garanzia), 8 (subappalto), 11 (clausola risolutiva espressa), 13 (esclusioni), 14 (risoluzione delle controversie).', 45, 0);
            pdfFormCellTitle( $pdf, $info, '' );
            pdfFormLineRow( $pdf, $info,'Il cliente accetta il trattamento dei propri dati personali per l\n esecuzione del contratto e le dovute operazioni di fatturazione per essere ricontattato ai fini di marketing e customer care per l\iscrizione alla newsletter di Istrice srl.', 45, 0);


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
            pdfFormCellRow( $pdf, $info, array(
                array(
                    'width' => 3,
                    
                ),
                array(
                    'width' => 12,
                    'label' => array( 'text' => 'quanto è soddisfatto da 1 a 10?' ),
                    
                ),
                array(
                    'width' => 2,
                    'label' => array( 'text' => '' ),
                    'bar' => array( 'text' => '' )
                ),
                array(
                    'width' => 9,
                    
                    
                ),
                array(
                    'width' => 12,
                    'label' => array( 'text' => 'quanto ci raccomanderebbe agli amici da 1 a 10?' ),
                    
                ),
                array(
                    'width' => 2,
                    'label' => array( 'text' => '' ),
                    'bar' => array( 'text' => '' )
                )

                )
            );






            


    // aggiunta di una pagina
	$pdf->AddPage();

     // output
     $pdf->Output( 'prova.pdf' );								// invia l'output al browser
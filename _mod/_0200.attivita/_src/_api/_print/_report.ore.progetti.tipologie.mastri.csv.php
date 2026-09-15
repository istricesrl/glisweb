<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

	/**
	 * Controllo autorizzazioni
	 * ========================
	 *
	 * Fix 2026-09-15: questo endpoint rispondeva 200 a chiunque, senza sessione. Non aveva
	 * nemmeno il segnaposto `if( true )` dei quattro del core: non aveva proprio niente.
	 *
	 * Non passa da `controller()` — ha una query sua — quindi l'ACL per tabella non lo vede
	 * e non basta essere autenticati per ereditare un permesso: NON esiste un privilegio d'area per questa famiglia, e inventarne uno adesso
     * chiuderebbe fuori tutti finche' qualcuno non lo attribuisce a un gruppo. Si pretende quindi
     * il minimo che chiude il buco vero, cioe' che ci sia qualcuno collegato. Il privilegio
     * d'area resta da decidere: vedi la voce nel TODO.
	 *
	 * Stesso meccanismo degli endpoint `/task/` e dei sei di `/print/` chiusi lo stesso
	 * giorno: verifica, log nel canale `security` a LOG_ERR, 403, exit.
	 */
	checkTaskPrivilege(  );

    // inclusione di PHPExcel
	use PhpOffice\PhpSpreadsheet\Spreadsheet;
	use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

	// se sono indicati mese e anno
	if ( isset( $_REQUEST['mese'] ) && isset( $_REQUEST['anno'] ) ){
		$mese = $_REQUEST['mese'];
		$anno = $_REQUEST['anno'];

		// elenco dati
		$report = mysqlQuery(
			$cf['mysql']['connection'],
			'SELECT r.*, p.nome as progetto FROM __report_ore_progetti_tipologie_mastri__ AS r LEFT JOIN progetti AS p '
			.'ON r.id_progetto = p.id WHERE r.mese = ? AND r.anno = ? ORDER BY p.nome',
			array(
				array( 's' => $mese ),
				array( 's' => $anno )
			)
		);

		if( !empty( $report ) ){
			$filename = "esportazione ore progetti per tipologia e conto ore " . int2month($mese) . " " . $anno . ".csv";
	
			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename=' . $filename );
			
			// intestazioni
			$csv[0] = array('ID progetto', 'Progetto', 'Tipologia', 'Conto ore', 'Ore previste', 'Ore lavorate', 'Differenza');

			foreach( $report as $r ){
				// estraggo il nome di tipologia e mastro
				$tipologia = mysqlSelectValue(
					$cf['mysql']['connection'],
					'SELECT nome FROM tipologie_attivita WHERE id = ?',
					array( array( 's' => $r['id_tipologia_attivita'] ) )
				);

				$mastro = mysqlSelectValue(
					$cf['mysql']['connection'],
					'SELECT nome FROM mastri WHERE id = ?',
					array( array( 's' => $r['id_mastro'] ) )
				);

				$csv[] = array( 
					$r['id_progetto'],
					$r['progetto'],
					$tipologia,
					$mastro, 
					str_replace('.', ',', $r['ore_previste'] ), 
					str_replace( '.', ',', $r['ore_fatte'] ), 
					str_replace( '.', ',', $r['ore_fatte'] - $r['ore_previste'] ) 
				);
			}

			$fp = fopen( DIR_TMP . microtime( true ) . '.csv', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ';');}
			fclose($fp);

		}else { buildText( 'nessun risultato per la ricerca effettuata' ); }

	} else { buildText( 'mese e anno non specificati' ); }


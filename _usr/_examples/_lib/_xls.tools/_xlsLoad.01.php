<?php

    /**
     * esempio di xlsLoad()
     *
     * L'output è controllato da _usr/_test/_tests/unit/xlsToolsCest.php. Si leggono quattro file costruiti qui:
     *
     * - un xlsx normale, di cui si devono leggere i valori;
     * - un ODS, che xlsLoad() non apre ( CVE-2026-108359 );
     * - un xlsx con un'immagine collegata a un indirizzo esterno ( CVE-2026-108360 );
     * - un xlsx col foglio che chiede un DTD esterno ( CVE-2026-108358 ).
     *
     * Gli indirizzi esterni puntano al finto REST dei test ( REST_MOCK_URL, vedi _src/_config/_595.rest.php ), e il test
     * controlla che non gli sia arrivata nessuna richiesta; fuori dai test puntano a esempio.test, che non esiste.
     *
     */

    require '../../../../_src/_config.php';

    // indirizzo che non deve essere chiamato
    $esterno = ( ( defined( 'REST_MOCK_URL' ) ) ? REST_MOCK_URL . '/esempio.test' : 'http://esempio.test' );

    // cartella di lavoro
    $cartella = DIR_VAR . 'tmp/xlsLoad.' . getmypid() . '/';
    @mkdir( $cartella, 0770, true );

    // xlsx normale
    array2xlsFile( $cartella . 'normale.xlsx', array( array( 'nome' => 'Mario', 'codice' => '001' ), array( 'nome' => 'Anna', 'codice' => '002' ) ) );
    $xls = xlsLoad( $cartella . 'normale.xlsx' );
    echo 'normale: ' . ( ( $xls === false ) ? 'false' : json_encode( $xls->getActiveSheet()->toArray() ) ) . PHP_EOL;

    // ODS
    $zip = new ZipArchive();
    $zip->open( $cartella . 'foglio.ods', ZipArchive::CREATE );
    $zip->addFromString( 'mimetype', 'application/vnd.oasis.opendocument.spreadsheet' );
    $zip->addFromString( 'META-INF/manifest.xml', '<?xml version="1.0" encoding="UTF-8"?><manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"><manifest:file-entry manifest:full-path="/" manifest:media-type="application/vnd.oasis.opendocument.spreadsheet"/></manifest:manifest>' );
    $zip->addFromString( 'meta.xml', '<?xml version="1.0" encoding="UTF-8"?><office:document-meta xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" office:version="1.2"><office:meta/></office:document-meta>' );
    $zip->addFromString( 'styles.xml', '<?xml version="1.0" encoding="UTF-8"?><office:document-styles xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" office:version="1.2"><office:automatic-styles/><office:master-styles/></office:document-styles>' );
    $zip->addFromString( 'content.xml', '<?xml version="1.0" encoding="UTF-8"?><office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" office:version="1.2"><office:automatic-styles/><office:body><office:spreadsheet><table:table table:name="a"><table:table-row><table:table-cell office:value-type="string"><text:p>ODS letto</text:p></table:table-cell></table:table-row></table:table></office:spreadsheet></office:body></office:document-content>' );
    $zip->close();
    $xls = xlsLoad( $cartella . 'foglio.ods' );
    echo 'ods: ' . ( ( $xls === false ) ? 'false' : json_encode( $xls->getActiveSheet()->toArray() ) ) . PHP_EOL;

    // xlsx con un'immagine collegata
    copy( $cartella . 'normale.xlsx', $cartella . 'immagine.xlsx' );
    $zip = new ZipArchive();
    $zip->open( $cartella . 'immagine.xlsx' );
    $foglio = $zip->getFromName( 'xl/worksheets/sheet1.xml' );
    $zip->addFromString( 'xl/worksheets/sheet1.xml', str_replace( '</worksheet>', '<drawing r:id="rIdImg"/></worksheet>', $foglio ) );
    $zip->addFromString( 'xl/worksheets/_rels/sheet1.xml.rels', '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rIdImg" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing" Target="../drawings/drawing1.xml"/></Relationships>' );
    $zip->addFromString( 'xl/drawings/drawing1.xml', '<?xml version="1.0" encoding="UTF-8"?><xdr:wsDr xmlns:xdr="http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><xdr:oneCellAnchor><xdr:from><xdr:col>0</xdr:col><xdr:colOff>0</xdr:colOff><xdr:row>0</xdr:row><xdr:rowOff>0</xdr:rowOff></xdr:from><xdr:ext cx="100" cy="100"/><xdr:pic><xdr:nvPicPr><xdr:cNvPr id="1" name="immagine"/><xdr:cNvPicPr/></xdr:nvPicPr><xdr:blipFill><a:blip r:link="rId1"/></xdr:blipFill><xdr:spPr/></xdr:pic><xdr:clientData/></xdr:oneCellAnchor></xdr:wsDr>' );
    $zip->addFromString( 'xl/drawings/_rels/drawing1.xml.rels', '<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="' . $esterno . '/immagine.png" TargetMode="External"/></Relationships>' );
    $zip->close();
    $xls = xlsLoad( $cartella . 'immagine.xlsx' );
    echo 'immagine: ' . ( ( $xls === false ) ? 'false' : json_encode( $xls->getActiveSheet()->toArray() ) ) . PHP_EOL;

    // xlsx col foglio che chiede un DTD esterno
    copy( $cartella . 'normale.xlsx', $cartella . 'dtd.xlsx' );
    $zip = new ZipArchive();
    $zip->open( $cartella . 'dtd.xlsx' );
    $foglio = $zip->getFromName( 'xl/worksheets/sheet1.xml' );
    $zip->addFromString( 'xl/worksheets/sheet1.xml', preg_replace( '/^(<\?xml[^>]*\?>)/', '$1<!DOCTYPE worksheet SYSTEM "' . $esterno . '/foglio.dtd">', $foglio ) );
    $zip->close();
    $xls = xlsLoad( $cartella . 'dtd.xlsx' );
    echo 'dtd: ' . ( ( $xls === false ) ? 'false' : json_encode( $xls->getActiveSheet()->toArray() ) ) . PHP_EOL;

    // pulizia
    array_map( 'unlink', glob( $cartella . '*' ) );
    rmdir( $cartella );

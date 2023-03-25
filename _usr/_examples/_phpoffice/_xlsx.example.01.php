<?php

    require '../../../../../_src/_config.php';

    $spreadsheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();

    header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    header('Content-Disposition: attachment;filename="myfile.xlsx"');
    header('Cache-Control: max-age=0');

    $writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter( $spreadsheet, 'Xlsx' );
    $writer->save('php://output');

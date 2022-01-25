<?php

    /**
     * 
     */
    function xlsIncrementCol( $col, $inc ) {

        $old = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::columnIndexFromString( $col );
        $new = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex( $old + $inc );

        return $new;

    }

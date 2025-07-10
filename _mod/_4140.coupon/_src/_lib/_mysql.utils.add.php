<?php

    function getDettagliCoupon( $id ) {

        global $cf;

        $coupon = mysqlSelectRow(
            $cf['mysql']['connection'],
            "SELECT * FROM `coupon` WHERE `id` = ?",
            array( 
                array( 's' => $id )
            )
        );

        $coupon['totale_utilizzi'] = 0;

        $coupon['utilizzi'] = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM `__report_utilizzi_coupon__` WHERE `id` = ?",
            array( 
                array( 's' => $id )
            )
        );

        foreach( $coupon['utilizzi'] as $key => $utilizzo ) {
            $coupon['totale_utilizzi'] += $utilizzo['importo_lordo_finale'];            
        }

        $coupon['totale_finale'] = $coupon['sconto_fisso'] - $coupon['totale_utilizzi'];

        return $coupon;

    }

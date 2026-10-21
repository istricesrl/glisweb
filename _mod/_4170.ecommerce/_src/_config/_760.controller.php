<?php

    /**
     *
     * il controllo del carrello chiuso in sessione è stato spostato nello STEP 0 di _750.controller.php,
     * perché qui girava dopo lo STEP 1 e il carrello chiuso veniva riscritto dalla prima richiesta
     * con __carrello__; questo file si può togliere dallo standard
     *
     */

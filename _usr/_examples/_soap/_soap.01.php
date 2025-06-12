<?php

    ini_set('soap.wsdl_cache_ttl', 0);

    class CurrentVersion
    {
        public $version;
        public $release;
    }
    try {
        $client = new SoapClient(
            'https://megimbe.istricesrl.it/api/current.version.wsdl',
            array(
                'classmap' => array('CurrentVersion' => "CurrentVersion"),
                'cache_wsdl' => WSDL_CACHE_NONE,
                'trace' => 1
            )
        );
        $response = $client->getCurrentVersion();
        echo "\nREQUEST:\n" . $client->__getLastRequest();
        echo "\nRESPONSE:\n" . $client->__getLastResponse();
        var_dump( $response );
        echo "\nVersion: " . $response->version;
        echo "\nRelease: " . $response->release;
    } catch (Exception $e) {
        echo "SOAP Error: " . $e->getMessage();
        if (isset($client)) {
            echo "\nREQUEST:\n" . $client->__getLastRequest();
            echo "\nRESPONSE:\n" . $client->__getLastResponse();
        }
    }

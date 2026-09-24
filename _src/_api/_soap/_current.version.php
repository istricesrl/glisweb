<?php
    ini_set("soap.wsdl_cache_enabled","0");
    class CurrentVersion
    {
        public $version;
        public $release;
    }
    $server=new SoapServer("_current.version.wsdl",[
        'classmap'=>[
            'CurrentVersion'=>'CurrentVersion',
        ]
    ]);
    $server->addFunction('getCurrentVersion');
    $server->handle();
    function getCurrentVersion()
    {
        $currentVersion = new CurrentVersion();
        $currentVersion->version = trim( file_get_contents( '../../../_etc/_current.version') );
        $currentVersion->release = trim( file_get_contents( '../../../_etc/_current.release') );
        return $currentVersion;
    }

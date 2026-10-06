<?php

    /**
     * actor della suite backend
     *
     * le azioni vengono dai moduli abilitati in _usr/_test/_tests/backend.suite.yml e le genera
     * php codecept build in _support/_generated/, che non si versiona
     *
     */

    class BackendTester extends \Codeception\Actor {

        use _generated\BackendTesterActions;

    }

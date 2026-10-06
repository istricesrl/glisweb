<?php

    /**
     * actor della suite frontend
     *
     * le azioni vengono dai moduli abilitati in _usr/_test/_tests/frontend.suite.yml e le genera
     * php codecept build in _support/_generated/, che non si versiona
     *
     */

    class FrontendTester extends \Codeception\Actor {

        use _generated\FrontendTesterActions;

    }

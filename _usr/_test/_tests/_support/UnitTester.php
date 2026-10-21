<?php

    /**
     * actor della suite unit
     *
     * le azioni vengono dai moduli abilitati in _usr/_test/_tests/unit.suite.yml e le genera
     * php codecept build in _support/_generated/, che non si versiona
     *
     */

    class UnitTester extends \Codeception\Actor {

        use _generated\UnitTesterActions;

    }

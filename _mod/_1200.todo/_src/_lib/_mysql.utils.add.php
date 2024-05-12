<?php

    /**
     * 
     * 
     * 
     * 
     */
    function updateTodoViewStatic( $id ) {

        global $cf;

        mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO todo_view_static SELECT * FROM todo_view WHERE id = ?', array( array( 's' => $id ) ) );

    }

DELIMITER //
DROP PROCEDURE IF EXISTS `todo_view_static`//
CREATE DEFINER=`root`@`localhost`
PROCEDURE `todo_view_static`( IN `i` INT(11) )
BEGIN
	
	IF @TRIGGER_LAZY IS NULL THEN
	  IF i IS NULL THEN
		DELETE FROM todo_view_static;	
		REPLACE INTO todo_view_static SELECT * FROM todo_view;
	  ELSE 
		DELETE FROM todo_view_static WHERE todo_view_static.id = i;
		INSERT INTO todo_view_static
		  SELECT * FROM todo_view WHERE todo_view.id = i;  
	  END IF;
	END IF;

END//
DELIMITER ;

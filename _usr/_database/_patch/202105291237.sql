DELIMITER //
DROP PROCEDURE IF EXISTS `attivita_view_static`//
CREATE DEFINER=`root`@`localhost`
PROCEDURE `attivita_view_static`( IN `i` INT(11) )
BEGIN

	IF @TRIGGER_LAZY IS NULL THEN
	  IF i IS NULL THEN
		DELETE FROM attivita_view_static;		
		REPLACE INTO attivita_view_static SELECT * FROM attivita_view;
	  ELSE	  
		DELETE FROM attivita_view_static WHERE attivita_view_static.id = i;
		INSERT INTO attivita_view_static
		  SELECT * FROM attivita_view WHERE attivita_view.id = i;	  
	  END IF;
	END IF;

END//
DELIMITER ;

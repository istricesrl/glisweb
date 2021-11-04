DELIMITER //
DROP PROCEDURE IF EXISTS `anagrafica_view_static`//
CREATE DEFINER=`root`@`localhost`
PROCEDURE `anagrafica_view_static`( IN `i` INT(11) )
BEGIN

  IF i IS NULL THEN

	DELETE FROM anagrafica_view_static;
	
	REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view;

  ELSE
  
	DELETE FROM anagrafica_view_static WHERE anagrafica_view_static.id = i;

	INSERT INTO anagrafica_view_static
	  SELECT * FROM anagrafica_view WHERE anagrafica_view.id = i;
  
  END IF;

END//
DELIMITER ;

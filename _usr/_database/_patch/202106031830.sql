DELIMITER //
DROP PROCEDURE IF EXISTS `attivita_view_static_by_anagrafica`//
CREATE DEFINER=`root`@`localhost`
PROCEDURE `attivita_view_static_by_anagrafica`( IN `i` INT(11) )
BEGIN

  IF i IS NOT NULL THEN
	  
	DELETE FROM attivita_view_static WHERE attivita_view_static.id_cliente = i;
	INSERT INTO attivita_view_static
      SELECT * FROM attivita_view WHERE attivita_view.id_cliente = i;
	  
	DELETE FROM attivita_view_static WHERE attivita_view_static.id_anagrafica = i;
	INSERT INTO attivita_view_static
      SELECT * FROM attivita_view WHERE attivita_view.id_anagrafica = i;
  
  END IF;

END//
DELIMITER ;

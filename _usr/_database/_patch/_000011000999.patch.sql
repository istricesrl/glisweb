--
-- TRIGGER
-- questo file contiene le query per la creazione dei trigger
--

--| 000011000001

-- anagrafica_view_static
DROP PROCEDURE IF EXISTS `anagrafica_view_static`;

--| 000011000002

-- anagrafica_view_static
CREATE
    DEFINER=CURRENT_USER()
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

    END;

--| 000011000003

-- anagrafica_update_static
DROP TRIGGER IF EXISTS anagrafica_update_static;

--| 000011000004

-- anagrafica_update_static
CREATE TRIGGER anagrafica_update_static AFTER UPDATE ON anagrafica FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id );
END;

--| 000011000005

-- anagrafica_insert_static
DROP TRIGGER IF EXISTS anagrafica_insert_static;

--| 000011000006

-- anagrafica_insert_static
CREATE TRIGGER anagrafica_insert_static AFTER INSERT ON anagrafica FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id );
END;

--| 000011000007

-- anagrafica_delete_static
DROP TRIGGER IF EXISTS anagrafica_delete_static;

--| 000011000008

-- anagrafica_delete_static
CREATE TRIGGER anagrafica_delete_static AFTER DELETE ON anagrafica FOR EACH ROW BEGIN
    CALL anagrafica_view_static( OLD.id );
END;

--| 000011000009

-- anagrafica_categorie_update_static
DROP TRIGGER IF EXISTS anagrafica_categorie_update_static;

--| 000011000010

-- anagrafica_categorie_update_static
CREATE TRIGGER anagrafica_categorie_update_static AFTER UPDATE ON anagrafica_categorie FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id_anagrafica );
END;

--| 000011000011

-- anagrafica_categorie_insert_static
DROP TRIGGER IF EXISTS anagrafica_categorie_insert_static;

--| 000011000012

CREATE TRIGGER anagrafica_categorie_insert_static AFTER INSERT ON anagrafica_categorie FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id_anagrafica );
END;

--| 000011000013

-- anagrafica_categorie_delete_static
DROP TRIGGER IF EXISTS anagrafica_categorie_delete_static;

--| 000011000014

-- anagrafica_categorie_delete_static
CREATE TRIGGER anagrafica_categorie_delete_static AFTER DELETE ON anagrafica_categorie FOR EACH ROW BEGIN
    CALL anagrafica_view_static( OLD.id_anagrafica );
END;

--| FINE FILE

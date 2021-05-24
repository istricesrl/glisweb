--
-- TRIGGER
-- questo file contiene le query per la creazione dei trigger
--

--| 000011000400

-- anagrafica_update_static
DROP TRIGGER IF EXISTS anagrafica_update_static;

--| 000011000401

-- anagrafica_update_static
CREATE TRIGGER anagrafica_update_static AFTER UPDATE ON anagrafica FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id );
END;

--| 000011000402

-- anagrafica_insert_static
DROP TRIGGER IF EXISTS anagrafica_insert_static;

--| 000011000403

-- anagrafica_insert_static
CREATE TRIGGER anagrafica_insert_static AFTER INSERT ON anagrafica FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id );
END;

--| 000011000404

-- anagrafica_delete_static
DROP TRIGGER IF EXISTS anagrafica_delete_static;

--| 000011000405

-- anagrafica_delete_static
CREATE TRIGGER anagrafica_delete_static AFTER DELETE ON anagrafica FOR EACH ROW BEGIN
    CALL anagrafica_view_static( OLD.id );
END;

--| 000011000500

-- anagrafica_categorie_update_static
DROP TRIGGER IF EXISTS anagrafica_categorie_update_static;

--| 000011000501

-- anagrafica_categorie_update_static
CREATE TRIGGER anagrafica_categorie_update_static AFTER UPDATE ON anagrafica_categorie FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id_anagrafica );
END;

--| 000011000502

-- anagrafica_categorie_insert_static
DROP TRIGGER IF EXISTS anagrafica_categorie_insert_static;

--| 000011000503

CREATE TRIGGER anagrafica_categorie_insert_static AFTER INSERT ON anagrafica_categorie FOR EACH ROW BEGIN
    CALL anagrafica_view_static( NEW.id_anagrafica );
END;

--| 000011000504

-- anagrafica_categorie_delete_static
DROP TRIGGER IF EXISTS anagrafica_categorie_delete_static;

--| 000011000505

-- anagrafica_categorie_delete_static
CREATE TRIGGER anagrafica_categorie_delete_static AFTER DELETE ON anagrafica_categorie FOR EACH ROW BEGIN
    CALL anagrafica_view_static( OLD.id_anagrafica );
END;

--| FINE FILE

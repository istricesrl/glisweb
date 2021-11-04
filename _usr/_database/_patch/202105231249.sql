-- trigger per todo_view_static
DELIMITER //

-- tabella todo
DROP TRIGGER IF EXISTS todo_update_static//
CREATE TRIGGER todo_update_static AFTER UPDATE ON todo FOR EACH ROW BEGIN
    CALL todo_view_static( NEW.id );
END//
DROP TRIGGER IF EXISTS todo_insert_static//
CREATE TRIGGER todo_insert_static AFTER INSERT ON todo FOR EACH ROW BEGIN
    CALL todo_view_static( NEW.id );
END//
DROP TRIGGER IF EXISTS todo_delete_static//
CREATE TRIGGER todo_delete_static AFTER DELETE ON todo FOR EACH ROW BEGIN
    CALL todo_view_static( OLD.id );
END//

DELIMITER ;
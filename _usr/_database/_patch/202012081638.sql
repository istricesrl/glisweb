CREATE OR REPLACE VIEW `menu_view` AS
    SELECT
    menu.*,
    menu.nome AS __label__
    FROM menu
    ORDER BY __label__
;

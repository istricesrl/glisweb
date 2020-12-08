-- pagine_menu_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `menu_view`;
CREATE OR REPLACE VIEW `menu_view` AS
    SELECT
    menu.*,
    menu.nome AS __label__
    FROM pagine_menu
    ORDER BY __label__
;

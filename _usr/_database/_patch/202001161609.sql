-- macro_view
-- tipologia: tabella gestita
DROP TABLE IF EXISTS `macro_view`;
CREATE OR REPLACE VIEW `macro_view` AS
    SELECT
    macro.*,
    macro.macro AS __label__
    FROM macro
    ORDER BY __label__
;

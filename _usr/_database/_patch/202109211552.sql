CREATE OR REPLACE VIEW `todo_lavoro_view` AS 
SELECT *
FROM todo_view_static	
WHERE timestamp_completamento IS  NULL
;

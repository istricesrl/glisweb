CREATE OR REPLACE VIEW `todo_archivio_view` AS 
SELECT *
FROM todo_view_static	
WHERE timestamp_completamento IS NOT NULL
;
CREATE OR REPLACE VIEW cron_view AS
    SELECT
	cron.*,
	cron.task AS __label__
    FROM cron
    ORDER BY __label__
;

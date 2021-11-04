CREATE OR REPLACE VIEW job_view AS
    SELECT
	job.*,
	IF( job.corrente IS NOT NULL, concat_ws( ' ', job.corrente, ' di ', job.totale ), '-' ) AS avanzamento,
	from_unixtime( job.timestamp_apertura, '%Y-%m-%d %H:%i' ) AS data_ora_apertura,
	from_unixtime( job.timestamp_esecuzione, '%Y-%m-%d %H:%i' ) AS data_ora_esecuzione,
	from_unixtime( job.timestamp_completamento, '%Y-%m-%d %H:%i' ) AS data_ora_completamento,
	job.nome AS __label__
    FROM job
    ORDER BY __label__
;
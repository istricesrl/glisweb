CREATE OR REPLACE VIEW ruoli_video_view AS
    SELECT
	ruoli_video.*,
	ruoli_video.nome AS __label__
    FROM ruoli_video
    ORDER BY __label__
;
CREATE OR REPLACE VIEW ruoli_audio_view AS
    SELECT
	ruoli_audio.*,
	ruoli_audio.nome AS __label__
    FROM ruoli_audio
    ORDER BY __label__
;
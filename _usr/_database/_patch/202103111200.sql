CREATE OR REPLACE VIEW `audio_view` AS
    SELECT
    audio.*,
    audio.nome AS __label__
    FROM audio
;
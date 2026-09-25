-- 2026-09-25 — i flag se_notizie, se_categorie_notizie, se_annunci e se_categorie_annunci sul ruolo audio di base
--
-- Contesto: i form audio dei moduli notizie e annunci ( _mod/_3100.notizie e _mod/_3200.annunci,
-- *.form.audio ) popolano la tendina dei ruoli da ruoli_audio_view con WHERE se_notizie = 1, WHERE
-- se_categorie_notizie = 1, WHERE se_annunci = 1 e WHERE se_categorie_annunci = 1, ma nessuno dei
-- due ruoli audio di base ha mai avuto questi flag ( nemmeno prima del riallineamento d975b4a15 ):
-- la tendina restava vuota e, essendo selectRequired, un audio di una notizia o di un annuncio non
-- si poteva salvare.
--
-- DATI. Si prende a modello il ruolo video corrispondente: il ruolo audio 1 ( 'audio' ) e' il
-- gemello del ruolo video 1 ( 'video' ), che ha i quattro flag a 1, e li riceve uguali. Il ruolo
-- audio 2 ( 'commento' ) non ha un gemello fra i ruoli video e resta com'e'. se_risorse e
-- se_categorie_risorse, che il ruolo video 1 ha, non si toccano: non erano richiesti. I file di base
-- sono stati aggiornati nello stesso giro.
--
-- IDEMPOTENZA. L'UPDATE e' mirato sull'id del ruolo di base e si puo' ripetere; le colonne
-- se_annunci e se_categorie_annunci arrivano con _202609251100.ruoli.audio.video.sql.

-- | 202609251200

-- ruoli_audio
UPDATE `ruoli_audio` SET
`se_notizie` = '1',
`se_categorie_notizie` = '1',
`se_annunci` = '1',
`se_categorie_annunci` = '1'
WHERE (`id` = '1');

-- | FINE FILE

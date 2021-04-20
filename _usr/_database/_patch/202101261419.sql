CREATE OR REPLACE VIEW `mail_out_view` AS
    SELECT
    mail_out.*,
    from_unixtime( mail_out.timestamp_invio, '%Y-%m-%d %H:%i' ) AS data_ora_invio,
    mail_out.oggetto AS __label__
    FROM mail_out
    ORDER BY mail_out.timestamp_invio ASC
;
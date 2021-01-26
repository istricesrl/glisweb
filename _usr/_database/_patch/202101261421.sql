CREATE OR REPLACE VIEW `mail_sent_view` AS
    SELECT
    mail_sent.*,
    from_unixtime( mail_sent.timestamp_invio, '%Y-%m-%d %H:%i' ) AS data_ora_invio,
    mail_sent.oggetto AS __label__
    FROM mail_sent
    ORDER BY mail_sent.timestamp_invio DESC
;
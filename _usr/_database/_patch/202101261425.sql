CREATE OR REPLACE VIEW `sms_sent_view` AS
    SELECT
    sms_sent.*,
    from_unixtime( sms_sent.timestamp_invio, '%Y-%m-%d %H:%i' ) AS data_ora_invio,
    sms_sent.corpo AS __label__
    FROM sms_sent
    ORDER BY sms_sent.timestamp_invio DESC
;
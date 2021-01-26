CREATE OR REPLACE VIEW `sms_out_view` AS
    SELECT
    sms_out.*,
    from_unixtime( sms_out.timestamp_invio, '%Y-%m-%d %H:%i' ) AS data_ora_invio,
    sms_out.corpo AS __label__
    FROM sms_out
    ORDER BY sms_out.timestamp_invio ASC
;
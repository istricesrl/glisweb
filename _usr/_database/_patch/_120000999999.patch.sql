--
-- PATCH
--

--| 120000000100

INSERT INTO __patch__ ( id, patch, timestamp_esecuzione, note_esecuzione )
    VALUES ( date_format( now(), '%Y%m%d%H%i' ), '-- fine installazione database ex novo --', unix_timestamp(), 'OK' );

--| FINE FILE
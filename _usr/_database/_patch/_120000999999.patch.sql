--
-- TRIGGER
-- questo file contiene le query per la creazione dei trigger
--

--| 120000000100

INSERT INTO __patch__ ( id, patch, timestamp_esecuzione )
    VALUES date_format( now(), '%Y%m%d%H%i' ), '-- fine installazione database ex novo --', unix_timestamp();

--| FINE FILE

-- 2026-09-25 — pagamenti.data_ripetizione, la data della ripetizione della pianificazione da cui nasce un pagamento
--
-- Contesto: per ogni entita' pianificabile la data dell'oggetto e' la data della ripetizione che l'ha creato ( la data
-- di un documento, la data di programmazione di una todo ), e il modulo _PI000.pianificazioni riconosce con quella
-- data se una ripetizione ha gia' il suo oggetto. Per i pagamenti no: la loro data e' la scadenza, che con un
-- differimento ( pianificazioni.offset_giorni, offset_fine_mese ) cade dopo la ripetizione, e da una scadenza non si
-- risale con certezza alla ripetizione: cambiando il differimento, la stessa ripetizione ha un'altra scadenza e il
-- controllo dei doppioni ne creava un secondo pagamento accanto a quello, magari gia' pagato; con il fine mese e una
-- periodicita' piu' breve del mese, piu' ripetizioni hanno la stessa scadenza. Sulla tabella non c'e' una colonna
-- adatta a tenerla ( le date sono data_scadenza e, come timestamp, timestamp_pagamento ): questa patch la aggiunge,
-- nullable, e il modulo la scrive per ogni pagamento che crea, autonomo o figlio di un documento pianificato.
--
-- I pagamenti creati prima di questa patch hanno data_ripetizione vuota, e il modulo per quelli continua a ragionare
-- sulla scadenza. Non si riempie la colonna per loro: la ripetizione andrebbe ricavata dai parametri attuali della
-- pianificazione, che possono non essere quelli con cui il pagamento e' nato.
--
-- ADD COLUMN IF NOT EXISTS e' di MariaDB, come in _202609151300.documenti.articoli.colonne.sql.

-- | 202609251600

-- la colonna nuova
ALTER TABLE `pagamenti`
	ADD COLUMN IF NOT EXISTS `data_ripetizione` date DEFAULT NULL AFTER `id_pianificazione`;

-- | FINE FILE

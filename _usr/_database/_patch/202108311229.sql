ALTER TABLE `indirizzi`
ADD KEY `timestamp_geocode` (`timestamp_geocode`), 
ADD KEY `latitudine` (`latitudine`), 
ADD KEY `longitudine` (`longitudine`),
ADD KEY `timestamp_aggiornamento` (`timestamp_aggiornamento`);

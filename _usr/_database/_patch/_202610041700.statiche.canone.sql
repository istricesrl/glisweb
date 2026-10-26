-- 2026-10-04 — attivita_view, attivita_view_static e articoli_view_static come il canone
--
-- il commit 622c1907a ha ridefinito le statiche nel _080 e attivita_view nel _090 senza una patch che ci
-- portasse i DB vivi: su DEV e PROD attivita_view dava colonne diverse dal canone e alla statica ne
-- mancavano fino a 26 ( piu' l'indice codice ). Le statiche sono dati derivati: si ricostruiscono dalla vista
-- in una tabella nuova e si scambiano con RENAME, cosi' non restano mai vuote. Dimensioni di articoli a
-- decimal(12,5) come in articoli ( decisione del 02/10; il _080 diceva decimal(7,2) e arrotondava ).
-- Provata il 04/10 su tabelle zz_ in bernispa, crmfia, gimbe, polmasi dev e prod, utensilerialughese.

-- | 202610041700

-- vuota dal 26/10/2026: ricreava una vista copiandola dal base, e la copia restava indietro quando il canone andava
-- avanti; le viste vivono solo nei file base e ai deploy arrivano con le migrazioni del canone ( 300.database.md )

-- | 202610041701

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041702

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041703

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041704

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041705

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041706

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041707

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041708

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041709

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | 202610041710

-- vuota dal 26/10/2026: rifaceva la statica dalla copia di attivita_view e articoli_view di questa patch, che il
-- canone ha superato; una costruzione da zero ha gia' statiche e viste dal base ( 300.database.md )

-- | FINE

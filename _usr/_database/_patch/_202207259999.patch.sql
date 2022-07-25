--
-- PATCH
--

--| 202207250010
ALTER TABLE contratti
ADD COLUMN   `note_cliente` text DEFAULT NULL AFTER  `note`; 

--| FINE
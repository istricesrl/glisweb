--
-- PATCH
-- 

--| 202206200010
ALTER TABLE `anagrafica_indirizzi` 
  CHANGE `id_indirizzo` `id_indirizzo` int(11) DEFAULT NULL,
  ADD COLUMN`indirizzo` char(255) DEFAULT NULL AFTER `interno`;

--| 202206200020
CREATE OR REPLACE VIEW anagrafica_indirizzi_view AS
	SELECT
		anagrafica_indirizzi.id,
		anagrafica_indirizzi.id_anagrafica,
		anagrafica_indirizzi.id_indirizzo,
		IF( anagrafica_indirizzi.id_indirizzo IS NOT NULL , concat(indirizzi.indirizzo,' ',comuni.nome,' ',provincie.sigla), anagrafica_indirizzi.indirizzo) AS indirizzo,
		anagrafica_indirizzi.id_ruolo,
		ruoli_indirizzi.nome AS ruolo,
		anagrafica_indirizzi.id_account_inserimento,
		anagrafica_indirizzi.id_account_aggiornamento,
		IF( anagrafica_indirizzi.id_indirizzo IS NOT NULL ,
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			tipologie_indirizzi.nome,
			' ',
			indirizzi.indirizzo,
			' ',
			indirizzi.civico,
			' ',
			comuni.nome,
			' ',
			provincie.sigla
		),
		concat(
			coalesce( anagrafica.denominazione , concat( anagrafica.cognome, ' ', anagrafica.nome ), '' ),
			' / ',
			tipologie_indirizzi.nome,
			' ',
			anagrafica_indirizzi.indirizzo
		) )AS __label__
	FROM anagrafica_indirizzi
		INNER JOIN anagrafica ON anagrafica.id = anagrafica_indirizzi.id_anagrafica
		LEFT JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo
		LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
		LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia
		LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
		LEFT JOIN provincie ON provincie.id = comuni.id_provincia
;

--| FINE
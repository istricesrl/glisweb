-- 2026-11-11 — test: l'entità bersaglio dei test automatici, nella forma canonica
--
-- Schema canonico, punto 6, riga 242, decisione di Fabio del 11/11/2026 ( opzione A ): test resta nel canone come
-- l'entità su cui scrivono i test del framework ( importCest, _test.import.sh, gli esempi di controller() ).
--
-- Cosa fa: la KEY codice diventa la UNIQUE unica ( il codice e' unico, come negli altri oggetti ), aggiunge la KEY
-- indice, ricrea la vista con la coda di audit.
--
-- Cosa NON fa: non tocca i dati ( la tabella e' vuota su tutti i DB letti l'11/11 ) ne' le FK; non crea la tabella dove
-- manca ( crmfia produzione, lughese_macchine: punto 12 ).
--
-- IDEMPOTENTE.

-- | 202611111700

-- test: codice unico, indice
ALTER TABLE `test`
	DROP INDEX IF EXISTS `codice`,
	DROP INDEX IF EXISTS `unica`,
	DROP INDEX IF EXISTS `indice`,
	ADD UNIQUE KEY `unica` (`codice`),
	ADD KEY `indice` (`id`,`codice`,`nome`);

-- | 202611111701

-- test_view
CREATE OR REPLACE VIEW `test_view` AS
	SELECT
		test.id,
		test.codice,
		test.nome,
		test.id_account_inserimento,
		test.id_account_aggiornamento,
		concat_ws( ' ', test.codice, test.nome ) AS __label__
	FROM test
;

-- | FINE

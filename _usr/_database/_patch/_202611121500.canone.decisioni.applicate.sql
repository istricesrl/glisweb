-- 2026-11-12 — tre decisioni del punto 6 che i file base non avevano ancora
--
-- Schema canonico, punto 7b, decisione di Fabio del 12/11/2026 ( opzione A ): l'inventario dei fuori canone ha trovato
-- tre oggetti decisi al punto 6 e mai entrati nei file base, che canone-vivo segnalava quindi "in piu'" su ogni deploy:
-- - zone_provincie e zone_provincie_view ( P9 e P80, 13/10/2026: canone, gemella di zone_stati );
-- - pagamenti.id_genitore, CASCADE sulla stessa tabella ( riga 152, 23/10/2026: rate, catture, differenze cambio );
-- - le FK di nascita di anagrafica, anagrafica_ibfk_05_nofollow ( id_stato_nascita ) e _06_nofollow ( id_comune_nascita ),
--   SET NULL ( riga 6, 05/10/2026 ).
--
-- Cosa fa: crea zone_provincie con chiavi e FK dove non c'e' ( dove c'e' ha gia' questa forma ) e la sua vista; aggiunge
-- id_genitore a pagamenti con la sua KEY ( polmasi ha gia' la colonna ).
--
-- Cosa NON fa ( punto 12 ): le FK, che sui DB esistenti trovano orfani e nomi diversi. pagamenti_ibfk_15_nofollow: polmasi
-- ha 42 id_genitore orfani su 42 in dev e 3 in prod. Le FK di nascita: bernispa, crmfia e polmasi le hanno gia' coi nomi
-- del canone, gimbe e lughese coi nomi _04_nofollow_x ( stato ) e _05_nofollow ( comune ), gli altri non le hanno; polmasi
-- dev ha 6 comuni di nascita orfani ( misura del 12/11/2026 ). Nemmeno pagamenti_view espone id_genitore, perche' su
-- polmasi pagamenti_view_static si riempie per posizione dalla vista: la colonna arriva nella vista quando la statica
-- entra nel canone con la sua corte ( 6i ). Il riordino delle colonne resta al punto 12.
--
-- IDEMPOTENTE.

-- | 202611121500

-- zone_provincie
CREATE TABLE IF NOT EXISTS `zone_provincie` (
	`id` bigint(20) NOT NULL AUTO_INCREMENT,
	`ordine` int(11) DEFAULT NULL,
	`id_zona` bigint(20) DEFAULT NULL,
	`id_provincia` bigint(20) DEFAULT NULL,
	`id_account_inserimento` bigint(20) DEFAULT NULL,
	`timestamp_inserimento` int(11) DEFAULT NULL,
	`id_account_aggiornamento` bigint(20) DEFAULT NULL,
	`timestamp_aggiornamento` int(11) DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `unica` (`id_zona`,`id_provincia`),
	KEY `ordine` (`ordine`),
	KEY `id_provincia` (`id_provincia`),
	KEY `id_account_inserimento` (`id_account_inserimento`),
	KEY `id_account_aggiornamento` (`id_account_aggiornamento`),
	KEY `indice` (`id`,`ordine`,`id_zona`,`id_provincia`),
	CONSTRAINT `zone_provincie_ibfk_01` FOREIGN KEY (`id_zona`) REFERENCES `zone` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `zone_provincie_ibfk_02_nofollow` FOREIGN KEY (`id_provincia`) REFERENCES `provincie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT `zone_provincie_ibfk_98_nofollow` FOREIGN KEY (`id_account_inserimento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
	CONSTRAINT `zone_provincie_ibfk_99_nofollow` FOREIGN KEY (`id_account_aggiornamento`) REFERENCES `account` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- | 202611121501

-- zone_provincie_view
CREATE OR REPLACE VIEW zone_provincie_view AS
	SELECT
		zone_provincie.id,
		zone_provincie.ordine,
		zone_provincie.id_zona,
		zone_path( zone_provincie.id_zona ) AS zona,
		zone_provincie.id_provincia,
		provincie.nome AS provincia,
		zone_provincie.id_account_inserimento,
		zone_provincie.id_account_aggiornamento,
		concat( provincie.nome, ' - ', zone_path( zone_provincie.id_zona ) ) AS __label__
	FROM zone_provincie
		LEFT JOIN provincie ON provincie.id = zone_provincie.id_provincia
;

-- | 202611121502

-- pagamenti: id_genitore
ALTER TABLE `pagamenti`
	ADD COLUMN IF NOT EXISTS `id_genitore` bigint(20) DEFAULT NULL AFTER `id`,
	ADD INDEX IF NOT EXISTS `id_genitore` (`id_genitore`);

-- | FINE FILE

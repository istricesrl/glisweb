-- 2026-10-05 — tipologia di pubblicazione anteprima e gruppo anteprima
--
-- Richiesta di Fabio del 05/10/2026: una pagina che non e' ancora pubblicata ( o che lo sara' solo da una certa data )
-- deve potersi far vedere a chi la deve controllare, senza pubblicarla per tutti. Una pubblicazione di tipologia
-- anteprima la fa caricare dai loader dei moduli ( _310.pages.php ), ma aggiungiPubblicazione() la riserva al gruppo
-- anteprima e ai roots, la toglie dalla sitemap e dalla cache e le mette il noindex. Se la pagina ha anche una
-- pubblicazione vera attiva, l'anteprima non conta.
--
-- La tipologia prende l'id 4 se e' libero, altrimenti il primo dopo il massimo: i deploy che hanno gia' aggiunto
-- tipologie loro non si vedono sovrascrivere niente. Il gruppo si riconosce dal nome, che in gruppi e' unico.
--
-- IDEMPOTENTE.

-- | 202610051200

ALTER TABLE `tipologie_pubblicazioni`
	ADD COLUMN IF NOT EXISTS `se_anteprima` tinyint(1) DEFAULT NULL AFTER `se_evidenza`;

-- | 202610051201

INSERT INTO `tipologie_pubblicazioni` ( `id`, `nome`, `se_anteprima` )
	SELECT if( max( id = 4 ), max( id ) + 1, 4 ), 'anteprima', 1 FROM `tipologie_pubblicazioni`
	HAVING coalesce( max( nome = 'anteprima' ), 0 ) = 0;

-- | 202610051202

INSERT IGNORE INTO `gruppi` ( `nome` ) VALUES ( 'anteprima' );

-- | FINE

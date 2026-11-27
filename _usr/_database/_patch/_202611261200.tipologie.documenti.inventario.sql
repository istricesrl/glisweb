-- 2026-11-26 — tipologie_documenti: missione di inventario ( id 39, sotto la missione )
--
-- Il modulo Modula di bernispa manda al magazzino verticale ordini di inventario ( ORD_TIPOOP I ): l'operatore conta
-- i pezzi di ogni riga e l'esito diventa una rettifica fra il mastro del Modula e la sua contropartita. L'ordine nasce
-- da un documento di una tipologia sua, figlia della missione come quelle di prelievo ( 35 ) e di movimentazione ( 36 ),
-- creato a mano dal form dei documenti o dal task settimanale dei mini inventari ( Fabio, 26/11/2026 ). La tabella e'
-- canonica ( patch 202611091500 ): stessi id su tutti i deploy, quindi la riga entra nello standard e non nel solo
-- database di bernispa. L'id 39 e' il primo libero, misurato sui database di bernispa ( DEV, www2, connor ).
--
-- Cosa fa: inserisce la riga 39 MISSIONE_DI_INVENTARIO con id_genitore 34.
--
-- Cosa NON fa: non tocca le righe esistenti.
--
-- IDEMPOTENTE: INSERT IGNORE.

-- | 202611261200

-- tipologie_documenti
INSERT IGNORE INTO `tipologie_documenti` (`id`, `id_genitore`, `ordine`, `codice`, `codice_sdi`, `nome`, `sigla`, `html_entity`, `font_awesome`, `se_fattura`, `se_nota_credito`, `se_nota_debito`, `se_pro_forma`, `se_offerta`, `se_ordine`, `se_missione`, `se_ricevuta`, `se_trasporto`, `se_ecommerce`, `numerazione`, `stampa_pdf`) VALUES
	(39, 34, NULL, 'MISSIONE_DI_INVENTARIO', NULL, 'missione di inventario', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- | FINE FILE

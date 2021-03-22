CREATE OR REPLACE VIEW `__report_volontari_pratiche__` AS
SELECT anagrafica.denominazione AS sede,anagrafica_view.__label__ as volontario, anagrafica_view.categorie AS categoria, COUNT(pratiche_avvocati.id) as pratiche, SUM(if(pratiche_avvocati.se_responsabile = 1 AND pratiche_avvocati.id, 1, 0)) AS 'pratiche di cui è responsabile',SUM(if(pratiche.data_chiusura IS NULL AND pratiche.id, 1, 0)) AS 'pratiche aperte', SUM(if(pratiche.data_chiusura IS NOT NULL AND pratiche.id, 1, 0)) AS 'pratiche chiuse', COUNT(pratiche_old.id) AS 'pratiche aperte prima del 2019', COUNT(pratiche_2019.id) AS 'pratiche aperte nel 2019',
COUNT(pratiche_2020.id) AS 'pratiche aperte nel 2020', COUNT(pratiche_2021.id) AS 'pratiche aperte nel 2021'
FROM anagrafica_view
LEFT JOIN __acl_anagrafica__ ON anagrafica_view.id = __acl_anagrafica__.id_entita
LEFT JOIN gruppi ON gruppi.id = __acl_anagrafica__.id_gruppo
LEFT JOIN anagrafica_ruoli ON gruppi.id_struttura = anagrafica_ruoli.id
LEFT JOIN anagrafica ON anagrafica.id = anagrafica_ruoli.id_anagrafica
LEFT JOIN pratiche_avvocati ON pratiche_avvocati.id_anagrafica = anagrafica_view.id
LEFT JOIN pratiche ON pratiche.id = pratiche_avvocati.id_pratica
LEFT JOIN pratiche AS pratiche_old ON pratiche_old.id = pratiche_avvocati.id_pratica AND YEAR(pratiche_old.data_apertura) < 2019
LEFT JOIN pratiche AS pratiche_2019 ON pratiche_2019.id = pratiche_avvocati.id_pratica AND YEAR(pratiche_2019.data_apertura) = 2019
LEFT JOIN pratiche AS pratiche_2020 ON pratiche_2020.id = pratiche_avvocati.id_pratica AND YEAR(pratiche_2020.data_apertura) = 2020
LEFT JOIN pratiche AS pratiche_2021 ON pratiche_2021.id = pratiche_avvocati.id_pratica AND YEAR(pratiche_2021.data_apertura) = 2021
WHERE anagrafica_view.se_collaboratore = 1
GROUP BY anagrafica_view.id
ORDER BY anagrafica.denominazione, anagrafica_view.__label__;
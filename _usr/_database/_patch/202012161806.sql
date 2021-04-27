CREATE OR REPLACE VIEW anagrafica_indirizzi_view AS
  SELECT anagrafica_indirizzi.*,
    anagrafica_view.__label__ AS anagrafica,
    indirizzi_view.__label__ AS indirizzo,
    anagrafica_indirizzi.descrizione AS __label__
  FROM anagrafica_indirizzi
  INNER JOIN anagrafica_view ON anagrafica_view.id = anagrafica_indirizzi.id_anagrafica
  INNER JOIN indirizzi_view ON indirizzi_view.id = anagrafica_indirizzi.id_indirizzo
;
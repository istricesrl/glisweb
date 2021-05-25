#!/usr/bin/env python3

import random
from random import randint
import mysql.connector

db = mysql.connector.connect( host = "127.0.0.1", database = "glisweb", user = "root", password = "io1Phokoc1ra.qu2", auth_plugin='mysql_native_password' )

cur = db.cursor()
result = ""
n = 3

if db.is_connected():

  print( "Connection true" )

else:

  print("Connection false")

NOMI=( "" "Mario", "Giovanna" ,"Luca" ,"Andrea" ,"Rossana" ,"Carla" ,"Francesco" ,"Alessandro" ,"Annalisa", "Giacomo" ,"Sara" )
COGNOMI=( "Bianchi", "Rossi", "Verdi", "Marroni","Gialli", "Arancioni", "Neri" ,"Turchesi", "Azzurri", "Violetti" )
DENOMINAZIONI=( "ACME", "Alfa", "Beta", "Gamma" ,"Delta", "Lambda" ,"Kappa" ,"Epsilon", "Omicron", "Sigma", "Tau" )
TIPOLOGIE=( "spa", "snc", "sas" ,"srl", "ONLUS" )
DOMINI=( "bogus", "bogon" ,"noob", "null", "no" ,"whatever" )
ESTENSIONI=( "bho", "tux" ,"nop" ,"clue" ,"clue" ,"wtf" )

CATEGORIE=( "1", "2" ,"3" ,"4" ,"5" ,"6" )
TIPOLOGIETELEFONI=( "1" ,"2", "3" ,"4" )

def popola_db(tabella, val):

  cur.execute(tabella,val)

  db.commit()

def create_anagrafiche():

  tblAnag = ( "INSERT into anagrafica (nome, cognome) values (%s, %s)" )

  telefono = []

  telefono.append( random.randint(6, 9) )

  n = 10
  numero = ''.join(str(randint(0,9))for num in range(0,n))
  print (numero)

  for i in range(n):

    nome=random.choice(NOMI)

    cognome=random.choice(COGNOMI)

    val = (nome ,cognome )

    popola_db(tblAnag, val)

    id = cur.lastrowid

    indirizzo =  nome+cognome+"@"+random.choice(DOMINI)+"." + random.choice(ESTENSIONI)

    tblEmail=("INSERT into mail (id_anagrafica, indirizzo) values (%s, %s)")

    valmail = (id, indirizzo)

    popola_db(tblEmail, valmail)

    tblCategorie =("INSERT into anagrafica_categorie (id_anagrafica, id_categoria) values (%s, %s)")

    valcat = (id, random.choice(CATEGORIE))

    popola_db(tblCategorie, valcat)

    # tblTipoTel=("INSERT into tipologie_telefoni (nome, html) values (%s,%s)")

    # valtiptel=(random.choice(DENOMINAZIONI), "html")

    # popola_db(tblTipoTel,valtiptel)

    # idTipo = cur.lastrowid
    idTipo = random.choice(TIPOLOGIETELEFONI)

    tblTel =("INSERT into telefoni (id_anagrafica, id_tipologia, numero ) values (%s, %s, %s)")

    valtel = (id , idTipo, numero)

    popola_db(tblTel, valtel)

create_anagrafiche()

db.close()

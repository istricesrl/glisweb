#!/usr/bin/env python3

import random
from random import randint
import mysql.connector

# CONNESSIONE AL DB

localhost = input("entrare l'host : ")
datab = input("entrare il database da carricare : ") 
utente = input("entrare il nome utente : ")
pssw = input("entrare la password MySQL : ") 

# pssw_auth_plugin = input("entrare la password auth plugin : ") , auth_plugin='mysql_native_password' 

db = mysql.connector.connect( host = localhost, database = datab, user = utente, password = pssw )

cur = db.cursor()

result = ""

if db.is_connected():

  print( "Connection true \°/ " )

else:

  print("Connection false")

#IMPOSTAZIONE NUMERO DI CICLI : 

volte = int(input("entrare il numeri di righe da carricare nell'anagrafiche : "))

NOMI=( "" "Mario", "Giovanna" ,"Luca" ,"Andrea" ,"Rossana" ,"Carla" ,"Francesco" ,"Alessandro" ,"Annalisa", "Giacomo" ,"Sara" )
COGNOMI=( "Bianchi", "Rossi", "Verdi", "Marroni","Gialli", "Arancioni", "Neri" ,"Turchesi", "Azzurri", "Violetti" )
DENOMINAZIONI=( "ACME", "Alfa", "Beta", "Gamma" ,"Delta", "Lambda" ,"Kappa" ,"Epsilon", "Omicron", "Sigma", "Tau" )
TIPOLOGIE=( "spa", "snc", "sas" ,"srl", "ONLUS" )
DOMINI=( "bogus", "bogon" ,"noob", "null", "no" ,"whatever" )
ESTENSIONI=( "bho", "tux" ,"nop" ,"clue" ,"clue" ,"wtf" )
PRODOTTI=( "vestito", "elettrodomestico", "informatico", "mobile" )

# usare id e categorie già presente in db : last row id? cur.lastrowid
# tolto tipologia telefono e telefono per mancanza dei dati standard

CATEGORIE=( "1", "2" ,"3" ,"4" ,"5" ,"6" )
TIPOLOGIETELEFONI=( "1" ,"2", "3" ,"4" )


table = int(input("\t------ MENU ------\n per caricare anagrafiche digita 1 : \n per caricare prodotti digita 2 : \n per caricare tutte digita 3 : \n -- "))

def popola_db(tabella, val):

  cur.execute(tabella,val)

  db.commit()

def create_anagrafiche():

  tblAnag = ( "INSERT into anagrafica (nome, cognome) values (%s, %s)" )

  telefono = []

  telefono.append( random.randint(6, 9) )

  n = 10
  numero = ''.join(str(randint(0,9))for num in range(0,n))

  for i in range(volte):

    nome=random.choice(NOMI)

    cognome=random.choice(COGNOMI)

    val = (nome ,cognome )

    popola_db(tblAnag, val)
    
    id = cur.lastrowid

    indirizzo =  nome + cognome + "@" + random.choice(DOMINI) + "." + random.choice(ESTENSIONI)

    tblEmail=("INSERT into mail (id_anagrafica, indirizzo) values (%s, %s)")

    valmail = (id, indirizzo)

    popola_db(tblEmail, valmail)

    tblCategorie =("INSERT into anagrafica_categorie (id_anagrafica, id_categoria) values (%s, %s)")

    valcat = (id, random.choice(CATEGORIE))

    popola_db(tblCategorie, valcat)
    
    idTipo = random.choice(TIPOLOGIETELEFONI)

    tblTel =("INSERT into telefoni (id_anagrafica, id_tipologia, numero ) values (%s, %s, %s)")

    valtel = (id , idTipo, numero)

    popola_db(tblTel, valtel)

def crea_prodotti():

  incremento = 0
  
  for i in range(volte):
        
    if incremento == 0 :
          
      incremento += 1
      
      idp = ( (random.choice(ESTENSIONI)) + (random.choice(CATEGORIE)*4) + str(incremento) )

    else : 
      
      incremento = cur.lastrowid

      
      idp = ( (random.choice(ESTENSIONI)) + (random.choice(CATEGORIE)*4) + str(incremento) )
      
    tipo = 1

    tblProd = ( "INSERT into prodotti (id, id_tipologia, nome, descrizione ) values ( %s, %s, %s, %s)" )

    valprod = ( idp, tipo, random.choice(PRODOTTI), random.choice(DENOMINAZIONI) )

    popola_db(tblProd,valprod)
    

if table == 1 : 

  create_anagrafiche()

if table == 2 : 

   crea_prodotti()

if table == 3 : 

  create_anagrafiche()

  crea_prodotti()

if table == 0 : 

  print( "Operazione terminata. Arriverderci." )

db.close()

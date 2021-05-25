#!/usr/bin/env python3

import random
from random import randint
import mysql.connector

# CONNESSIONE AL DB

incremento = 0

# localhost = input("entrare l'host : ")
# datab = input("entrare il database da carricare : ") 
# utente = input("entrare il nome utente : ")
# pssw = input("entrare la password MySQL : ") 

# pssw_auth_plugin = input("entrare la password auth plugin : ") , auth_plugin='mysql_native_password' 

db = mysql.connector.connect( host = "127.0.0.1", database = "glisweb", user = "root", password = "new-password" )

#db = mysql.connector.connect( host = localhost, database = datab, user = utente, password = pssw )

cur = db.cursor()

result = ""

if db.is_connected():

  print( "Connection true \°/ " )

else:

  print("Connection false")

NOMI=( "" "Mario", "Giovanna" ,"Luca" ,"Andrea" ,"Rossana" ,"Carla" ,"Francesco" ,"Alessandro" ,"Annalisa", "Giacomo" ,"Sara" )
COGNOMI=( "Bianchi", "Rossi", "Verdi", "Marroni","Gialli", "Arancioni", "Neri" ,"Turchesi", "Azzurri", "Violetti" )
DENOMINAZIONI=( "ACME", "Alfa", "Beta", "Gamma" ,"Delta", "Lambda" ,"Kappa" ,"Epsilon", "Omicron", "Sigma", "Tau" )
TIPOLOGIE=( "spa", "snc", "sas" ,"srl", "ONLUS" )
DOMINI=( "bogus", "bogon" ,"noob", "null", "no" ,"whatever" )
ESTENSIONI=( "bho", "tux" ,"nop" ,"clue" ,"clue" ,"wtf" )
PRODOTTI=( "vestito", "elettrodomestico", "informatico", "mobile" )

CATEGORIE=( "1", "2" ,"3" ,"4" ,"5" ,"6" )
TIPOLOGIETELEFONI=( "1" ,"2", "3" ,"4" )

def popola_db(tabella, val):
      
  cur.execute(tabella,val)

  db.commit()
  
def create_anagrafiche(volte):

  tblAnag = ( "INSERT into anagrafica (nome, cognome) values (%s, %s)" )
  
  tblEmail=("INSERT into mail (id_anagrafica, indirizzo) values (%s, %s)")
  
  tblCategorie =("INSERT into anagrafica_categorie (id_anagrafica, id_categoria) values (%s, %s)")
  
  tblTel =("INSERT into telefoni (id_anagrafica, id_tipologia, numero ) values (%s, %s, %s)")

  telefono = []

  for i in range(volte):
        
    #creazione dati random
        
    telefono.append( random.randint(6, 9) )

    numero = ''.join(str(randint(0,9))for num in range(0,10))

    nome=random.choice(NOMI)

    cognome=random.choice(COGNOMI)

    val = (nome ,cognome )

    #chiamata alla funzione per il commit 
    
    popola_db(tblAnag, val)
    
    #ricerca con il cursor dell'id dell'ultima riga inserita con il caricamento dell'anagrafica
    
    id = cur.lastrowid

    indirizzo =  nome + cognome + "@" + random.choice(DOMINI) + "." + random.choice(ESTENSIONI)

    valmail = (id, indirizzo)

    popola_db(tblEmail, valmail)

    valcat = (id, random.choice(CATEGORIE))

    popola_db(tblCategorie, valcat)
    
    idTipo = random.choice(TIPOLOGIETELEFONI)

    valtel = (id , idTipo, numero)

    popola_db(tblTel, valtel)  

def crea_prodotti(volte):
      
  tblProd = ( "INSERT into prodotti (id, id_tipologia, nome, descrizione ) values ( %s, %s, %s, %s)" )
  
  for i in range(volte):
        
    #PRODUZIONE ID NON RIPETUTO CON CARATTERI SPECIALI
        
    idp= ''.join( [chr(random.randint(0,64)) for i in range(0,7)] )
      
    tipo = 1

    valprod = (idp, tipo, random.choice(PRODOTTI), random.choice(DENOMINAZIONI) )

    popola_db(tblProd,valprod)
    
# ESECUZIONE SCELTA 

while(True): 
    
  table = int(input("\t------ MENU ------\nper caricare anagrafiche digita 1 \nper caricare prodotti digita 2 \nper caricare tutte digita 3 \n-->> "))
  
#IMPOSTAZIONE NUMERO DI CICLI : 

  volte = int(input("entrare il numeri di righe da caricare nel database / entrare 0 per uscire : "))

  if volte >= 1 :

      if table == 1 : 

        create_anagrafiche(volte)

      if table == 2 : 

        crea_prodotti(volte)

      if table == 3 : 

        create_anagrafiche(volte)

        crea_prodotti(volte)

  else : 

    print( "Operazione terminata. Arriverderci." )

    break

db.close()

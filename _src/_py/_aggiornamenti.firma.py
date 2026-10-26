#!/usr/bin/env python3
# -*- coding: utf-8 -*-

##  \file _aggiornamenti.firma.py
#   \brief firma degli aggiornamenti distribuiti da /api/aggiornamenti ( _src/_api/_aggiornamenti.php )
#
#   Un software esterno al deploy ( p.es. il GlisWeb Agent sul PC di un cliente ) si aggiorna da solo
#   scaricando il file pubblicato in var/spool/aggiornamenti/<sorgente>/, ma lo installa solo se la firma
#   Ed25519 di "<sorgente>\n<versione>\n<sha256>" torna con la chiave pubblica che porta con se'. Questo
#   script fa le due cose che servono a chi pubblica:
#
#   - **chiavi**: genera la coppia di chiavi. La privata resta sul PC di chi pubblica e **non va mai sul
#     server**, ne' in un repository: e' l'unica cosa che impedisce a chi riuscisse a scrivere sul deploy
#     di installare un suo programma sui PC dei clienti. La pubblica si copia nel sorgente del software
#     prima di compilarlo;
#   - **firma**: prepara la cartella da copiare in var/spool/aggiornamenti/<sorgente>/, col file e il
#     manifest.json che l'endpoint serve;
#   - **verifica**: rifa' il controllo che fara' il software, prima di pubblicare.
#
#   Richiede la libreria cryptography ( pip install cryptography ).
#
#   \code
#   _src/_py/_aggiornamenti.firma.py chiavi ~/chiavi/glisweb-agent
#   _src/_py/_aggiornamenti.firma.py firma ~/chiavi/glisweb-agent/privata.pem glisweb-agent 0.1.8 dist/agent18.exe --file agent.exe --uscita pubblica/
#   _src/_py/_aggiornamenti.firma.py verifica pubblica/ glisweb-agent <chiave pubblica in base64>
#   \endcode

import argparse
import base64
import hashlib
import json
import os
import shutil
import sys

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey, Ed25519PublicKey


def messaggio(sorgente, versione, sha256):
    """il testo firmato: lega il file alla sorgente e alla versione, cosi' una firma non vale per un altro software"""
    return f'{sorgente}\n{versione}\n{sha256}'.encode('utf-8')


def chiavi(args):
    os.makedirs(args.cartella, exist_ok=True)
    privata = os.path.join(args.cartella, 'privata.pem')
    if os.path.exists(privata):
        sys.exit(f'{privata} esiste gia\': non la sovrascrivo, i software in giro si fidano di quella')
    chiave = Ed25519PrivateKey.generate()
    with open(os.open(privata, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), 'wb') as f:
        f.write(chiave.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption()))
    pubblica = base64.b64encode(chiave.public_key().public_bytes(serialization.Encoding.Raw, serialization.PublicFormat.Raw)).decode('ascii')
    print(f'chiave privata in {privata} ( non va mai sul server )')
    print(f'chiave pubblica, da copiare nel sorgente del software: {pubblica}')


def firma(args):
    with open(args.privata, 'rb') as f:
        chiave = serialization.load_pem_private_key(f.read(), password=None, backend=default_backend())
    with open(args.eseguibile, 'rb') as f:
        sha256 = hashlib.sha256(f.read()).hexdigest()
    nome = args.file or os.path.basename(args.eseguibile)
    os.makedirs(args.uscita, exist_ok=True)
    shutil.copyfile(args.eseguibile, os.path.join(args.uscita, nome))
    manifest = {
        'versione': args.versione,
        'file': nome,
        'sha256': sha256,
        'firma': base64.b64encode(chiave.sign(messaggio(args.sorgente, args.versione, sha256))).decode('ascii'),
    }
    with open(os.path.join(args.uscita, 'manifest.json'), 'w') as f:
        json.dump(manifest, f, indent=4)
        f.write('\n')
    print(f'pronto in {args.uscita}: {nome} e manifest.json, da copiare in var/spool/aggiornamenti/{args.sorgente}/')
    print('copiare PRIMA il file e POI il manifest, cosi\' il manifest nuovo non punta mai a un file a meta\'')


def verifica(args):
    with open(os.path.join(args.cartella, 'manifest.json')) as f:
        manifest = json.load(f)
    with open(os.path.join(args.cartella, manifest['file']), 'rb') as f:
        sha256 = hashlib.sha256(f.read()).hexdigest()
    if sha256 != manifest['sha256']:
        sys.exit('KO: il file non corrisponde all\'hash del manifest')
    try:
        Ed25519PublicKey.from_public_bytes(base64.b64decode(args.pubblica)).verify(base64.b64decode(manifest['firma']), messaggio(args.sorgente, manifest['versione'], sha256))
    except Exception:
        sys.exit('KO: la firma non torna con questa chiave pubblica')
    print(f'OK: {manifest["file"]} versione {manifest["versione"]} firmato correttamente per {args.sorgente}')


parser = argparse.ArgumentParser(description='firma degli aggiornamenti per /api/aggiornamenti')
comandi = parser.add_subparsers(dest='comando', required=True)

p = comandi.add_parser('chiavi', help='genera la coppia di chiavi')
p.add_argument('cartella', help='dove scrivere privata.pem, sul PC di chi pubblica')
p.set_defaults(funzione=chiavi)

p = comandi.add_parser('firma', help='prepara file e manifest.json da pubblicare')
p.add_argument('privata', help='il file privata.pem')
p.add_argument('sorgente', help='il nome della sorgente, come in debug.log.remoti.sorgenti')
p.add_argument('versione', help='la versione del file, p.es. 0.1.8')
p.add_argument('eseguibile', help='il file da pubblicare')
p.add_argument('--file', help='il nome con cui pubblicarlo ( default: quello del file )')
p.add_argument('--uscita', default='pubblica', help='la cartella da preparare ( default: pubblica )')
p.set_defaults(funzione=firma)

p = comandi.add_parser('verifica', help='rifa\' il controllo del software')
p.add_argument('cartella', help='la cartella con file e manifest.json')
p.add_argument('sorgente', help='il nome della sorgente')
p.add_argument('pubblica', help='la chiave pubblica in base64')
p.set_defaults(funzione=verifica)

args = parser.parse_args()
args.funzione(args)

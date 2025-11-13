#!/bin/bash

HOST=${1:-127.0.0.1}
PORT=${2:-11211}

echo "Connessione a memcached su $HOST:$PORT..."

# ottiene la lista degli slab in uso
SLABS=$(echo -e "stats items\nquit" | nc $HOST $PORT | \
        grep "items:" | awk -F: '{print $2}' | sort -u)

if [ -z "$SLABS" ]; then
    echo "Nessuno slab trovato o memcached non accessibile."
    exit 1
fi

echo "Slab trovati: $SLABS"
echo

# per ogni slab estraiamo le chiavi
for slab in $SLABS; do
    echo "Dump slab $slab:"
    # usa limite alto per cercare di pescare tutte le chiavi
    echo -e "stats cachedump $slab 50000\nquit" | nc $HOST $PORT | \
        grep "ITEM " | awk '{print $2}'
    echo
done

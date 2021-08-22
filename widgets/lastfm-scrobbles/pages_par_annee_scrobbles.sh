#!/bin/bash
# télécharge tous les fichiers de scrobbles depuis $1
# les années 2007 à 2020 incluse sont complètes
#
# le format des fichiers est :
# [
# [ ...page 1... ]
# ,
# [ ...page 2... ]
# ...
# [ ...dernière page]
# ]
#
# je charge les paramètres d'authentification
# USER et API_KEY
source private_api_key
#
annee=$1
anneefin=$2
while [ $annee -le $anneefin ]; do
    FILE=$HOME/.config/awesome/widgets/lastfm-scrobbles/donnees/scrobbles_${annee}.json
    #
    madatedebut=${annee}"0101"
    ((annee++))
    madatefin=${annee}"0101"
    tsdebut=$(date -d ${madatedebut} +%s)
    tsfin=$(date -d ${madatefin} +%s)
    #
    # nombre de pages à télécharger
    tp=$(curl -s "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${USER}&api_key=${API_KEY}&page=1&from=${tsdebut}&to=${tsfin}&limit=200&format=json" | jq -r '.recenttracks."@attr".totalPages')
    #
    # on encapsule l'ensemble des listes de pages récupérées pour
    # l'année dans une liste globale (JSON valide)
    echo "[" > $FILE
    i=1
    while [ $i -le $tp ]; do
        curl -s "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${USER}&api_key=${API_KEY}&page=1&from=${tsdebut}&to=${tsfin}&limit=200&page=${i}&format=json" | jq -r '.recenttracks.track' >> $FILE
        # on insère une séparation "," entre les différentes
        # listes récupérées
        if [ $i -ne $tp ]; then
            echo "," >> $FILE
        fi
        ((i++))
    done
    echo "]" >> $FILE
done

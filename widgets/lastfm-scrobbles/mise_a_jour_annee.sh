!/bin/bash
# david cobac
# 2021
#
annee=$1
FILE=/tmp/recup_lastfm_pas_aplati.json
WIDGET_DIR=$HOME/.config/awesome/widgets/lastfm-scrobbles
# je charge les paramètres d'authentification
# USER et API_KEY
cd $WIDGET_DIR
source private_api_key
#
if [ -f $FILE ]; then
    rm -f $FILE
fi
#
# ouverture json existant et lecture de la dernière date
ts=$(cat donnees/${annee}.json|jq -r "[.[].date.uts][0]")
# dans le cas d'un "now playing", il n'y a pas de timestamp !
if [ $ts == "null" ]; then
    ts=$(cat donnees/${annee}.json|jq -r "[.[].date.uts][1]")
fi
#
# requête avec from :
# nombre de pages à télécharger
tp=$(curl -s "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${USER}&api_key=${API_KEY}&page=1&from=${ts}&limit=200&format=json" | jq -r '.recenttracks."@attr".totalPages')
#
echo "[" > $FILE
i=1
while [ $i -le $tp ]; do
        curl -s "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${USER}&api_key=${API_KEY}&page=1&from=${ts}&limit=200&page=${i}&format=json" | jq -r '.recenttracks.track' >> $FILE
        # on insère une séparation "," entre les différentes
        # listes récupérées
        if [ $i -ne $tp ]; then
            echo "," >> $FILE
        fi
        ((i++))
done
echo "]" >> $FILE
#
# on aplatit et on fusionne les json ancien et nouveau
python3 aplatissement_fichier_json.py ${annee} ${WIDGET_DIR}
# on bouge l'ensemble
mv /tmp/recup_lastfm_aplati_${annee}.json donnees/${annee}.json
rm -f /tmp/recup_lastfm_pas_aplati.json
#
echo $USER

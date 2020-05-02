#!/usr/bin/env python3
import sys
import requests
import random

# récupération des arguments commme mots-clés de recherche
if len(sys.argv) > 1:
    theme = " ".join(sys.argv[1:])
else:
    theme = "earth"

url = "https://images-api.nasa.gov"
recherche = "/search?"

# paramètres de la recherche
# voir API https://images.nasa.gov/docs/images.nasa.gov_api_docs.pdf
parametres = {"q": theme,
              "media_type": "image",
              "year_start": 2010,
              "year_end": 2020}

reponse = requests.get(url + recherche, params=parametres)
reponse = reponse.json()

# parfois aucun résultat récent
# en fait... mauvaise idée : parfois trop peu d'images
# donc on boucle sur les mêmes
# autant mettre une année de départ lointaine genre 2010
while reponse['collection']['metadata']['total_hits'] == 0:
    parametres["year_start"] -= 1
    reponse = requests.get(url + recherche, params=parametres)
    reponse = reponse.json()

# on choisit au hasard dans les réponses obtenues
# 100 réponses par page -> on cherche la bonne page
N = reponse['collection']['metadata']['total_hits']
n = random.randint(1, N)

if n >= 100:
    numero_page, n = divmod(n, 100)
    parametres['page'] = numero_page

reponse = requests.get(url + recherche, params=parametres)
reponse = reponse.json()

# on récupère le lien vers le fichier type "thumb"
# on remplace thumb par orig pour l'image original
lien = reponse['collection']['items'][n-1]['links'][0]['href']
lien = lien.replace("thumb", "orig")

# on met l'image dans le fichier fond sans extension
# awesome se débrouille après
with open("/home/david/.config/awesome/fondEspace/fond", "wb") as fh:
    f = requests.get(lien)
    fh.write(f.content)

with open("/home/david/.config/awesome/fondEspace/fondDescription", "w") as fh:
    fh.write(reponse['collection']['items'][2]['data'][0]['title'])
    fh.write("\n")
    fh.write(reponse['collection']['items'][n-1]['data'][0]['description'])

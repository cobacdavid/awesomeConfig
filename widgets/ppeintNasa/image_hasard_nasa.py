#!/usr/bin/env python3
import sys
import requests
import random
import datetime
import os


def analyse_reponse(r, f_log, lien=""):
    heure = datetime.datetime.now().strftime("%H:%M:%S")
    with open(f_log, "a+") as fh:
        fh.write(heure + '\t')
        fh.write(theme + '\t')
        fh.write(r.url + '\t')
        fh.write(str(r.status_code) + '\t')
        fh.write(r.reason + '\t')
        if r.status_code != 200:
            fh.write('\n')
            sys.exit()
        else:
            fh.write(lien + "\n")


# récupération des arguments commme mots-clés de recherche
if len(sys.argv) > 1:
    theme = " ".join(sys.argv[1:])
else:
    theme = "jupiter"

myhome = os.environ['HOME']
fichier_log = "image_hasard_nasa.log"

url = "https://images-api.nasa.gov"
recherche = "/search?"

# paramètres de la recherche
# voir API https://images.nasa.gov/docs/images.nasa.gov_api_docs.pdf
parametres = {"q": theme,
              "media_type": "image",
              "year_start": 2000}

reponse = requests.get(url + recherche, params=parametres)
analyse_reponse(reponse, fichier_log)
reponseJ = reponse.json()

# attention même s'il y a BEAUCOUP de réponses,
# le site n'affiche que 100 pages de réponses au max
# donc 100 x 100 = 10 000 réponses au max
N = reponseJ['collection']['metadata']['total_hits']
N = min(10_000, N)

n = random.randrange(N)
numero_page, n = divmod(n, 100)
parametres['page'] = numero_page + 1

if numero_page != 0:
    reponse = requests.get(url + recherche, params=parametres)
    analyse_reponse(reponse, fichier_log)
    reponseJ = reponse.json()

# on récupère le lien vers le fichier type "thumb"
# on remplace thumb par orig pour l'image original
# ou large plus susceptible d'être accessible que orig
lien = reponseJ['collection']['items'][n]['links'][0]['href']
lien = lien.replace("thumb", "large")

# on met l'image dans le fichier fond sans extension
# awesome se débrouille après
with open(myhome + "/.config/awesome/widgets/ppeintNasa/fond", "wb") as fh:
    f = requests.get(lien)
    analyse_reponse(f, fichier_log, lien=lien)
    fh.write(f.content)

# écriture de la description
with open(myhome + "/.config/awesome/widgets/ppeintNasa/fondDescription",
          "w") as fh:
    fh.write(reponseJ['collection']['items'][n]['data'][0]['title'])
    fh.write("\n")
    fh.write(reponseJ['collection']['items'][n]['data'][0]['description'])

#
import json
import sys
import os

annee = sys.argv[1]
rep = sys.argv[2]

fichier_a_traiter = "/tmp/recup_lastfm_pas_aplati.json"
fichier_sauvegarde = f"/tmp/recup_lastfm_aplati_{annee}.json"
fichier_definitif = f"{rep}/donnees/{annee}.json"

with open(fichier_a_traiter) as fh, \
     open(fichier_sauvegarde, "w") as fi, \
     open(fichier_definitif) as fj:
    contenu_nouveau = json.load(fh)
    # TODO: on doit tester s'il existe un fichier définitif !!
    contenu_ancien = json.load(fj)
    liste_aplatie_nouveau = [v for page in contenu_nouveau for v in page]
    # TODO: on n'ajoute rien si contenu_ancien n'existe pas
    liste_aplatie_nouveau += contenu_ancien
    json.dump(liste_aplatie_nouveau, fi)

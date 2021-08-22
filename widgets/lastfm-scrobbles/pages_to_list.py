# cet utilitaire prend les fichiers scrobbles_YYYY.json
# contenant une liste de listes et les aplatit
import json
import sys


for annee in range(int(sys.argv[1]), int(sys.argv[2])+1):
    print(annee, end=" ")
    fichier_a_traiter = f"donnees/scrobbles_{annee}.json"
    fichier_sauvegarde = f"donnees/{annee}.json"

    try:
        with open(fichier_a_traiter) as fh, open(fichier_sauvegarde, "w") as fi:
            contenu = json.load(fh)
            liste_aplatie = [v for page in contenu for v in page]
            print(len(liste_aplatie))
            json.dump(liste_aplatie, fi)
    except:
        print("echec")

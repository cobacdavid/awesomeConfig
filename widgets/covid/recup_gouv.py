# david cobac
# 2021
# script de récupération totale des informations officielles
import requests
import pandas as pd
from pathlib import Path
from io import StringIO


DIR = Path.home().joinpath(".config", "awesome", "widgets", "covid")
URL = "https://www.data.gouv.fr/fr/datasets/r/5c4e1452-3850-4b59-b11c-3dd51d7fb8b5"

indicateurs = {
    "hosp": "total hospitalisés", # OK
    "incid_hosp": "nouveaux hospitalisés", # OK
    "rea": "total réanimation", # OK
    "incid_rea": "nouveaux réanimation", # OK
    "rad": "total guéris", # OK
    "incid_rad": "nouveaux guéris", # OK
    "dchosp": "total décès hôpital", # OK
    "incid_dchosp": "nouveaux décès hôpital", # OK
    # "esms_dc": "total décès ehpad",
    # "dc_tot": "total décès",
    # "conf": "total cas",
    # "conf_j1": "nouveaux cas",
    "pos": "cas positifis -1", # OK
    "pos_7j": "cas positifs -7", # OK
    # "esms_cas": "cas esms",
    "tx_pos": "taux + test", # OK
    "tx_incid": "taux incidence", # OK
    "TO": "taux occupation", # OK
    "R": "évolution du R0" # OK
}

contenu = requests.get(URL).text

df = pd.read_csv(StringIO(contenu))
mel = df[df['dep'] == "49"]
mel.index = mel["date"]

for cle in indicateurs:
    mel[cle].to_csv(f"{DIR}/donnees/{cle}",
                    header=False,
                    sep=" ",
                    na_rep="-1")

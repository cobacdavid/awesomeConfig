import sys
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import pandas as pd


rep_maison = "/home/david/tmp/"
rep_asus = "/home/david/temp/"


if len(sys.argv) <= 1:
    print("Usage: script.py ordinateur (maison ou asus)")
    quit()
elif sys.argv[1] == "maison":
    rep = rep_maison
else:
    rep = rep_asus

# les données
df = pd.read_csv(rep + "logBatterie",
                 delimiter=" ",
                 header=None,
                 names=["heure", "niveau"],
                 parse_dates=["heure"])

plt.style.use("dark_background")
fig, ax = plt.subplots()

# tracé temporel
X = mdates.date2num(df['heure'])
plt.plot(X, df['niveau'])

# formatage de l'axe temporel
fmt = mdates.DateFormatter('%Y-%m-%d %H:%M:%S')
ax.xaxis.set_major_formatter(fmt)
ax.xaxis_date()
fig.autofmt_xdate()
plt.savefig(rep + "logBatterie.png")

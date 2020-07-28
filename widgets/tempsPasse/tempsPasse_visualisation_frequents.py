#################################################
# author: David Cobac
# twitter: @david_cobac
# github: https://github.com/cobacdavid
# date: 2020
# copyright: CC-BY-NC-SA
#################################################
import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import sys
# import locale


# locale.setlocale(locale.LC_ALL, 'fr_FR.UTF-8')
#
myhome = os.environ['HOME']
rep_desktop = myhome + "/.config/awesome/widgets/"
rep_laptop = myhome + "/temp/"
#
if len(sys.argv) <= 1 or \
   (sys.argv[1] != "desktop" and sys.argv[1] != "laptop"):
    print("Usage: script.py ordinateur (desktop ou laptop)")
    quit()
elif sys.argv[1] == "desktop":
    rep = rep_desktop
else:
    rep = rep_laptop
#
# les données
df = pd.read_csv(rep + "logFenetreTempsPasse",
                 delimiter=",",
                 header=None,
                 names=["date", "class", "time"],
                 parse_dates=["date"])

# suppression des doublons
print(f"Suppression de {df.duplicated().sum()} doublons")
df.drop_duplicates()

# réunion des "dates" en dates d'une même journée
df['date'] = pd.to_datetime(df['date'].dt.strftime('%Y%m%d'))
# notre tableau à double-entrée
s = df.groupby(['date', 'class'])['time'].sum()
# application d'un seuil
# s[s > 3600] = 3600
s = s[s > 60 * 60]
# on remet sous la forme d'un dataframe pour le tracé
df = s.unstack('date', fill_value=0)

plt.style.use("dark_background")
fig, ax = plt.subplots()

# couleur spéciale pour 0 : le noir
mes_couleurs = cm.get_cmap('cool')
mes_couleurs.set_under('black')

# le tracé
trace = plt.imshow(df, cmap=mes_couleurs, interpolation='none', vmin=0.1)

# formatage axe des dates
dates = df.columns.to_pydatetime()
dates = [d.strftime("%d %b") for d in dates]
plt.xticks(range(len(dates)), labels=dates, rotation=90)
# formatage axe des applications
plt.yticks(range(df.shape[0]), labels=df.index)

# customisation de la colorbar
cbar_ticks = range(0, 60 * 60 * 24+1, 60 * 60 +1)
cbar_labels = [f'{i}' for i in range(25)] #['0', '1/4 h', '1/2 h', '3/4 h', '>1 h']
cbar = plt.colorbar(trace, ticks=cbar_ticks)
cbar.ax.set_yticklabels(cbar_labels)

# sauvegarde
plt.savefig("tempsPasse.jpg", bbox_inches='tight', dpi=300)
# plt.show()

#################################################
# author: David Cobac
# twitter: @david_cobac
# github: https://github.com/cobacdavid
# date: 2020
# copyright: CC-BY-NC-SA
#################################################

import pandas as pd
import matplotlib.pyplot as plt
import sys
import locale
locale.setlocale(locale.LC_ALL, 'fr_FR.UTF-8')

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
df = pd.read_csv(rep + "logFenetre",
                 delimiter=",",
                 header=None,
                 names=["date", "class", "time"],
                 parse_dates=["date"])

df['date'] = pd.to_datetime(df['date'].dt.strftime('%Y%m%d'))
s = df.groupby(['date', 'class'])['time'].sum()
s[s > 3600] = 3600
df = s.unstack('date', fill_value=0)
#print(df.columns)
#quit()

# plt.style.use("seaborn")
fig, ax = plt.subplots()

# trace = sns.heatmap(df, cmap='binary', linewidths=.5)
trace = plt.imshow(df, cmap='binary', interpolation='none')

dates = df.columns.to_pydatetime()
dates = [d.strftime("%d %b") for d in dates]
plt.xticks(range(len(dates)), labels=dates, rotation=90)
plt.yticks(range(df.shape[0]), labels=df.index)

cbar_ticks = range(0, 60*60 + 1, 15 * 60)
cbar_labels = ['0', '1/4 h', '1/2 h', '3/4 h', '>1 h']
cbar = plt.colorbar(trace, ticks=cbar_ticks)
cbar.ax.set_yticklabels(cbar_labels)

plt.show()

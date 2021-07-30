FILE=$HOME/.config/awesome/widgets/fichiers/sortie_commande.csv
# on détruit le précédent
# à améliorer ! on devrait prendre la dernière ligne, lisre la date
# la supprimer et recommencer à cette date
if [ -f $FILE ] then;
   d=$(tail -1 sortie_commande.csv |cut -d, -f1)
else
    d=$1
fi
#
fin==$(date -I -d "$2 + 1 day")
# https://stackoverflow.com/questions/28226229/how-to-loop-through-dates-using-bash#28226303
while [ $d != $fin ]; do
    jour_suivant=$(date -I -d "$d + 1 day")
    nb=$(find ~/travail/david/production/lycee -type f -newermt $d ! -newermt $jour_suivant | wc -l)
    echo "$d,$nb" >> $FILE
    d=$jour_suivant
done

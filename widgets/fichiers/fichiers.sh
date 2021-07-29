FILE=$HOME/.config/awesome/widgets/fichiers/sortie_commande.csv
# on détruit le précédent
# à améliorer ! on devrait prendre la dernière ligne, lisre la date
# la supprimer et recommencer à cette date
rm $FILE 2>/dev/null
d=$1
# https://stackoverflow.com/questions/28226229/how-to-loop-through-dates-using-bash#28226303
while [ $d != $2 ]; do
    jour_suivant=$(date -I -d "$d + 1 day")
    nb=$(find ~/travail/david/production/lycee -type f -newermt $d ! -newermt $jour_suivant | wc -l)
    echo "$d,$nb" >> $FILE
    d=$jour_suivant
done

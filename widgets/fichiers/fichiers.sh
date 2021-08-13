# $1 from $2 to $3 path
# $1 et $2 en format YYYYMMDD
#
CHEMIN=$(echo $3 | sed 's/\///g')
FILE=$HOME/.config/awesome/widgets/fichiers/sortie_commande_${CHEMIN}.csv
# on prend la dernière ligne, on lit la date
# on supprime cette ligne et on recommence à cette date
if [ -f $FILE ]; then
    d=$(tail -1 $FILE |cut -d " " -f1)
    # on supprime la dernière ligne du fichier
    sed -i '$ d' $FILE
else
    d=$1
fi
#
fin=$(date -d "$2 + 1 day" +%Y%m%d)
# https://stackoverflow.com/questions/28226229/how-to-loop-through-dates-using-bash#28226303
while [ $d != $fin ]; do
    jour_suivant=$(date -d "$d + 1 day" +%Y%m%d)
    nb=$(find $3 -type f -newermt $d ! -newermt $jour_suivant | wc -l)
    echo "$d $nb" >> $FILE
    d=$jour_suivant
done
#
# return name of the file
echo $FILE

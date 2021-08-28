CHEMIN=/home/david/Polar/$1/U/0
EXE=$HOME/github/polar/polar_dailysummary2txt
DEBUT=$(date +%Y%m%d)
FIN=20201014

cd $CHEMIN
jour=$DEBUT
while [ $jour != $FIN ]; do
    if [ -d ${jour} ]; then
        if [ ! -f ${jour}/DSUM/${jour}.txt ]; then
            $EXE ${CHEMIN}/${jour}/DSUM  ${CHEMIN}/${jour}/DSUM/${jour}.txt 1>/dev/null
        fi
        if [ -f ${jour}/DSUM/${jour}.txt ]; then
            echo $jour\ $(cat ${jour}/DSUM/${jour}.txt |grep "Training\s*calories" |cut -d : -f2 |xargs |cut -d " " -f1)
        fi
    fi
    jour=$(date -d "$jour - 1 day" +%Y%m%d)
done

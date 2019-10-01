PARAM_FILE=/var/project/param.txt
INDEX_FILE=/var/www/html/index.html
echo "Cours AZURE AZ300" > $PARAM_FILE
echo "<br>" >>  $PARAM_FILE
date >> $PARAM_FILE
echo "<br>" >>  $PARAM_FILE
hostname -i >> $PARAM_FILE
echo "<br>" >> $PARAM_FILE
cat $PARAM_FILE > $INDEX_FILE

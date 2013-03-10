#!/bin/bash

#Motion stoppen
echo
echo "Service Motion wird gestoppt..."
echo
service motion stop

#Webcam Snapshot für Github erstellen
echo
echo "Snapshot erstellen"
echo
fswebcam -c /root/.fswebcam.conf /home/pi/webcam.jpg

#Format fuer Datum einstellen:
echo "Datumsformat setzen"
echo
DATUM=`date +%m.%d.%y-%H.%M`
echo
echo $DATUM
echo
#Backups anlegen:
echo "Backup als .tar wird gestartet..."
tar cfv /srv/server/video0/backup_$DATUM.tar /srv/motion/video0

#Alte Backups loeschen:
echo "Backups, älter als 14 Tage werden gelöscht..."
find /srv/motion/video0 -mtime +14 -exec rm {} \;

#Backups komprimieren
#echo "Backups werden als gzip komprimiert..."
#for file in /srv/server/video0/*.tar
#do
#    gzip -9 "$file"
#done

#Motion Verzeichnis leeren
echo "Motion Verzeichnis wird geleert..."
rm -f /srv/motion/video0/*.jpg
rm -f /srv/motion/video0/*.avi

#Webcam Snapshot zu Github  hochladen
GITPROJECT="webcam"
cp /home/pi/webcam.jpg /srv/git/$GITPROJECT/
cd /srv/git/$GITPROJECT/
git add .
git commit -a -m $DATUM
git push origin


#Motion starten
echo "Motion wird wieder gestartet..."
service motion start
/srv/python-yahoo-weather/weather2motion.sh

echo "Alles fertig!"


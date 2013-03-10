#!/bin/bash

#Motion stoppen
echo "Service Motion wird gestoppt..."

service motion stop

#Format fuer Datum einstellen:
echo "Datumsformat setzen"
DATUM=`date +%m.%d.%y-%H.%M`
echo $DATUM
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

#Webcam Snapshot für Github erstellen und hochladen
DATE=`date`
GITPROJECT="shamanix"
fswebcam -r 960x720 -d /dev/video0 /home/pi/webcam.jpg
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


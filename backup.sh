#!/bin/sh

# configuration de l'utilisateur MySQL et de son mot de passe
DB_USER="root"
DB_PASS="Nm3ZaMg64"
# configuration de la machine hébergeant le serveur MySQL
DB_HOST="localhost"

# sous-chemin de destination
OUTDIR=`date +%Y-%m-%d/%H:%M:%S`
# création de l'arborescence
mkdir -p /var/archives/$OUTDIR
# récupération de la liste des bases
DATABASES=`MYSQL_PWD=$DB_PASS mysql -u $DB_USER -e "SHOW DATABASES;" | tr -d "| " | grep -v -e Database -e _schema -e mysql`
# boucle sur les bases pour les dumper
for DB_NAME in $DATABASES; do
    MYSQL_PWD=$DB_PASS mysqldump -u $DB_USER --single-transaction --skip-lock-tables $DB_NAME -h $DB_HOST > /backup/backup.sql
done
# boucle sur les bases pour compresser les fichiers
for DB_NAME in $DATABASES; do
    gzip /backup/backup.sql
done

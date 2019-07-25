#!/bin/bash

mv /data/sftp_user/upload/GrantNE01/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019_et.txt"
/home/centos/parallel41/daily-et/bin/reference-et "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019_et.txt" "40.793,-101.624" "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019.txt"

mv /data/sftp_user/upload/MeadNE01/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019_et.txt"
/home/centos/parallel41/daily-et/bin/reference-et "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019_et.txt" "41.165,-96.477" "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019.txt"

mv /data/sftp_user/upload/MeadNE02/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019_et.txt"
/home/centos/parallel41/daily-et/bin/reference-et "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019_et.txt" "41.165,-96.47" "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019.txt"

mv /data/sftp_user/upload/MeadNE03/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019_et.txt"
/home/centos/parallel41/daily-et/bin/reference-et "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019_et.txt" "41.18,-96.44" "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019.txt"

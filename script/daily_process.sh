#!/bin/bash

mv /data/sftp_user/upload/GrantNE01/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019.txt"

mv /data/sftp_user/upload/MeadNE01/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 01/2019.txt"

mv /data/sftp_user/upload/MeadNE02/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 02/2019.txt"

mv /data/sftp_user/upload/MeadNE03/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Mead NE 03/2019.txt"

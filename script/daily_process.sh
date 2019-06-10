#!/bin/bash

mv /data/sftp_user/upload/*.txt "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019"
/home/centos/parallel41/daily-et/bin/daily-et 2019 "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019" > "/var/www/parallel41.nebraska.edu/dist/static/data/Grant NE 01/2019.txt"

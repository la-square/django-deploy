#!/bin/bash


#####
# Postgres: wait until container is created
#####

set -e
python3 /tmp/database-check.py > /dev/null 2>&1
while [[ $? != 0 ]] ; do
    sleep 5; echo "*** Waiting for postgres container ..."
    python3 /tmp/database-check.py > /dev/null 2>&1
done
set +e


#####
# Django setup
#####

if [ "$PRODUCTION" == "true" ]; then
    echo "==> Django setup, executing: migrate"
    python3 /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/manage.py migrate --fake-initial
    echo "==> Django setup, executing: collectstatic"
    python3 /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/manage.py collectstatic --noinput -v 3
else
    echo "==> Django setup, executing: flush"
    python3 /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/manage.py flush --noinput
    echo "==> Django setup, executing: migrate"
    python3 /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/manage.py migrate --fake-initial
    echo "==> Django setup, executing: collectstatic"
    python3 /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/manage.py collectstatic --noinput -v 3
fi


#####
# Start uWSGI
#####

echo "==> Starting uWSGI ..."
/usr/local/bin/uwsgi --emperor /etc/uwsgi/django-uwsgi.ini

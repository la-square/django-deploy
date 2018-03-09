FROM python:3.6

ARG DJANGO_PROJECT_NAME

RUN useradd -d /home/hotdog -s /bin/hotdog -m hotdog
ADD ./djapp /home/hotdog/${DJANGO_PROJECT_NAME}/djapp

ADD ./config/requirements.txt /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/
RUN pip3 install -r /home/hotdog/${DJANGO_PROJECT_NAME}/djapp/requirements.txt


ADD ./config/start.sh /tmp
ADD ./config/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini
ADD ./config/database-check.py /tmp/database-check.py


RUN chown -R hotdog:hotdog /home/hotdog
CMD ["/tmp/start.sh"]

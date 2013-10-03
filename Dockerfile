FROM ubuntu:12.04
MAINTAINER Maciej Pasternacki <maciej@3ofcoins.net>

# Basic system preparation
RUN apt-get update --yes && apt-get upgrade --yes
RUN apt-get install --yes python-software-properties lsb-release
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu `lsb_release -sc` main universe multiverse"
RUN apt-get update --yes
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

# Prerequisites
RUN apt-get install --yes \
    python2.7 python2.7-dev postgresql-9.1 libpq-dev wget ca-certificates runit openssh-server

# Virtualenv
RUN cd /tmp && \
    wget https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.10.1.tar.gz && \
    echo '3a04aa2b32c76c83725ed4d9918e362e  virtualenv-1.10.1.tar.gz' | md5sum -c -
RUN tar -C /tmp -xzf /tmp/virtualenv-1.10.1.tar.gz
RUN python2.7 /tmp/virtualenv-1.10.1/virtualenv.py /opt/sentry

# Installation of Sentry
RUN /opt/sentry/bin/pip install 'sentry[postgresql]' psycopg2
RUN useradd --comment sentry --user-group --no-create-home sentry

# Add this services directory
ADD service /service.tmpl
ADD start /start

EXPOSE 2222
EXPOSE 9000
VOLUME /service
CMD "/start"

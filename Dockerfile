# -*- conf -*- 
FROM ubuntu:14.04
MAINTAINER Maciej Pasternacki <maciej@3ofcoins.net>

# Prerequisites
RUN set -e -x ; \
    apt-get update --yes ; \
    apt-get install --yes python2.7 python2.7-dev python-virtualenv postgresql-client \
                          libpq-dev libxslt1-dev libxml2-dev libz-dev libffi-dev libssl-dev \
                          ca-certificates runit ; \
    useradd --system --comment sentry --user-group --create-home sentry ; \
    install -d -o sentry -g sentry -m 0750 /var/opt/sentry /var/opt/sentry/files ; \
    /usr/bin/virtualenv /opt/sentry ; \
    /opt/sentry/bin/pip install 'sentry[postgres]==7.4.3' ; \
    /opt/sentry/bin/pip freeze | tee /opt/sentry/requirements-freeze.txt ; \
    dpkg -l | awk '$2 ~ /-dev$/ { print $2 }' | xargs apt-get purge --yes cpp gcc binutils manpages ; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/*

# Add this services directory
ADD env_remote_user_middleware.py /opt/sentry/local/lib/python2.7/site-packages/
ADD settings.py /etc/sentry/settings.py
ADD sentry /sentry

VOLUME /var/opt/sentry
EXPOSE 9000
ENTRYPOINT [ "/sentry" ]
CMD [ "start", "--noupgrade" ]

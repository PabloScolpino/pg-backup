ARG PG_VERSION=13
FROM postgres:${PG_VERSION}

RUN apt-get update --quiet --assume-yes && \
    apt-get install --quiet --assume-yes --no-install-recommends \
      bash \
      openssl \
      python3-pip \
    && \
    pip3 install b2

WORKDIR /app
COPY backup.sh /app/backup.sh

RUN chmod +x /app/backup.sh

CMD ["/app/backup.sh"]

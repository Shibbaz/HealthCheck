FROM postgres:15.0
COPY init.sql /docker-entrypoint-initdb.d/
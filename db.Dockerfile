FROM postgres:15.0
ARG POSTGRES_USERNAME
ARG POSTGRES_PASSWORD

COPY init.sql .
RUN sed -i "s/POSTGRES_USERNAME/$POSTGRES_USERNAME/g" init.sql
RUN sed -i "s/POSTGRES_PASSWORD/$POSTGRES_PASSWORD/g" init.sql
RUN echo < init.sql
COPY init.sql /docker-entrypoint-initdb.d/

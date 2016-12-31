FROM traefik:v1.1.0-alpine

ADD conf/traefik.toml /etc/traefik/traefik.toml
ADD run.sh /run.sh

RUN chmod +x /run.sh

CMD /run.sh

FROM traefik:1.7.1-alpine

ADD conf/traefik.toml /etc/traefik/traefik.toml
ADD conf/public_https.crt /etc/traefik/ssl_certs/public_https.crt
ADD conf/ca.crt /etc/traefik/ssl_certs/ca.crt
ADD run.sh /run.sh

RUN chmod +x /run.sh

CMD /run.sh

traefik-fn61
============

tl;dr: your Docker Swarm -based services are discovered and loadbalanced automatically.

[Traefik](https://traefik.io/) configured for needs of function61.com:

- Service discovery via Docker Swarm - multi-host overlay networking.
- Explicit `traefik.enable=true` required, i.e. whitelist instead of blacklist - we're not animals here.
- Default frontends are `public_http` and `public_https`. If you have company-internal services (like
  monitoring via [Prometheus](https://prometheus.io/)), create that service with `-l traefik.frontend.entryPoints=backoffice`
  to have it not exposed publicly, but via the backoffice entrypoint (https+basic auth in port 9001).


Running
-------

Docker socket must be mounted at `/run/docker.sock`.
Run command looks somewhat like this:

```
$ docker service create --name traefik-fn61 \
	--network your-network \
	--mount type=bind,src=/run/docker.sock,dst=/run/docker.sock \
	-p 80:80 \
	-p 443:443 \
	-p 9001:9001 \
	-e 'BACKOFFICE_USERS=[\"user:PASSWORD_IN_HTPASSWD_FORMAT\"]' \
	-e 'SSL_CERT_PRIVATE_KEY=...' \
	fn61/traefik-fn61
```

NOTE: current limitation is that you have to run Traefik on the same node as as a Swarm manager.


SSL cert
--------

```
$ openssl req -x509 -newkey rsa:4096 -keyout public_https.key -out conf/public_https.crt -days 3650 -nodes -subj /CN=localhost'

# provide output of this via ENV SSL_CERT_PRIVATE_KEY when running this image
$ cat public_https.key | base64 --wrap=0 && rm public_https.key
```

Self-signed certs only work because we're being fronted by Cloudflare. Certs facing public users anchor to trusted CAs.

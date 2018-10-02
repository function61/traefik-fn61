[![Build Status](https://travis-ci.org/function61/traefik-fn61.svg?branch=master)](https://travis-ci.org/function61/traefik-fn61)
[![Download](https://img.shields.io/docker/pulls/fn61/traefik-fn61.svg)](https://hub.docker.com/r/fn61/traefik-fn61/)

traefik-fn61
============

TL;DR: Docker Swarm -based services are discovered and loadbalanced automatically by Traefik.

DISCLAIMER: This is only a sample configuration to produce an image for our needs - you cannot just directly
use this and expect it to work for you. You need to at least replace the SSL certs and your own private key.

[Traefik](https://traefik.io/) configured for needs of function61.com:

- Service discovery via Docker Swarm - multi-host overlay networking.
- Explicit `traefik.enable=true` required, i.e. whitelist instead of blacklist - we're not animals here.
- Default frontends are `public_http` and `public_https`. If you have company-internal services (like
  monitoring via [Prometheus](https://prometheus.io/)), create that service with `-l traefik.frontend.entryPoints=backoffice`
  to have it not exposed publicly, but via the backoffice entrypoint (https+client cert auth in port 9001).


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
	-e 'SSL_CERT_PRIVATE_KEY=... public_https.key base64-encoded ...' \
	fn61/traefik-fn61
```

NOTE: current limitation is that you have to run Traefik on the same node as as a Swarm manager.


SSL config
----------

These three files live in Traefik's configuration:

- ca.crt
- public_https.crt
- public_https.key (secret - injected via ENV variable at container startup)

```
+------------------+
|                  |
| ca.crt (root CA) |
| (self-signed)    |
|                  |
+--------------+---+
               |
               |      +--------------------+
               |      |                    |
               +------+ Server cert:       |
               |      | - public_https.crt |
               |      | - public_https.key |
               |      |                    |
               |      +--------------------+
               |
               |      +---------------------------------+
               |      |                                 |
               +------+  Client certs                   |
                      |  - authentication to backoffice |
                      |                                 |
                      +---------------------------------+
```

Port `443` is backed by `public_https` certificate. It is self-signed and thus not accepted
by general web users, but that is okay because we're fronted by Cloudflare which serves its
own SSL cert to users, and their cert is backed by publicly recognized CAs.

Port `9001` is backed by the same `public_https` certificate, but with attached to different
frontend, "backoffice". Backoffice is for company-internal services that require authentication.
Authentication is implemented via client certs that must anchor to `ca.crt`.

SSL cert setup is documented [here](https://github.com/function61/certificate-authority).

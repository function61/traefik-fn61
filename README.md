traefik-fn61
============

[Traefik](https://traefik.io/) configured for needs of function61.com:

- Service discovery via Docker swarm - multi-host overlay networking
- Explicit `traefik.enable=true` required, i.e. whitelist instead of blacklist - we're not animals here
- Traefik UI visible via hostname traefikstats.dev-laptop.xs.fi

Running
-------

Docker socket must be mounted at `/run/docker.sock`.

TODO: document `$ docker service create`


SSL cert
--------

```
$ openssl req -x509 -newkey rsa:4096 -keyout public_https.key -out conf/public_https.crt -days 3650 -nodes -subj '/CN=localhost'
$ cat public_https.key | base64 --wrap=0 && rm public_https.key
```

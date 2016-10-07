traefik-fn61
============

[Traefik](https://traefik.io/) configured for needs of function61.com:

- Discovery via Consul
- Require tag `traefik.tags=traefik` so services advertised in Traefik must be whitelisted instead of blacklisted
- Traefik UI visible via hostname traefikstats.dev-laptop.xs.fi
- Consul UI visible via hostname consul.dev-laptop.xs.fi

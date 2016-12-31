#!/bin/sh -eu

BACKOFFICE_USERS="$BACKOFFICE_USERS"

# http://stackoverflow.com/a/2705678
BACKOFFICE_USERS_ESCAPED=$(echo -n "$BACKOFFICE_USERS" | sed -e 's/[\/&]/\\&/g')

sed -i "s/#BACKOFFICE_USERS/$BACKOFFICE_USERS_ESCAPED/" /etc/traefik/traefik.toml

exec traefik

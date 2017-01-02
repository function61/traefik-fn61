#!/bin/sh -eu

configure_ssl_cert_private_key() {
	SSL_CERT_PRIVATE_KEY_DECODED=$(echo -n "$SSL_CERT_PRIVATE_KEY" | base64 -d)

	echo "$SSL_CERT_PRIVATE_KEY_DECODED"

	echo -n "$SSL_CERT_PRIVATE_KEY_DECODED" > /etc/traefik/ssl_certs/public_https.key
}

replace_backoffice_users() {
	# http://aspirine.org/htpasswd_en.html
	# looks like ["user1:$apr1$PuimP4wl$KaLTApRBsyBxA1GJa5z8u0", "user2:$apr1$PuimP4wl$KaLTApRBsyBxA1GJa5z8u0"]
	BACKOFFICE_USERS="$BACKOFFICE_USERS"

	# http://stackoverflow.com/a/2705678
	BACKOFFICE_USERS_ESCAPED=$(echo -n "$BACKOFFICE_USERS" | sed -e 's/[\/&]/\\&/g')

	sed -i "s/#BACKOFFICE_USERS/$BACKOFFICE_USERS_ESCAPED/" /etc/traefik/traefik.toml
}

start_traefik() {
	exec traefik
}

configure_ssl_cert_private_key
replace_backoffice_users
start_traefik

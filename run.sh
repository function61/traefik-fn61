#!/bin/sh -eu

configure_ssl_cert_private_key() {
	SSL_CERT_PRIVATE_KEY_DECODED=$(echo -n "$SSL_CERT_PRIVATE_KEY" | base64 -d)

	echo "$SSL_CERT_PRIVATE_KEY_DECODED"

	echo -n "$SSL_CERT_PRIVATE_KEY_DECODED" > /etc/traefik/ssl_certs/public_https.key
}

start_traefik() {
	exec traefik
}

configure_ssl_cert_private_key
start_traefik

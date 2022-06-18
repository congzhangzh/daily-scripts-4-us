#!/usr/bin/env bash
your_domain=xxx.xxx.xxx
letsencryptsudo certbot --renew-by-default certonly -d ${your_domain} --agree-tos --manual --preferred-challenges dns

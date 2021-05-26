#!/bin/bash

set -e

CERTIFICADO=$(openssl x509 -noout -subject -in /etc/httpd/certs/site.crt | awk -F= '{print $NF}' | sed -e 's/^[ \t]*//')
VARIABLE_OBTENIDA="$SERVERNAME"

if [ ! -f /var/log/httpd/modsec_audit.log ]; then
touch /var/log/httpd/modsec_audit.log
fi

if [ ! -f /var/log/httpd/modsec_debug.log ]; then
touch /var/log/httpd/modsec_debug.log
fi

if [ -z "$SERVERNAME" ]; then
echo "···································································································"
echo "VARIABLE SERVERNAME NO SETEADA - ERROR"
echo "···································································································"
    exit 1
fi

if [ -z "$PROXY_IP" ]; then
echo "···································································································"
echo "VARIABLE PROXY_IP NO SETEADA - ERROR"
echo "···································································································"
    exit 1
fi

if [ -z "$PROXY_PORT" ]; then
echo "···································································································"
echo "VARIABLE PROXY_PORT NO SETEADA - ERROR"
echo "···································································································"
    exit 1
fi

if [ -z "$MODSECURITY_STATUS" ]; then
echo "···································································································"
echo "VARIABLE MODSECURITY_STATUS NO SETEADA - ERROR"
echo "···································································································"
    exit 1
fi

if [ -z "$PROTOCOL_PROXY" ]; then
echo "···································································································"
echo "VARIABLE PROTOCOL_PROXY NO SETEADA - ERROR"
echo "···································································································"
    exit 1
fi

if [ "$VARIABLE_OBTENIDA" == "$CERTIFICADO" ]; then
echo "··························································································"
echo "CERTIFICADO GENERADO PARA EL SERVERNAME YA EXISTE"
echo "··························································································"
else
echo "··························································································"
echo "GENERANDO CERTIFICADO PARA EL SERVERNAME INGRESADO"
echo "··························································································"
openssl req -x509 -sha256 -newkey rsa:4060 -keyout /etc/httpd/certs/site.key -out /etc/httpd/certs/site.crt -days 1024 -nodes -subj "/C=UY/ST=UY/L=UY/O=WAF/OU=WAF/CN=$SERVERNAME" &> /dev/null
echo "··························································································"
echo "CERTIFICADO GENERADO, EL ACCESO AL SITIO ES https://$SERVERNAME:8443"
echo "8443 ES EL PUERTO POR DEFECTO. SI UTILIZA UN MAPEO DE PUERTOS, CAMBIELO POR EL ELEGIDO."
echo "··························································································"
fi
rm -rf /var/run/httpd/*
exec "$@"

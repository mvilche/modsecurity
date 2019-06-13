# PROYECTO APACHE PROXY REVERSE + WAF MODSECURITY


#### ARQUITECTURA:

  - APACHE +  WAF MODSECURITY CORE RULE 3
  - DOCKER-COMPOSE
  - DOCKER CE


## INSTALACIÓN

Iniciar

```sh
$ docker-compose up
```

Iniciar en segundo plano

```sh
$ docker-compose up -d
```

Detener

```sh
$ docker-compose down
```

```

INSTRUCCIONES PARA AMBOS SISTEMAS OPERATIVOS:

#### DEFINICION DE VARIABLES REQUERIDAS.
Se requiere que se definan ciertas variables para que el servicio funcione
Las mismas deben ser seteadas en Config.env

 Ejemplo:

     - PROXY_IP=192.168.1.20
     - PROXY_PORT=80
     - SERVERNAME=localhost
     - MODSECURITY_STATUS=On
     - PROTOCOL_PROXY=ajp


PROXY_IP: Ip del servidor de aplicaciones que se desea utilizar

PROXY_PORT: Puerto del servidor de aplicaciones a utilizar

SERVERNAME: Dominio por el cual se accederá al WAF

MODSECURITY_STATUS: Estado de modsecurity, los valores posibles son:

On (Activado)
DetectionOnly (Detecta ataques pero no bloquea)
Off (Desactivado)

SSL_MAP_PORT: Protocolo utilizado para la configuracion el proxy (soportados http y ajp)


AL INICIAR EL SERVICIO SE GENERA EL CERTIFICADO DE ACUERDO AL SERVERNAME INGRESADO

License
----

MARTIN VILCHE

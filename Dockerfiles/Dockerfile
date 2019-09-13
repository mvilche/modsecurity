FROM centos
LABEL PROYECTO="APACHE + MODSECURITY" AUTOR="MARTIN VILCHE"
ENV LANG=es_ES.UTF-8 \
TZ=America/Montevideo
RUN localedef -i es_ES -f UTF-8 es_ES.UTF-8 && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
yum install epel-release -y && yum update -y &&  yum install httpd mod_ssl git openssl mod_security -y
RUN mkdir /etc/httpd/certificados && \
sed -i -e "s/^Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf && \
openssl req -x509 -sha256 -newkey rsa:4060 -keyout /etc/httpd/certificados/sitio.key -out /etc/httpd/certificados/sitio.crt -days 1024 -nodes -subj "/C=UY/ST=UY/L=UY/O=WAF/OU=WAF/CN=localhost" && \
sed -ri -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' /etc/httpd/conf/httpd.conf
RUN cd /etc/httpd/ && git clone --depth=1 https://github.com/SpiderLabs/owasp-modsecurity-crs.git && \
mv owasp-modsecurity-crs modsecurity && \
mv modsecurity/crs-setup.conf.example modsecurity/crs-setup.conf && mv modsecurity/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example modsecurity/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf && \
mv modsecurity/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example modsecurity/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf && rm -rf modsecurity.d
RUN yum remove git -y && yum autoremove -y && \
rm -rf /var/cache/yum /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/mod_security.conf
WORKDIR /usr/share/httpd
COPY run.sh /usr/bin/
COPY seguridad.conf /etc/httpd/conf.d/
COPY sitio.conf /etc/httpd/conf.d/
COPY ErrorPages /var/www/html/ErrorPages
RUN touch /var/log/httpd/modsec_audit.log && usermod -aG root apache && chmod +x /usr/bin/run.sh && \
chown apache -R /etc/httpd /var/log/httpd /usr/share/httpd /var/run/httpd /var/lib/mod_security /var/www/html /usr/bin/run.sh && \
ln -sf /dev/stdout /var/log/httpd/modsec_audit.log && \
chgrp -R 0 /etc/httpd /var/log/httpd /usr/share/httpd /var/run/httpd /var/lib/mod_security /var/www/html /usr/bin/run.sh && \
chmod -R g=u /etc/httpd /var/log/httpd /usr/share/httpd /var/run/httpd /var/lib/mod_security /var/www/html /usr/bin/run.sh
EXPOSE 8080 8443
USER apache
VOLUME ["/var/log/httpd"]
ENTRYPOINT ["/usr/bin/run.sh"]
CMD ["httpd", "-D", "FOREGROUND"]
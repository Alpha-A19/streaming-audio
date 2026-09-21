FROM alpine:latest

# Instalación de paquetes (incluyendo su-exec para cambiar de usuario de forma segura)
RUN apk add --no-cache icecast nginx gettext bash su-exec

# Crear directorios de ejecución y de logs
RUN mkdir -p /run/nginx /var/log/icecast /usr/share/nginx/html

# Copia de archivos del proyecto
COPY icecast.xml /etc/icecast2/icecast.xml
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY public/ /usr/share/nginx/html/

# Asignar permisos al usuario de Icecast en Alpine
RUN chown -R icecast:icecast /var/log/icecast /etc/icecast2

EXPOSE 8080

# Script de arranque: procesa Nginx, ejecuta Icecast como usuario 'icecast' e inicia Nginx
CMD ["/bin/bash", "-c", "export PORT=${PORT:-8080} && envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && su-exec icecast icecast -c /etc/icecast2/icecast.xml & nginx -g 'daemon off;'"]

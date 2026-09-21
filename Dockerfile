FROM alpine:latest

# Instalación de paquetes necesarios
RUN apk add --no-cache icecast nginx gettext bash su-exec

# Crear directorios y ajustar permisos para el usuario icecast
RUN mkdir -p /run/nginx /var/log/icecast2 /usr/share/nginx/html && \
    chown -R icecast:icecast /var/log/icecast2 /etc/icecast2

# Copia de archivos del repositorio
COPY icecast.xml /etc/icecast2/icecast.xml
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY public/ /usr/share/nginx/html/

EXPOSE 8080

# Comando de inicio: asigna PORT si falta, sustituye la variable en Nginx,
# ejecuta Icecast como usuario 'icecast' (sin root) y arranca Nginx.
CMD ["/bin/bash", "-c", "export PORT=${PORT:-8080} && envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && su-exec icecast icecast -c /etc/icecast2/icecast.xml & nginx -g 'daemon off;'"]

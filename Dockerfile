FROM alpine:latest

RUN apk add --no-cache icecast nginx gettext bash

RUN mkdir -p /run/nginx /var/log/icecast2 /usr/share/nginx/html

COPY icecast.xml /etc/icecast2/icecast.xml
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY public/ /usr/share/nginx/html/

RUN chown -R icecast:icecast /var/log/icecast2 /etc/icecast2

EXPOSE 8080

CMD ["/bin/bash", "-c", "envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && icecast -c /etc/icecast2/icecast.xml & nginx -g 'daemon off;'"]

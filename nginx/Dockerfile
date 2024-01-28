FROM base-ubuntu

RUN true \
    && add-ppa-repo ondrej/nginx-mainline 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        nginx \
    && rm -rf /var/lib/apt/lists/* \
    && true

RUN true \
    && install -d -o app -g app -m 0755 /var/tmp/nginx \
    && find /etc/nginx -mindepth 1 -not \( \
            -name 'mime.types' -o \
            -name 'modules-available' -o \
            -name 'modules-enabled' \
        \) -exec rm -rf {} + \
    && install -d -o root -g root -m 0755 \
        /etc/nginx/conf.d \
        /etc/nginx/vhost.d \
    && true

COPY rootfs/ /

USER app
EXPOSE 8080/tcp
VOLUME [ "/var/tmp/nginx" ]

CMD [ "/usr/sbin/nginx", "-e", "stderr", "-g", "daemon off;" ]

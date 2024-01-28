FROM base-ubuntu
WORKDIR /opt/emailproxy

RUN true \
    && ct-add-ppa-repo deadsnakes/ppa F23C5A6CF475977595C89F51BA6932366A755776 \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        python3.12 \
        python3.12-venv \
    && rm -rf /var/lib/apt/lists/* \
    && true

ENV VIRTUAL_ENV="/opt/emailproxy/venv"
RUN python3.12 -m venv "${VIRTUAL_ENV}"
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

RUN install -d -o app -g app -m 0750 /data/emailproxy
COPY rootfs/ /
RUN chmod -R +x /etc/s6-overlay/scripts

USER app
ENV EMAILPROXY_CACHE_STORE="/data/emailproxy/auth.cache"
ENV EMAILPROXY_CONFIG_FILE="/etc/emailproxy.config"

VOLUME [ "/data" ]
CMD ["/etc/s6-overlay/scripts/emailproxy"]

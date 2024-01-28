FROM public.ecr.aws/ubuntu/ubuntu:22.04
ARG S6_OVERLAY_VERSION="3.1.6.2"
ENV DEBIAN_FRONTEND="noninteractive"

RUN true \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gettext-base \
        gnupg \
        lsb-release \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && true

RUN true \
    && curl -sSLfo /tmp/s6-overlay-noarch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
    && curl -sSLfo /tmp/s6-overlay-arch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$(arch).tar.xz" \
    && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz \
    && rm -f /tmp/s6-overlay-noarch.tar.xz /tmp/s6-overlay-arch.tar.xz \
    && true

COPY rootfs/ /

RUN true \
    && groupadd -g 10000 app \
    && useradd -u 10000 -g app -d /home/app -s /bin/false app \
    && chmod +x \
        /usr/local/bin/ct-add-ppa-repo \
        /usr/local/bin/ct-envsubst \
        /usr/local/bin/ct-fatal \
        /usr/local/bin/ct-log \
    && true

ENV PATH="/command:/usr/bin:/bin:/usr/local/bin"
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2"
ENV S6_LOGGING="0"
ENV S6_VERBOSITY="1"

ENTRYPOINT [ "/init" ]

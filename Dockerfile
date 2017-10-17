FROM buildpack-deps:curl

ARG DUPLICATI_URL

RUN set -ex; \
    apt-get update; \
    export BUILD_DEPS='unzip'; \
    apt-get install -y --no-install-recommends \
        ${BUILD_DEPS} \
        libmono-2.0-1 \
        ca-certificates-mono \
        libmono-microsoft-csharp4.0-cil \
        libmono-system-configuration4.0-cil \
        libmono-system-configuration-install4.0-cil \
        libmono-system-core4.0-cil \
        libmono-system-data4.0-cil \
        libmono-system-drawing4.0-cil \
        libmono-system-net4.0-cil \
        libmono-system-net-http4.0-cil \
        libmono-system-net-http-webrequest4.0-cil \
        libmono-system-numerics4.0-cil \
        libmono-system-runtime-serialization4.0-cil \
        libmono-system-servicemodel4.0a-cil \
        libmono-system-servicemodel-discovery4.0-cil \
        libmono-system-serviceprocess4.0-cil \
        libmono-system-transactions4.0-cil \
        libmono-system-web4.0-cil \
        libmono-system-web-services4.0-cil \
        libmono-system-xml4.0-cil \
        libsqlite3-0 \
        mono-runtime \
    ; \
    mkdir -p /usr/lib/duplicati; \
    cd /usr/lib/duplicati; \
    curl -sSL "$DUPLICATI_URL" > duplicati.zip; \
    unzip duplicati.zip; \
    rm duplicati.zip; \
    apt-get autoremove -y --purge ${BUILD_DEPS}

COPY root /

VOLUME /etc/duplicati
VOLUME /backups

EXPOSE 8200

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Duplicati on Docker" \
      org.label-schema.url="https://github.com/mumblepins-docker/docker-duplicati" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/mumblepins-docker/docker-duplicati" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      maintainer="Daniel Sullivan <https://github.com/mumblepins>"




CMD ["/usr/bin/duplicati-server", \
    "--webservice-port=8200", \
    "--webservice-interface=any", \
    "--server-datafolder=/etc/duplicati", \
    "--log-level=information"]



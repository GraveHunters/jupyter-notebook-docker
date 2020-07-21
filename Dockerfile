ARG REGISTRY=registry.hub.docker.com/library
ARG IMAGE=alpine
ARG VERSION=3.11.5

FROM "${REGISTRY}/${IMAGE}:${VERSION}"

ARG VERSION
ARG BUILD_DATE_TIME
ARG IMAGE_TAG
ARG PYTHON_VERSION
ARG PIP_VERSION

LABEL org.opencontainers.image.created="${BUILD_DATE_TIME}" \
  org.opencontainers.image.authors="Jonathan Batteas" \
  org.opencontainers.image.url="" \
  org.opencontainers.image.documentation="" \
  org.opencontainers.image.source="" \
  org.opencontainers.image.version="" \
  org.opencontainers.image.revision="" \
  org.opencontainers.image.vendor="The Grave Hunters Society" \
  org.opencontainers.image.licenses="" \
  org.opencontainers.image.ref.name="" \
  org.opencontainers.image.title="Extensible Jupyter Notebooks - Base Image" \
  org.opencontainers.image.description="Docker image meant to be used as a base for other images. Python 3, on Alpine Linux." \
  org.label-schema.docker.cmd="docker run -d [OPTIONS] ${IMAGE_TAG}" \
  org.label-schema.docker.cmd.debug="docker exec -it --rm [CONTAINER] /bin/bash" \
  org.label-schema.docker.params="" \
  afrl.cecep.image.component.python.version="${PYTHON_VERSION}" \
  afrl.cecep.image.component.pip.version="${PIP_VERSION}"


ARG HOST_USER
ARG HOST_GROUP
RUN addgroup -S -g ${HOST_GROUP} notebook && adduser -S notebook  -G notebook -u ${HOST_USER} -h /home/notebook -s /bin/bash

ARG APKS

COPY ./install-scripts/apks.sh /apks.sh

ARG PIPS

COPY ./install-scripts/pips.sh /pips.sh

RUN chmod +x /apks.sh
RUN chmod +x /pips.sh
RUN apk update \
    && apk add --no-cache --virtual .build-deps \
      g++  \
      python3-dev \
      libffi-dev \
      openssl-dev \
      bash \
      bash-doc \
      bash-completion \
      gcc \
      g++ \
      tzdata \
      libffi-dev \
      build-base \
      wget \
      git \
    && apk add --no-cache --update python3 \
    && ./apks.sh --APKS=${APKS} \
    && ./pips.sh --PIPS=${PIPS} \
    && ln -s pip3 /usr/local/pip \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && pip3 install --upgrade pip setuptools wheel \
    && echo $(python --version | awk '{print $2}') > /pyversion \
    && echo "Python Version: $(cat /pyversion)" \
    && apk del \
      tzdata \
      build-base \
      git

RUN mkdir /notebooks && chown notebook:notebook /notebooks

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LIBRARY_PATH=/lib:/usr/lib

ENV SHELL=/bin/bash

WORKDIR /notebooks

EXPOSE 8888

VOLUME [/notebooks]
VOLUME [/home/notebook]
USER notebook

COPY ./install-scripts/docker-entrypoint /usr/local/bin/
ENTRYPOINT ["docker-entrypoint"]

COPY ./install-scripts/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

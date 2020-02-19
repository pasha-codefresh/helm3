ARG HELM_VERSION

FROM alpine as tt

RUN apk add --no-cache git
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*
RUN apk add --no-cache bash

ARG HELM_VERSION
ARG S3_PLUGIN_VERSION
ARG GCS_PLUGIN_VERSION
ARG PUSH_PLUGIN_VERSION

# for helm 3
ENV XDG_CACHE_HOME=/root/.helm
ENV XDG_DATA_HOME=/root/.helm
ENV XDG_CONFIG_HOME=/root/.helm

RUN echo "HELM_VERSION is set to: 3.0.3" && mkdir /temp
RUN curl -L "https://get.helm.sh/helm-v3.0.3-linux-amd64.tar.gz" -o helm.tar.gz \
    && tar -zxvf helm.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/helm \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git \
    && helm plugin install https://github.com/nouney/helm-gcs.git \
    && helm plugin install https://github.com/chartmuseum/helm-push.git

RUN ls /root/.helm

#
FROM codefresh/kube-helm:3.0.3

ENV XDG_CACHE_HOME=/root/.helm
ENV XDG_DATA_HOME=/root/.helm
ENV XDG_CONFIG_HOME=/root/.helm

#ARG HELM_VERSION

COPY --from=tt /root/.helm/ /root/.helm/

#COPY --from=tt /temp /root/.helm/* /root/.helm/
#
#COPY /root/.config /root/.helm

RUN ls /root/.helm


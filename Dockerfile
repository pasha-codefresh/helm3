ARG HELM_VERSION
ARG S3_PLUGIN_VERSION
ARG GCS_PLUGIN_VERSION
ARG PUSH_PLUGIN_VERSION

FROM golang:latest as setup
ARG HELM_VERSION
ARG S3_PLUGIN_VERSION
ARG GCS_PLUGIN_VERSION
ARG PUSH_PLUGIN_VERSION

# for helm 3
ENV XDG_CACHE_HOME=/root/.helm
ENV XDG_DATA_HOME=/root/.helm
ENV XDG_CONFIG_HOME=/root/.helm

RUN echo "HELM_VERSION is set to: ${HELM_VERSION}" && mkdir /temp
RUN curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o helm.tar.gz \
    && tar -zxvf helm.tar.gz \
    && mv ./linux-amd64/helm /usr/local/bin/helm \
    && helm plugin install https://github.com/hypnoglow/helm-s3.git --version=${S3_PLUGIN_VERSION} \
    && helm plugin install https://github.com/nouney/helm-gcs.git --version=${GCS_PLUGIN_VERSION} \
    && helm plugin install https://github.com/chartmuseum/helm-push.git --version=${PUSH_PLUGIN_VERSION}

FROM codefresh/kube-helm:${HELM_VERSION}
ARG HELM_VERSION

ENV HELM_VERSION ${HELM_VERSION}

ENTRYPOINT ["/opt/bin/release_chart"]

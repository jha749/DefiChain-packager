FROM alpine

ARG DEFI_VERSION
ENV DEFI_VERSION=${DEFI_VERSION:-1.6.0}

RUN echo "${DEFI_VERSION:-1.6.0}"

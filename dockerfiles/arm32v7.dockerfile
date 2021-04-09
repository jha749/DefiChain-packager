FROM arm32v7/hello-world

RUN echo "${DEFI_VERSION:-1.6.0}"

FROM --platform=$BUILDPLATFORM ubuntu:20.04 as builder-base
ARG BUILDPLATFORM
ARG BUILD_VERSION
ENV DEBIAN_FRONTEND=noninteractive

#RUN if [ "$TARGET" = "linux/arm64" ] ; then \
#    echo 'aarch64-linux-gnu' > ~/target_arch.txt; \
#  else \
#    echo 'arm-linux-gnueabihf' > ~/target_arch.txt; \
#  fi

LABEL org.defichain.name="defichain-builder-base"
#LABEL org.defichain.arch=${TARGET}

RUN apt update && apt dist-upgrade -y

# Setup Defichain build dependencies. Refer to depends/README.md and doc/build-unix.md
# from the source root for info on the builder setup

RUN apt install -y software-properties-common build-essential libtool autotools-dev automake \
pkg-config bsdmainutils python3 libssl-dev libevent-dev libboost-system-dev \
libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev \
libminiupnpc-dev libzmq3-dev libqrencode-dev \
curl cmake \
g++-arm-linux-gnueabihf binutils-arm-linux-gnueabihf \
g++-aarch64-linux-gnu binutils-aarch64-linux-gnu
#g++-"$(cat ~/target_arch.txt)" binutils-"$(cat ~/target_arch.txt)"

# Get the source files
RUN mkdir -p /usr/src/defich && \
 cd /usr/src/defich && \
 curl -L https://github.com/DeFiCh/ain/archive/v$BUILD_VERSION.tar.gz > ain.tar.gz && \
 tar xvzf ain.tar.gz && \
 mkdir -p /work && \
 cp -R /usr/src/defich/ain-$BUILD_VERSION/* /work

# -----------
FROM --platform=$BUILDPLATFORM builder-base as depends-builder
ARG BUILDPLATFORM
ARG TARGETPLATFORM
LABEL org.defichain.name="defichain-depends-builder"
LABEL org.defichain.arch=${TARGETPLATFORM}

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
    echo 'aarch64-linux-gnu' > ~/target_arch.txt; \
  else \
    echo 'arm-linux-gnueabihf' > ~/target_arch.txt; \
  fi

WORKDIR /work/depends
# XREF: #depends-make
RUN make HOST="$(cat ~/target_arch.txt)" NO_QT=1

# -----------
FROM --platform=$BUILDPLATFORM builder-base as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG BUILD_VERSION
LABEL org.defichain.name="defichain-builder"
LABEL org.defichain.arch=${TARGETPLATFORM}

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
    echo 'aarch64-linux-gnu' > ~/target_arch.txt; \
  else \
    echo 'arm-linux-gnueabihf' > ~/target_arch.txt; \
  fi

WORKDIR /work
COPY --from=depends-builder /work/depends ./depends

RUN ./autogen.sh

# XREF: #make-configure
RUN ./configure --prefix=`pwd`/depends/"$(cat ~/target_arch.txt)" \
    --enable-glibc-back-compat \
    --enable-reduce-exports \
    LDFLAGS="-static-libstdc++"

RUN make
RUN mkdir /app && make prefix=/ DESTDIR=/app install && cp /work/README.md /app/.

# Final image with binaries
FROM ubuntu:20.10
LABEL org.defichain.name="defichain"
LABEL org.defichain.arch=${TARGETPLATFORM}
ENV PATH=/app/bin:$PATH
WORKDIR /app

COPY --from=builder /app/. ./

RUN useradd --create-home defi && \
    mkdir -p /data && \
    chown defi:defi /data && \
    ln -s /data /home/defi/.defi

VOLUME ["/data"]

USER defi:defi
CMD [ "/app/bin/defid" ]

EXPOSE 8555 8554 18555 18554 19555 19554

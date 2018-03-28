ARG UBUNTU_IMAGE=xenial
FROM ubuntu:$UBUNTU_IMAGE

ARG RUST_TOOLCHAIN=stable
ARG TARPAULIN_REV="-b master"

ENV CARGO_HOME=/opt/.cargo
ENV RUSTUP_HOME=/opt/.rustup
ENV PATH=${CARGO_HOME}/bin:${PATH}

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    file \
    git \
    libssl-dev \
    pkg-config \
    zlib1g-dev \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path \
    --default-toolchain ${RUST_TOOLCHAIN} \
    && which rustc && rustc --version \
    && which cargo && cargo --version \
    && git clone https://github.com/xd009642/tarpaulin.git ${TARPAULIN_REV} \
    && cd tarpaulin \
    && git rev-parse HEAD \
    && cargo install -f --path . \
    && cd .. \
    && rm -rf tarpaulin \
    && apt-get clean \
    && rm ${CARGO_HOME}/bin/rustup \
    && rm -rf ${CARGO_HOME}/registry/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /volume
COPY run.sh /opt/
ENTRYPOINT [ "/opt/run.sh" ]

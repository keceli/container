FROM intel/oneapi-hpckit:2023.2.1-devel-ubuntu22.04

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=US \
    CXX=icpx

WORKDIR /app

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get -y upgrade \
    && apt-get -y install git wget vim libboost-all-dev doxygen ninja-build \
    && python3 -m pip install sphinx sphinx_rtd_theme pytest-benchmark ninjaparser \
    && wget https://github.com/evaleev/libint/releases/download/v2.6.0/libint-2.6.0.tgz \
    && tar -zxf libint-2.6.0.tgz \
    && cmake -GNinja -H./libint-2.6.0 -B./libint-2.6.0/build \
           -DCMAKE_INSTALL_PREFIX=/app/install \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_CXX_FLAGS="-std=c++17 -g" \
           -DBUILD_SHARED_LIBS=ON \
    && cmake --build ./libint-2.6.0/build \
    && cmake --install ./libint-2.6.0/build \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app


FROM nvidia/cuda:11.2.2-base-ubuntu20.04

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
# update the OS
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
# build TiledArray
# 1. basic prereqs
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-pip python3-numpy ninja-build liblapacke-dev liblapack-dev mpich libboost-dev libeigen3-dev git wget libboost-serialization-dev libunwind-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# 2. recent cmake
RUN wget --no-check-certificate -O - https://cmake.org/files/v3.19/cmake-3.19.0-Linux-x86_64.tar.gz | tar --strip-components=1 -xz -C /usr/local
ENV CMAKE=/usr/local/bin/cmake
# 3. download and build TiledArray
RUN cd /usr/local/src && \
    git clone --depth=1 https://github.com/ValeevGroup/tiledarray.git && \
    cd /usr/local/src/tiledarray && \
    mkdir build && \
    cd build && \
    /usr/local/bin/cmake .. -G Ninja -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_COMPILER=gcc -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_CUDA=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
    /usr/local/bin/cmake --build . --target tiledarray && \
    /usr/local/bin/cmake --build . --target examples && \
    /usr/local/bin/cmake --build . --target install 
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

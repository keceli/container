# docker build . -t <MYIMAGE>
# docker run -it <MYIMAGE> bash
# Authors:
# Murat Keceli <keceli@gmail.com>

FROM keceli/dev:base
LABEL maintainer "Murat Keceli <keceli@gmail.com>"


# Install blas, lapack, tbb, boost
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        libblas-dev \
        liblapack-dev \  
        liblapacke-dev \
        libtbb-dev \
        libboost-all-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install tiledarray 
RUN cd /container && /
    git clone https://github.com/ValeevGroup/tiledarray.git && /
    cd tiledarray && /
    mkdir build && /
    cd build && /
    cmake -DTA_BUILD_UNITTEST=True .. && /
    make

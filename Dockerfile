# docker build . -t <MYIMAGE>
# docker run -it <MYIMAGE> bash
# Authors:
# Murat Keceli <keceli@gmail.com>

FROM keceli/dev:base
LABEL maintainer "Murat Keceli <keceli@gmail.com>"


# Install blas, lapack, tbb, boost
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        google-perftools libgoogle-perftools-dev \
        gdb \
        libblas-dev \
        liblapack-dev \  
        liblapacke-dev \
        libtbb-dev \
        libboost-all-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install cereal
RUN cd /container && \
    git clone https://github.com/USCiLab/cereal.git && \
    cd cereal && \
    mkdir build && \
    cd build && \
    cmake  -DSKIP_PORTABILITY_TEST=ON -DCMAKE_CXX_STANDARD=17 .. && \
    make && \
    make install
    
# Install madness 
RUN cd /container && \
    git clone https://github.com/m-a-d-n-e-s-s/madness.git && \
    cd madness && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=DEBUG .. && \
    make && \
    make test_ar && \
    cd /container && \
    git clone https://github.com/keceli/madness.git keceli_madness&& \
    cd keceli_madness && \
    git checkout parallel_archive &&\
    mkdir build && \
    cd build && \
    cmake  -DCMAKE_BUILD_TYPE=DEBUG .. && \
    make test_ar

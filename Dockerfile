# docker build . -t <MYIMAGE>
# docker run -it <MYIMAGE> bash
# Authors:
# Murat Keceli <keceli@gmail.com>

FROM gcc:9.2.0
LABEL maintainer "Murat Keceli <keceli@gmail.com>"

ENV MPICH_VERSION=3.3.2
ENV CMAKE_VERSION=

# Install system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        curl \
        vim \
        time \
        ca-certificates \
        wget && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /container && \
    cd /container && \
    wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz && \
    tar xf mpich-${MPICH_VERSION}.tar.gz && \
    rm -f  mpich-${MPICH_VERSION}.tar.gz  && \
    cd mpich-${MPICH_VERSION} && \
    ./configure --prefix=/container/mpich-${MPICH_VERSION}/install --disable-wrapper-rpath && \
    make -j4 && \
    make install && \
    cd .. && \
    version=3.16 && \
    build=0 && \
    wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz && \
    tar -xzvf cmake-$version.$build.tar.gz && \
    cd cmake-$version.$build/ && \
    ./bootstrap && \
    make -j4  && \
    make install
    
RUN cd /container && \ 
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    git clone https://bitbucket.org/wlav/cppyy-backend.git && \
    cd cppyy-backend/cling && \
    python3 setup.py egg_info && \
    python3 create_src_directory.py && \
    python3 -m pip install . --upgrade && \
    # Install cppyy https://cppyy.readthedocs.io/en/latest/repositories.html
    cd /container && \
    git clone https://bitbucket.org/wlav/cppyy-backend.git && \
    cd cppyy-backend/clingwrapper && \
    python3 -m pip install . --upgrade && \
    #
    cd /container && \
    git clone https://bitbucket.org/wlav/CPyCppyy.git && \
    cd CPyCppyy && \
    python3 -m pip install . --upgrade && \
    #
    cd /container && \
    git clone https://bitbucket.org/wlav/cppyy.git && \
    cd cppyy && \
    python3 -m pip install . --upgrade
    
    
ENV PATH=$PATH:/container/mpich-${MPICH_VERSION}/install/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/container/mpich-${MPICH_VERSION}/install/lib

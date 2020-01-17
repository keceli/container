# docker build . -t <MYIMAGE>
# docker run -it <MYIMAGE> bash
# Authors:
# Murat Keceli <keceli@gmail.com>

FROM gcc:9.2.0
LABEL maintainer "Murat Keceli <keceli@gmail.com>"

ENV MPICH_VERSION=3.3.2
ENV CMAKE_VERSION=

# Install system packages
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        build-essential \
        software-properties-common \
        lsb-release \
        git \
        curl \
        vim \
        time \
        bzip2 \
        ca-certificates \
        wget \
        python3-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /container 

# Install mpich
RUN cd /container && \
    wget http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz && \
    tar xf mpich-${MPICH_VERSION}.tar.gz && \
    rm -f  mpich-${MPICH_VERSION}.tar.gz  && \
    cd mpich-${MPICH_VERSION} && \
    ./configure --prefix=/container/mpich-${MPICH_VERSION}/install --disable-wrapper-rpath && \
    make -j4 && \
    make install
    
# Install cmake   
RUN cd /container && \
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
    python3 get-pip.py 

#install LLVM latest version
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

#install miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

ENV PATH=$PATH:/container/mpich-${MPICH_VERSION}/install/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/container/mpich-${MPICH_VERSION}/install/lib

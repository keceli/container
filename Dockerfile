FROM        ubuntu:20.04

ENV         LC_ALL C.UTF-8
ENV         LANG C.UTF-8
ENV         DEBIAN_FRONTEND "noninteractive" 
ENV         TZ "US"

RUN         apt-get update \
            && apt-get -y install software-properties-common

RUN         apt-get update \
            && apt-get -y upgrade \
            && apt-get -y install clang-12 \
            && apt-get -y install git \
            && apt-get -y install libboost-all-dev libgslcblas0 libgsl-dev \
            && apt-get -y install -f clang-format-9 \
            && apt-get -y install -f doxygen \
            && apt-get -y install libeigen3-dev wget vim

ENV         CMAKE_V "3.22.4"

ENV         CC clang-12
ENV         CXX clang++-12
ENV         FC gfortran

RUN         apt-get update \
            && apt-get -y install ninja-build \
            && apt-get -y install liblapacke liblapacke-dev \
            && apt-get -y install libopenblas-base libopenblas-dev \
            && apt-get -y install openmpi-bin libopenmpi-dev \
            && apt-get -y install libscalapack-openmpi-dev 

RUN         apt-get -y install python3-pip

RUN         python3 -m pip install cmake==${CMAKE_V}
RUN         python3 -m pip install cppyy==2.2.0
RUN         python3 -m pip install sphinx sphinx_rtd_theme
RUN         python3 -m pip install pytest-benchmark
RUN         python3 -m pip install ninjaparser
RUN         python3 -m pip install rdkit-pypi

WORKDIR     /app
RUN         wget https://github.com/evaleev/libint/releases/download/v2.6.0/libint-2.6.0.tgz \
            && tar -zxf libint-2.6.0.tgz
WORKDIR     /app/libint-2.6.0
RUN         cmake -GNinja -H. -Bbuild \
            -DCMAKE_INSTALL_PREFIX=/app/install \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_CXX_FLAGS="-std=c++17 -g" \
            -DBUILD_SHARED_LIBS=ON
WORKDIR     /app/libint-2.6.0/build
RUN         cmake --build .
RUN         cmake --install .

WORKDIR     /app


FROM        ubuntu:22.04

ENV         LC_ALL C.UTF-8
ENV         LANG C.UTF-8
ENV         DEBIAN_FRONTEND "noninteractive" 
ENV         TZ "US"

RUN         apt-get update \
            && apt-get -y install software-properties-common

RUN         apt-get update \
            && apt-get -y upgrade \
            && apt-get -y install git \
            && apt-get -y install libboost-all-dev libgslcblas0 libgsl-dev \
            && apt-get -y install -f clang-format \
            && apt-get -y install -f doxygen \
            && apt-get -y install libeigen3-dev wget vim

ENV         CMAKE_V "3.22.4"

ENV         GNU_V 12
ENV         GCC_NO_V "/usr/bin/gcc"
ENV         GCC_V "${GCC_NO_V}-${GNU_V}"
ENV         GXX_NO_V "/usr/bin/g++"
ENV         GXX_V "${GXX_NO_V}-${GNU_V}"
ENV         GFORT_NO_V "/usr/bin/gfortran"
ENV         GFORT_V "${GFORT_NO_V}-${gnu_v}"
ENV         GCOV_NO_V "/usr/bin/gcov"
ENV         GCOV_V "${GCOV_NO_V}-${GNU_V}"

ENV         CC ${GCC_V}
ENV         CXX ${GXX_V}
ENV         FC ${GFORT_V}

RUN         add-apt-repository ppa:ubuntu-toolchain-r/test \
            && apt-get update \
            && apt-get -y install "gcc-${GNU_V}" "g++-${GNU_V}" "gfortran-${GNU_V}" \
            && update-alternatives --install "${GCC_NO_V}" gcc "${GCC_V}" 95 \
                           --slave "${GXX_NO_V}" g++ "${GXX_V}" \
                           --slave "${GFORT_NO_V}" gfortran "${GFORT_V}" \
                           --slave "${GCOV_NO_V}" gcov "${GCOV_V}"

RUN         apt-get update \
            && apt-get -y install ninja-build \
            && apt-get -y install liblapacke liblapacke-dev \
            && apt-get -y install libopenblas-base libopenblas-dev \
            && apt-get -y install openmpi-bin libopenmpi-dev \
            && apt-get -y install libint2-dev \
            && apt-get -y install libscalapack-openmpi-dev 

RUN         apt-get -y install python3-pip

RUN         python3 -m pip install cmake==${CMAKE_V}
RUN         python3 -m pip install cppyy==2.2.0
RUN         python3 -m pip install sphinx sphinx_rtd_theme
RUN         python3 -m pip install pytest-benchmark
RUN         python3 -m pip install ninjaparser
RUN         python3 -m pip install rdkit-pypi

WORKDIR     /app


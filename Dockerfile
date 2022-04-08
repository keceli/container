FROM        ubuntu:20.04

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
            && apt-get -y install -f clang-format-9 \
            && apt-get -y install -f doxygen \
            && apt-get -y install libeigen3-dev wget vim

ENV         CMAKE_V "3.16.3"
ENV         CMAKE_URL "https://github.com/Kitware/CMake/releases/download"
ENV         ARCH "Linux-x86_64"
ENV         CMAKE_SCRIPT "cmake-${CMAKE_V}-${ARCH}.sh"
ENV         CMAKE_ROOT ${PWD}/cmake-"${CMAKE_V}"-"${ARCH}"
ENV         CMAKE_COMMAND "${CMAKE_ROOT}/bin/cmake"
ENV         CTEST_COMMAND "${CMAKE_ROOT}/bin/ctest"

RUN         wget "${CMAKE_URL}/v${CMAKE_V}/${CMAKE_SCRIPT}" \
            && yes | /bin/sh "${CMAKE_SCRIPT}"

ENV         GNU_V 9
ENV         GCC_NO_V "/usr/bin/gcc"
ENV         GCC_V "${GCC_NO_V}-${GNU_V}"
ENV         GXX_NO_V "/usr/bin/g++"
ENV         GXX_V "${GXX_NO_V}-${GNU_V}"
ENV         GFORT_NO_V "/usr/bin/gfortran"
ENV         GFORT_V "${GFORT_NO_V}-${gnu_v}"
ENV         GCOV_NO_V "/usr/bin/gcov"
ENV         GCOV_V "${GCOV_NO_V}-${GNU_V}"

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
            && apt-get -y install libscalapack-openmpi-dev 

RUN         apt-get -y install python3-pip

RUN         python3 -m pip install cppyy

RUN         apt-get update \
            && apt-get -y install -f python3-venv \
            && python3 -m venv venv \
            && . venv/bin/activate \
            && python -m pip install sphinx sphinx_rtd_theme


WORKDIR     /app
RUN         wget https://github.com/evaleev/libint/releases/download/v2.6.0/libint-2.6.0.tgz \
            && tar -zxf libint-2.6.0.tgz
WORKDIR     /app/libint-2.6.0
RUN         ${CMAKE_COMMAND} -GNinja -H. -Bbuild -DCMAKE_INSTALL_PREFIX=/app/install \
            -DCMAKE_CXX_FLAGS="-std=c++17" -DBUILD_SHARED_LIBS=ON
WORKDIR     /app/libint-2.6.0/build
RUN         ${CMAKE_COMMAND} --build .
RUN         ${CMAKE_COMMAND} --install .

WORKDIR     /app


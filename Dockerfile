FROM        intel/oneapi

ENV         LC_ALL C.UTF-8
ENV         LANG C.UTF-8
ENV         DEBIAN_FRONTEND "noninteractive" 
ENV         TZ "US"

RUN         apt-get update \
            && apt-get -y install software-properties-common

RUN         apt-get update \
            && apt-get -y upgrade \
            && apt-get -y install git \
            && apt-get -y install wget \
            && apt-get -y install vim \
            && apt-get -y install libboost-all-dev \
            && apt-get -y install -f doxygen \
            && apt-get -y install ninja-build \
            && apt-get -y install libint2-2 

RUN         python3 -m pip install cppyy==2.2.0
RUN         python3 -m pip install sphinx sphinx_rtd_theme
RUN         python3 -m pip install pytest-benchmark
RUN         python3 -m pip install ninjaparser
RUN         python3 -m pip install rdkit-pypi

WORKDIR     /app


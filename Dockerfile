# docker build . -t <MYIMAGE>
# docker run -it <MYIMAGE> bash
# Authors:
# Murat Keceli <keceli@gmail.com>

FROM keceli/dev:lib
LABEL maintainer "Murat Keceli <keceli@gmail.com>"


# Install tiledarray 
RUN cd /container && /
    git clone https://github.com/ValeevGroup/tiledarray.git && /
    cd tiledarray && /
    mkdir build && /
    cd build && /
    cmake -DTA_BUILD_UNITTEST=True .. && /
    make

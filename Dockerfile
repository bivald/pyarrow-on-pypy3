FROM python:3.10-slim-bullseye

RUN apt-get update && apt-get install -y build-essential libjemalloc-dev libboost-dev \
                       libboost-filesystem-dev \
                       libboost-system-dev \
                       libboost-regex-dev \
                       libgoogle-glog-dev   \
                       libsnappy-dev \
                       libbrotli-dev \
                       openssl \
                       libssl-dev pkg-config \
                       python-dev \
                       autoconf \
                       flex \
                       bison \
                       wget \
                       unzip \
                       libgoogle-glog-dev   \
                       libsnappy-dev brotli \
                       libbrotli-dev openssl \
                       libssl-dev pkg-config \
                       nano \
                       bzip2 \
                       cmake

RUN rm -rf /opt/pypy/* && mkdir -p /opt/pypy && wget -q https://downloads.python.org/pypy/pypy3.8-v7.3.11-linux64.tar.bz2  \
    && tar -C /opt/pypy --strip-components=1 -xf pypy*

RUN /opt/pypy/bin/pypy3 -m ensurepip && /opt/pypy/bin/pypy3 -m pip install --upgrade pip virtualenv && \
	/opt/pypy/bin/pypy3 -m virtualenv /pyarrow

RUN /pyarrow/bin/pip -vvvv install numpy cython hypothesis pandas

RUN /pyarrow/bin/pip install cmake

FROM pypy:3.8-slim-bullseye

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

RUN rm -rf /opt/pypy/* && wget -q https://buildbot.pypy.org/nightly/py3.8/pypy-c-jit-latest-linux64.tar.bz2 \
    && tar -C /opt/pypy --strip-components=1 -xf pypy-c-jit-latest-linux64.tar.bz2

RUN /opt/pypy/bin/pypy3 -m ensurepip && pypy3 -m pip install --upgrade pip virtualenv && \
	virtualenv /pyarrow

RUN /pyarrow/bin/pip -vvvv install numpy cython hypothesis pandas

RUN /pyarrow/bin/pip install cmake
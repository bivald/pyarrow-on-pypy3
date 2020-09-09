FROM pypy:3.6-slim-buster

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
                       bison wget unzip

RUN pypy3 -m pip install virtualenv && \
	virtualenv /pyarrow

RUN /pyarrow/bin/pip -vvvv install numpy>=1.1 cython hypothesis pandas

RUN apt-get install nano
RUN /pyarrow/bin/pip install cmake
RUN apt-get install -y libgoogle-glog-dev   libsnappy-dev brotli libbrotli-dev openssl libssl-dev pkg-config
RUN /pyarrow/bin/pip install twine

WORKDIR /
RUN wget https://github.com/apache/arrow/archive/765686ec2ae4853d070081463914683af7ac13b3.zip \
	&& unzip 765686ec2ae4853d070081463914683af7ac13b3.zip \
	&& mv arrow-765686ec2ae4853d070081463914683af7ac13b3 arrow \
	&& cd arrow \
	&& . /pyarrow/bin/activate \
	&& /pyarrow/bin/pip install -r /arrow/python/requirements-build.txt \
	&& mkdir /dist/ && export ARROW_HOME=$(pwd)/dist \
	&& export LD_LIBRARY_PATH=$(pwd)/dist/lib:$LD_LIBRARY_PATH \
	&& mkdir /arrow/cpp/build \
	&& cd /arrow/cpp/ \
	&& cmake \
		-DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DARROW_BUILD_CUDA=off \
		-DARROW_BUILD_FLIGHT=off \
		-DARROW_BUILD_GANDIVA=off \
		-DARROW_BUILD_DATASET=off \
		-DARROW_BUILD_ORC=off \
		-DARROW_BUILD_PARQUET=on \
		-DARROW_BUILD_PLASMA=off \
		-DARROW_BUILD_S3=off \
		-DARROW_BUILD_HDFS=off \
		-DARROW_USE_TENSORFLOW=off \
		-DARROW_BUNDLE_ARROW_CPP=on \
		-DARROW_BUNDLE_BOOST=off \
		-DARROW_GENERATE_COVERAGE=off \
		-DARROW_BOOST_USE_SHARED=on-DCMAKE_BUILD_TYPE=release \
		-DARROW_BUILD_TESTS=off \
		-DARROW_PARQUET_USE_SHARED=on \
		-DARROW_PARQUET=on \
		-DARROW_PYTHON=on \
	&& make -j4 \
	&& make install \
	&& cd /arrow/python/ \
	&& export PYARROW_WITH_PARQUET=1 \
	&& 	PYARROW_WITH_PARQUET=1 \
		ARROW_HOME=/arrow/dist/ \
		PARQUET_HOME=/arrow/dist/ \
		ARROW_PYTHON_INCLUDE_DIR=/arrow/cpp/src/arrow/ \
		/pyarrow/bin/pypy3 setup.py build_ext \
		--build-type=release  \
		--bundle-arrow-cpp bdist_wheel

# This will create a .whl file in /arrow/python/./dist/pyarrow-0.15.0a0-pp36-pypy36_pp73-linux_x86_64.whl

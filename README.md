# pyarrow-on-pypy3
This repository aims to show how to build pyarrow on PyPy3 (for use with parquet files in pandas). Currently it builds on latest arrow.

Instructions are mainly taken from https://arrow.apache.org/docs/developers/python.html

## How to build
Run `make dist` and it should build docker container and copy wheel files into `./dist`

## Wheels
You can also grab the wheel from the wheels folder if you just want the wheel (and don't care about building it yourself)

## Runtime dependencies
The following dependencies are required to run this pyarrow build:

```
apt-get install -y libjemalloc-dev libboost-dev \
                   libboost-filesystem-dev \
                   libboost-system-dev \
                   libboost-regex-dev \
                   libgoogle-glog-dev   \
                   libsnappy-dev \
                   libbrotli-dev \
                   libssl-dev
```

If you don't have them `pandas` will give an error saying you don't have pyarrow installed.
You can check that everything works by running:

```
import arrow
print(arrow._parquet)
```

If the runtime dependencies are *not* installed you will see errors such as:

```
>>>> import pyarrow
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/opt/pypy/site-packages/pyarrow/__init__.py", line 49, in <module>
    from pyarrow.lib import cpu_count, set_cpu_count
ImportError: libglog.so.0: cannot open shared object file: No such file or directory
```

## Sample usage
```
pypy3 -m pip install --extra-index https://antocuni.github.io/pypy-wheels/manylinux2010 numpy pandas pyarrow-0.15.0a0-pp36-pypy36_pp73-linux_x86_64.whl
pypy3 -c "import pandas as pd; pd.read_parquet('file.parq')"
```

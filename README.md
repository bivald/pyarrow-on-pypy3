# pyarrow-on-pypy3
This repository aims to show how to build pyarrow on PyPy3 (for use with parquet files in pandas). Currently it only builds:

- Pyarrow PyPy3 (0.15.0) the exact commit https://github.com/apache/arrow/tree/765686ec2ae4853d070081463914683af7ac13b3

Preferably we would like to use an newer version but we've failed for the following reasons:

- 0.16 - 1.0 fails on datetime.cc: https://mail.python.org/pipermail/pypy-dev/2020-September/016002.html
- 1.0 or newer fails on PyMemoryView_GetContiguous (see logs/1.0.txt)

And since my current aim is simply to read and write parquet files through pandas 0.15.0 is OK.

Instructions are mainly taken from https://arrow.apache.org/docs/developers/python.html

## How to build
Run `make dist` and it should build docker container and copy wheel files into `./dist`

## Wheels
You can also grab the wheel from the wheels folder if you just want the wheel (and don't care about building it yourself)

cp $(find /|egrep "pandas-.+-pp38-pypy38_pp73-linux_x86_64.whl") /arrow/python/dist/
pypy3 -m venv /.venv
source /.venv/bin/activate
pip install /arrow/python/dist/*
pip install -r /arrow/python/requirements-test.txt
cp -r /arrow/python/pyarrow /pyr
python -m pytest pyr/tests

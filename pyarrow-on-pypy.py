#
# Sample for PyArrow on PyPy
# This should work for ideally pypy:3.6-7.3.2-slim-buster as well as 3.9-7.3.9-slim-bullseye. But if need be, we can sacrify 3.6 in favor of 3.9
#

import datetime
import pyarrow.parquet as pq
import pyarrow as pa

arrow_schema = pa.schema(
	[
		pa.field('id', pa.string()),
		pa.field('date', pa.date32()),
		pa.field('datetime', pa.timestamp('ns')),
		pa.field('float', pa.float64()),
		pa.field('almost_bool', pa.float32()),
	]
)


with pq.ParquetWriter(
    "filename.parquet",
    arrow_schema,
    compression='snappy',
    allow_truncated_timestamps=True,
    version='2.0',  # Legacy, could be upgraded if needed
    data_page_version='2.0',  # Legacy, could be upgraded if needed
) as writer:

	writer.write_table(
	        pa.Table.from_pydict(
	            {
	            	"id": pa.array(["20cf3cd5-9fb5-4287-99d4-32254f597ba0", "74c0ff22-96fe-4ee4-8548-18e2aeec75ed", "6c92975c-7f39-46e2-878b-c41c4da64ce2"], type=arrow_schema.field('id').type),
	            	"date": pa.array([datetime.date(2022,10,1), datetime.date(2022,10,1), datetime.date(2022,10,1)], type=arrow_schema.field('date').type),
	            	"datetime": pa.array([datetime.datetime(2022, 10, 1, 1, 1, 1), datetime.datetime(2022, 10, 1, 1, 1, 2), datetime.datetime(2022, 10, 1, 1, 1, 3)], type=arrow_schema.field('datetime').type),
	            	"float": pa.array([1.0, 2.0, 3.0], type=arrow_schema.field('float').type),
	            	"almost_bool": pa.array([1,0,1], type=arrow_schema.field('almost_bool').type),
	            },
	            arrow_schema
	        ),
	    )
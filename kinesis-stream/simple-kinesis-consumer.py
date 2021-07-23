#!/usr/bin/python3

# This client receives data from $STREAM_NAME in the format below:
#
# {'EVENT_TIME': '2021-07-21T17:43:11.555265', 'TICKER': 'AAPL', 'PRICE': 65.89}
# {'EVENT_TIME': '2021-07-21T17:43:11.758197', 'TICKER': 'AAPL', 'PRICE': 61.9}
# {'EVENT_TIME': '2021-07-21T17:43:11.909215', 'TICKER': 'MSFT', 'PRICE': 96.28}
# {'EVENT_TIME': '2021-07-21T17:43:12.074115', 'TICKER': 'AAPL', 'PRICE': 46.7}
# {'EVENT_TIME': '2021-07-21T17:43:12.227249', 'TICKER': 'AMZN', 'PRICE': 73.92}
# {'EVENT_TIME': '2021-07-21T17:43:12.373232', 'TICKER': 'AAPL', 'PRICE': 93.2}
# {'EVENT_TIME': '2021-07-21T17:43:12.523530', 'TICKER': 'AMZN', 'PRICE': 91.93}
# {'EVENT_TIME': '2021-07-21T17:43:12.679653', 'TICKER': 'AMZN', 'PRICE': 72.73}
# {'EVENT_TIME': '2021-07-21T17:43:12.827167', 'TICKER': 'AMZN', 'PRICE': 56.02}
 


import datetime
import json
import random
import boto3

STREAM_NAME = "stock-data-stream"


def main():
  kinesis = boto3.client('kinesis')
  r = kinesis.list_shards(
    StreamName=STREAM_NAME
  )
# 
# Returns:
#
# {'Shards': [{'ShardId': 'shardId-000000000000', 'HashKeyRange': {'StartingHashKey': '0', 'EndingHashKey': '340282366920938463463374607431768211455'}, 'SequenceNumberRange': {'StartingSequenceNumber': '49620379020041838730356823277958029727720210499410853890'}}], 'ResponseMetadata': {'RequestId': 'fd1b00a1-eebe-a836-a46f-925ea660f133', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': 'fd1b00a1-eebe-a836-a46f-925ea660f133', 'x-amz-id-2': 'rIO4cojaGo+W4cJIoc+gmajnChXtwUsR4O7g9C2W+V3w8r69YLzNmOcT/uxk5g+O2GZ5wQnjgLcKK2yfKgZFIN76kp+vuo9r', 'date': 'Fri, 
#
  assert(r['Shards'])
  shard_id = r['Shards'][0]['ShardId']
  seq_number = r['Shards'][0]['SequenceNumberRange']['StartingSequenceNumber']
  print (shard_id, seq_number)  
  response = kinesis.get_shard_iterator(
    StreamName=STREAM_NAME,
    ShardId=shard_id,
    ShardIteratorType='AT_SEQUENCE_NUMBER',
    StartingSequenceNumber=seq_number
  )
  shard_iterator = response['ShardIterator']

  for i in range(10):
# 
# Returns:
#
#    {'Records': [{'SequenceNumber': '49620379020041838730356823278000342131411123521974173698', 'ApproximateArrivalTimestamp': datetime.datetime(2021, 7, 23, 11, 26, 51, 689000, tzinfo=tzlocal()), 'Data': b'{"EVENT_TIME": "2021-07-23T11:26:50.932472", "TICKER": "INTC", "PRICE": 79.06}', 'PartitionKey': 'TICKER'}], 'NextShardIterator': 'AAAAAAAAAAF15Ukdc0M/c+hI1eIRWrWalhpfQCev3qimilFRmGnGvQLh33DyrlYEU3Ij1uQJOTft2hEDBDsovEPBCaKYAbzqiKz2QNYbQLU/e1Ab0OQxP7sEln1z8xD570mYLi2LIGj+MdFRlqFZle959mQOlU7BkX71nAv8y/9ZyDJV8ACRtDnZ338CmVmFupvRxJDXJufvDuTBZaE+vmm3zZa3hsS3B3gT1lKchRvSRHAEI15bDA==', 'MillisBehindLatest': 0, 'ResponseMetadata': {'RequestId': 'c11001d3-af0c-017b-9864-92281f78ebb3', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': 'c11001d3-af0c-017b-9864-92281f78ebb3', 'x-amz-id-2': 'cEF8bqoTcduw2+S7LsJOZV/dKhYSr8SUNXizD8XCLuX6k6Qc0QlrGoOY76wQsBpoobO6YWYgjHyMszjlTUjh+/KyH0J8QrCL', 'date': 'Fri, 23 Jul 2021 09:54:03 GMT', 'content-type': 'application/x-amz-json-1.1', 'content-length': '570'}, 'RetryAttempts': 0}}

#
    response = kinesis.get_records(
      Limit=2,
      ShardIterator=shard_iterator
    )
    shard_iterator = response['NextShardIterator']
    stock_data = [d['Data'] for d in response['Records']]
    print(stock_data)


if __name__ == '__main__':
  main()


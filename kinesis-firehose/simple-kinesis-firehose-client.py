# This client sends data in the format below to kinesis firehose
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

STREAM_NAME = "my-first-kinesis-firehose-stream"

def get_data():
    return {
        'EVENT_TIME': datetime.datetime.now().isoformat(),
        'TICKER': random.choice(['AAPL', 'AMZN', 'MSFT', 'INTC', 'TBV']),
        'PRICE': round(random.random() * 100, 2)}


def main():
  firehose = boto3.client('firehose')
  while(True):
    data = get_data()
    print(data)
    firehose.put_record(
      DeliveryStreamName=STREAM_NAME,
      Record={
        'Data': json.dumps(data)
      }
    )


if __name__ == '__main__':
  main()


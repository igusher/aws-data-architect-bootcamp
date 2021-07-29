import datetime
import json
import random
import boto3

S3_BUCKET = 'test-ig-01'
S3_FILE = '1500000 Sales Records.csv'

def main():
  s3 = boto3.client('s3')
  r = s3.select_object_content(
    Bucket=S3_BUCKET,
    Key=S3_FILE,
    ExpressionType='SQL',
    Expression='SELECT * FROM s3object s where s.Country = \'Ukraine\' AND CAST(s."Total Profit" AS FLOAT) > 100000 limit 1000',
    InputSerialization = {'CSV': {"FileHeaderInfo": "Use"}},
    OutputSerialization = {'CSV': {}}
  )

  for event in r['Payload']:
    if 'Records' in event:
      records = event['Records']['Payload'].decode('utf-8')
      print(records)
    else:
      print(event)

if __name__ == '__main__':
  main()


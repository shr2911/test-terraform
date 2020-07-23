import os
import boto3
import json
import urllib3
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.setLevel(logging.INFO)
def lambda_handler(event, context):
    gem_source_url = os.environ['nsp_source_url']
    try:
      file_content = extract_payloads_event(event)
    except Exception as e:
      logger.error(f"Failed to extract payload:{e}")
      raise e
    else:
      try:
       post_to_gem(gem_source_url, file_content)
      except Exception as e:
       logger.error(f"Failed to publish payload to gem:{e}")
       raise e
def extract_payloads_event(event):
    s3 = boto3.client("s3")
    if event:
         print("Event :", event)
         file_obj = event["Records"][0]
         print(file_obj)
         destination = 'testshruthi'
         bucketname = str(file_obj['s3']['bucket']['name'])
         #bucketname = "customerdata-aws1"
         filename = str(file_obj['s3']['object']['key'])
         print("Filename: ", filename)
         fileObj = s3.get_object(Bucket=bucketname, Key=filename)
         file_content = fileObj["Body"].read().decode('utf-8')
         print(file_content)
         s3.put_object(Body=file_content, Bucket=destination, Key=filename)
         return file_content

def post_to_gem(gem_source_url, payloads):
    connection_pool = None
    try:
        print(payloads)

        headers_req = {
            "Content-Type": "application/json",
        }

        connection_pool = urllib3.connectionpool.connection_from_url(
            url=gem_source_url, cert_reqs="CERT_NONE", maxsize=1
        )
        print(connection_pool)
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
        response = connection_pool.request(
            "POST", gem_source_url, headers=headers_req, body=payloads
        )
        status = response.status
        print(status)
        print(response)
        if status == 200:
            logger.info(f"SUCCESSFULL Write to GEM on {gem_source_url}")
        else:
            logger.error(f"FAILED to write to GEM URl : {gem_source_url}")
    except Exception as e:
        logger.error(f"FAIL with status exception:{e}")
    finally:
        if connection_pool is not None:
            connection_pool.close()
    return True

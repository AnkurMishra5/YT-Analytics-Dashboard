import boto3
import requests
import os
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

def lambda_handler(event=None, context=None):
    api_key = os.getenv("YOUTUBE_API_KEY")
    channel_id = os.getenv("CHANNEL_ID")
    s3_bucket = os.getenv("S3_BUCKET_NAME")

    url = f"https://www.googleapis.com/youtube/v3/channels?part=statistics&id={channel_id}&key={api_key}"
    response = requests.get(url)
    data = response.json()

    filename = f"youtube-stats-{datetime.utcnow().isoformat()}.json"
    s3 = boto3.client("s3")
    s3.put_object(Bucket=s3_bucket, Key=filename, Body=str(data))

    return {
        "statusCode": 200,
        "body": f"Uploaded: {filename}"
    }
import os
import json
import boto3
from PIL import Image
from io import BytesIO

s3_client = boto3.client('s3')

def resize_image(image_path, size):
    with Image.open(image_path) as image:
        image.thumbnail(size)
        buffer = BytesIO()
        image.save(buffer, "JPEG")
        buffer.seek(0)
        return buffer

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Log the bucket and key
    print(f"Bucket: {bucket}, Key: {key}")
    
    # Define the download path
    download_path = f'/tmp/wedding/{key.replace("/", "_")}'
    
    # Ensure the directory exists
    os.makedirs(os.path.dirname(download_path), exist_ok=True)
    
    # Download the image from S3
    try:
        s3_client.download_file(bucket, key, download_path)
    except s3_client.exceptions.NoSuchKey:
        print(f"Error: The object with key '{key}' was not found in bucket '{bucket}'")
        return {
            'statusCode': 404,
            'body': json.dumps(f"Error: The object with key '{key}' was not found in bucket '{bucket}'")
        }

    # Continue with the rest of your processing
    thumbnail = resize_image(download_path, (150, 150))
    thumbnail_key = f'thumbnails/{key}'
    s3_client.upload_fileobj(thumbnail, bucket, thumbnail_key)
    
    medium = resize_image(download_path, (600, 600))
    medium_key = f'medium/{key}'
    s3_client.upload_fileobj(medium, bucket, medium_key)

    return {
        'statusCode': 200,
        'body': json.dumps('Images resized and uploaded successfully!')
    }

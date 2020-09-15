import boto3
import datetime
import time
import os

# Defined in MediaConvert template JSON
mediaConvertNameModifier = 'a.ts'

# Define notification ARN
notifyARN = 'arn:aws-cn:sns:cn-northwest-1:855501529395:HLS-TS-Compression'


def lambda_handler(event, context):
    os.environ['TZ'] = 'Asia/Shanghai'
    time.tzset()
    srcBucket = event['Records'][0]['s3']['bucket']['name']
    # path/to/key.name
    srcFile = event['Records'][0]['s3']['object']['key']
    # key.name
    srcName = srcFile.split("/", 2)[-1]
    dstName = srcName.replace(mediaConvertNameModifier, ".ts")

    dstFile = ""
    for n in range(0, len(srcFile.split("/", 2))):
        if n < len(srcFile.split("/", 2)) - 1:
            dstFile += srcFile.split("/", 2)[n] + '/'
        else:
            dstFile += dstName
        n += 1
    print('Source file: ' + srcFile)
    print('Destination file: ' + dstFile)

    # Move result objects
    s3Client = boto3.resource('s3')
    s3Client.Object(srcBucket, dstFile).copy_from(
        CopySource={
            'Bucket': srcBucket,
            'Key': srcFile
        }
    )
    time.sleep(5)
    s3Client.Object(srcBucket, srcFile).delete()

    # Send out notification via SNS
    snsClient = boto3.client('sns')
    tsComplete = datetime.datetime.now().strftime('%G-%m-%d %H:%M:%S')
    completeSubject = '[' + tsComplete + ']' + ' Compression completed'
    completeMessage = completeSubject + '\r\nResult file: ' + srcFile + '\r\nBucket: ' + srcBucket
    snsClient.publish(
        TopicArn=notifyARN,
        Message=completeMessage,
        Subject=completeSubject
    )

    return {
        'statusCode': 200,
        'bucket': srcBucket,
        'resultFile': dstFile
    }

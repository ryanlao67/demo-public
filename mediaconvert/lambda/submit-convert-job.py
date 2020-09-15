import subprocess
import logging
import json
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

originConvertJsonPath = './template.json'
targetConvertJsonPath = '/tmp/target.json'


# Specify MediaConvert job settings
def update_convert_json(qvbrLevel, maxBitrate, codecProfile, inputFile, destPath):
    with open(originConvertJsonPath, "r") as originJson:
        json_data = json.load(originJson)

    # Update convert parameters
    videoSettings = json_data['Settings']['OutputGroups'][0]['Outputs'][0]['VideoDescription']['CodecSettings']['H264Settings']
    videoSettings['QvbrSettings']['QvbrQualityLevel'] = int(qvbrLevel)
    videoSettings['MaxBitrate'] = int(maxBitrate)
    videoSettings['CodecProfile'] = codecProfile

    # Update input and output settings
    inputSettings = json_data['Settings']['Inputs'][0]
    inputSettings['FileInput'] = inputFile
    outputGroupSettings = json_data['Settings']['OutputGroups'][0]['OutputGroupSettings']['FileGroupSettings']
    outputGroupSettings['Destination'] = destPath

    # Generate target JSON for MediaConvert job
    with open(targetConvertJsonPath, "w") as targetJson:
        targetJson.write(json.dumps(json_data, indent=2))


# Submit MediaConvert job via AWS CLI
def run_command(command):
    command_list = command.split(' ')

    try:
        logger.info("Running shell command: \"{}\"".format(command))
        result = subprocess.run(command_list, stdout=subprocess.PIPE);
        logger.info("Command output:\n---\n{}\n---".format(result.stdout.decode('UTF-8')))
    except Exception as e:
        logger.error("Exception: {}".format(e))
        return False
    return True


def lambda_handler(event, context):
    bucketName = event['Records'][0]['s3']['bucket']['name']
    objectKey = event['Records'][0]['s3']['object']['key']
    s3 = boto3.client('s3')
    objectMeta = s3.head_object(
        Bucket=bucketName,
        Key=objectKey
    )
    # Define updated parameters for convert json
    convertInputFile = 's3://' + bucketName + '/' + objectKey
    convertTargetCodecProfile = objectMeta['ResponseMetadata']['HTTPHeaders']['x-amz-meta-codecprofile']
    convertTargetMaxBitrate = objectMeta['ResponseMetadata']['HTTPHeaders']['x-amz-meta-maxbitrate']
    convertTargetQvbrLevel = objectMeta['ResponseMetadata']['HTTPHeaders']['x-amz-meta-qvbrqualitylevel']

    # Define output path
    if "x-amz-meta-outputpath" in objectMeta['ResponseMetadata']:
        convertOutputPath = objectMeta['ResponseMetadata']['HTTPHeaders']['x-amz-meta-outputpath']
    else:
        prefixDepth = 0
        for prefixString in str(objectKey):
            if prefixString == '/':
                prefixDepth += 1

        prefixLayer = objectKey.split("/", prefixDepth)
        convertPath = ''
        for n in range(0, len(prefixLayer) - 1):
            convertPath = convertPath + '/' + str(prefixLayer[n])
        convertOutputPath = 's3://' + bucketName + convertPath + '/converted/'

    update_convert_json(convertTargetQvbrLevel,
                        convertTargetMaxBitrate,
                        convertTargetCodecProfile,
                        convertInputFile,
                        convertOutputPath)

    #with open(targetConvertJsonPath, "r") as targetJson:
    #    parsed = json.load(targetJson)
    #    print(json.dumps(parsed, indent=2, sort_keys=True))

    mediaConvertInit = boto3.client('mediaconvert')
    with open(targetConvertJsonPath, "r") as jobJson:
        jobSettings = json.load(jobJson)
    mediaConvertEndpoint = mediaConvertInit.describe_endpoints()
    mediaConvert = boto3.client('mediaconvert', endpoint_url=mediaConvertEndpoint['Endpoints'][0]['Url'])
    try:
        mediaConvert.create_job(**jobSettings)
    except Exception as e:
        logger.error("Exception: {}".format(e))
        return 500
    return 200

    #try:
    #    run_command('cat /tmp/target.json')
    #except Exception as e:
    #    logger.error("Exception: {}".format(e))
    #    return 500
    #return 200

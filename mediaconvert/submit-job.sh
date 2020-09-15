#!/bin/bash

# Usage:
# ./submit-job.sh 8 6000000 \
#	  s3://poc-data-zhy-ryanlao/opg-mediaconvert/mixed/FDNB5542050/6000/ \
#	  s3://poc-data-zhy-ryanlao/opg-mediaconvert/origin-mp4/FDNB5542050/6000/flow.mp4 \
#   MAIN

# "QvbrQualityLevel" : 8,
sed -i 's|\"QvbrQualityLevel\":.*|\"QvbrQualityLevel\": '$1,'|g' "convert.json"

# "MaxBitrate" : 2300000,
sed -i 's|\"MaxBitrate\":.*|\"MaxBitrate\": '$2,'|g' "convert.json"

# "Destination": "s3://poc-data-zhy-ryanlao/mediaconvert/dist/"
sed -i 's|\"Destination\":.*|\"Destination\": "'$3'"|g' "convert.json"

# "FileInput": "s3://poc-data-zhy-ryanlao/mediaconvert/mp4/comic/6000/flow.mp4"
sed -i 's|\"FileInput\":.*|\"FileInput\": "'$4'"|g' "convert.json"

# "CodecProfile": "MAIN",
sed -i '72s|\"CodecProfile\":.*|\"CodecProfile\": "'$5'",|g' "convert.json"

aws mediaconvert create-job \
    --endpoint-url https://jueykjjnc.mediaconvert.cn-northwest-1.amazonaws.com.cn \
    --cli-input-json file://~/opg/convert.json

aws cloudfront create-invalidation \
    --distribution-id E1FSZQXDIJLIDX \
    --paths "/*"
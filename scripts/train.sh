#!/bin/bash
set -e 

echo "Getting data from S3"

if [ ! -d "backup" ]; then
    mkdir backup
fi

if [${DOWNLOAD_DATA} -gt 0]; then
    aws s3 sync s3://${S3_BUCKET_NAME}/cfg cfg/
    aws s3 sync s3://${S3_BUCKET_NAME}/data/images data/images 
    #aws s3 sync s3://${S3_BUCKET_NAME}/data/labels data/images 
    aws s3 sync s3://${S3_BUCKET_NAME}/data/labels data/labels 
    aws s3 sync s3://${S3_BUCKET_NAME}/data/obj.data data/obj.data 
    aws s3 sync s3://${S3_BUCKET_NAME}/data/obj.names data/obj.names
    aws s3 sync s3://${S3_BUCKET_NAME}/data/test.txt data/train.txt 
    aws s3 sync s3://${S3_BUCKET_NAME}/data/train.txt data/train.txt  
    aws s3 sync s3://${S3_BUCKET_NAME}/pretrained pretrained/
fi

if [ -f "cfg/${NETWORK_FILENAME}" ]; then
    export OCTAV_NETWORK="cfg/${NETWORK_FILENAME}"
fi

if [ -f "pretrained/${PRETRAINED_WEIGHTS_FILENAME}" ]; then
    export OCTAV_PRETRAINED_WEIGHTS="pretrained/${PRETRAINED_WEIGHTS_FILENAME}"
fi

if [ -f "data/${DATA_FILENAME}" ]; then
    export OCTAV_DATA="data/${DATA_FILENAME}"
fi

echo "Start training at $(date +"%D %T")"
./darknet/darknet detector train ${OCTAV_DATA} ${OCTAV_NETWORK} ${OCTAV_PRETRAINED_WEIGHTS} -dont_show -mjpeg_port 8090 -map 

echo "Finished training at $(date +"%D %T")"

source save_weights.sh

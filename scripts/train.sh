#!/bin/bash
set -e 

echo "Getting data from S3"

if [ ! -d "backup" ]; then
    mkdir backup
fi
  
aws s3 sync s3://${S3_BUCKET_NAME}/cfg cfg/
aws s3 sync s3://${S3_BUCKET_NAME}/data data/ 
aws s3 sync s3://${S3_BUCKET_NAME}/pretrained pretrained/

if [ -f "cfg/${NETWORK_FILENAME}" ]; then
    export NETWORK ="cfg/${NETWORK_FILENAME}"
fi

if [ -f "pretrained/${PRETRAINED_WEIGHTS_FILENAME}" ]; then
    export PRETRAINED_WEIGHTS="pretrained/${PRETRAINED_WEIGHTS_FILENAME}"
fi

if [ -f "data/${DATA_FILENAME}" ]; then
    export DATA="data/${DATA_FILENAME}"
fi

echo "Start training at $(date +"%D %T")"
./darknet/darknet detector train ${DATA} ${NETWORK} ${PRETRAINED_WEIGHTS} -dont_show -mjpeg_port 8090 -mjson_port 9070 -map 

echo "Finished training at $(date +"%D %T")"

source save_weights.sh

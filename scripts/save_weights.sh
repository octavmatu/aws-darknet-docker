#!/bin/bash
set -e

UNIX_EPOCH=$(date +%s)

# Get basename of the network file, since Darknet saves the weights as 'NetworkFileBaseName_final.weights'
NETWORK_FILENAME=${NETWORK_FILENAME##*/}
BASE_NAME=${NETWORK_FILENAME%.cfg}
OUTPUT_PATH = "s3://${S3_BUCKET_NAME}/trained/${UNIX_EPOCH}"
echo "Uploading final weights, ${BASE_NAME}_${UNIX_EPOCH}.weights, and config file, ${NETWORK}, to ${OUTPUT_PATH}"

aws s3 cp ${NETWORK} ${OUTPUT_PATH}/${NETWORK}
aws s3 cp backup/${BASE_NAME}_final.weights ${OUTPUT_PATH}/${BASE_NAME}_${UNIX_EPOCH}_final.weights
aws s3 cp backup ${OUTPUT_PATH}/backup

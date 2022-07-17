#!/bin/bash

IFS=':'
project_name=$1

mc alias set minio https://$ENDPOINT $ACCESS_KEY $SECRET_KEY --api S3v4
cd /workspace
zip -r $project_name.zip $project_name/modflow
mc cp /workspace/$project_name.zip minio/hydrological-simulations/projects/output/$project_name.zip
if [ $? -eq 0 ]; then
    rm -r /workspace/$project_name /workspace/$project_name.zip
else
    echo Project upload failed!
fi

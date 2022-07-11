#!/bin/bash

IFS=':'
project_name=$1

mc alias set minio https://$ENDPOINT $ACCESS_KEY $SECRET_KEY --api S3v4
cd /workspace
for model in "${@:2}"
do
    read -ra model_type_and_name <<< $model
    model_type=${model_type_and_name[0]}
    model_name=${model_type_and_name[1]}
    zip -r $project_name.zip $project_name/$model_type/$model_name
done
mc cp /workspace/$project_name.zip minio/output/$project_name.zip
if [ $? -eq 0 ]; then
    rm -r /workspace/$project_name /workspace/$project_name.zip
else
    echo Project upload failed!
fi

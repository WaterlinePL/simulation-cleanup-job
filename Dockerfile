FROM hyperflowwms/montage2-alpine-node-12:montage5.0-patched

ARG hf_job_executor_version

ENV HYPERFLOW_JOB_EXECUTOR_VERSION=$hf_job_executor_version
RUN npm install -g @hyperflow/job-executor@${HYPERFLOW_JOB_EXECUTOR_VERSION}

# Install minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod +x mc
RUN mv mc /bin/mc

RUN apk add --no-cache --upgrade bash zip

# Assumes folowing laumch: 
# sh project_cleanup.sh <project_name> <model_type:model_to_upload1> <model_type:model_to_upload2> <model_type:model_to_upload3> ...
COPY project_cleanup.sh .
RUN chmod +x project_cleanup.sh
# Job performing project download

This job downloads all models related to simulation project and unzips it so that simulation may be performed.

### Important!
In order to work properly this job requires having present a secret with credentials to S3 with fields:

* endpoint
* access_key
* secret_key

These fields are passed to MinIO client in order to establish connection. This job also requires to have the simulation temporary volume mounted under `/workspace`.

### Run using Hyperflow Job Executor:
`hflow-job-execute <task_id> <redis_url>`

On redis there should be a list with key `<flow_name>:<task_id>_msg` with commands in form of *JSON* string. Format of JSON for running this job:

```yaml
{
   "exectuable": "bash",
   "args": [
       "download_project.sh",
        "<project_name>",
        "<model1_type>:<model1_name>",
        "<model2_type>:<model2_name>",
        "<model3_type>:<model3_name>",
        ...
        ],
   "input": [],
   "output": []
}
```

Model types and names are directly mapped to buckets on MinIO so for example `<model1_type>:<model1_name>` will download file `minio/<model1_type>/<model1_name>.zip`.


Example:

```yaml
{
   "exectuable": "bash",
   "args": [
        "download_project.sh",
        "my-project", 
        "modflow:model1", 
        "hydrus:model2", 
        "hydrus:model3"
        ],
   "input": [],
   "output": []
}
```
This job will create directory `my-project` in workspace and create two folders for each model type: `modflow` and `hydrus`. Project `model1` will be downloaded from bucket `minio/modflow/model1.zip` and unpacked into `/workspace/my-project/modflow/model1`. Similarly for hydrus:
* `model2` will be downloaded from bucket `minio/hydrus/model2.zip` and unpacked into `/workspace/my-project/hydrus/model2`
* `model3` will be downloaded from bucket `minio/hydrus/model3.zip` and unpacked into `/workspace/my-project/hydrus/model3`
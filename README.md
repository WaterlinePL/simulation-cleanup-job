# [DEPRECATED] Job performing project cleanup

This job uploads selected output projects to MinIO `output` bucket and deletes all files related to simulation project from temporary volume.

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
       "project_cleanup.sh",
        "<project_name>",
        "<model1_type>:<model_to_upload1>",
        "<model2_type>:<model_to_upload1>",
        "<model3_type>:<model_to_upload1>",
        ...
        ],
   "input": [],
   "output": []
}
```

Model types and names are directly mapped to buckets on MinIO so for example `<model1_type>:<model_to_upload1>` will add to output zip whole directory of `model_to_upload1` (`<project_name>/<model1_type>/<model_to_upload1>` inside .zip - same as in `/workspace`). Then it uploads to MinIO the .zip file to the output bucket.


Example:

```yaml
{
   "exectuable": "bash",
   "args": [
        "project_cleanup.sh",
        "my-project", 
        "modflow:model1", 
        "hydrus:model2", 
        "hydrus:model3"
        ],
   "input": [],
   "output": []
}
```
This job will create a .zip `my-project` with following structure:
```
.zip root
|
└───my-project
      └───modflow
      |   |
      │   └───model1
      │       │   output_file1.ex1
      │       │   output_file2.ex2
      │       │   ...
      │   
      └───hydrus
         |
         └───model2
         |   │   output_file1.ex1
         |   │   output_file2.ex2
         |   │   ...
         |   
         └───model3
            │   output_file1.ex1
            │   output_file2.ex2
            │   ...
```

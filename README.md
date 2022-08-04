## tf_aws_eks_cluster

The terraform plan is to create `eks` cluster, node-groups and bootstrap cluster permssions and security groups 


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name| The name of the eks cluster  | `string` | null | yes |
| map\_users | `system.master` users to access the cluster | `list(object)` | null | yes |
| node\_groups | node-groups configuraiton | `map(object{})` | <pre> "node" = { <br/>  ami_type = "AL2_x86_64" <br/>  desired_capacity = "1"  <br/>  disk_size   = "20" <br/>  instance_types = ["m5.xlarge"] <br/>  k8s_labels = { "workload" = "core" } <br/> } </pre> | yes |


## Outputs

None

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.1 |
| aws | >= 4.20.1 |


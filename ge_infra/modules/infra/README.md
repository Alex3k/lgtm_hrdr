## Deploying env_setup
You will need a service account which has editor permissions to a GCP project. This is as the env_setup terraform script creates an external facing IP address that will be used for Grafana. Please download the service account json file and use the `gcp_svc_acc_file_path` variable to point to it

To set up the GE environment:
- `terraform init`
- `terraform validate`
- `terraform apply -var owner_name="" -var gcp_svc_acc_file_path=""`

This will then output the created IP address which can be given a Grafana Labs team member to get your license which requires the IP address.

Then please run the `ge_deploy` terraform directory
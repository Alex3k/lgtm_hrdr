## Deploying env_setup
You will need a service account which has editor permissions to a GCP project. This is as the env_setup terraform script creates an external facing IP address that will be used for Grafana. Please download the service account json file and use the `gcp_svc_acc_file_path` variable to point to it

To set up the GE environment:
- `terraform init`
- `terraform validate`
- `terraform apply -var owner_name="" -var gcp_svc_acc_file_path="" -var gke_cluster_name="" -var ge_ip_address="" -var ge_license_file=""`

Use the IP address outputed from the `env_setup` process and the contents of the license from your friendly Grafana Labs team member.

This will output a URL, username and password. go to http://{URL}:3000 to go to Grafana, and use the below commands to view the username and password:
`terraform output grafana_username`
`terraform output grafana_password`